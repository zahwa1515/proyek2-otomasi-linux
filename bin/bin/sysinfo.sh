#!/usr/bin/env bash
# sysinfo.sh - membuat laporan informasi sistem ke sebuah direktori.
# Pemakaian: bin/sysinfo.sh <direktori_output> [nama_laporan]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/log.sh"
source "$SCRIPT_DIR/validate.sh"

TMP_FILE=""
cleanup() {
  if [ -n "$TMP_FILE" ] && [ -f "$TMP_FILE" ]; then rm -f "$TMP_FILE"; fi
}
trap cleanup EXIT

usage() { echo "Pemakaian: $0 <direktori_output> [nama_laporan]" >&2; }

collect_info() {
  echo "=== Laporan Sistem ==="
  echo "Waktu     : $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Hostname  : $(hostname)"
  echo "Kernel    : $(uname -sr)"
  echo "Uptime    : $(uptime -p)"
  echo "--- Disk (/) ---"
  df -h /
  echo "--- Memori ---"
  free -h
}

main() {
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then usage; exit 2; fi
  local out_dir="$1"
  local name="${2:-sysinfo_$(date +%Y%m%d_%H%M%S).txt}"
  local rc=0

  log_init || { echo "Gagal menyiapkan file log" >&2; exit 1; }
  log_info "Mulai: output_dir=$out_dir nama=$name"

  validate_output_dir "$out_dir" || rc=$?
  if [ "$rc" -ne 0 ]; then log_error "Validasi direktori gagal (kode $rc)"; exit "$rc"; fi
  validate_report_name "$name" || rc=$?
  if [ "$rc" -ne 0 ]; then log_error "Validasi nama gagal (kode $rc)"; exit "$rc"; fi

  TMP_FILE="$(mktemp "$out_dir/.sysinfo.XXXXXX")" || { log_error "Gagal membuat file sementara"; exit 1; }
  if ! collect_info > "$TMP_FILE"; then log_error "Gagal mengumpulkan informasi"; exit 1; fi
  mv "$TMP_FILE" "$out_dir/$name"
  TMP_FILE=""
  log_info "Selesai: laporan disimpan di $out_dir/$name"
}

main "$@"
