#!/usr/bin/env bash
set -euo pipefail

source /workspace/.ci-workflows/hooks/lib/distro.sh
source /workspace/.ci-workflows/hooks/lib/common.sh || true

log "Project pre-test hook – distro: $ID ($ID_LIKE)"

echo "[DEBUG] /etc/os-release content:"
cat /etc/os-release || true
echo "[DEBUG] Detected ID=$ID, ID_LIKE=$ID_LIKE, RELEASE=${RELEASE:-unknown}"

if is_el; then
  log "RHEL-kompatible Distro erkannt – installiere OpenVox..."
  dnf install -y --allowerasing "https://yum.voxpupuli.org/openvox8-release-el-${RELEASE}.noarch.rpm"
  dnf makecache
else
  log "Nicht-RHEL-kompatible Distribution – epel-release wird übersprungen."
fi
