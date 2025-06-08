# Run this on the first client PC to setup. Change the admin name & password to whatever you want.
# This script should only be run after installing all software (like Steam)
$adminUser = "LANAdmin"
$adminPass = "SuperSecret123"

# Adds a user account as an admin.
net user $adminUser $adminPass /add
net localgroup Administrators $adminUser /add

# Hides the account so users cannot see it.
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name $adminUser -Value 0 -PropertyType DWord

# Create a Steam folder on C: that all users can access.
# Ensure the install directory exists
$installDir = "C:\SteamGames"
if (-not (Test-Path $installDir)) {
    New-Item -Path $installDir -ItemType Directory -Force | Out-Null
    Write-Output "Created folder: $installDir"
} else {
    Write-Output "Folder already exists: $installDir"
}

# Path to Steam's library config file
$libraryFile = "C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"

if (Test-Path $libraryFile) {
    $content = Get-Content $libraryFile

    if ($content -notmatch "C:\\\\SteamGames") {
        # Determine next available index
        $lastIndex = ($content | Where-Object { $_ -match '^\s*"\d+"\s*"' }).Count
        $insertLine = "    `"$lastIndex`" `"C:\\\\SteamGames`""

        # Insert before the closing brace
        $insertIndex = ($content | Select-String '^\s*}' | Select-Object -Last 1).LineNumber - 1
        $newContent = $content[0..($insertIndex - 1)] + $insertLine + $content[$insertIndex..($content.Count - 1)]

        $newContent | Set-Content $libraryFile -Encoding UTF8
        Write-Output "Added C:\\SteamGames as library folder index $lastIndex"
    } else {
        Write-Output "SteamGames folder already in Steam library."
    }
} else {
    Write-Warning "Steam library file not found. Make sure Steam is installed."
}

# Prepares the client for imaging by removing machine specific stuff.
C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown
