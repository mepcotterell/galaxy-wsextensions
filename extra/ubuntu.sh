#!/bin/bash
# 
# Copyright (c) 2012 Michael E. Cotterell <mepcotterell@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# nthe following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

clear

echo "Local Install Script for Galaxy with UGA Web Service Extensions"
echo ""
echo "This install script requires sudo access to your system in order to"
echo "install the required prequisites. These prerequisites will be installed"
echo "using the system's package manager and can be easily uninstalled at a "
echo "later time"
echo ""
echo "WARNING:   You may be required to enter your password during the"
echo "           installation process."
echo ""
echo "AGREEMENT: THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY "
echo "           KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE "
echo "           WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE"
echo "           AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT"
echo "           HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, "
echo "           WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING "
echo "           FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR"
echo "           OTHER DEALINGS IN THE SOFTWARE."
echo ""

read -p "Do you agree to the terms above? " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    exit 1
fi

echo ""
echo ""
echo "Installing system-wide prerquisites..."
sudo apt-get install build-essential python2.7 python2.7-dev

echo ""
echo "NOTE: The rest of the installation process will occur locally. No more"
echo "      changes will be made system-wide."
echo ""

