$ErrorActionPreference = "Stop"

$map = Get-Location

Write-Host "Installing BeatForge..." -ForegroundColor Cyan

# Create script template
if (!(Test-Path "$map\script.lua")) {
@"
-- BeatForge entry script
local bf = require("beatforge")
local map = bf.load("ExpertPlus.dat")

map:notes(function(n)
    n.animation.dissolve = { {0,0}, {1,0.3,"easeOutSine"} }
end)

map:save("ExpertPlus.dat")
"@ | Set-Content "$map\script.lua"
}

# Download loader
$loaderUrl = "https://raw.githubusercontent.com/ThijsvZwam/BeatForge/main/beatforge.lua"
Invoke-WebRequest $loaderUrl -OutFile "$map\beatforge.lua"

Write-Host "BeatForge installed!" -ForegroundColor Green