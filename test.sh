#!/bin/bash

# Test script for Plasma Panel Shell Execute widget

./uninstall.sh
./install.sh

plasmoidviewer -a org.kde.plasma.shellexecute

exit