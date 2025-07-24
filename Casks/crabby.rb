cask "crabby" do
  version "0.0.1"

  arch arm: "aarch64", intel: "x64"

  url "https://github.com/lassejlv/crabby-rs/releases/download/v#{version}/Crabby_#{version}_#{arch}.dmg",
      verified: "github.com/lassejlv/crabby-rs/"

  # You'll need to replace these with actual SHA256 hashes after creating a release
  sha256 arm:   "REPLACE_WITH_ARM64_SHA256",
         intel: "REPLACE_WITH_X64_SHA256"

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
