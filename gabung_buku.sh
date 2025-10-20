#!/data/data/com.termux/files/usr/bin/bash
# Skrip penggabung file TXT jadi satu buku
# By: Singgih Perkasa

echo "📘 GABUNG FILE TXT JADI SATU BUKU"
echo "Masukkan lokasi folder berisi file TXT (contoh: /storage/shared/Quotes):"
read folder

# Cek folder
if [ ! -d "$folder" ]; then
  echo "❌ Folder tidak ditemukan!"
  exit 1
fi

cd "$folder"

# Nama output
output="buku_$(date +%Y%m%d_%H%M).txt"

# Header buku
echo "==============================" > "$output"
echo "         KUMPULAN QUOTES       " >> "$output"
echo "==============================" >> "$output"
echo "Disusun oleh: Singgih Perkasa" >> "$output"
echo "Tanggal: $(date)" >> "$output"
echo -e "\n\n" >> "$output"

# Gabungkan semua txt
for f in *.txt; do
  echo "===== $f =====" >> "$output"
  cat "$f" >> "$output"
  echo -e "\n\n" >> "$output"
done

# Bersihkan karakter aneh
sed -i 's/[^[:print:]\t]//g' "$output"
sed -i 's/ \+/ /g' "$output"

echo "✅ Buku berhasil dibuat: $folder/$output"
echo "Selesai!"

