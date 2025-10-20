#!/data/data/com.termux/files/usr/bin/bash
# === YouTube Playlist Player for Termux ===
# By ChatGPT

PLAYLIST_URL="https://youtube.com/playlist?list=PLBTupEHzjhsPdni3GOrgZF6s73dlG2020"
SAVE_DIR="$HOME/music_playlist"

mkdir -p "$SAVE_DIR"
cd "$SAVE_DIR"

# Pastikan dependensi terpasang
pkg install -y python mpv
pip install -U yt-dlp

echo "🎵 Memulai pemutaran playlist..."
echo "Tekan Ctrl+C untuk berhenti, atau tunggu lagu selesai."

# Mainkan playlist via mpv (audio only)
mpv --no-video --ytdl-format=bestaudio "$PLAYLIST_URL" \
    --loop-playlist=no \
    --ytdl-raw-options=yes-playlist=,extract-audio=,audio-format=mp3

