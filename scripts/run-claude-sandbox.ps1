[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$SandboxName = 'claude-admin-lab',
    [string]$WorkspacePath = (Split-Path -Parent $PSScriptRoot),
    [string]$KitPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'kit'),
    [string]$PluginRoot = (Join-Path $HOME '.claude\plugins'),
    [string]$PluginInventoryPath = (Join-Path $HOME '.claude\plugins\installed_plugins.json'),
    [string[]]$ClaudeArgument = @()
)

$ErrorActionPreference = 'Stop'

function ConvertTo-SandboxPath {
    param([string]$Path)

    if ($Path -notmatch '^(?<drive>[A-Za-z]):\\(?<rest>.*)$') {
        throw "Unsupported Windows path for Docker Sandboxes: $Path"
    }

    return '/' + $Matches.drive.ToLowerInvariant() + '/' + $Matches.rest.Replace('\', '/')
}

$resolvedWorkspace = (Resolve-Path -LiteralPath $WorkspacePath).Path
$resolvedKit = (Resolve-Path -LiteralPath $KitPath).Path
$resolvedPluginRoot = (Resolve-Path -LiteralPath $PluginRoot).Path.TrimEnd('\')

if (-not (Test-Path -LiteralPath $PluginInventoryPath -PathType Leaf)) {
    throw "Claude Code plugin inventory not found: $PluginInventoryPath"
}

$inventory = Get-Content -LiteralPath $PluginInventoryPath -Raw | ConvertFrom-Json
$pluginDirectories = foreach ($plugin in $inventory.plugins.PSObject.Properties) {
    foreach ($installation in @($plugin.Value)) {
        if ($installation.scope -ne 'user') {
            continue
        }

        $resolvedInstallPath = (Resolve-Path -LiteralPath $installation.installPath).Path
        if (-not $resolvedInstallPath.StartsWith($resolvedPluginRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Plugin $($plugin.Name) is outside the mounted plugin cache: $resolvedInstallPath"
        }

        ConvertTo-SandboxPath $resolvedInstallPath
    }
}

$pluginDirectories = @($pluginDirectories | Sort-Object -Unique)
if ($pluginDirectories.Count -eq 0) {
    throw 'No user-scope Claude Code plugins were found in the inventory.'
}

$pluginArguments = foreach ($pluginDirectory in $pluginDirectories) {
    '--plugin-dir'
    $pluginDirectory
}

$pluginMount = "${resolvedPluginRoot}:ro"
$runArguments = @(
    'run'
    'claude'
    '--name'
    $SandboxName
    '--kit'
    $resolvedKit
    $resolvedWorkspace
    $pluginMount
    '--'
) + $pluginArguments + $ClaudeArgument

Write-Host "Loading $($pluginDirectories.Count) user-scope Claude Code plugin(s) from $resolvedPluginRoot"
if ($PSCmdlet.ShouldProcess($SandboxName, 'Create and run the Claude Code sandbox')) {
    & sbx @runArguments
}