cask "synapse" do
  version "2.0.3"
  sha256 "a9695b8cfb67e786c1d4fbf216cbe28e7c3fe10871b22ea623c12f99ae077dcf"

  url "https://github.com/ahmetshbz1/homebrew-tap/releases/download/v#{version}/Synapse.zip"
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
