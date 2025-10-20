import requests, os, time

print("🔍 Mengambil Surah Al-Fatihah dari Quran.com...")

# Ambil ayat dan terjemahan
ayat = requests.get("https://api.quran.com/api/v4/quran/verses/uthmani?chapter_number=1").json()["verses"]
terjemah = requests.get("https://api.quran.com/api/v4/quran/translations/33?chapter_number=1").json()["translations"]

for i, a in enumerate(ayat):
    arab = a["text_uthmani"]
    indo = terjemah[i]["text"]
    print(f"\nAyat {i+1}:\n{arab}\n{indo}")
    url = f"https://verses.quran.com/{a['verse_key'].replace(':', '/')}/ar.mishari_al_afasy.mp3"
    os.system(f"mpv --no-video '{url}'")
    time.sleep(1)

