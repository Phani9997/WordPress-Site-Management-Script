#!/bin/bash

set -e

USERID=$(id -u)

DATE=$(date +"%F-%H-%M-%S")

LOGFILE="$DATE.log"

R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"

public_ip=$(wget -qO- https://api.ipify.org)

#check user is root or not
if [ $USERID -ne 0 ]; then
    echo "$R Please run this script with root access $N"
    exit 1
fi
# Checking docker and docker-compose is installed or not 
if dpkg-query -W -f='${Status}' docker.io 2>/dev/null | grep -q "install ok installed"; then
    echo  "$Y Docker is already installed. $N"
    echo  "$Y Docker-compose is already installed. $N"
else
    if sudo apt-get update -y >> "$LOGFILE" 2>&1; then
        echo  "Server...$G Updated $N"
    fi

    if sudo apt-get install docker.io -y >> "$LOGFILE" 2>&1; then
       sudo usermod -aG docker $USER
       echo  "Docker...$G Installed $N"
    fi

    if sudo apt-get install docker-compose -y >> "$LOGFILE" 2>&1; then
         echo  "Docker-compose...$G Installed $N"
    fi
fi


# Check if site name and port are provided as command-line arguments
if [ $# -lt 2 ]; then
    echo "Please provide the site name and port as command-line arguments."
    echo "Usage: $0 <site_name> <port> [enable|disable|delete]"
    exit 1
fi

# Store the site name and port from the command-line arguments
site_name=$1
port=$2

# Set the site directory
site_dir="/var/www/html/$site_name"

# Create the site directory if it doesn't exist
mkdir -p "$site_dir"
cd "$site_dir" || exit 1

# Check if the site is already enabled
if [ -f .enabled ]; then
    if [ "$3" = "enable" ]; then
        echo "Site '$site_name' is already enabled."
        exit 0
    fi
elif [ "$3" = "disable" ]; then
    echo "Site '$site_name' is already disabled."
    exit 0
fi

# Enable the site
if [ "$3" = "enable" ]; then
    touch .enabled
    echo "Site '$site_name' is now enabled."
    exit 0
fi

# Disable the site
if [ "$3" = "disable" ]; then
    rm -f .enabled
    echo "Site '$site_name' is now disabled."
    exit 0
fi

# Delete the site
if [ "$3" = "delete" ]; then
    docker-compose down
    rm -rf "$site_dir"
    echo "Site '$site_name' has been deleted."
    exit 0
fi


# Creating a docker-compose.yml file
cat > docker-compose.yml <<EOL
version: '2.2'
services:
  db:
    image: mariadb:10.6.4-focal
    command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=somewordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
    expose:
      - 3306
      - 33060
  wordpress:
    image: wordpress:latest
    ports:
      - $port:80
    restart: always
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - WORDPRESS_DB_NAME=wordpress
volumes:
  db_data:
EOL

# Create a volume for the database
docker volume create db_data

# Start the WordPress site
docker-compose up -d

# Provide information about the created site
echo "$G WordPress site created successfully! $N"

# Add entry to /etc/hosts
echo "Adding entry to /etc/hosts..."
echo "127.0.0.1    $site_name" >> /etc/hosts


# Prompt user to open the site in a browser
echo "Open the following URL in a browser to access the site:"
echo "Site Name: $G http://$site_name $N"
echo "Site URL: $G http://$public_ip:$port $N"

exit 0
