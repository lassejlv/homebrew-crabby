# Homebrew Tap for Crabby

This is the official Homebrew tap for [Crabby](https://github.com/lassejlv/crabby-rs) - a cross-platform terminal emulator written in Rust.

## Installation

### Add the tap

```bash
brew tap lassejlv/crabby
```

### Install Crabby (GUI Application)

```bash
brew install --cask crabby
```

This will install the Crabby.app to your Applications folder and create a command-line symlink.

### Install Crabby (Command Line)

```bash
brew install crabby
```

This installs Crabby as a command-line tool.

## Usage

After installation:

- **GUI**: Launch from Applications folder or run `open /Applications/Crabby.app`
- **Command Line**: Run `crabby` in your terminal

## Uninstall

```bash
# For cask installation
brew uninstall --cask crabby

# For formula installation
brew uninstall crabby

# Remove the tap (optional)
brew untap lassejlv/crabby
```

## About

Crabby is a modern, fast terminal emulator built with:
- **Rust** for performance and safety
- **Tauri** for native cross-platform support
- **Modern web technologies** for the UI

### Features

- 🚀 **Fast & Lightweight** - Built with Rust for maximum performance
- 🌍 **Cross-Platform** - Works on Windows, macOS, and Linux
- 🎨 **Modern UI** - Clean interface with customizable themes
- 💻 **Native Feel** - Powered by Tauri for true native experience
- ⚡ **Terminal Emulation** - Full-featured terminal with modern capabilities

## Issues

If you encounter any issues with the Homebrew installation, please report them at:
- [Main Repository Issues](https://github.com/lassejlv/crabby-rs/issues)
- [Tap Repository Issues](https://github.com/lassejlv/homebrew-crabby/issues)

## Contributing

Contributions to improve the Homebrew formulas are welcome! Please submit pull requests to this repository.