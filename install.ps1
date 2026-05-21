$ErrorActionPreference = "Stop"

Write-Host "Installing BeatForge..." -ForegroundColor Cyan

$repo = "https://raw.githubusercontent.com/ThijsvZwam/BeatForge/main"
$profilePath = $PROFILE

# ensure profile exists
if (!(Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# define bf_setup function
$function = @'

function bf_setup {

    $map = Get-Location
    $repo = "https://raw.githubusercontent.com/ThijsvZwam/BeatForge/main"

    Write-Host "Setting up BeatForge in $map ..." -ForegroundColor Cyan

    # download loader
    Invoke-WebRequest "$repo/beatforge.lua" -OutFile "$map\beatforge.lua"

    # create script.lua if missing
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

    Write-Host "BeatForge setup complete!" -ForegroundColor Green
}

'@

# prevent duplicates
if (-not (Select-String -Path $profilePath -Pattern "function bf_setup" -Quiet -ErrorAction SilentlyContinue)) {
    Add-Content -Path $profilePath -Value $function
}

Write-Host "Installed successfully!" -ForegroundColor Green
Write-Host "Use: bf_setup, to set up BeatForge in your current directory." -ForegroundColor Yellow