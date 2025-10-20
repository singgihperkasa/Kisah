k	mport requests, re
from bs4 import BeautifulSoup

url = "https://www.tiktok.com/tag/sholawat"
headers = {"User-Agent": "Mozilla/5.0"}

html = requests.get(url, headers=headers).text
soup = BeautifulSoup(html, "html.parser")

data = []
for video in soup.find_all("a", href=re.compile("/video/")):
    title = video.get("title", "")
    link = "https://www.tiktok.com" + video["href"]
    views = re.findall(r'(\d+(?:\.\d+)?[KM]?) views', str(video))
    view = views[0] if views else "0"
    data.append((title, view, link))

# Urutkan dari viewers terbanyak
sorted_data = sorted(data, key=lambda x: float(x[1].replace('K','000').replace('M','000000')), reverse=True)

for i, (title, view, link) in enumerate(sorted_data, 1):
    print(f"{i}. {title}\n   👁️ {view} | 🔗 {link}\n")

