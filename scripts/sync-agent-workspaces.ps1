[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string]$AgentId,
  [switch]$All,
  [switch]$IncludeSharedSkills,
  [switch]$IncludeSharedState,
  [switch]$Prune,
  [string]$OpenClawRoot = (Join-Path $HOME ".openclaw")
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-RepoRoot {
  (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Ensure-Directory {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    if ($PSCmdlet.ShouldProcess($Path, "Create directory")) {
      New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
  }
}

function Get-ManagedChildren {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return @()
  }

  Get-ChildItem -LiteralPath $Path -Force | Where-Object {
    $_.Name -notin @(".git", ".DS_Store", "Thumbs.db")
  }
}

function Sync-DirectoryContent {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [string]$Source,
    [string]$Destination,
    [switch]$Mirror
  )

  Ensure-Directory -Path $Destination -WhatIf:$WhatIfPreference

  $sourceChildren = Get-ManagedChildren -Path $Source
  $sourceNames = @{}

  foreach ($child in $sourceChildren) {
    $sourceNames[$child.Name] = $true
    $destChild = Join-Path $Destination $child.Name

    if ($child.PSIsContainer) {
      Sync-DirectoryContent -Source $child.FullName -Destination $destChild -Mirror:$Mirror -WhatIf:$WhatIfPreference
      continue
    }

    if ($PSCmdlet.ShouldProcess($destChild, "Copy file from $($child.FullName)")) {
      Copy-Item -LiteralPath $child.FullName -Destination $destChild -Force
    }
  }

  if (-not $Mirror) {
    return
  }

  foreach ($destChild in Get-ManagedChildren -Path $Destination) {
    if (-not $sourceNames.ContainsKey($destChild.Name)) {
      if ($PSCmdlet.ShouldProcess($destChild.FullName, "Remove stale item")) {
        Remove-Item -LiteralPath $destChild.FullName -Recurse -Force
      }
    }
  }
}

function Get-AgentWorkspacePath {
  param(
    [string]$Agent,
    [string]$Root
  )

  Join-Path $Root ("workspace-" + $Agent)
}

$repoRoot = Get-RepoRoot
$teamRoot = Join-Path $repoRoot "agent-team"
$agentsRoot = Join-Path $teamRoot "agents"
$sharedSkillsRoot = Join-Path $teamRoot "shared-skills"
$sharedStateRoot = Join-Path $teamRoot "shared-state"

if (-not (Test-Path -LiteralPath $agentsRoot)) {
  throw "Missing agent-team/agents directory at $agentsRoot"
}

$knownAgents = Get-ChildItem -LiteralPath $agentsRoot -Directory |
  Sort-Object Name |
  Select-Object -ExpandProperty Name

if ($AgentId -and $All) {
  throw "Use either -AgentId or -All, not both."
}

if (-not $AgentId -and -not $All) {
  throw "Specify -AgentId <id> or -All."
}

if ($AgentId) {
  if ($AgentId -notin $knownAgents) {
    throw "Unknown agent id '$AgentId'. Known agents: $($knownAgents -join ', ')"
  }
  $targetAgents = @($AgentId)
} else {
  $targetAgents = $knownAgents
}

foreach ($targetAgent in $targetAgents) {
  $sourceAgentDir = Join-Path $agentsRoot $targetAgent
  $destWorkspace = Get-AgentWorkspacePath -Agent $targetAgent -Root $OpenClawRoot

  Ensure-Directory -Path $destWorkspace -WhatIf:$WhatIfPreference
  Sync-DirectoryContent -Source $sourceAgentDir -Destination $destWorkspace -Mirror:$Prune -WhatIf:$WhatIfPreference

  if ($IncludeSharedState) {
    $destShared = Join-Path $destWorkspace "shared"
    Sync-DirectoryContent -Source $sharedStateRoot -Destination $destShared -Mirror:$Prune -WhatIf:$WhatIfPreference
  }
}

if ($IncludeSharedSkills) {
  $destSkillsRoot = Join-Path $OpenClawRoot "skills"
  Sync-DirectoryContent -Source $sharedSkillsRoot -Destination $destSkillsRoot -Mirror:$Prune -WhatIf:$WhatIfPreference
}

Write-Host "Synced agent workspaces: $($targetAgents -join ', ')"
if ($IncludeSharedState) {
  Write-Host "Included shared state."
}
if ($IncludeSharedSkills) {
  Write-Host "Included shared skills."
}
