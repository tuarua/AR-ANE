#!/bin/sh

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/2.0.0/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/AR-ANE/releases/download/0.0.1/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget -O ../native_extension/ane/ARANE.ane https://github.com/tuarua/AR-ANE/releases/download/0.0.1/ARANE.ane?raw=true
