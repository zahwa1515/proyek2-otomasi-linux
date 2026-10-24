#!/usr/bin/env bash
# validate.sh - validasi input. Dipakai dengan: source bin/validate.sh
# Exit code: 0 ok | 2 argumen salah | 3 path tidak ada | 4 izin ditolak | 5 input tidak valid
EXIT_OK=0; EXIT_USAGE=2; EXIT_NOT_FOUND=3; EXIT_NO_PERM=4; EXIT_BAD_INPUT=5

validate_output_dir() {
  local dir="${1:-}"
  if [ -z "$dir" ]; then log_error "Direktori output kosong"; return $EXIT_USAGE; fi
  case "$dir" in
    *..*) log_error "Path tidak boleh mengandung '..': $dir"; return $EXIT_BAD_INPUT ;;
  esac
  if [ ! -e "$dir" ]; then log_error "Direktori tidak ditemukan: $dir"; return $EXIT_NOT_FOUND; fi
  if [ ! -d "$dir" ]; then log_error "Bukan direktori: $dir"; return $EXIT_BAD_INPUT; fi
  if [ ! -w "$dir" ]; then log_error "Direktori tidak bisa ditulis: $dir"; return $EXIT_NO_PERM; fi
  return $EXIT_OK
}

validate_report_name() {
  local name="${1:-}"
  if [[ ! "$name" =~ ^[A-Za-z0-9._-]+$ ]] || [[ "$name" == .* ]]; then
    log_error "Nama laporan tidak valid: '$name' (hanya huruf, angka, . _ -)"
    return $EXIT_BAD_INPUT
  fi
  return $EXIT_OK
}
