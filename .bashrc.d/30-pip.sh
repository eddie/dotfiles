export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

if command -v poetry &> /dev/null; then
  poetry config virtualenvs.in-project true
fi

