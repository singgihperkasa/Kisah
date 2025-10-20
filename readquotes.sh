#!/data/data/com.termux/files/usr/bin/bash
# === OCR + TTS untuk semua gambar di folder ===

# Folder sumber gambar (ubah sesuai kebutuhan)
SRC="/sdcard/Quotes"

# Folder output (Download agar mudah dibuka)
OUT="/sdcard/Download"

echo "🔍 Memindai gambar di $SRC ..."
sleep 1

# Loop semua gambar jpg dan png
for IMG in "$SRC"/*.jpg "$SRC"/*.png; do
  # Cek apakah file benar-benar ada
  [ -f "$IMG" ] || continue

  echo "📸 Membaca: $(basename "$IMG")"
  # Nama output unik per file (tanpa ekstensi)
  NAME=$(basename "$IMG" | cut -d. -f1)
  
  # Jalankan OCR
  tesseract "$IMG" "$OUT/$NAME" > /dev/null 2>&1

  if [ -f "$OUT/$NAME.txt" ]; then
    echo "✅ Teks tersimpan di: $OUT/$NAME.txt"
    echo "🎙️ Membacakan..."
    termux-tts-speak "$(cat "$OUT/$NAME.txt")"
    sleep 2
  else
    echo "❌ Gagal membaca: $IMG"
  fi
done

echo "✨ Selesai! Semua quote telah dibacakan."

