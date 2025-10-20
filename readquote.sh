#!/data/data/com.termux/files/usr/bin/bash
# === OCR + TTS otomatis ===

# Lokasi gambar (ubah sesuai lokasi file kamu)
IMG="/sdcard/WhatsApp/Media/WhatsApp Images/IMG-20251018-WA0012.jpg"

# Lokasi file output teks (disimpan di folder Termux)
OUT="$HOME/quote"

echo "🔍 Membaca teks dari gambar..."
tesseract "$IMG" "$OUT" > /dev/null 2>&1

if [ -f "$OUT.txt" ]; then
  echo "✅ Teks berhasil diambil:"
  cat "$OUT.txt"
  echo
  echo "🎙️ Membacakan teks..."
  termux-tts-speak "$(cat "$OUT.txt")"
else
  echo "❌ Gagal membaca teks. Periksa lokasi gambar."
fi

