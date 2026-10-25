# Proyek 2: Otomasi dan Container Linux - sysinfo

## Use case dan tujuan
Mengumpulkan informasi sistem Linux (hostname, kernel, uptime, disk, memori) ke file
laporan secara aman: input divalidasi, kegagalan ditandai exit code yang berbeda, dan
semua aktivitas dicatat di log. Menjadi dasar otomasi pada P12-P15.

## Struktur
- `bin/log.sh` : fungsi logging (INFO/WARN/ERROR + timestamp)
- `bin/validate.sh` : validasi direktori output dan nama laporan
- `bin/sysinfo.sh` : script utama
- `run_tests.sh` : pengujian (1 skenario berhasil, 4 skenario gagal)
- `config/sysinfo.conf.example` : contoh konfigurasi tanpa credential
- `hasil_uji.txt` : output asli run_tests.sh

## Cara menjalankan
    chmod +x bin/*.sh run_tests.sh
    mkdir -p hasil
    bin/sysinfo.sh hasil laporan.txt

Parameter: `<direktori_output>` (wajib), `[nama_laporan]` (opsional; default
`sysinfo_<tanggal>_<jam>.txt`).

## Exit code
| Kode | Arti |
|------|------|
| 0 | Berhasil |
| 1 | Kegagalan umum (log, file sementara, pengumpulan data) |
| 2 | Argumen salah atau kosong |
| 3 | Direktori output tidak ditemukan |
| 4 | Direktori output tidak bisa ditulis |
| 5 | Input tidak valid (path berisi `..` atau nama laporan tidak valid) |

## Verifikasi
    cat hasil/laporan.txt
    cat logs/sysinfo.log
    echo $?
    bash run_tests.sh 2>&1 | tee hasil_uji.txt

## Cleanup
    rm -rf hasil logs

## Rollback
    rm -f hasil/laporan.txt          # hapus laporan yang dibuat
    git revert <commit_id>           # batalkan commit tertentu
    git checkout <tag>               # kembali ke versi bertag

## Hasil uji aktual (dijalankan di Ubuntu VM)
    == Test berhasil ==
    PASS  T1 laporan dibuat di direktori valid (exit=0)
    PASS  T1b file laporan ada dan tidak kosong
    == Test gagal ==
    PASS  T2 tanpa argumen (exit=2)
    PASS  T3 direktori tidak ada (exit=3)
    PASS  T4 path mengandung .. (exit=5)
    PASS  T5 nama laporan tidak valid (exit=5)
    == Ringkasan: PASS=6 FAIL=0 ==

## Log kondisi berhasil dan gagal (dijalankan manual)
Berhasil (exit 0):

    2026-10-24 19:19:33 [INFO] Mulai: output_dir=hasil nama=laporan.txt
    2026-10-24 19:19:33 [INFO] Selesai: laporan disimpan di hasil/laporan.txt

Gagal, direktori tidak ada (exit 3):

    2026-10-24 19:20:59 [ERROR] Direktori tidak ditemukan: folder_ngawur
    2026-10-24 19:20:59 [ERROR] Validasi direktori gagal (kode 3)

Gagal, nama laporan tidak valid (exit 5):

    2026-10-24 19:24:10 [ERROR] Nama laporan tidak valid: '../x.txt' (hanya huruf, angka, . _ -)
    2026-10-24 19:24:10 [ERROR] Validasi nama gagal (kode 5)

Tanpa argumen menampilkan `Pemakaian: bin/sysinfo.sh <direktori_output> [nama_laporan]` dan exit 2.

## Interpretasi singkat
Skenario berhasil menghasilkan laporan berisi informasi sistem dan exit 0. Tiga
skenario gagal ditolak sebelum laporan dibuat, dengan kode yang sesuai (2, 3, 5) dan
pesan ERROR di log. PASS pada test gagal berarti penolakan input buruk bekerja seperti
yang dirancang, bukan bahwa script error. Hostname VM tidak ditampilkan di README.

## Konfigurasi
`LOG_FILE` dapat diatur lewat environment variable (default `logs/sysinfo.log`).
Contoh ada di `config/sysinfo.conf.example`; file ini tidak dibaca otomatis oleh script.

## Keterbatasan
- Exit code 4 (direktori tidak bisa ditulis) dan 1 belum diuji.
- Belum terjadwal (cron) dan belum dijalankan di container.
- (isi hal lain yang memang belum selesai)

## Catatan kontribusi anggota
| Anggota | Kontribusi |
|---------|------------|
| (isi nama) | (isi, sesuai yang benar-benar dikerjakan) |
| (isi nama) | (isi) |
