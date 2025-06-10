#!/bin/bash

	#Installing nginx and control webpage
	sudo apt-get update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx

    echo " <h1> hii </h1>" > /var/www/html/index.html