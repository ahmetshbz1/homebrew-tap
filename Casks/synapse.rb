cask "synapse" do
  version "1.2.0"
  sha256 "d16aa51e2c76c8589f9f2d8423339a3cc7451bf23d76656f2c7dfeffbbc3eef7"

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
