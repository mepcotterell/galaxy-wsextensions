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
echo "sudo apt-get install build-essential python2.7 python2.7-dev"
echo ""
sudo apt-get install build-essential python2.7 python2.7-dev

echo ""
echo "NOTE:      The rest of the installation process will occur locally. No "
echo "           more changes will be made system-wide."

# Temporary variables and environment variables
CWD=$(pwd)        # current working dir
ENV="$CWD"/env    # dir for the virtual environment installation
TMP="$CWD"/temp   # temp dir
JDK="$CWD"/jdk    # dir for the oracle jdk installation
GAL="$CWD"/galaxy # dir for the galaxy installation

# Create the directories if they don't already exist
mkdir -p "$ENV"
mkdir -p "$TMP"
mkdir -p "$JDK"
mkdir -p "$GAL"

# The python executable
PYTHON="$(which python2.7)"

# Determine whether the system is 32 or 64 bit
MODEL=$(uname -m)

echo ""
echo "Downloading the prerequisites..."

# Download the python virtualenv script
echo ""
echo "Downloading the Virtual Python Environment builder"
wget -P "$TMP" https://raw.github.com/pypa/virtualenv/master/virtualenv.py

# Download the appropriate jdk
echo "Downloading the Java Development Kit"
if [ "$MODEL" == "x86_64" ]
then 
    echo "64bit JDK"
    wget -O "$TMP"/jdk.tar.gz -P "$TMP" http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.tar.gz
else
    echo "32bit JDK"
    wget -O "$TMP"/jdk.tar.gz -P "$TMP" http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-i586.tar.gz
fi

echo "Downloading JPype"
wget -O "$TMP"/jpype.zip -P "$TMP" http://downloads.sourceforge.net/project/jpype/JPype/0.5.4/JPype-0.5.4.2.zip

echo "Downloading Galaxy"
wget -O "$TMP"/galaxy.tar.gz -P "$TMP" http://dist.g2.bx.psu.edu/galaxy-dist.tip.tar.gz

# Go into the temp directory
cd "$TMP"

echo "Installing and activating the Virtual Python Environment"
$PYTHON virtualenv.py "$ENV"

# Update the path to the python executable
PYTHON="$ENV"/bin/python

# Activate the new environment
. "$ENV"/bin/activate

echo ""
echo "Installing the JDK and setting up the environmental variables"
tar zxf jdk.tar.gz
mv jdk*/* "$JDK"
export JAVA_HOME="$JDK"
export PATH="$JDK"/bin:$PATH

echo ""
echo "Installing JPype"
unzip jype.zip
cd JPype-0.5.4.2
$PYTHON setup.py install --prefix "$ENV"

# Go into the temp directory
cd "$TMP"

echo ""
echo "Installing Galaxy"
tar zxf galaxy.tar.gz
mv galaxy-dit/* "$GAL"

echo ""
echo "Patching Galaxy with Web Service Extensions"

echo ""
echo "Cleaning up..."

# Clean up
cd "$CWD"
rm -rf "$TMP"

echo ""
echo "Done!"

echo "You can start Galaxy using the following command: "

