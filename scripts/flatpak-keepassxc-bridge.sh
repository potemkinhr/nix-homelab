#!/bin/bash
# Fix KeePassXC-Browser native messaging when BOTH KeePassXC and Brave are
# installed as Flatpaks (e.g. on immutable Fedora / Aurora / uBlue).
#
# Root cause: the native messaging manifest Chromium-based browsers look for
# normally points at a real host binary (keepassxc-proxy). When KeePassXC is
# a Flatpak, that binary only exists inside KeePassXC's own sandbox, so Brave
# can't launch it directly. This script builds a wrapper that uses
# flatpak-spawn to reach into KeePassXC's sandbox and run the real proxy from
# there, then wires it up as Brave's native messaging host.
#
# Safe to re-run — it overwrites its own generated files each time.

set -euo pipefail

BRAVE_APP_ID="com.brave.Browser"
KEEPASSXC_APP_ID="org.keepassxc.KeePassXC"
BRAVE_CFG_DIR="$HOME/.var/app/${BRAVE_APP_ID}/config/BraveSoftware/Brave-Browser"
WRAPPER="${BRAVE_CFG_DIR}/keepassxc-proxy-wrapper.sh"
NMH_DIR="${BRAVE_CFG_DIR}/NativeMessagingHosts"
NMH_JSON="${NMH_DIR}/org.keepassxc.keepassxc_browser.json"

echo "==> Checking prerequisites"
command -v flatpak >/dev/null || { echo "flatpak not found"; exit 1; }
flatpak info "${BRAVE_APP_ID}" >/dev/null 2>&1 || { echo "Brave Flatpak (${BRAVE_APP_ID}) not installed"; exit 1; }
flatpak info "${KEEPASSXC_APP_ID}" >/dev/null 2>&1 || { echo "KeePassXC Flatpak (${KEEPASSXC_APP_ID}) not installed"; exit 1; }

echo "==> Granting Brave access to KeePassXC's Flatpak files and proxy socket"
flatpak override --user \
  --filesystem=/var/lib/flatpak:ro \
  --filesystem="$HOME/.local/share/flatpak:ro" \
  --filesystem=xdg-run/app/org.keepassxc.KeePassXC:create \
  "${BRAVE_APP_ID}"

echo "==> Writing wrapper script: ${WRAPPER}"
mkdir -p "${BRAVE_CFG_DIR}"
cat > "${WRAPPER}" << 'EOF'
#!/bin/bash
REF="org.keepassxc.KeePassXC/x86_64/stable"

for base in "$HOME/.local/share/flatpak" /var/lib/flatpak; do
    [ -d "$base/app/$REF" ] && APP_BASE="$base" && break
done
[ -z "${APP_BASE:-}" ] && exit 1
APP_PATH="$APP_BASE/app/$REF/active"

RUNTIME=$(awk -F'=' '$1=="runtime"{print $2}' "$APP_PATH/metadata")
for base in "$HOME/.local/share/flatpak" /var/lib/flatpak; do
    [ -d "$base/runtime/$RUNTIME" ] && RT_BASE="$base" && break
done
[ -z "${RT_BASE:-}" ] && exit 1
RUNTIME_PATH="$RT_BASE/runtime/$RUNTIME/active"

exec flatpak-spawn \
    --env=LD_LIBRARY_PATH=/app/lib \
    --app-path="$APP_PATH/files" \
    --usr-path="$RUNTIME_PATH/files" \
    -- /app/bin/keepassxc-proxy "$@"
EOF
chmod +x "${WRAPPER}"

echo "==> Writing native messaging manifest: ${NMH_JSON}"
mkdir -p "${NMH_DIR}"
cat > "${NMH_JSON}" << EOF
{
    "allowed_origins": [
        "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/",
        "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
    ],
    "description": "KeePassXC integration with native messaging support",
    "name": "org.keepassxc.keepassxc_browser",
    "path": "${WRAPPER}",
    "type": "stdio"
}
EOF

echo "==> Sanity-testing the wrapper (should exit 0, no 'No such file' error)"
if flatpak run --command=/bin/sh "${BRAVE_APP_ID}" -c "'${WRAPPER}' < /dev/null"; then
  echo "OK: wrapper launched cleanly."
else
  echo "WARNING: wrapper did not exit cleanly — check flatpak override permissions"
  echo "and confirm KeePassXC's Flatpak ref/runtime match what this script expects."
fi

echo
echo "Done. Now fully quit Brave (check 'flatpak ps' for lingering com.brave.Browser"
echo "processes), relaunch it, and reconnect the KeePassXC-Browser extension."
