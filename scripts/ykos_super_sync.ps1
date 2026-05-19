param(
    [ValidateSet("Plan", "Apply")]
    [string]$Mode = "Plan",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "ykos_config.json"),

    [string]$CommitMessage = "",

    [switch]$SkipDriveSync,

    [switch]$SkipGitPush
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message"
}

function Join-RelativePath {
    param(
        [Parameter(Mandatory = $true)][string]$BasePath,
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $current = $BasePath
    foreach ($part in ($RelativePath -split "[\\/]")) {
        if ([string]::IsNullOrWhiteSpace($part)) {
            continue
        }
        $current = Join-Path -Path $current -ChildPath $part
    }
    return $current
}

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][string]$WorkingDirectory,
        [switch]$AllowFailure,
        [switch]$RunInPlan
    )

    $rendered = "$FilePath $($Arguments -join ' ')"
    Write-Host $rendered

    if (($Mode -eq "Plan") -and (-not $RunInPlan)) {
        return @{
            ExitCode = 0
            Stdout = ""
            Stderr = ""
        }
    }

    $process = Start-Process `
        -FilePath $FilePath `
        -ArgumentList $Arguments `
        -WorkingDirectory $WorkingDirectory `
        -NoNewWindow `
        -Wait `
        -PassThru `
        -RedirectStandardOutput "$env:TEMP\ykos_super_sync_stdout.txt" `
        -RedirectStandardError "$env:TEMP\ykos_super_sync_stderr.txt"

    $stdout = Get-Content -LiteralPath "$env:TEMP\ykos_super_sync_stdout.txt" -Raw -ErrorAction SilentlyContinue
    $stderr = Get-Content -LiteralPath "$env:TEMP\ykos_super_sync_stderr.txt" -Raw -ErrorAction SilentlyContinue

    if ($stdout) { Write-Host $stdout.TrimEnd() }
    if ($stderr) { Write-Host $stderr.TrimEnd() }

    if (($process.ExitCode -ne 0) -and (-not $AllowFailure)) {
        throw "命令失败，退出码 $($process.ExitCode)：$rendered"
    }

    return @{
        ExitCode = $process.ExitCode
        Stdout = $stdout
        Stderr = $stderr
    }
}

function Get-GitOutput {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][string]$WorkingDirectory,
        [switch]$AllowFailure
    )

    $result = Invoke-Checked -FilePath "git" -Arguments (@("-c", "safe.directory=E:/project/YkOS") + $Arguments) -WorkingDirectory $WorkingDirectory -AllowFailure:$AllowFailure -RunInPlan
    return $result.Stdout
}

function Get-FileHashSafe {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return ""
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Get-RelativeFiles {
    param([string]$Root)

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        return @()
    }

    Get-ChildItem -LiteralPath $Root -File -Recurse -Force |
        Where-Object { $_.FullName -notmatch "\\.git(\\|$)" } |
        ForEach-Object {
            [PSCustomObject]@{
                FullName = $_.FullName
                Relative = $_.FullName.Substring($Root.Length).TrimStart("\", "/")
                LastWriteTimeUtc = $_.LastWriteTimeUtc
                Length = $_.Length
            }
        }
}

function Find-MappingConflicts {
    param(
        [string]$LeftRoot,
        [string]$RightRoot,
        [string]$LeftLabel,
        [string]$RightLabel
    )

    $leftFiles = @{}
    foreach ($file in (Get-RelativeFiles -Root $LeftRoot)) {
        $leftFiles[$file.Relative] = $file
    }

    $conflicts = @()
    foreach ($right in (Get-RelativeFiles -Root $RightRoot)) {
        if (-not $leftFiles.ContainsKey($right.Relative)) {
            continue
        }

        $left = $leftFiles[$right.Relative]
        if ((Get-FileHashSafe -Path $left.FullName) -eq (Get-FileHashSafe -Path $right.FullName)) {
            continue
        }

        $newer = if ($left.LastWriteTimeUtc -gt $right.LastWriteTimeUtc) {
            $LeftLabel
        } elseif ($right.LastWriteTimeUtc -gt $left.LastWriteTimeUtc) {
            $RightLabel
        } else {
            "same-time"
        }

        $conflicts += [PSCustomObject]@{
            Relative = $right.Relative
            Left = $left.FullName
            Right = $right.FullName
            Newer = $newer
            LeftTime = $left.LastWriteTimeUtc.ToString("s")
            RightTime = $right.LastWriteTimeUtc.ToString("s")
        }
    }
    return $conflicts
}

function Get-AheadBehind {
    param([string]$RepoRoot)

    $output = Get-GitOutput -Arguments @("rev-list", "--left-right", "--count", "HEAD...@{upstream}") -WorkingDirectory $RepoRoot -AllowFailure
    if (-not $output) {
        return [PSCustomObject]@{ Ahead = 0; Behind = 0; HasUpstream = $false }
    }

    $parts = $output.Trim() -split "\s+"
    return [PSCustomObject]@{
        Ahead = [int]$parts[0]
        Behind = [int]$parts[1]
        HasUpstream = $true
    }
}

function Write-Report {
    param(
        [string]$RepoRoot,
        [string]$DrivePath,
        [array]$Conflicts,
        [object]$AheadBehind,
        [string]$GitStatus
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
    $date = Get-Date -Format "yyyy-MM-dd"
    $pendingDir = Join-Path $RepoRoot "04_memory_transactions\pending"
    $reviewDir = Join-Path $RepoRoot "06_reviews\daily"
    New-Item -ItemType Directory -Force -Path $pendingDir | Out-Null
    New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null

    $pendingFile = Join-Path $pendingDir "$($timestamp)_super_sync.md"
    $reviewFile = Join-Path $reviewDir "$($date)_super_sync_review.md"

    $conflictText = if ($Conflicts.Count -eq 0) {
        "- 未发现同名不同内容的 Drive/YkOS 映射冲突。"
    } else {
        ($Conflicts | ForEach-Object {
            "- $($_.Relative)：较新侧=$($_.Newer)；Left=$($_.Left)；Right=$($_.Right)"
        }) -join "`n"
    }

    $pending = @"
# $timestamp Super Sync Memory Delta

## Memory Delta

### 新事实

- 来源：scripts/ykos_super_sync.ps1
  - 事实：本次运行模式为 $Mode。
  - 事实：YkOS 根目录为 $RepoRoot。
  - 事实：Google Drive 路径为 $DrivePath。
  - 事实：Git ahead=$($AheadBehind.Ahead)，behind=$($AheadBehind.Behind)，has_upstream=$($AheadBehind.HasUpstream)。
  - 事实：Drive/YkOS 映射冲突数量为 $($Conflicts.Count)。

### 推理 / 分析

- Super sync 只负责协同同步编排，不自动判断有争议内容的真实语义新旧。
- 如果 Git 出现 diverged 或 Drive/YkOS 同名文件冲突，应先人工审核。

### 决策

- 不删除文件。
- 不同步 .git。
- 不绕过 pending 审核。
- GitHub push 只由本地脚本执行。

### 开放问题

- 冲突文件是否应保留两份，还是由人工决定覆盖方向？
- 是否需要把 02_knowledge 纳入更严格的人工审批清单？

### 下一步动作

- 检查本次 super sync review。
- 如果有冲突，人工处理后再重新运行。
- 如果无冲突且需要上传，使用 Mode Apply。

### 来源 / 产物

- scripts/ykos_super_sync.ps1
- scripts/ykos_sync.ps1
- scripts/ykos_config.json
- $pendingFile
- $reviewFile

## 冲突摘要

$conflictText

## Git 状态摘要

```text
$GitStatus
```

## 状态

pending
"@

    $review = @"
# $date Super Sync Review

## 1. 本次完成了什么

- 扫描 Google Drive 与本地 YkOS 映射冲突。
- 检查 GitHub upstream ahead/behind 状态。
- 按模式 $Mode 编排 Drive sync 与 Git sync。
- 生成 pending Memory Transaction。

## 2. 路径

- YkOS：$RepoRoot
- Google Drive：$DrivePath

## 3. Git 状态

- ahead：$($AheadBehind.Ahead)
- behind：$($AheadBehind.Behind)
- has_upstream：$($AheadBehind.HasUpstream)

```text
$GitStatus
```

## 4. 冲突检查

$conflictText

## 5. 风险

- 如果 GitHub 远端和本地同时修改同一文件，rebase 可能冲突。
- 如果 Drive 和本地同名文件内容不同，脚本不会自动删除或强制覆盖争议文件。
- 如果仓库是私有仓库，Git push 依赖本机 GitHub 凭据。

## 6. 下一步动作

- 无冲突时可使用 `-Mode Apply` 执行完整同步。
- 有冲突时先人工处理冲突文件。
- 执行后检查 pending Memory Transaction 和 daily review。

## Memory Delta

- 新事实：
  - Super sync 已具备本地 Drive 与 GitHub 协同同步编排能力。
- 新决策：
  - 默认 Plan，不直接写入远端。
  - Apply 模式才执行 commit / rebase / push。
- 待审核项：
  - 人工确认是否把该同步策略作为 YkOS 标准操作。
"@

    if ($Mode -eq "Apply") {
        Set-Content -LiteralPath $pendingFile -Value $pending -Encoding UTF8
        Set-Content -LiteralPath $reviewFile -Value $review -Encoding UTF8
        Write-Host "已生成：$pendingFile"
        Write-Host "已生成：$reviewFile"
    } else {
        Write-Host "Plan 模式：将会生成 pending/review，但本次不写文件。"
    }
}

if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
    throw "未找到配置文件：$ConfigPath"
}

$config = Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
$repoRoot = (Resolve-Path -LiteralPath $config.ykos_root).Path
$driveRoot = $config.drive_path

if (-not (Test-Path -LiteralPath $repoRoot -PathType Container)) {
    throw "YkOS 根目录不存在：$repoRoot"
}
if (-not (Test-Path -LiteralPath $driveRoot -PathType Container)) {
    throw "Google Drive 路径不存在：$driveRoot"
}

Write-Step "读取配置"
Write-Host "Mode: $Mode"
Write-Host "YkOS: $repoRoot"
Write-Host "Drive: $driveRoot"

Write-Step "扫描 Drive/YkOS 映射冲突"
$allConflicts = @()
$config.inbox_mapping.PSObject.Properties | ForEach-Object {
    $driveSide = Join-RelativePath -BasePath $driveRoot -RelativePath $_.Name
    $ykosSide = Join-RelativePath -BasePath $repoRoot -RelativePath $_.Value
    $allConflicts += Find-MappingConflicts -LeftRoot $driveSide -RightRoot $ykosSide -LeftLabel "Drive" -RightLabel "YkOS"
}
$config.export_mapping.PSObject.Properties | ForEach-Object {
    $ykosSide = Join-RelativePath -BasePath $repoRoot -RelativePath $_.Name
    $driveSide = Join-RelativePath -BasePath $driveRoot -RelativePath $_.Value
    $allConflicts += Find-MappingConflicts -LeftRoot $ykosSide -RightRoot $driveSide -LeftLabel "YkOS" -RightLabel "Drive"
}

if ($allConflicts.Count -gt 0) {
    Write-Host "发现映射冲突：$($allConflicts.Count)"
    $allConflicts | Format-Table Relative, Newer, LeftTime, RightTime -AutoSize
    if ($Mode -eq "Apply") {
        throw "发现 Drive/YkOS 同名不同内容冲突。请人工处理后再运行 Apply。"
    }
} else {
    Write-Host "未发现 Drive/YkOS 同名不同内容冲突。"
}

Write-Step "检查 Git 状态"
$gitStatus = Get-GitOutput -Arguments @("status", "--short", "--branch") -WorkingDirectory $repoRoot
Write-Host $gitStatus

Write-Step "获取 GitHub 最新状态"
Get-GitOutput -Arguments @("fetch", "--all", "--prune") -WorkingDirectory $repoRoot | Out-Null
$aheadBehind = Get-AheadBehind -RepoRoot $repoRoot
Write-Host "ahead=$($aheadBehind.Ahead), behind=$($aheadBehind.Behind), has_upstream=$($aheadBehind.HasUpstream)"

if (-not $SkipDriveSync) {
    Write-Step "运行 Google Drive 同步层"
    Invoke-Checked -FilePath "powershell" -Arguments @(
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        (Join-Path $PSScriptRoot "ykos_sync.ps1"),
        "-ConfigPath",
        $ConfigPath
    ) -WorkingDirectory $repoRoot | Out-Null
} else {
    Write-Step "跳过 Drive 同步"
}

Write-Step "重新读取 Git 工作区"
$gitStatusAfterDrive = Get-GitOutput -Arguments @("status", "--short", "--branch") -WorkingDirectory $repoRoot
Write-Host $gitStatusAfterDrive

Write-Report -RepoRoot $repoRoot -DrivePath $driveRoot -Conflicts $allConflicts -AheadBehind $aheadBehind -GitStatus $gitStatusAfterDrive

if ($Mode -eq "Plan") {
    Write-Step "Plan 完成"
    Write-Host "未修改文件、未 commit、未 push。确认无误后运行："
    Write-Host "powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ykos_super_sync.ps1 -Mode Apply"
    exit 0
}

Write-Step "暂存允许提交的文件"
$excludePathspecs = @(
    ":(exclude).obsidian",
    ":(exclude)**/__pycache__/**",
    ":(exclude)**/*.pyc",
    ":(exclude).env",
    ":(exclude).env.*",
    ":(exclude)secrets/**",
    ":(exclude)credentials/**"
)
Get-GitOutput -Arguments (@("add", "--all", "--", ".") + $excludePathspecs) -WorkingDirectory $repoRoot | Out-Null

$staged = Get-GitOutput -Arguments @("diff", "--cached", "--name-only") -WorkingDirectory $repoRoot
if ([string]::IsNullOrWhiteSpace($staged)) {
    Write-Host "没有需要提交的变更。"
} else {
    Write-Host "将提交："
    Write-Host $staged
    if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
        $CommitMessage = "chore: super sync YkOS"
    }
    Get-GitOutput -Arguments @("commit", "-m", $CommitMessage) -WorkingDirectory $repoRoot | Out-Null
}

Write-Step "处理远端 ahead/behind"
Get-GitOutput -Arguments @("fetch", "--all", "--prune") -WorkingDirectory $repoRoot | Out-Null
$aheadBehindAfterCommit = Get-AheadBehind -RepoRoot $repoRoot
Write-Host "ahead=$($aheadBehindAfterCommit.Ahead), behind=$($aheadBehindAfterCommit.Behind)"

if ($aheadBehindAfterCommit.Behind -gt 0) {
    Write-Host "远端有新提交，执行 rebase。若冲突，脚本会停止。"
    Get-GitOutput -Arguments @("pull", "--rebase") -WorkingDirectory $repoRoot | Out-Null
}

if (-not $SkipGitPush) {
    Write-Step "推送到 GitHub"
    Get-GitOutput -Arguments @("push") -WorkingDirectory $repoRoot | Out-Null
} else {
    Write-Step "跳过 GitHub push"
}

Write-Step "Super sync 完成"
Get-GitOutput -Arguments @("status", "--short", "--branch") -WorkingDirectory $repoRoot | Write-Host
