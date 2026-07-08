#!/bin/bash

# Uninstall script for Plasma Panel Shell Execute widget

WIDGET_NAME="org.kde.plasma.shellexecute"
INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$WIDGET_NAME"

echo "Uninstalling Plasma Panel Shell Execute widget..."

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "Widget uninstalled successfully!"
else
    echo "Widget not found in $INSTALL_DIR"
fi

echo ""
echo "Note: You may need to restart Plasma or remove the widget from your panel manually."
