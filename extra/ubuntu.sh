#!/bin/bash

echo "Local Install Script for Galaxy with UGA Web Service Extensions"
echo ""
echo "This install script requires sudo access to your system in order to"
echo "install the required prequisites. These prerequisites will be installed"
echo "using the system's package manager and can be easily uninstalled at a "
echo "later time"
echo ""
echo "WARNING: You will be required to enter your password during the"
echo "         installation process."
echo ""
echo "Installing build tools..."
sudo apt-get install build-essential
echo ""
echo "Installing Python..."
sudo apt-get install python2.7 python2.7-dev
echo ""
echo "NOTE: The rest of the installation process will occur locally. No more"
echo "      changes will be made system-wide."
echo ""

