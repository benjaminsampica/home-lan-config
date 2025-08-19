# 🖥️ LAN Gaming Setup

## Helpful Setup
   - Set desktop wallpaper, power settings, disable updates
   - Install any software you want preconfigured
   - Remove watermark
```powershell
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Value 0
```
---
   - Set background every time
   ```powershell
# Set-Wallpaper.ps1
$wallpaper = "C:\Wallpapers\lan_bg.jpg"
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
# 20 = SPI_SETDESKWALLPAPER, 3 = update INI file
[Wallpaper]::SystemParametersInfo(20, 0, $wallpaper, 3)
```
   Save this to `C:\Scripts` and create a shortcut in `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp` with the target `powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\Set-Wallpaper.ps1 `

## LanCache Server

The settings for LanCache can be found in the [scripts](/scripts) folder. Simply set your env variables, run `firewall-allow.ps1`, and then run the `docker-compose.yml` file.

## Extras

- Game hosting https://playit.gg/
