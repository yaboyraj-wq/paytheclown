$ErrorActionPreference = 'Stop'
$taskToolBin = Join-Path $env:USERPROFILE '.rokit\bin'
if (Test-Path -LiteralPath $taskToolBin) { $env:PATH = $taskToolBin + [IO.Path]::PathSeparator + $env:PATH }
function Invoke-Checked { param([string]$Tool, [string[]]$ToolArgs)
    & $Tool @ToolArgs
    if ($LASTEXITCODE -ne 0) { throw "$Tool failed with exit code $LASTEXITCODE" }
}
New-Item -ItemType Directory -Path '.tools','build' -Force | Out-Null
if (-not (Test-Path -LiteralPath '.tools/globalTypes.d.luau')) {
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/1.70.1/scripts/globalTypes.d.luau' -OutFile '.tools/globalTypes.d.luau'
}
Invoke-Checked 'stylua' @('--check','src','tools/tests')
Invoke-Checked 'selene' @('src','tools/tests')
Invoke-Checked 'rojo' @('sourcemap','dev.project.json','--output','sourcemap.json')
Invoke-Checked 'luau-lsp' @('analyze','--definitions=.tools/globalTypes.d.luau','--sourcemap=sourcemap.json','--ignore=Packages/**','--ignore=ServerPackages/**','src')
Invoke-Checked 'lune' @('run','tools/tests/run')
foreach ($taskProject in @('hub','tower','dev')) {
    Invoke-Checked 'rojo' @('build',"$taskProject.project.json",'--output',"build/$taskProject.rbxl")
}

