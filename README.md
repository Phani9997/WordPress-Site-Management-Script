
## WordPress Site Management Script
This script automates the setup, management, and deletion of WordPress sites using Docker and Docker Compose. It allows you to easily create, enable, disable, and delete WordPress sites with customizable site names and port numbers.


## Prerequisites
Before using this script, make sure you have the following prerequisites installed:

1. Docker: You can install Docker by following the official installation guide for your operating system: Install Docker
2. Docker Compose: You can install Docker Compose by following the official installation guide: Install Docker Compose

## Installation
1. Clone the repository or download the script file to your local machine.
git clone https://github.com/Phani9997/WordPress-Site-Management-Script.git

2. Grant execution permissions to the script file.
  chmod +x script.sh

3. If you don't have root access, make sure to run the script with root privileges or use sudo when executing the commands.




## Usage
To use the script, follow the instructions below for different operations.
## Creating a New WordPress Site
To create a new WordPress site, run the script with the site name and port number as command-line arguments. Additionally, provide the enable option to automatically enable the site after creation.
* ./script.sh <site_name> <port> enable

Replace <site_name> with the desired name for your WordPress site (e.g., mysite) and <port> with the desired port number (e.g., 8080).

The script performs the following steps to create the site:

* Checks if Docker and Docker Compose are installed and installs them if necessary.
* Creates a directory for the site at /var/www/html/<site_name>.
* Generates a Docker Compose file (docker-compose.yml) for the site.
* Creates a Docker volume for the database.
* Starts the WordPress site using Docker Compose.
* Enables the site by creating a .enabled file in the site directory.
* Adds an entry to /etc/hosts for easy access to the site.
The script then displays the following information:
* Site Name: <site_name>
* Site URL: http://<site_name>
* Site URL with Public IP: http://<public_ip>:<port>
* Instructions to open the site in a browser.
## Enabling a WordPress Site
To enable an existing WordPress site, run the script with the site name and port number as command-line arguments. Use the enable option.

./script.sh <site_name> <port> enable

* Replace <site_name> with the name of the existing WordPress site and <port> with the corresponding port number.

* The script checks if the site is already enabled. If it's not, the script creates the .enabled file in the site directory to enable the site.


## Disabling a WordPress Site

To disable an enabled WordPress site, run the script with the site name and port number as command-line arguments. Use the disable option.

./script.sh <site_name> <port> disable
 
* Replace <site_name> with the name of the WordPress site and <port> with the corresponding port number.

* The script checks if the site is already disabled. If it's not, the script removes the .enabled file from the site directory to disable the site.


## Deleting a WordPress Site
To delete an existing WordPress site, run the script with the site name and port number as command-line arguments. Use the delete option.

./script.sh <site_name> <port> delete

* Replace <site_name> with the name of the WordPress site and <port> with the corresponding port number.

* The script performs the following steps to delete the site:

* Stops and removes the Docker containers associated with the site.
* Deletes the site directory and its contents.
* Displays a confirmation message.
