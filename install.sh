#!/bin/bash

# Install script for Plasma Panel Shell Execute widget

WIDGET_NAME="org.kde.plasma.shellexecute"
INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$WIDGET_NAME"

echo "Installing Plasma Panel Shell Execute widget..."

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Copy package contents
cp -r package/* "$INSTALL_DIR/"

echo "Widget installed to: $INSTALL_DIR"
echo ""
echo "To add the widget to your panel:"
echo "1. Right-click on your panel"
echo "2. Select 'Add Widgets...'"
echo "3. Search for 'Plasma-Panel-Shell-Execute'"
echo "4. Add it to your panel"
echo ""
echo "To uninstall, run: ./uninstall.sh"
