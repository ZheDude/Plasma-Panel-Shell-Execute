#!/bin/bash

# Test script for Plasma Panel Shell Execute widget

./uninstall.sh
./install.sh

QT_LOGGING_RULES="qml.debug=true;qt.qml.binding.removal.info=true" plasmoidviewer -a org.kde.plasma.shellexecute

exit