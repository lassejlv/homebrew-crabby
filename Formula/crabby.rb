class Crabby < Formula
  desc "Cross-platform terminal emulator written in Rust"
  homepage "https://github.com/lassejlv/crabby-rs"
  version "0.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lassejlv/crabby-rs/releases/download/v#{version}/Crabby_#{version}_aarch64.dmg"
      sha256 "REPLACE_WITH_ARM64_SHA256"
    else
      url "https://github.com/lassejlv/crabby-rs/releases/download/v#{version}/Crabby_#{version}_x64.dmg"
      sha256 "REPLACE_WITH_X64_SHA256"
    end
  end

  depends_on macos: ">= :big_sur"

  def install
    if OS.mac?
      # Mount the DMG
      system "hdiutil", "attach", cached_download, "-mountpoint", "/tmp/crabby-mount", "-quiet"

      app_path = "/tmp/crabby-mount/Crabby.app"

      if File.exist?(app_path)
        # Copy the app bundle to a temporary location
        system "cp", "-R", app_path, "#{buildpath}/Crabby.app"

        # Install the binary
        bin.install "#{buildpath}/Crabby.app/Contents/MacOS/Crabby" => "crabby"

        # Optionally install the app bundle to a subdirectory
        prefix.install "#{buildpath}/Crabby.app"
      else
        odie "Crabby.app not found in the DMG at #{app_path}"
      end

      # Unmount the DMG
      system "hdiutil", "detach", "/tmp/crabby-mount", "-quiet"
    end
  end

  def caveats
    <<~EOS
      Crabby has been installed as a command-line tool.

      Usage:
        crabby

      The application bundle is also available at:
        #{prefix}/Crabby.app

      To open the GUI application:
        open #{prefix}/Crabby.app
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crabby --version 2>&1", 1)
  end
end
