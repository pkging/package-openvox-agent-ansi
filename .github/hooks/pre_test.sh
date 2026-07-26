#!/usr/bin/env bash
set -euo pipefail

source /workspace/.ci-workflows/hooks/lib/distro.sh
source /workspace/.ci-workflows/hooks/lib/common.sh || true

log "Project pre-test hook – distro: $ID ($ID_LIKE)"

echo "[DEBUG] /etc/os-release content:"
cat /etc/os-release || true
echo "[DEBUG] Detected ID=$ID, ID_LIKE=$ID_LIKE, RELEASE=${RELEASE:-unknown}"

if is_el; then
  log "RHEL-kompatible Distro erkannt – installiere epel-release..."
  dnf install -y --allowerasing epel-release
  if [ "${RELEASE:-9}" -gt 8 ]; then
    dnf config-manager --enable crb
  else
    dnf config-manager --enable powertools
  fi
  dnf makecache
else
  log "Nicht-RHEL-kompatible Distribution – epel-release wird übersprungen."
fi
