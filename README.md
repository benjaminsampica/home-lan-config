# 🖥️ LAN Gaming Setup – Centralized Sync & Game Deployment

This repo contains a step-by-step guide and scripts to set up and manage 8 LAN Windows 11 gaming PCs using a single “master” server. With this system, you’ll be able to:

- Deploy Windows 11 to all machines from one image
- Install or uninstall Steam games via a shared manifest
- Push those game changes out to all 8 clients in one click
- Host LAN game servers
- Keep everything in sync with a monthly update process

## 🧱 STEP 1 – Prep the First Client PC

1. Install **Windows 11 Pro** on one of the LAN PCs.
2. Configure it fully:
   - Disable Cortana, News/Interests, etc.
   - Install all drivers and updates
   - Install Steam (but don’t log in)
   - Create folder: `C:\SteamGames`
   - Install any default tools (e.g., Chrome, MSI Afterburner)
3. Create a shared local admin account on the PC and prepare for imaging by running `master-client-machine-setup.ps1`.

## 📦 STEP 2 – Clone the Image to the Other PCs

**Recommended Tool: [Macrium Reflect Free](https://www.macrium.com/reflectfree)**

### On the Master PC:
1. Create an image of Disk 0 using Macrium.
2. Save it to an external SSD or HDD.
3. Create a Macrium Rescue USB (via "Create Rescue Media").

### On the Other PCs:
1. Plug in the Rescue USB + the image drive.
2. Boot to USB (tap `F12` or `DEL` during startup).
3. Restore the image to the internal disk.
4. Reboot and complete Windows setup.

> Repeat for all clients.

## 🌐 STEP 3 – Setup Shared Folder on Your Server

On your server (not a client machine).
1. Create a folder: `C:\SteamTools`
2. Inside it, place:
   - `games.json`
   - `sync_games.ps1`
3. Share this folder over the network:
   - Right-click > Properties > Sharing > Share > "Everyone" (read/write)
   - Example network path: `\\192.168.1.100\sync`

## 🔁 STEP 4 – Configure Game Sync System

1. Install [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) on your server:
   - Extract to: `C:\SteamTools\SteamCMD`
2. Edit `games.jsonc` with the AppIDs to install or uninstall.
3. Run `sync_games.ps1` on the server to download and cache all game data into `C:\SteamGames`.

## 🌐 STEP 5 - LAN Cache Setup with lancache.net

To ensure games are only downloaded once and then served locally to all other PCs, this setup uses [lancache.net](https://lancache.net) on the server.

### 🚀 Why?

When any PC downloads a Steam game, the data is cached locally on the server. All future downloads or updates for that game are pulled at LAN speed from the cache instead of Steam’s servers.

### 🧱 Setup Overview

| Component          | Tool            | Host                  |
|-------------------|-----------------|-----------------------|
| Cache system       | `lancache.net`  | Your “master” server  |
| DNS override       | Manual or DHCP  | Each LAN PC           |
| Cached games       | SSD/HDD         | Server local storage  |

### 🧰 Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed on your server
- Static IP for the server (e.g., `192.168.1.100`)

### 📦 Folder Structure

Create the following folder on your server:

```
C:\Lancache
├── lancache-docker-compose.yml
├── lancache
├── lancache-dns
├── lancache-logs
```

### Run The Lancache Server

Run `lancache-setup.ps1`. This starts your local cache and DNS service.

### 🖥️ Configuring LAN PCs

On each LAN PC:
1. Go to Network Adapter settings > TCP/IPv4 > Properties
2. Set DNS to:

```
Preferred DNS: 192.168.1.100
Alternate DNS: 8.8.8.8
```

This ensures:
- If Lancache is up, downloads are cached
- If Lancache is down, the PC still connects to the internet normally

### ⚠️ If You Only Use the Cache DNS

If you set **only** `192.168.1.100` and the cache is offline, all internet access will break due to DNS failure. Always use a backup DNS (e.g., 8.8.8.8).

## 🧨 STEP 6 – Push Sync to Clients

1. Download [PSExec](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) and extract to `C:\Tools\PsExec`.
2. Edit `push_sync.ps1`:
   - Update the PC names (e.g., `PC-01` to `PC-08`)
   - Replace `$adminUser` and `$$adminPass` with the credentials you configured on the clients via `master-client-machine-setup.ps1`.
   - Confirm the share path is correct.
3. Run `push_sync.ps1` from your server to remotely sync all client machines using PsExec.

## 📅 Updating The Clients Games Going Forward

When it’s time to sync:

1. Ensure every PC is powered on, logged in, and connected to the network.
2. Update `games.json` (add/remove games)
3. Run `sync_games.ps1` on the server to cache new data
4. Run `push_sync.ps1` to push changes to all PCs