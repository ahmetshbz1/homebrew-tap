# Synapse Release Pipeline

## Güncelleme Kontrolü Zamanlaması
- **Uygulama açıldığında** bir kere hemen kontrol
- **Her 1 saatte bir** otomatik kontrol (arka planda)
- **Manuel kontrol**: Settings > General > Check Now
- **Automatic Updates toggle**: ON ise otomatik indir + kur + restart, OFF ise toast göster (zorunlu güncellemeler `<synapse:forceUpdate>true</synapse:forceUpdate>` ile her zaman otomatik kurulur)

---

## Release Adımları

### 1. Versiyon Güncelle

```bash
# project.pbxproj'da güncelle:
# - MARKETING_VERSION = X.Y.Z
# - CURRENT_PROJECT_VERSION = N (build number)

# Veya sed ile:
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse
sed -i '' 's/MARKETING_VERSION = 1.2.1/MARKETING_VERSION = 1.2.2/g' Synapse.xcodeproj/project.pbxproj
sed -i '' 's/CURRENT_PROJECT_VERSION = 4/CURRENT_PROJECT_VERSION = 5/g' Synapse.xcodeproj/project.pbxproj
```

### 2. Release Build Al

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse
xcodebuild -project Synapse.xcodeproj -scheme Synapse -configuration Release -derivedDataPath build clean build
```

### 3. ZIP Oluştur ve İmzala

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse/build/Build/Products/Release

# ZIP oluştur
rm -f Synapse.zip
ditto -c -k --keepParent Synapse.app Synapse.zip

# Sparkle ile imzala (edSignature ve length alacaksın)
# sign_update path'i build klasöründe olacak
/Users/ahmet/Desktop/projeler-bireysel/Synapse/build/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update Synapse.zip
```

**Çıktı örneği:**
```
sparkle:edSignature="ABC123..." length="2224938"
```

### 4. GitHub Release Oluştur

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse

# GitHub Release oluştur (ZIP'i direkt build klasöründen kullan)
gh release create vX.Y.Z ./build/Build/Products/Release/Synapse.zip \
  --repo ahmetshbz1/homebrew-tap \
  --title "Synapse vX.Y.Z" \
  --notes "Release notes..."
```

### 5. appcast.xml Güncelle

`/Users/ahmet/Desktop/projeler-bireysel/homebrew-tap-temp/appcast.xml` dosyasına yeni item ekle:

```xml
<item>
  <title>Version X.Y.Z</title>
  <pubDate>Sat, 29 Nov 2025 01:30:00 +0300</pubDate>
  <sparkle:version>N</sparkle:version>  <!-- build number -->
  <sparkle:shortVersionString>X.Y.Z</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>
  <!-- Opsiyonel: Bu sürüm zorunlu güncelleme olsun (Automatic Updates toggle'ını yok sayar) -->
  <synapse:forceUpdate>true</synapse:forceUpdate>
  <description><![CDATA[
    <h2>What's New</h2>
    <ul>
      <li>Feature 1</li>
      <li>Bug fix 1</li>
    </ul>
  ]]></description>
  <enclosure 
    url="https://github.com/ahmetshbz1/homebrew-tap/releases/download/vX.Y.Z/Synapse.zip"
    sparkle:edSignature="IMZA_BURAYA"
    length="BOYUT_BURAYA"
    type="application/octet-stream"
  />
</item>
```

### 6. appcast.xml Push Et

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/homebrew-tap-temp
git add appcast.xml
git commit -m "feat: vX.Y.Z"
git push
```

### 7. Web Changelog Güncelle (Opsiyonel)

`/Users/ahmet/Desktop/projeler-bireysel/Synapse/web/src/app/data/changelog.ts` dosyasına yeni entry ekle:

```typescript
{
  version: "vX.Y.Z",
  date: "November 29, 2025",
  sections: [
    {
      title: "What's New",
      items: [
        "Feature 1",
        "Bug fix 1",
      ],
    },
  ],
},
```

**Not:** Yeni entry'yi en üste ekle (array'in başına).

### 8. Web Hero Güncelle (Opsiyonel)

`/Users/ahmet/Desktop/projeler-bireysel/Synapse/web/src/app/sections/Hero.tsx` dosyasında:
- Versiyon badge'i güncelle: `vX.Y.Z Available Now`
- Download linkini güncelle: `https://github.com/ahmetshbz1/homebrew-tap/releases/download/vX.Y.Z/Synapse.zip`

### 9. Synapse Repo'sunu Commit Et

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse
git add -A
git commit -m "chore: vX.Y.Z release"
git push origin main
```

---

## Tam Örnek (v1.3.19)

```bash
# 1. Versiyon güncelle
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse
sed -i '' 's/MARKETING_VERSION = 1.3.18;/MARKETING_VERSION = 1.3.19;/g' Synapse.xcodeproj/project.pbxproj
sed -i '' 's/CURRENT_PROJECT_VERSION = 118;/CURRENT_PROJECT_VERSION = 119;/g' Synapse.xcodeproj/project.pbxproj

# 2. Build
xcodebuild -project Synapse.xcodeproj -scheme Synapse -configuration Release -derivedDataPath build clean build 2>&1 | tail -5

# 3. ZIP + İmzala
cd build/Build/Products/Release
rm -f Synapse.zip
ditto -c -k --keepParent Synapse.app Synapse.zip
/Users/ahmet/Desktop/projeler-bireysel/Synapse/build/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update Synapse.zip
# Çıktı: sparkle:edSignature="..." length="..."

# 4. GitHub Release
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse
gh release create v1.3.19 ./build/Build/Products/Release/Synapse.zip \
  --repo ahmetshbz1/homebrew-tap \
  --title "Synapse v1.3.19" \
  --notes "- Feature 1\n- Bug fix 1"

# 5. appcast.xml güncelle (en üste ekle)
# /Users/ahmet/Desktop/projeler-bireysel/homebrew-tap-temp/appcast.xml

# 6. Push
cd /Users/ahmet/Desktop/projeler-bireysel/homebrew-tap-temp
git add appcast.xml
git commit -m "feat: v1.3.19"
git push

# 7. Synapse repo commit
cd /Users/ahmet/Desktop/projeler-bireysel/Synapse
git add -A
git commit -m "chore: v1.3.19 release"
git push
```

---

## Hızlı Referans

| Dosya | Konum |
|-------|-------|
| Proje | `/Users/ahmet/Desktop/projeler-bireysel/Synapse` |
| homebrew-tap-temp | `/Users/ahmet/Desktop/projeler-bireysel/homebrew-tap-temp` |
| appcast.xml | `homebrew-tap-temp/appcast.xml` |
| sign_update | `build/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update` |

## Önemli Notlar

- `sparkle:version` = build number (CURRENT_PROJECT_VERSION)
- `sparkle:shortVersionString` = marketing version (MARKETING_VERSION)
- Yeni item'ı appcast.xml'in **en üstüne** ekle (en yeni üstte)
- ZIP imzası (edSignature) her build'de değişir, mutlaka yenile
- GitHub Release URL formatı: `https://github.com/ahmetshbz1/homebrew-tap/releases/download/vX.Y.Z/Synapse.zip`
- `sign_update` path'i build klasöründe: `build/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update`
- GitHub Release oluştururken ZIP'i kopyalamaya gerek yok, direkt build klasöründen kullan
