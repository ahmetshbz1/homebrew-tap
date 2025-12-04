# Homebrew Tap - Synapse

Modern clipboard manager for macOS.

## Installation

```bash
brew tap ahmetshbz1/tap
brew install --cask synapse
```

## Available Casks

| Cask | Description |
|------|-------------|
| synapse | Modern clipboard manager for macOS |

## Updating

```bash
brew update
brew upgrade --cask synapse
```

## Uninstalling

```bash
brew uninstall --cask synapse
brew untap ahmetshbz1/tap
```

---

## Repository Structure

```
brew-tap/
├── appcast.xml       # Sparkle auto-update feed
├── Casks/
│   └── synapse.rb    # Homebrew cask formula
├── RELEASE.md        # Release pipeline documentation
└── README.md
```

## Auto-Updates (Sparkle)

Synapse uses Sparkle for in-app updates:
- **appcast.xml**: Update feed with version info and signatures
- Updates are checked hourly and on app launch
- Users can toggle automatic updates in Settings

## Latest Version

**v1.4.2** - Copy Sound Picker
- 10 unique copy sounds
- Sound preview on selection
- Bundle fix for sound files

See [Releases](https://github.com/ahmetshbz1/homebrew-tap/releases) for all versions.
