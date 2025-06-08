$serverShare = "\\192.168.1.100\sync"
$scriptPath = "$serverShare\sync_games.ps1"
$adminUser = "LANAdmin"
$adminPass = "SuperSecret123" # Use what you set in `master-client-machine-setup.ps1`

# Computer names on the local network.
$targets = @(
  "PC-01",
  "PC-02",
  "PC-03",
  "PC-04",
  "PC-05",
  "PC-06",
  "PC-07",
  "PC-08"
)

foreach ($target in $targets) {
    Write-Host "Syncing $target..."
    Start-Process -FilePath "C:\Tools\PsExec\PsExec.exe" -ArgumentList "\\$target -u $adminUser -p $adminPass powershell -ExecutionPolicy Bypass -File $scriptPath" -NoNewWindow -Wait
}