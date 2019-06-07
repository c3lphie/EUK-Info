#! /bin/bash

# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


# This script is responsible for the first stage in setting the system up to use and install p5-central-hub

echo "Checking if user is root..."
if [ "$EUID" -ne 0 ]
  then echo -e "[ ${RED}FAIL${NC} ] Please run script as root"
  exit
fi

echo -e "[  ${GREEN}OK${NC}  ] User is root"

echo "Checking internet connection..."

ping -q -w 1 -c 1 google.com > /dev/null

# Check internet
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Internet connection is up"
else
  echo -e "[ ${RED}FAIL${NC} ] Internet connection is down" >&2
  exit 1
fi

echo "Initializing pacman keys..."

pacman-key --init

# Check if pacman-key ran successfully
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] pacman keys initialized successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] pacman keys did not initialize successfully" >&2
  exit 1
fi

echo "Populating pacman keys..."

pacman-key --populate archlinuxarm

# Check if pacman-key ran successfully
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] pacman keys populated successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] pacman keys did not populate successfully" >&2
  exit 1
fi

#Update system
echo "Updating system..."

pacman -Suy --noconfirm

# Check if pacman ran successfully
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Updated system successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] System update failed" >&2
  exit 1
fi

echo "Installing packages..."

pacman -Suy --noconfirm git wget apache mysql php php-apache phpmyadmin

# Check if pacman ran successfully
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Packages installed successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] Package install failed" >&2
  exit 1
fi

echo "Creating cache folder for updating..."
mkdir $HOME/.cache/euk-info

echo "Downloading apache config..."

wget https://raw.githubusercontent.com/c3lphie/EUK-Info/master/requirements/httpd.conf -O httpd.conf

# Check if wget downloaded config
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Apache config downloaded successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] Apache config download failed" >&2
  exit 1
fi


echo "Copying apache config..."

cp httpd.conf /etc/httpd/conf/httpd.conf

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Apache config copy succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] Apache config copy failed" >&2
  exit 1
fi

echo "Downloading phpmyadmin config..."

wget https://raw.githubusercontent.com/c3lphie/EUK-Info/master/requirements/phpmyadmin.conf -O phpmyadmin.conf

# Check if wget downloaded config
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] phpmyadmin config downloaded successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] phpmyadminconfig download failed" >&2
  exit 1
fi


echo "Copying phpmyadmin config..."

cp phpmyadmin.conf /etc/httpd/conf/extra/phpmyadmin.conf

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] phpmyadmin config copy succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] phpmyadmin config copy failed" >&2
  exit 1
fi

echo "Downloading php config..."

wget https://raw.githubusercontent.com/c3lphie/EUK-Info/master/requirements/php.ini -O php.ini

# Check if wget downloaded config
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] php config downloaded successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] php config download failed" >&2
  exit 1
fi

echo "Copying php config..."

cp php.ini /etc/php/php.ini

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] phpmyadmin config copy succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] phpmyadmin config copy failed" >&2
  exit 1
fi

systemctl stop httpd
systemctl stop mysqld

echo "Installing MySQL..."

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] MySQL installation succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] MySQL installation failed" >&2
  exit 1
fi

systemctl restart mysqld

echo "Executing mysql_secure_installation..."

mysql_secure_installation

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] MySQL secure installation succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] MySQL secure installation failed" >&2
  exit 1
fi

echo "Downloading update-info"

wget https://raw.githubusercontent.com/c3lphie/EUK-Info/master/update.sh -O update-info.sh

# Check if wget downloaded config
if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] update-central-hub downloaded successfully"
else
  echo -e "[ ${RED}FAIL${NC} ] update-central-hub download failed" >&2
  exit 1
fi

echo "Copying update-info..."

cp update-info.sh /usr/bin/update-info

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] update-central-hub copy succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] update-central-hub copy failed" >&2
  exit 1
fi

echo "Setting permissions..."

chmod +x /usr/bin/update-info

if [ $? -eq 0 ]
then
  echo -e "[  ${GREEN}OK${NC}  ] Permissions change succeeded"
else
  echo -e "[ ${RED}FAIL${NC} ] Permissions change failed" >&2
  exit 1
fi

update-info

if [ $? -eq 1 ]
then
  exit 1
fi


echo "Enabling services to start on startup..."

systemctl enable create_ap
systemctl enable mysqld
systemctl enable httpd

echo -e "[  ${GREEN}OK${NC}  ] Install completed successfully. Reboot the machine to apply changes."
