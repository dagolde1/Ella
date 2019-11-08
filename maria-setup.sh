#!/bin/bash

#########################################
# Installing python and necessary packages
# for Maria. This script will install python
# into the ~/.maria/local/bin directory and
# install maria & requirements in their
# respective directories.
#########################################
# Assume this program is in the main Maria directory
# so we can save and return to it.
export MARIA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "MARIA_DIR = $MARIA_DIR"
echo "Updating apt, preparing to install libssl-dev, gettext, portaudio19-dev and libasound2-dev"
# install dependencies
sudo apt-get update
# libssl-dev required to get the python _ssl module working
sudo apt-get install libssl-dev gettext libncurses5-dev portaudio19-dev libasound2-dev -y

# installing python 2.7.13
echo 'Installing python 2.7.13 to ~/.maria/local'
mkdir -p ~/.maria/local
cd ~/.maria/local
wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
tar xvzf Python-2.7.13.tgz
cd Python-2.7.13
./configure
make
make altinstall prefix=~/.maria/local  # specify local installation directory
ln -s ~/.maria/local/bin/python2.7 ~/.maria/local/bin/python
cd ..  # ~/.maria/local

# install setuptools and pip for package management
echo 'Installing setuptools'
wget https://files.pythonhosted.org/packages/37/1b/b25507861991beeade31473868463dad0e58b1978c209de27384ae541b0b/setuptools-40.6.3.zip
unzip setuptools-40.6.3.zip
cd setuptools-40.6.3
~/.maria/local/bin/python setup.py install  # specify the path to the python you installed above
cd .. # ~/.maria/local

# The old version of pip expects to access pypi.org using http. PyPi now
# requires ssl for all connections.
wget https://files.pythonhosted.org/packages/45/ae/8a0ad77defb7cc903f09e551d88b443304a9bd6e6f124e75c0fbbf6de8f7/pip-18.1.tar.gz
tar xvzf pip-18.1.tar.gz
cd pip-18.1 # ~/.maria/local/pip-18.1
~/.maria/local/bin/python setup.py install  # specify the path to the python you installed above

# install maria & dependancies
echo "Returning to $MARIA_DIR"
cd $MARIA_DIR
~/.maria/local/bin/pip install -r python_requirements.txt
./compile_translations.sh

# start the maria setup process
echo "#!/bin/bash" > Maria
echo "~/.Maria/local/bin/python $NAOMI_DIR/Maria.py \$@" >> Naomi
chmod a+x Maria
echo "In the future, run $MARIA_DIR/Maria to start Naomi"
./Maria --repopulate

