# Proyek 2: Otomasi dan Container Linux - sysinfo

## Use case dan tujuan
Mengumpulkan informasi sistem (hostname, kernel, uptime, disk, memori) ke file laporan
secara aman, tervalidasi, dan tercatat di log. Menjadi dasar otomasi pada P12-P15
(mis. penjadwalan dan container).

## Struktur
bin/log.sh       fungsi logging
bin/validate.sh  validasi input
bin/sysinfo.sh   script utama
run_tests.sh     pengujian
config/          contoh konfigurasi (tanpa credential)

## Cara menjalankan
chmod +x bin/*.sh run_tests.sh
mkdir -p hasil
bin/sysinfo.sh hasil laporan.txt

## Exit code
| Kode | Arti                                          |
|------|-----------------------------------------------|
| 0    | Berhasil                                      |
| 1    | Kegagalan umum (log, file sementara, kumpul)  |
| 2    | Argumen salah atau kosong                     |
| 3    | Direktori output tidak ditemukan              |
| 4    | Direktori output tidak bisa ditulis           |
| 5    | Input tidak valid (path '..' / nama laporan)  |

## Verifikasi
cat hasil/laporan.txt
tail logs/sysinfo.log
echo $?
bash run_tests.sh | tee hasil_uji.txt

## Cleanup
rm -rf hasil logs

## Rollback
rm -f hasil/laporan.txt            # hapus laporan yang dibuat
git revert <commit_id>             # batalkan commit tertentu
git checkout <tag_sebelumnya>      # kembali ke versi sebelumnya

## Hasil uji aktual
(tempel output asli bash run_tests.sh dari VM)

## Log kondisi berhasil dan gagal
(tempel cuplikan asli dari logs/sysinfo.log)

## Interpretasi singkat
(2-4 kalimat dengan kata sendiri: apa arti PASS/FAIL, apa yang terbukti)

## Keterbatasan
- Baru mengumpulkan informasi dasar; belum terjadwal (cron) dan belum di container.
- (tambahkan hal lain yang memang belum selesai)

## Catatan kontribusi anggota
| Anggota | Kontribusi |
|---------|------------|
| (nama)  | bin/log.sh, bin/validate.sh, run_tests.sh |
| (nama)  | (isi sesuai kenyataan) |
