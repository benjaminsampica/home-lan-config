$steamcmd = "C:\SteamTools\SteamCMD\steamcmd.exe"
$manifest = Get-Content "C:\SteamTools\games.json" | ConvertFrom-Json
$user = "your_steam_username"
$pass = "your_password"

foreach ($id in $manifest.install) {
    Start-Process -NoNewWindow -Wait $steamcmd -ArgumentList "+login $user $pass +force_install_dir C:\SteamGames\$id +app_update $id validate +quit"
}

foreach ($id in $manifest.uninstall) {
    $path = "C:\SteamGames\$id"
    if (Test-Path $path) {
        Remove-Item -Recurse -Force $path
    }
}