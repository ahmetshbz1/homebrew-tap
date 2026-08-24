cask "synapse" do
  version "2.2.0"
  sha256 "566384f8726ec70ec24559afcb721e68aef5135f6edb11d904d2b758c0555439"

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
