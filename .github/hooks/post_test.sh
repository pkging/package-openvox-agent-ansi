#!/usr/bin/env bash
set -euo pipefail

source /workspace/.ci-workflows/hooks/lib/distro.sh
source /workspace/.ci-workflows/hooks/lib/common.sh || true

log "Project post-test hook – distro: $ID ($ID_LIKE)"

# z.B. Logs sammeln, zusätzliche Checks, Cleanup

# ---------------------------------------------------------------------------
# SMOKE TESTS
# ---------------------------------------------------------------------------
log "Running smoke tests..."

if is_debian || is_ubuntu; then
  MYBIN='/usr/lib/nagios/plugins/check_apache_status.pl'
else
  MYBIN='/usr/lib64/nagios/plugins/check_apache_status.pl'
fi

# Beispiel: Prüfen, ob das installierte Binary existiert
if command -v $MYBIN >/dev/null 2>&1; then
  log "Binary '${MYBIN}' found – OK"
else
  echo "❌ Binary '${MYBIN}' fehlt nach Installation!" >&2
  exit 1
fi

# Beispiel: Versionstest
#$MYBIN || {
#  echo "❌ ${MYBIN} fehlgeschlagen!" >&2
#  exit 1
#}

log "Smoke tests completed successfully."

