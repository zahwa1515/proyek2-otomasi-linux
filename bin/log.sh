#!/usr/bin/env bash
# log.sh - fungsi pencatatan log. Dipakai dengan: source bin/log.sh
LOG_FILE="${LOG_FILE:-logs/sysinfo.log}"

log_init() {
  mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || return 1
  touch "$LOG_FILE" 2>/dev/null || return 1
}

_log() {
  local level="$1"; shift
  local line
  line="$(date '+%Y-%m-%d %H:%M:%S') [$level] $*"
  echo "$line" >> "$LOG_FILE" 2>/dev/null || true
  if [ "$level" = "INFO" ]; then echo "$line"; else echo "$line" >&2; fi
}

log_info()  { _log INFO "$@"; }
log_warn()  { _log WARN "$@"; }
log_error() { _log ERROR "$@"; }
