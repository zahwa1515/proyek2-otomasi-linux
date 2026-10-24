#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
SCRIPT=./bin/sysinfo.sh
export LOG_FILE="$PWD/logs/test.log"
rm -f "$LOG_FILE"
TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT
PASS=0; FAIL=0

run_case() {  # nama kode_diharapkan perintah...
  local name="$1" expected="$2"; shift 2
  local actual=0
  "$@" >/dev/null 2>&1 || actual=$?
  if [ "$actual" -eq "$expected" ]; then
    echo "PASS  $name (exit=$actual)"; PASS=$((PASS+1))
  else
    echo "FAIL  $name (diharapkan=$expected, aktual=$actual)"; FAIL=$((FAIL+1))
  fi
}

echo "== Test berhasil =="
run_case "T1 laporan dibuat di direktori valid" 0 bash "$SCRIPT" "$TMPD" laporan_test.txt
if [ -s "$TMPD/laporan_test.txt" ]; then
  echo "PASS  T1b file laporan ada dan tidak kosong"; PASS=$((PASS+1))
else
  echo "FAIL  T1b file laporan tidak ada/kosong"; FAIL=$((FAIL+1))
fi

echo "== Test gagal =="
run_case "T2 tanpa argumen"            2 bash "$SCRIPT"
run_case "T3 direktori tidak ada"      3 bash "$SCRIPT" "$TMPD/tidak_ada"
run_case "T4 path mengandung .."       5 bash "$SCRIPT" "$TMPD/../x"
run_case "T5 nama laporan tidak valid" 5 bash "$SCRIPT" "$TMPD" "../hack.txt"

echo "== Ringkasan: PASS=$PASS FAIL=$FAIL =="
[ "$FAIL" -eq 0 ]
