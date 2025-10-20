#!/usr/bin/env python3
"""
playlist_player.py

Python script untuk Termux: memindai semua file audio (mp3, wav, m4a, flac, ogg, opus),
menyortir berdasarkan ukuran (terbesar dulu), lalu memutar playlist menggunakan mpv.

Fitur:
- Memindai folder default: ~/storage/shared/Music (bisa diganti lewat argumen)
- Mendukung ekstensi: .mp3, .wav, .m4a, .flac, .ogg, .opus
- Menyortir file berdasarkan ukuran (desc)
- Membuat file playlist sementara dan memutar via mpv (audio-only)
- Tidak menghapus file apa pun

Cara pakai:
1. Pastikan mpv terpasang di Termux:
   pkg update && pkg install mpv -y

2. (Jika belum) beri akses storage ke Termux:
   termux-setup-storage

3. Jalankan script:
   python3 playlist_player.py                # pakai folder default ~/storage/shared/Music
   python3 playlist_player.py /path/to/folder # pakai folder kustom

Kontrol pemutaran: gunakan kontrol keyboard mpv saat pemutaran (space pause/play, > next, < prev, q quit)

"""

import sys
import os
import subprocess
import tempfile
from pathlib import Path

AUDIO_EXTENSIONS = {'.mp3', '.wav', '.m4a', '.flac', '.ogg', '.opus'}


def human_readable_size(nbytes: int) -> str:
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if nbytes < 1024.0:
            return f"{nbytes:.1f}{unit}"
        nbytes /= 1024.0
    return f"{nbytes:.1f}PB"


def find_audio_files(start_path: Path):
    files = []
    if not start_path.exists():
        print(f"[ERROR] Folder tidak ditemukan: {start_path}")
        return files
    for root, _, filenames in os.walk(start_path):
        for fn in filenames:
            p = Path(root) / fn
            if p.suffix.lower() in AUDIO_EXTENSIONS:
                try:
                    size = p.stat().st_size
                except OSError:
                    size = 0
                files.append((p, size))
    return files


def main():
    # default folder: Termux shared Music
    default_music = Path.home() / 'storage' / 'shared' / 'Music'
    if len(sys.argv) > 1:
        folder = Path(sys.argv[1]).expanduser()
    else:
        folder = default_music

    print("Scanning folder:", folder)
    audio_files = find_audio_files(folder)
    if not audio_files:
        print("Tidak ditemukan file audio di folder tersebut.")
        return

    # sort by size desc
    audio_files.sort(key=lambda x: x[1], reverse=True)

    print(f"Ditemukan {len(audio_files)} file audio. Menyortir berdasarkan ukuran (terbesar dulu):")
    for idx, (p, size) in enumerate(audio_files, start=1):
        print(f"{idx:02d}. {p.name} — {human_readable_size(size)}")

    # buat playlist sementara
    with tempfile.NamedTemporaryFile(mode='w', delete=False, prefix='termux_playlist_', suffix='.txt') as tf:
        playlist_path = Path(tf.name)
        for p, _ in audio_files:
            tf.write(str(p) + "\n")

    print('\nMembuat playlist sementara di:', playlist_path)

    # cek mpv
    mpv_path = shutil_which('mpv')
    if not mpv_path:
        print('\n[ERROR] mpv tidak ditemukan. Silakan install mpv di Termux:')
        print('    pkg update && pkg install mpv -y')
        print('Setelah itu jalankan script ulang.')
        # hapus playlist sementara sebelum keluar
        try:
            playlist_path.unlink()
        except Exception:
            pass
        return

    # jalankan mpv dengan playlist
    cmd = [mpv_path, '--no-video', f'--playlist={str(playlist_path)}']
    print('\nMenjalankan mpv... (gunakan kontrol mpv: SPACE pause/play, > next, < prev, q quit)')
    try:
        subprocess.run(cmd)
    except KeyboardInterrupt:
        print('\nDihentikan oleh user.')
    finally:
        # hapus playlist sementara
        try:
            playlist_path.unlink()
            print('Playlist sementara dihapus.')
        except Exception:
            pass


def shutil_which(cmd_name: str):
    """Simple which replacement to find executable in PATH."""
    for p in os.environ.get('PATH', '').split(os.pathsep):
        exe = Path(p) / cmd_name
        if exe.exists() and os.access(exe, os.X_OK):
            return str(exe)
    return None


if __name__ == '__main__':
    main()

