#!/bin/sh

set -ex

cleanup_after_install () {
    find /usr/local -depth -type d -a  -name test -o -name tests -o  -type f -a -name '*.pyc' -o -name '*.pyo' -exec rm -rf '{}' +
    rm -rf /usr/src/python
}


get_install () {
    PY_VERSION=$1
    PY_DIR=${2:-$1}
    cd /tmp
    wget -q https://www.python.org/ftp/python/$PY_DIR/Python-$PY_VERSION.tgz
    tar xzf Python-$PY_VERSION.tgz
    cd /tmp/Python-$PY_VERSION
    ./configure && make && make altinstall
    cd /tmp
    rm Python-$PY_VERSION.tgz && rm -r Python-$PY_VERSION
}


# Install Python 2.7, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9
#
# For pre-release versions, include a second argument that's *just*
# Major.Minor.Patch (i.e. without the pre-release tag) since when they don't
# match, the second argument is the download directory.
get_install $PYTHON_27_VER
get_install $PYTHON_34_VER
get_install $PYTHON_35_VER
get_install $PYTHON_36_VER
get_install $PYTHON_37_VER
get_install $PYTHON_38_VER
get_install $PYTHON_39_VER 3.9.0

# Get and install Python rolling devel from the latest git install.
cd  /tmp/
wget -q https://github.com/python/cpython/archive/master.zip
unzip -qq master.zip
cd /tmp/cpython-master
./configure && make && make altinstall
# Remove the git clone.
rm -r /tmp/cpython-master && rm /tmp/master.zip

# After we have installed all the things, we cleanup tests and unused files
# like .pyc and .pyo
cleanup_after_install
