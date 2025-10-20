#!/data/data/com.termux/files/usr/bin/bash

MUSIC_DIR=~/storage/shared/Music

# Cek folder Music
if [ ! -d "$MUSIC_DIR" ]; then
    echo "Folder Music tidak ditemukan!"
    exit 1
fi

# Ambil semua file mp3
FILES=("$MUSIC_DIR"/*.mp3)

if [ ${#FILES[@]} -eq 0 ]; then
    echo "Tidak ada file MP3 di folder Music."
    exit 1
fi

# Loop tiap file
for f in "${FILES[@]}"; do
    FILE_NAME=$(basename "$f")
    echo "============================"
    echo "Memutar: $FILE_NAME"
    echo "============================"

    # Putar file
    mpv "$f"

    # Konfirmasi hapus
    while true; do
        read -p "Hapus file ini? (y/n): " yn
        case $yn in
            [Yy]* ) rm "$f"; echo "$FILE_NAME terhapus."; break;;
            [Nn]* ) echo "$FILE_NAME tetap ada."; break;;
            * ) echo "Jawaban tidak valid. Ketik y atau n.";;
        esac
    done
done

echo "Semua lagu selesai."

