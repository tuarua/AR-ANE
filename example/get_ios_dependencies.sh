#!/bin/sh

AneVersion="1.0.0"
FreSwiftVersion="4.3.0"

rm -r ios_dependencies/device
rm -r ios_dependencies/simulator

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AR-ANE/releases/download/$AneVersion/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AR-ANE/releases/download/$AneVersion/assets.zip
unzip -u -o assets.zip
rm assets.zip

wget https://github.com/tuarua/AR-ANE/releases/download/$AneVersion/reference_images.zip
unzip -u -o reference_images.zip
rm reference_images.zip

wget -O ../native_extension/ane/ARANE.ane https://github.com/tuarua/AR-ANE/releases/download/$AneVersion/ARANE.ane?raw=true
