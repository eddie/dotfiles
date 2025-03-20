export WORKON_HOME=~/.virtualenvs
# Point this to your python3 executable, or ignore this line if you want to
# create default venv based on the default python exe.
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
# Find out where virtualenvwrapper.sh is located; you can use
#   $ find / |grep virtualenvwrapper.sh
# or alternatively:
#   # updatedb         # this has to be performed by root, and takes a while
#   # locate virtualenvwrapper.sh
# If you installed virtualenvwrapper using `$ pip install --user`, it should
# be stored in the following location.
source $HOME/.local/bin/virtualenvwrapper.sh
# or let bash find it
# source $(which virtualenvwrapper.sh)
 
poetry config virtualenvs.in-project true
