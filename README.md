# 🖥️ LAN Gaming Setup – PXE Imaging & Turnkey Game Deployment

This guide walks you through setting up a **completely turnkey LAN gaming environment** using:

- A single master image (with Windows 11 + Steam games preinstalled)  
- PXE boot + Clonezilla for monthly reimaging  
- Auto-login into a local admin account  
- No OOBE, no setup screens, just **power on and game**

---

## 🔧 Goal

You power on a LAN PC → it auto-boots into Windows → logs into a preconfigured admin account → games are installed and ready.

---

## 🧱 STEP 1 – Set Up the Master PC

1. **Install Windows 11 Pro**
2. **Create a Local Admin User**

   ```powershell
   net user LANUser SuperSecret123 /add
   net localgroup Administrators LANUser /add
   ```

3. **Enable Auto-Login for That User**

   ```powershell
   $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
   Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value "LANUser"
   Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value "SuperSecret123"
   Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1"
   ```

4. **Install Steam and Games**
   - Install Steam
   - Set the library to `C:\SteamGames`
   - Download and install all LAN games you want included

5. **Do Any Final Tuning**
   - Set desktop wallpaper, power settings, disable updates
   - Install any software you want preconfigured
   - Remove watermark
```powershell
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "PaintDesktopVersion" -Value 0
```
---

## 🧼 STEP 2 – Generalize the Image (Skip OOBE)

Open PowerShell **as administrator** and run:

```powershell
C:\Windows\System32\Sysprep\sysprep.exe /generalize /shutdown
```

> This resets system-specific data but **keeps the local user intact**. No setup wizard (OOBE) will appear on first boot.

---

## 🖥️ STEP 3 – Capture the Image with Clonezilla

1. Create a Clonezilla USB drive
2. Boot the master PC into Clonezilla
3. Choose `device-image` → save to:
   - External USB **or**
   - Network share (e.g., `\\192.168.1.100\images`)
4. Save as: `win11-lan-v1`
5. Shut down when finished

---

## 🌐 STEP 4 – Set Up PXE Server

Use **Tiny PXE Server** (Windows) or **Serva**. On your server:

1. Point TFTP root to Clonezilla’s files
2. Copy `win11-lan-v1` to the `images` directory
3. Use this PXE config:

   ```cfg
   label win11-lan-v1
       menu label Restore LAN Image
       kernel clonezilla/live/vmlinuz
       append initrd=clonezilla/live/initrd.img boot=live config noswap edd=on nomodeset ocs_live_run="ocs-sr -e1 auto -e2 -r -j2 -scr -p poweroff restoredisk win11-lan-v1 sda" ocs_live_extra_param="" keyboard-layouts="NONE" ocs_live_batch="yes" locales="en_US.UTF-8" vga=788 fetch=tftp://192.168.1.100/clonezilla/live/filesystem.squashfs
   ```

---

## 🚀 STEP 5 – PXE Boot & Reimage Clients

1. Enable PXE boot in each client’s BIOS
2. Power on the PXE server
3. Boot each LAN PC
4. The system will auto-download and install the image
5. PC will shut down when done
6. Power it on — it’s now **ready to play**

---

## 🧯 STEP 6 – Optional: Disable PXE Boot

To prevent accidental reinstalls:
- Disable PXE boot in BIOS after imaging
- Or just change boot order to internal drive first

---

## 📅 Monthly Maintenance Flow

1. Power on one LAN PC
2. Add/remove Steam games
3. Rerun Sysprep (`/generalize /shutdown`)
4. Reimage using Clonezilla again as `win11-lan-v2`
5. Update PXE config
6. PXE boot the others to refresh

---

## ✅ Result

- Each machine is clean, identical, and fully loaded  
- Steam games are ready to go  
- LANUser is logged in automatically  
- No config needed from end users

## Extras

- Game hosting https://playit.gg/
