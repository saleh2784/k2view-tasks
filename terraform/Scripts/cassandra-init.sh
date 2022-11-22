#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start

## example for apache server ##
# sudo su 
# yum check-update
# yum install -y httpd
# chkconfig httpd on
# echo "<h1><b1>My new devops lab</b1></h1>" > /var/www/html/index.html
# service httpd start
