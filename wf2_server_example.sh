#!/usr/bin/env bash
# ─────────────────────────────────────────────────────
#  QUEENS MAIN CORE — Beispiel Server Script (WF2)
#
#  Zweiter Server-Slot — z.B. für einen zweiten Port,
#  eine andere Konfiguration oder ein anderes Spiel.
#
#  Unterstützte Befehle:
#    ./wf2_server.sh start   — Server starten
#    ./wf2_server.sh stop    — Server stoppen
#    ./wf2_server.sh status  — Status anzeigen
#    ./wf2_server.sh check   — Ports + Prozesse prüfen
# ─────────────────────────────────────────────────────
set -euo pipefail

# ── KONFIGURATION ─────────────────────────────────────
SERVER_NAME="Wreckfest Server 2"
SERVER_BIN="/path/to/your/wreckfest_server"   # Pfad zur Server-Binary
SERVER_PORT=27017                               # Anderen Port als WF1!
RCON_PORT=27018
LOG_FILE="/tmp/wf2_server.log"
PID_FILE="/tmp/wf2_server.pid"

USE_WINE=false
WINEPREFIX="$HOME/.wine-wreckfest"
# ── ENDE KONFIGURATION ────────────────────────────────

is_running() {
  [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

cmd_start() {
  if is_running; then
    echo "[$SERVER_NAME] Läuft bereits (PID: $(cat "$PID_FILE"))"
    exit 0
  fi

  echo "[$SERVER_NAME] Starte..."

  if $USE_WINE; then
    WINEPREFIX="$WINEPREFIX" nohup wine "$SERVER_BIN" \
      >> "$LOG_FILE" 2>&1 &
  else
    nohup "$SERVER_BIN" \
      >> "$LOG_FILE" 2>&1 &
  fi

  echo $! > "$PID_FILE"
  echo "[$SERVER_NAME] Gestartet mit PID $(cat "$PID_FILE")"
  echo "Log: $LOG_FILE"
}

cmd_stop() {
  if ! is_running; then
    echo "[$SERVER_NAME] Läuft nicht."
    rm -f "$PID_FILE"
    exit 0
  fi
  local pid
  pid="$(cat "$PID_FILE")"
  echo "[$SERVER_NAME] Stoppe PID $pid..."
  kill "$pid" 2>/dev/null || true
  sleep 2
  kill -9 "$pid" 2>/dev/null || true
  rm -f "$PID_FILE"
  echo "[$SERVER_NAME] Gestoppt."
}

cmd_status() {
  echo "=== $SERVER_NAME STATUS ==="
  if is_running; then
    echo "Status : ✅ LÄUFT (PID: $(cat "$PID_FILE"))"
  else
    echo "Status : ❌ GESTOPPT"
  fi
  echo "Port   : $SERVER_PORT (UDP)"
  echo "Log    : $LOG_FILE"
}

cmd_check() {
  cmd_status
  echo ""
  echo "=== PORT CHECK ==="
  echo "UDP $SERVER_PORT:"
  ss -ulnp | grep ":$SERVER_PORT " || echo "  (kein Listener gefunden)"
  echo ""
  echo "=== LETZTE LOG-ZEILEN ==="
  [[ -f "$LOG_FILE" ]] && tail -20 "$LOG_FILE" || echo "(kein Log vorhanden)"
}

case "${1:-}" in
  start)  cmd_start  ;;
  stop)   cmd_stop   ;;
  status) cmd_status ;;
  check)  cmd_check  ;;
  *)
    echo "Usage: $0 {start|stop|status|check}"
    exit 1
    ;;
esac
