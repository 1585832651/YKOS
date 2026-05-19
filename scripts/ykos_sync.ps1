param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "ykos_config.json")
)

$ErrorActionPreference = "Stop"

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

function Assert-NotKnowledgePath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $normalized = $Path.Replace("/", "\")
    if ($normalized -match "(^|\\)02_knowledge(\\|$)") {
        throw "安全停止：同步脚本不允许修改 02_knowledge。路径：$Path"
    }
}

function Copy-DirectoryContent {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRoot,
        [Parameter(Mandatory = $true)][string]$TargetRoot
    )

    Assert-NotKnowledgePath -Path $TargetRoot

    if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $SourceRoot | Out-Null
    }
    if (-not (Test-Path -LiteralPath $TargetRoot -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
    }

    $copied = 0
    $files = Get-ChildItem -LiteralPath $SourceRoot -File -Recurse -Force |
        Where-Object { $_.FullName -notmatch "\\.git(\\|$)" }

    foreach ($file in $files) {
        $relative = $file.FullName.Substring($SourceRoot.Length).TrimStart("\", "/")
        $target = Join-RelativePath -BasePath $TargetRoot -RelativePath $relative
        $targetDir = Split-Path -Parent $target

        if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        }

        $shouldCopy = $true
        if (Test-Path -LiteralPath $target -PathType Leaf) {
            $existing = Get-Item -LiteralPath $target
            $shouldCopy = ($existing.Length -ne $file.Length) -or ($existing.LastWriteTimeUtc -lt $file.LastWriteTimeUtc)
        }

        if ($shouldCopy) {
            Copy-Item -LiteralPath $file.FullName -Destination $target -Force
            $copied += 1
        }
    }

    return $copied
}

if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
    Write-Error "未找到配置文件：$ConfigPath。请复制 scripts/ykos_config.example.json 为 scripts/ykos_config.json，并填写 drive_path。"
}

$config = Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json

if (-not (Test-Path -LiteralPath $config.ykos_root -PathType Container)) {
    throw "ykos_root 不存在：$($config.ykos_root)"
}

if (-not (Test-Path -LiteralPath $config.drive_path -PathType Container)) {
    throw "drive_path 不存在：$($config.drive_path)"
}

$ykosRoot = (Resolve-Path -LiteralPath $config.ykos_root).Path
$driveRoot = (Resolve-Path -LiteralPath $config.drive_path).Path

$driveDirs = @(
    "00_export_to_ykos/reports",
    "00_export_to_ykos/prompts",
    "01_sources/papers",
    "01_sources/reports",
    "01_sources/docs",
    "01_sources/slides",
    "02_notebooklm_exports",
    "03_gemini_outputs",
    "04_google_ai_studio",
    "05_chatgpt_exports",
    "99_archive"
)

foreach ($dir in $driveDirs) {
    $fullPath = Join-RelativePath -BasePath $driveRoot -RelativePath $dir
    New-Item -ItemType Directory -Force -Path $fullPath | Out-Null
}

$driveToInboxCopied = 0
$exportToDriveCopied = 0

$config.inbox_mapping.PSObject.Properties | ForEach-Object {
    $source = Join-RelativePath -BasePath $driveRoot -RelativePath $_.Name
    $target = Join-RelativePath -BasePath $ykosRoot -RelativePath $_.Value
    $driveToInboxCopied += Copy-DirectoryContent -SourceRoot $source -TargetRoot $target
}

$config.export_mapping.PSObject.Properties | ForEach-Object {
    $source = Join-RelativePath -BasePath $ykosRoot -RelativePath $_.Name
    $target = Join-RelativePath -BasePath $driveRoot -RelativePath $_.Value
    $exportToDriveCopied += Copy-DirectoryContent -SourceRoot $source -TargetRoot $target
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$date = Get-Date -Format "yyyy-MM-dd"
$pendingDir = Join-RelativePath -BasePath $ykosRoot -RelativePath $config.pending_path
$reviewDir = Join-RelativePath -BasePath $ykosRoot -RelativePath $config.review_path
New-Item -ItemType Directory -Force -Path $pendingDir | Out-Null
New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null

$pendingFile = Join-Path $pendingDir "$($timestamp)_drive_sync.md"
$reviewFile = Join-Path $reviewDir "$($date)_drive_sync_review.md"

$memoryDelta = @"
# $timestamp Drive Sync Memory Delta

## Memory Delta

### 新事实

- 来源：scripts/ykos_config.json
  - 事实：本次同步使用的 Google Drive 路径为 $driveRoot。
- 来源：scripts/ykos_sync.ps1
  - 事实：Drive 输入复制到本地 inbox 的文件数为 $driveToInboxCopied。
  - 事实：本地输出复制到 Drive 的文件数为 $exportToDriveCopied。

### 推理 / 分析

- 本次同步只代表文件交换，不代表任何内容已进入正式知识库。
- 进入 01_inbox/ 的内容仍需人工审核和 Memory Transaction 审批。

### 决策

- 本脚本不修改 02_knowledge/。
- 本脚本不执行 git commit 或 git push。
- 本脚本不删除文件。

### 开放问题

- 哪些新输入应升级为正式 Memory Transaction？
- 哪些 Drive 来源需要归档或人工清理？

### 下一步动作

- 人工检查本次同步进入 inbox 的文件。
- 对重要输入创建或审核 Memory Transaction。
- 审批后再决定是否更新正式知识库。

### 来源 / 产物

- scripts/ykos_sync.ps1
- scripts/ykos_config.json
- $pendingFile
- $reviewFile

## 状态

pending
"@

$review = @"
# $date Drive Sync Review

## 1. 本次完成了什么

- 验证本地 YkOS 路径：$ykosRoot
- 验证 Google Drive 路径：$driveRoot
- 确认并创建 Drive 交换目录结构。
- 将 Drive 输入目录复制到本地 inbox。
- 将本地输出目录复制到 Drive 导出区。
- 生成 pending Memory Transaction。

## 2. 同步统计

- Drive 输入复制到本地 inbox：$driveToInboxCopied 个文件。
- 本地输出复制到 Drive：$exportToDriveCopied 个文件。

## 3. 生成的 Memory Delta

- $pendingFile

## 4. 需要人工审批的地方

- 哪些 inbox 输入需要进入正式 Memory Transaction。
- 哪些内容允许进入 02_knowledge/。

## 5. 下一步建议任务

- 检查 01_inbox/notebooklm/、01_inbox/gemini/、01_inbox/papers/。
- 审核 $pendingFile。
- 人工确认后再 commit + push GitHub。

## Memory Delta

- 新事实：
  - 本次同步使用 Drive 路径 $driveRoot。
  - 本次 Drive 输入复制数为 $driveToInboxCopied。
  - 本次本地输出复制数为 $exportToDriveCopied。
- 新决策：
  - 同步结果先进入 inbox 和 pending，不直接进入正式知识库。
- 假设变化：
  - Google Drive 仅作为交换层，不是最终记忆源。
- 影响文件：
  - $pendingFile
  - $reviewFile
- 待审核项：
  - 所有新增 inbox 内容都需要人工审核。
"@

Set-Content -LiteralPath $pendingFile -Value $memoryDelta -Encoding UTF8
Set-Content -LiteralPath $reviewFile -Value $review -Encoding UTF8

Write-Host "YkOS Drive 同步完成"
Write-Host "Drive 输入复制到本地 inbox：$driveToInboxCopied"
Write-Host "本地输出复制到 Drive：$exportToDriveCopied"
Write-Host "Memory Delta：$pendingFile"
Write-Host "Daily Review：$reviewFile"
