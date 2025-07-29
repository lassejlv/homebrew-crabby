cask "crabby" do
  version "0.0.7"

  arch arm: "aarch64", intel: "28a95518c9a9023313df7ea5a40055fb193bb4a3252cea5264549cbc96530724"

  url "https://github.com/lassejlv/crabby-rs/releases/download/v#{version}/Crabby_#{version}_#{arch}.dmg",
      verified: "github.com/lassejlv/crabby-rs/"

  # You'll need to replace these with actual SHA256 hashes after creating a release
  sha256 arm:   "d98e437addd2ae7c6a2d8edee0726f2e3c748eadced454fb144dde547b740a8d",
         intel: "28a95518c9a9023313df7ea5a40055fb193bb4a3252cea5264549cbc96530724"

  name "Crabby"
  desc "Cross-platform terminal emulator written in Rust"
  homepage "https://github.com/lassejlv/crabby-rs"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Crabby.app"

  # Create a command-line symlink
  binary "#{appdir}/Crabby.app/Contents/MacOS/Crabby", target: "crabby"

  zap trash: [
    "~/Library/Application Support/com.crabby",
    "~/Library/Caches/com.crabby",
    "~/Library/HTTPStorages/com.crabby",
    "~/Library/Preferences/com.crabby.plist",
    "~/Library/Saved Application State/com.crabby.savedState",
    "~/Library/WebKit/com.crabby",
  ]

  # Optional: Add uninstall script if needed
  uninstall quit: "com.crabby"
end
