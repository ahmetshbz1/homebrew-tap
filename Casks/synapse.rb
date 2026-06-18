cask "synapse" do
  version "2.1.0"
  sha256 "2146232d8049a08ec91a3f23eafbc4d5422eae382238758584ff5a0e2af35068"

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
