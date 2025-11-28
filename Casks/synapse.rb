cask "synapse" do
  version "1.1.0"
  sha256 "4c64469604d67b17199e261a591bd978c988bd9194bc9f934c5ec42eeec9a2ea"

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
