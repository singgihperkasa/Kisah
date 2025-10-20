# Auto play music setiap buka Termux
mpv --loop-playlist=inf $(ls -t ~/storage/shared/Music/*.mp3 ~/storage/shared/Music/*.m4a ~/storage/shared/Music/*.wav ~/storage/shared/Music/*.ogg 2>/dev/null)

