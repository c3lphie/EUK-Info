#!/bin/bash
# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


echo "Cleaning existing files..."

rm -Rf /srv/http
rm -Rf $HOME/.cache/euk-info

echo "Cloning webcontent..."

git clone https://github.com/c3lphie/p5-central-hub.git $HOME/.cache/euk-info

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Webcontent clone succeeded"
  exit 0
else
  echo -e "[ ${RED}FAIL${NC} ] Webcontent clone failed" >&2
  exit 1
fi

echo "Copying to /srv/http"
cp -R $HOME/.cache/euk-info/lib /srv/http
cp -R $HOME/.cache/euk-info/www /srv/http
