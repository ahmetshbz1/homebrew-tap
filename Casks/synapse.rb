cask "synapse" do
  version "1.0.0"
  sha256 "85263c4a1d2453079acc50dcd498031a4c9bc35b9aaa069359dfa3d4d530b244"

  url "https://github.com/ahmetshbz1/homebrew-tap/releases/download/v#{version}/Synapse.dmg"
  name "Synapse"
  desc "Modern clipboard manager for macOS"
  homepage "https://github.com/ahmetshbz1/homebrew-tap"

  depends_on macos: ">= :sonoma"

  app "Synapse.app"

  zap trash: [
    "~/Library/Application Support/Synapse",
    "~/Library/Caches/com.ahmetshbz.Synapse",
    "~/Library/Preferences/com.ahmetshbz.Synapse.plist",
  ]
end
