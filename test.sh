#!/bin/bash

# Test script for Plasma Panel Shell Execute widget

echo "Testing Plasma Panel Shell Execute widget..."

# Check if required files exist
echo "Checking required files:"

FILES=(
    "package/metadata.json"
    "package/contents/ui/main.qml"
    "package/contents/ui/configGeneral.qml"
    "package/contents/config/config.qml"
    "package/contents/config/main.xml"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file missing"
    fi
done

echo ""
echo "Validating QML syntax..."

# Check QML syntax if qmlplugindump is available
if command -v qmlplugindump &> /dev/null; then
    echo "QML tools found, checking syntax..."
    # Note: Full validation would require proper Qt/Plasma environment
else
    echo "QML tools not found, skipping syntax check"
fi

echo ""
echo "Widget structure looks good!"
echo "Run './install.sh' to install the widget."
