# Copyright (c) 2026 Kevin Collins.
# SPDX-License-Identifier: MPL-2.0-no-copyleft-exception

[CmdletBinding()]
param(
    [string]$GameSource,
    [string]$PackageRoot = 'C:\gitdev\nexus\packages\nexus-packages',
    [string]$Nexus2DRoot = 'C:\gitdev\Nexus2D',
    [string]$CompilerBin = 'C:\lazarus\fpc\3.2.2\bin\x86_64-win64',
    [string]$GnuDllToolBin = 'C:\gitdev\tools\solar2d-win64-deps\strawberry-perl-5.42.3.1\c\bin',
    [string]$OutputRoot
)
$ErrorActionPreference = 'Stop'
if (-not $GameSource) { $GameSource = Join-Path $PSScriptRoot '..' }
if (-not $OutputRoot) {
    $OutputRoot = Join-Path $env:TEMP ('StarExplorerPluginProof-' + [guid]::NewGuid().ToString('N'))
}
$OutputRoot = [IO.Path]::GetFullPath($OutputRoot)
$GameSource = (Resolve-Path -LiteralPath $GameSource).Path
if ($OutputRoot.StartsWith($GameSource.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
    throw 'OutputRoot must be outside the source game.'
}
if ((Test-Path -LiteralPath $OutputRoot) -and @(Get-ChildItem -LiteralPath $OutputRoot -Force).Count) {
    throw 'OutputRoot must be a new or empty directory.'
}
if ($OutputRoot -match '\s') { throw 'This historical GNU linker build requires an output path without spaces.' }
$lPackageRoot = (Resolve-Path -LiteralPath $PackageRoot).Path
$lSimulatorRoot = Join-Path $Nexus2DRoot 'platform\windows\Bin\Corona'
$lProxy = Join-Path $lSimulatorRoot 'Resources\CoronaLabs.Corona.Native.dll'
$lCompiler = Join-Path $CompilerBin 'fpc.exe'
$lDllTool = (Get-Command llvm-dlltool.exe -ErrorAction Stop).Source
$lReadObj = (Get-Command llvm-readobj.exe -ErrorAction Stop).Source
foreach ($lPath in @($lCompiler, "$CompilerBin\as.exe", "$CompilerBin\ld.exe",
    "$GnuDllToolBin\dlltool.exe", $lProxy, "$lSimulatorRoot\lua.dll", "$GameSource\main.lua")) {
    if (-not (Test-Path -LiteralPath $lPath)) { throw "Missing proof prerequisite: $lPath" }
}
if ((& $lCompiler -iV) -ne '3.2.2') { throw 'This recovered recipe uses the historically tested FPC 3.2.2 toolchain.' }
if ((& $lCompiler -iTP) -ne 'x86_64' -or (& $lCompiler -iTO) -ne 'win64') {
    throw 'The proof requires the native Win64 compiler.'
}
$lBuild = Join-Path $OutputRoot 'build'
$lGame = Join-Path $OutputRoot 'StarExplorer'
[void](New-Item -ItemType Directory -Path $lBuild, $lGame -Force)
foreach ($lName in @('as.exe', 'ld.exe')) {
    Copy-Item -LiteralPath (Join-Path $CompilerBin $lName) -Destination $lBuild
}
Copy-Item -LiteralPath "$GnuDllToolBin\dlltool.exe" -Destination $lBuild
& $lDllTool -m i386:x86-64 -d "$PSScriptRoot\imports\lua.def" -l "$lBuild\liblua.a"
if ($LASTEXITCODE -ne 0) { throw 'Lua import-library generation failed.' }
& $lDllTool -m i386:x86-64 -d "$PSScriptRoot\imports\CoronaNativeProxy.def" -l "$lBuild\libCoronaLabs.Corona.Native.a"
if ($LASTEXITCODE -ne 0) { throw 'Corona proxy import-library generation failed.' }
$lOldPath = $env:PATH
try {
    $env:PATH = "$GnuDllToolBin;$env:PATH"
    $lArguments = @('-B', '-Xe', "-FD$lBuild", '-MObjFPC', '-Scgi',
        "-Fu$lPackageRoot\lua\src\bindings", "-Fu$lPackageRoot\lua\src",
        "-Fu$lPackageRoot\solar2d\src", "-Fu$lPackageRoot\solar2d\sample",
        "-FU$lBuild", "-FE$lBuild", "-Fl$lBuild", "-o$lBuild\plugin_sample.dll",
        "$PSScriptRoot\plugin_sample.lpr")
    # Windows PowerShell treats native stderr diagnostics as errors even when
    # the compiler succeeds. Preserve diagnostics and use its exit code.
    $ErrorActionPreference = 'Continue'
    & $lCompiler @lArguments 2>&1 | ForEach-Object { $_.ToString() } |
        Set-Content -LiteralPath "$lBuild\compile.log"
    $lCompileExitCode = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    if ($lCompileExitCode -ne 0) {
        Get-Content -LiteralPath "$lBuild\compile.log" -Tail 30
        throw 'Plugin compilation failed.'
    }
} finally { $env:PATH = $lOldPath; $ErrorActionPreference = 'Stop' }
$lImage = & $lReadObj --file-headers --coff-imports --coff-exports "$lBuild\plugin_sample.dll"
if ($LASTEXITCODE -ne 0) { throw 'Plugin image inspection failed.' }
$lImage | Set-Content -LiteralPath "$lBuild\image.txt"
$lText = $lImage -join "`n"
foreach ($lExpected in @('IMAGE_FILE_MACHINE_AMD64', 'luaopen_plugin_sample', 'Name: lua.dll', 'Name: CoronaLabs.Corona.Native.dll')) {
    if (-not $lText.Contains($lExpected)) { throw "Plugin is missing the expected image contract: $lExpected" }
}
if ($lText.Contains('Name: Corona Simulator.exe')) { throw 'The plugin must import the native proxy, not the simulator executable.' }
Get-ChildItem -LiteralPath $GameSource -Force | Copy-Item -Destination $lGame -Recurse
$lPluginDirectory = Join-Path $lGame 'plugin'
[void](New-Item -ItemType Directory -Path $lPluginDirectory -Force)
Copy-Item -LiteralPath "$lBuild\plugin_sample.dll" -Destination "$lPluginDirectory\sample.dll" -Force
Copy-Item -LiteralPath $lProxy -Destination $lPluginDirectory -Force
Write-Host "Built and staged the proof: $lGame"
Write-Host "Open $lGame\main.lua with $lSimulatorRoot\Corona Simulator.exe."
Write-Host 'Expected banner: WIN64 PASCAL PLUGIN: PASS, Add(20, 22) = 42, and the StarExplorer greeting.'
