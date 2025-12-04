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
cd /Users/ahmet/Desktop/projeler-bireysel/SynapseDev/apps/macos

# project.pbxproj'da güncelle:
sed -i '' 's/MARKETING_VERSION = OLD/MARKETING_VERSION = NEW/g' Synapse.xcodeproj/project.pbxproj
sed -i '' 's/CURRENT_PROJECT_VERSION = OLD/CURRENT_PROJECT_VERSION = NEW/g' Synapse.xcodeproj/project.pbxproj
```

### 2. What's New Ekranını Güncelle (Eğer Featured Update Varsa)

Eğer bu sürümde interaktif özellik tanıtımı yapılacaksa:

```swift
// FeaturedUpdate.swift - Yeni case ekle
enum FeaturedUpdate: String, CaseIterable, Identifiable {
    case copySoundPicker = "copy_sound_picker"
    // Yeni özellik ekle:
    // case newFeature = "new_feature"
    
    var targetVersion: String {
        switch self {
        case .copySoundPicker: return "1.4.2"
        // case .newFeature: return "X.Y.Z"
        }
    }
    // ... title, icon, color da eklenmeli
}

// WhatsNewView.swift
// 1. featuredSection(for:) switch'ine yeni case ekle
// 2. Yeni section view oluştur (örn: newFeatureSection)
// 3. releaseNotes array'ini bu sürüme göre güncelle
```

### 3. Release Build Al

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/SynapseDev/apps/macos
xcodebuild -project Synapse.xcodeproj -scheme Synapse -configuration Release -derivedDataPath build clean build
```

### 4. ZIP Oluştur ve İmzala

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/SynapseDev/apps/macos/build/Build/Products/Release

# ZIP oluştur
rm -f Synapse.zip
ditto -c -k --keepParent Synapse.app Synapse.zip

# Sparkle ile imzala
/Users/ahmet/Desktop/projeler-bireysel/SynapseDev/apps/macos/build/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update Synapse.zip
```

**Çıktı örneği:**
```
sparkle:edSignature="ABC123..." length="2224938"
```

### 5. GitHub Release Oluştur

```bash
gh release create vX.Y.Z ./build/Build/Products/Release/Synapse.zip \
  --repo ahmetshbz1/homebrew-tap \
  --title "Synapse vX.Y.Z" \
  --notes "Release notes..."
```

### 6. appcast.xml Güncelle

`/Users/ahmet/Desktop/projeler-bireysel/SynapseDev/brew-tap/appcast.xml` dosyasına yeni item ekle (en üste):

```xml
<item>
  <title>Version X.Y.Z</title>
  <pubDate>Wed, 04 Dec 2025 17:15:00 +0300</pubDate>
  <sparkle:version>N</sparkle:version>  <!-- build number -->
  <sparkle:shortVersionString>X.Y.Z</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>
  <!-- Opsiyonel: Zorunlu güncelleme -->
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

### 7. Push Et

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/SynapseDev/brew-tap
git add -A
git commit -m "feat: vX.Y.Z"
git push
```

### 8. Web Changelog Güncelle (Opsiyonel)

```bash
cd /Users/ahmet/Desktop/projeler-bireysel/SynapseDev/apps/web
bun run scripts/generate-changelog-from-appcast.ts
vercel --prod
```

---

## What's New Featured Updates Sistemi

### Dosya Yapısı

```
Synapse/Features/WhatsNew/
├── FeaturedUpdate.swift      # Enum - hangi sürümde hangi özellik gösterilecek
└── WhatsNewView.swift        # UI - featured section'lar ve release notes
```

### FeaturedUpdate Enum

Her yeni interaktif özellik için:

1. **Case ekle**: `case myFeature = "my_feature"`
2. **targetVersion belirle**: Bu özellik hangi versiyonda gösterilecek
3. **Metadata ekle**: title, icon, color

```swift
enum FeaturedUpdate: String, CaseIterable, Identifiable {
    case copySoundPicker = "copy_sound_picker"
    
    var targetVersion: String {
        switch self {
        case .copySoundPicker: return "1.4.2"
        }
    }
    
    var title: String {
        switch self {
        case .copySoundPicker: return "Copy Sounds"
        }
    }
    
    var icon: String {
        switch self {
        case .copySoundPicker: return "speaker.wave.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .copySoundPicker: return .pink
        }
    }
}
```

### WhatsNewView Yapısı

1. **AppStorage bindings**: Özellik için gerekli ayarlar
2. **featuredSection(for:)**: Switch case ile section yönlendirmesi
3. **Section View**: Toggle, Picker veya diğer interaktif elementler
4. **releaseNotes**: "Other Updates" bölümündeki statik notlar

```swift
// 1. AppStorage ekle
@AppStorage("playSoundOnCopy") private var playSoundOnCopy: Bool = false

// 2. Switch case ekle
private func featuredSection(for feature: FeaturedUpdate) -> some View {
    switch feature {
    case .copySoundPicker:
        copySoundSection
    }
}

// 3. Section view oluştur (toggle, picker vb.)
private var copySoundSection: some View { ... }

// 4. Release notes güncelle
private var releaseNotes: [ReleaseNote] {
    [
        ReleaseNote(icon: "speaker.wave.3.fill", iconColor: .pink, title: "Premium Audio", description: "...")
    ]
}
```

### Versiyon Sonrası Temizlik

Bir sonraki sürümde eski featured update'i kaldırabilirsin:
- FeaturedUpdate enum'dan case'i sil
- WhatsNewView'dan ilgili section'ı sil



---

## Hızlı Referans

| Dosya | Konum |
|-------|-------|
| Proje | `/Users/ahmet/Desktop/projeler-bireysel/SynapseDev/apps/macos` |
| brew-tap | `/Users/ahmet/Desktop/projeler-bireysel/SynapseDev/brew-tap` |
| appcast.xml | `brew-tap/appcast.xml` |
| sign_update | `apps/macos/build/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update` |
| FeaturedUpdate | `apps/macos/Synapse/Features/WhatsNew/FeaturedUpdate.swift` |
| WhatsNewView | `apps/macos/Synapse/Features/WhatsNew/WhatsNewView.swift` |

## Önemli Notlar

- `sparkle:version` = build number (CURRENT_PROJECT_VERSION)
- `sparkle:shortVersionString` = marketing version (MARKETING_VERSION)
- Yeni item'ı appcast.xml'in **en üstüne** ekle (en yeni üstte)
- ZIP imzası (edSignature) her build'de değişir, mutlaka yenile
- GitHub Release URL formatı: `https://github.com/ahmetshbz1/homebrew-tap/releases/download/vX.Y.Z/Synapse.zip`
- **FeaturedUpdate targetVersion**: Her özellik sadece belirtilen versiyonda gösterilir
- **releaseNotes**: Her sürümde güncellenmeli
