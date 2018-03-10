#!/bin/sh

rm -r ios_dependencies/device
rm -r ios_dependencies/simulator

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/2.3.0/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AR-ANE/releases/download/0.0.9/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AR-ANE/releases/download/0.0.9/assets.zip
unzip -u -o assets.zip
rm assets.zip

wget -O ../native_extension/ane/ARANE.ane https://github.com/tuarua/AR-ANE/releases/download/0.0.9/ARANE.ane?raw=true
