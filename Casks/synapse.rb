cask "synapse" do
  version "1.2.0"
  sha256 "e9c614fb7d58329052ff6e5cbf5197de467504683affcf669633fc5487e9bb8c"

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
