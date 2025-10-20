import requests, re
from bs4 import BeautifulSoup

url = "https://www.tiktok.com/tag/sholawat?is_from_webapp=1&sender_device=pc"
headers = {"User-Agent": "Mozilla/5.0"}

html = requests.get(url, headers=headers).text
soup = BeautifulSoup(html, "html.parser")

videos = []
for vid in soup.find_all("a", href=re.compile("/video/")):
    link = "https://www.tiktok.com" + vid["href"]
    title = vid.get("title", "Tanpa Judul")
    match = re.search(r'(\d+(?:\.\d+)?[KM]?) views', str(vid))
    views = match.group(1) if match else "0"
    videos.append((title, views, link))

def to_number(v):
    v = v.upper()
    if "M" in v: return float(v.replace("M", "")) * 1_000_000
    if "K" in v: return float(v.replace("K", "")) * 1_000
    return float(v)

videos.sort(key=lambda x: to_number(x[1]), reverse=True)

for i, (title, views, link) in enumerate(videos, 1):
    print(f"{i}. {title}\n   👁️ {views} | 🔗 {link}\n")

