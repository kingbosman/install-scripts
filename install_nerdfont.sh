#!/bin/bash

# Check if font name is provided
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <FontName>"
  echo "Example: $0 Hack"
  exit 1
fi

# Read the font name from argument
FONT_NAME="$1"
GITHUB_REPO="ryanoasis/nerd-fonts"
INSTALL_DIR="$HOME/.local/share/fonts"

# Create fonts directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Fetch latest release download URL for the specified font
echo "🔍 Searching for $FONT_NAME Nerd Font in latest release..."
RELEASE_URL=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/releases/latest" \
  | grep "browser_download_url" \
  | grep "${FONT_NAME}.zip" \
  | cut -d '"' -f 4)

# Check if we found a matching URL
if [ -z "$RELEASE_URL" ]; then
  echo "❌ Could not find ${FONT_NAME}.zip in the latest Nerd Fonts release."
  exit 1
fi

# Download the font zip
ZIP_FILE="/tmp/${FONT_NAME}.zip"
echo "⬇️ Downloading $FONT_NAME Nerd Font..."
curl -L -o "$ZIP_FILE" "$RELEASE_URL"

# Unzip font to local font directory
echo "📂 Installing font to $INSTALL_DIR..."
unzip -o "$ZIP_FILE" -d "$INSTALL_DIR"

# Update font cache
echo "🔄 Refreshing font cache..."
fc-cache -fv > /dev/null

# Cleanup
rm "$ZIP_FILE"

echo "✅ $FONT_NAME Nerd Font installed successfully!"
