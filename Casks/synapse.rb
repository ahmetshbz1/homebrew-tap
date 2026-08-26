cask "synapse" do
  version "2.7.1"
  sha256 "18d166717792c8aef306fa92898ef61395d1c0e482e063ddf8e43dafb6aa11a5"

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
