# Run this on the first client PC to setup. Change the admin name & password to whatever you want.
$adminUser = "LANAdmin"
$adminPass = "SuperSecret123"

# Adds a user account as an admin.
net user $adminUser $adminPass /add
net localgroup Administrators $adminUser /add

# Hides the account so users cannot see it.
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name $adminUser -Value 0 -PropertyType DWord

# Prepares the client for imaging by removing machine specific stuff.
C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown