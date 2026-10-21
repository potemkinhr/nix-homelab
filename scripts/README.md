# Infrastructure & Automation Scripts

A collection of Bash, PowerShell, and Python scripts for automating system administration, fixing OS edge-cases, and daily workflows. Tested primarily on immutable Linux (Aurora/uBlue) and enterprise systems.

## 📜 Scripts Directory

| Script | Description | Target OS |
| :--- | :--- | :--- |
| [`flatpak-keepassxc-bridge.sh`](#flatpak-keepassxc-bridgesh) | Bridges the Flatpak sandbox between Brave Browser and KeePassXC for native messaging. | Linux (Flatpak) |

---

## 🛠️ Detailed Instructions

### `flatpak-keepassxc-bridge.sh`

**The Issue:** 
When both KeePassXC and Brave are installed as Flatpaks, Chromium cannot launch the `keepassxc-proxy` binary because it is trapped inside KeePassXC's sandbox. This script uses `flatpak-spawn` to generate a secure wrapper, bridging the two sandboxes without disabling security.

**Prerequisites:**
- `flatpak`
- Brave Browser (`com.brave.Browser`)
- KeePassXC (`org.keepassxc.KeePassXC`)

**Usage:**
1. Make executable and run:
   ```bash
   chmod +x flatpak-keepassxc-bridge.sh
   ./flatpak-keepassxc-bridge.sh
   ```
2. **Crucial Step:** Completely quit Brave (ensure no lingering processes via `flatpak ps | grep brave`). Relaunch Brave and reconnect the extension.

---

