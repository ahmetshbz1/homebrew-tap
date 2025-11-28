cask "synapse" do
  version "1.2.0"
  sha256 "9218293656a6222bdcd26419b3c5d93b2ec93255fa3837cf6b6040eeaeafe4c4"

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
