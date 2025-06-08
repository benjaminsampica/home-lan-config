# Run this on the first client PC to setup. Change the admin name & password to whatever you want.
$adminName = "LANAdmin"
$password = "SuperSecret123"

# Adds a user account as an admin.
net user $adminName $password /add
net localgroup Administrators $adminName /add

# Hides the account so users cannot see it.
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name $adminName -Value 0 -PropertyType DWord

# Prepares the client for imaging by removing machine specific stuff.
C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown