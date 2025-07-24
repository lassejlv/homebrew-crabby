# Homebrew Tap Setup Instructions

This guide will help you set up your Homebrew tap so users can install Crabby with `brew install`.

## Prerequisites

- [x] Your main repository has GitHub Actions set up for releases
- [x] You have this homebrew-tap folder ready
- [ ] You need to create a new GitHub repository for the tap

## Step 1: Create the Homebrew Tap Repository

1. **Create a new GitHub repository** named `homebrew-crabby`
   - The name MUST start with `homebrew-` for Homebrew to recognize it
   - Make it public
   - Initialize with a README

2. **Copy the contents of this `homebrew-tap` folder** to the new repository:
   ```bash
   # Clone your new tap repository
   git clone https://github.com/lassejlv/homebrew-crabby.git
   cd homebrew-crabby
   
   # Copy files from this folder (adjust path as needed)
   cp -r /path/to/crabby-rs/homebrew-tap/* .
   
   # Add and commit
   git add .
   git commit -m "Initial Homebrew tap setup"
   git push
   ```

## Step 2: Create Your First Release

1. **Update version numbers** in your main repository:
   - `src-tauri/Cargo.toml`: Update version to `0.1.0`
   - `src-tauri/tauri.conf.json`: Update version to `0.1.0`

2. **Create and push a git tag**:
   ```bash
   cd /path/to/crabby-rs
   git add .
   git commit -m "Bump version to 0.1.0"
   git tag v0.1.0
   git push origin main
   git push origin v0.1.0
   ```

3. **Wait for GitHub Actions** to build and create the release

## Step 3: Get SHA256 Hashes

After your release is created:

1. **Run the hash calculation script**:
   ```bash
   cd homebrew-crabby
   ./get-sha256.sh 0.1.0
   ```

2. **Copy the SHA256 values** output by the script

## Step 4: Update the Homebrew Formulas

### Option A: Cask (Recommended for GUI apps)

Edit `Casks/crabby.rb`:
- Replace `REPLACE_WITH_ARM64_SHA256` with the ARM64 SHA256
- Replace `REPLACE_WITH_X64_SHA256` with the x64 SHA256
- Update version if needed

### Option B: Formula (For command-line focus)

Edit `Formula/crabby.rb`:
- Replace the SHA256 placeholders in both ARM64 and x64 sections
- Update version if needed

## Step 5: Test Installation

Test your formula locally:

```bash
# Test cask installation
brew install --cask /path/to/homebrew-crabby/Casks/crabby.rb

# Or test formula installation
brew install /path/to/homebrew-crabby/Formula/crabby.rb

# Test that it works
crabby --version

# Uninstall for clean testing
brew uninstall crabby  # or brew uninstall --cask crabby
```

## Step 6: Publish Your Tap

1. **Commit and push** your updated formulas:
   ```bash
   cd homebrew-crabby
   git add .
   git commit -m "Add Crabby v0.1.0 with SHA256 hashes"
   git push
   ```

2. **Your tap is now live!** Users can install with:
   ```bash
   brew tap lassejlv/crabby
   brew install --cask crabby  # or just 'brew install crabby'
   ```

## Step 7: Automate Future Updates (Optional)

### Option A: Manual Updates
For each new release:
1. Run `./get-sha256.sh <version>`
2. Update the SHA256 hashes in your formula/cask
3. Update the version number
4. Commit and push

### Option B: Automated Updates
Set up the GitHub Action in your main repository to automatically update the tap:

1. **Create a Personal Access Token** with `repo` scope
2. **Add it as a secret** named `HOMEBREW_TAP_TOKEN` in your main repository
3. **Add this workflow** to your main repository at `.github/workflows/update-homebrew.yml`:

```yaml
name: Update Homebrew on Release

on:
  release:
    types: [published]

jobs:
  update-homebrew:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Get release assets and calculate SHA256
        id: get-hashes
        run: |
          VERSION=${GITHUB_REF_NAME#v}
          
          # Download assets
          curl -L -o arm64.dmg "https://github.com/lassejlv/crabby-rs/releases/download/${GITHUB_REF_NAME}/Crabby_${VERSION}_aarch64.dmg"
          curl -L -o x64.dmg "https://github.com/lassejlv/crabby-rs/releases/download/${GITHUB_REF_NAME}/Crabby_${VERSION}_x64.dmg"
          
          # Calculate SHA256
          ARM64_SHA=$(shasum -a 256 arm64.dmg | cut -d' ' -f1)
          X64_SHA=$(shasum -a 256 x64.dmg | cut -d' ' -f1)
          
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "arm64_sha=$ARM64_SHA" >> $GITHUB_OUTPUT
          echo "x64_sha=$X64_SHA" >> $GITHUB_OUTPUT

      - name: Trigger tap update
        run: |
          curl -X POST \
            -H "Authorization: token ${{ secrets.HOMEBREW_TAP_TOKEN }}" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/lassejlv/homebrew-crabby/dispatches \
            -d '{
              "event_type": "crabby-release",
              "client_payload": {
                "version": "${{ steps.get-hashes.outputs.version }}",
                "arm64_sha": "${{ steps.get-hashes.outputs.arm64_sha }}",
                "x64_sha": "${{ steps.get-hashes.outputs.x64_sha }}"
              }
            }'
```

## Troubleshooting

### Common Issues:

1. **SHA256 mismatch**: 
   - Recalculate hashes using the script
   - Ensure you're using the correct file URLs

2. **DMG not found**:
   - Check that your GitHub Actions workflow is creating DMG files
   - Verify the file naming convention matches

3. **Installation fails**:
   - Test locally first with the full path to your formula
   - Check the DMG contains `Crabby.app` in the root

4. **Binary not executable**:
   - Ensure your Tauri build creates an executable binary
   - Check the path to the binary in the .app bundle

### Useful Commands:

```bash
# Check what's in a DMG
hdiutil attach Crabby_0.1.0_aarch64.dmg -mountpoint /tmp/test
ls -la /tmp/test
hdiutil detach /tmp/test

# Test formula syntax
brew audit --strict /path/to/formula.rb

# Debug installation
brew install --verbose --debug /path/to/formula.rb
```

## Next Steps

1. Complete Step 1-6 above
2. Test with a few users
3. Consider setting up automated updates
4. Update your main README with installation instructions
5. Add the tap to Homebrew directories (optional, for discoverability)

Your users can now install Crabby with a simple `brew install` command! 🎉