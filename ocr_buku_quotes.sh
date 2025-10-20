#!/data/data/com.termux/files/usr/bin/bash
# 📘 OCR semua JPG di folder Quotes dan gabung jadi satu buku
# By: Singgih Perkasa

folder="$HOME/storage/shared/Quotes"
output="$folder/buku_quotes_$(date +%Y%m%d_%H%M).txt"

echo "🔍 Membaca gambar di: $folder"
cd "$folder" || exit

# Buat folder hasil txt kalau belum ada
mkdir -p "$folder/txt"

# Proses OCR untuk setiap JPG
for img in *.jpg *.jpeg *.png; do
  [ -f "$img" ] || continue
  base="${img%.*}"
  echo "📝 Membaca teks dari: $img ..."
  tesseract "$img" "txt/$base" >/dev/null 2>&1
done

echo "✅ Semua gambar sudah diubah ke TXT."

# Gabungkan semua file TXT
echo "==============================" > "$output"
echo "      KUMPULAN QUOTES OCR      " >> "$output"
echo "==============================" >> "$output"
echo "Tanggal: $(date)" >> "$output"
echo -e "\n\n" >> "$output"

for f in txt/*.txt; do
  [ -f "$f" ] || continue
  echo "===== $(basename "$f") =====" >> "$output"
  cat "$f" >> "$output"
  echo -e "\n\n" >> "$output"
done

# Bersihkan karakter aneh
sed -i 's/[^[:print:]\t]//g' "$output"
sed -i 's/ \+/ /g' "$output"

echo "📚 Buku berhasil dibuat: $output"

