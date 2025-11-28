cask "synapse" do
  version "1.2.0"
  sha256 "93cf745f4e17118e29a3115b3d179e227a59d011dd2fd3b1930c8b78c6bbc20d"

  url "https://github.com/ahmetshbz1/homebrew-tap/releases/download/v#{version}/Synapse.dmg"
  name "Synapse"
  desc "Modern clipboard manager"
  homepage "https://github.com/ahmetshbz1/homebrew-tap"

  depends_on macos: ">= :sonoma"

  app "Synapse.app"

  zap trash: [
    "~/Library/Application Support/Synapse",
    "~/Library/Caches/com.ahmetshbz.Synapse",
    "~/Library/Preferences/com.ahmetshbz.Synapse.plist",
  ]
end
