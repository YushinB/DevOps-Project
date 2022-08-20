# What’s a LEMP stack ?
LEMP is a variation of the ubiquitous LAMP stack used for developing and deploying web applications. Traditionally, LAMP consists of Linux, Apache, MySQL, and PHP. Due to its modular nature, the components can easily be swapped out. With LEMP, Apache is replaced with the lightweight yet powerful Nginx.

![image](https://user-images.githubusercontent.com/34083808/185729945-4040233b-38fb-445a-b058-f9b4e32161e9.png)

## Step 1: Installing the Nginx Web Server.

Nginx is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols. It also functions as a load balancer, HTTP cache, and web server (origin server). It has a strong focus on high concurrency, high performance and low memory usage. The HTML5 Boilerplate project has sample server configuration files to improve performance and security.

intall Nginx using ubuntu's package manager 'apt'

```
# update a list of packages in package manager.
sudo apt update

# run nginx package installation
sudo apt install nginx
# check nginx version 
nginx -v

# to verify that nginx is running
sudo systemctl status nginx

# If Nginx is not running, use the following command to launch the Nginx service:
sudo systemctl start nginx

# To set Nginx to load when the system starts, enter the following:
sudo systemctl stop nginx

#To prevent Nginx from loading when the system boots:
sudo systemctl disable nginx

#To reload the Nginx service (used to apply configuration changes):
sudo systemctl reload nginx

#For a hard restart of Nginx:
sudo systemctl restart nginx

#Start by displaying the available Nginx profiles:
sudo ufw app list
```

![image](https://user-images.githubusercontent.com/34083808/185730280-f263c5a1-7406-4fdf-809e-4e8462f85528.png)

Before we can reviev any traffic by our web server, we need to open TCP Port 80 which is the default port that web browsers use to access web pages on the internet. So, we need to update the security rule for inbound connection. Inbound connection mean the connection from outside to our virtual host. The current settup was allow port 22(ssh), 80 (http), 443 (https) can connect our virtual host from the internet. IP adress ```0.0.0.0\0``` mean that our VM can recive request from any Ip adress. 

![image](https://user-images.githubusercontent.com/34083808/185522567-fa25c23e-0183-4c05-a225-b7bd48e70cc6.png)


To check how we can access it locally in our Ubuntu shell.

```
# access by DNS name
curl http://localhost:80

# access by Ip adress
curl http://127.0.0.1:80
```

To check our Nginx server can respond to requests from the internet, open a web browser and input follow url ```http://<public-ip-address>:80```

![image](https://user-images.githubusercontent.com/34083808/185730339-850f5887-78d6-483c-aa84-debde32a391b.png)


## step 2: Installing MYSQL.

Now that you have a web server up and runnung. You need to install a Database Managerment System (DBMS) to be able to store and manage data for your site in a Relational database. MySQL is a popular relational database management system used within PHP environments.

to install mysql we use apt package manager.
```
sudo apt install mysql-server
```
It's recommended that you run a security script that comes pre-installed with MySQL. This script will remove some insecure default settings and lock down access to your database system.

```
sudo mysql_secure_installation
```
> Note: Enabling this feature is something of a justment call. Id enabled, passwords which don't match the specified criterial will be rejected by MySQL with an error. IT's safe to leave validation disble. But you shoud always use strong, unique passwords for database credentials. 


```
Securing the MySQL server deployment.

Connecting to MySQL using a blank password.

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?

Press y|Y for Yes, any other key for No:
```

If you have problem error message when input new password to root ``` .. Failed! Error: SET PASSWORD has no significance for user 'root'@'localhost'```
please solve it by follwing steps. 
1. Open the terminal application.
2. Terminate the mysql_secure_installation from another terminal using the killall command: ```sudo killall -9 mysql_secure_installation```
3. Start the mysql client: ```sudo mysql``` Run the following SQL query ```ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mypassword;'; exit ```
4. run ``` sudo mysql_secure_installation ``` again. 
5. input your root password which set at step 3. 
6. access mysql with ``` mysql -h localhost -u root -p ``` 

![image](https://user-images.githubusercontent.com/34083808/185567131-98dcd95a-b4cd-4ead-a031-82449306bec4.png)

> note: at defaut the authentication method for mysql user is unix_socket or auth_socket. It allow you access mysql without password by administrative (sudo) mode. 
> to check current authentication method please type in follwing command in mysql terminal ```mysql> SELECT user,authentication_string,plugin,host FROM mysql.user; ```

![image](https://user-images.githubusercontent.com/34083808/185568153-165dcb6f-0808-4cae-b613-a10c5060addd.png)

## Step 3: Installing PHP. 
While Apache embeds the PHP interpreter in each request, Nginx requres an external program to handle PHP processing and act as a bridge between the PHP interpreter itself and the web server. You'll need to install ```php-fpm```, which stand for "PHP fastCGI process manager", and tell Nginx to pass PHP request to this software for processing. Additionally, you'll need ``` php-mysql```, a php module that allows PHP to communicate with MySQL-based databases. 

To install these 2 packages at onece. 

```
sudo apt install php-fpm php-mysql
```

onnce the installing completed, your can check the version of php by ``` sudo php -v ```

At this point, your LEMP stack is completely installed and fully operational. 

## Step 4 - Configuring Nginx to User PHP Processor.

When using the Nginx web server, we can create server block (similar to virtual hosts in apache) to encapsulate configuration details and host more than one domain on a single server.

Nginx on Ubuntu 20.04 has one server block enabled by default that is configured to serve documents from the /var/www/html directory. We will leave this configuration as it is and create our own directory. 

```
# create our folder for web server
sudo mkdir /var/www/projectlemp

# change ownership of the directory with your current system user.
sudo chown -R $USER:$USER /var/www/projectlemp

# create and open new configuration file in Nginx's site-avalable directory. 
sudo vi /etc/nginx/sites-available/projectlemp

# pass in the following bare-bones configuration.

#/etc/nginx/sites-available/projectlemp

server {
  listen 80;
  server_name soraking.cloud www.soraking.cloud;
  root /var/www/projectlemp;
  
  # the priority of index file
  index index.html index.htm index.php
  
  location / {
     try_files $url $url/ = 404
  }
  
  location ~\.php$ {
     include snippets/fastcgi-php.conf;
     fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
  }
  # This directive tells the webserver to deny all incoming requests for any files starting with .ht in the root directory (/).
  # The tilde ~ tells nginx to use regular expressions. Thus, files like ```.htaccess```, ```.htpasswd```, etc, will not be served
  location ~/\.ht{
    deny all;
  }
}
```
> please check the php-fpm version and input the avalable version in the nginx config file. 

![image](https://user-images.githubusercontent.com/34083808/185731576-37b5bec4-ddab-4621-a5dd-14aa4dd2261f.png)

Active your configuration by linking to the config file from Nginx's ``` sites-enabled``` directory:

```
sudo ln - /etc/nginx/sites-available/projectlemp /etc/nginx/sites-enabled
```

This will tell Nginx to use the configuration next time it is reloaded. You can test your configuration for systax errors by typing. 

```
sudo nginx -t

# disable default Nginx host that is currently configured to listen on port 80.
sudo unlink /etc/nginx/sites-enabled/default
# reload nginx 
sudo systemctl reload nginx
```

Create an index.html file in var/www/projectlemp folder for your website. So that we can test that the virtual host works as expected. 

```
sudo echo 'Hello LEMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' $(curl -s curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/projectlemp/index.html
```
![image](https://user-images.githubusercontent.com/34083808/185733961-2b5cb9a4-f26b-4a25-8d80-88dcc0375fee.png)

## step 5: Testing PHP with Nginx.

create new index.php file to confirm that Apache is able to handle and process requests for PHP file.

```
sudo vim /var/www/projectlemp/index.php

# file contents
<?php
phpinfo();
```

![image](https://user-images.githubusercontent.com/34083808/185735524-d0dc960a-00e4-4092-845c-558a102c4907.png)

After checking the relevent information about your PHP server though above page. It's best to remove the file, because it contain sensitive information of our ubunu severs. 

```
sudo rm /var/www/projectlemp/infor.php.
```

## Step 6: Retriving data from Mysql database with PHP.

In this step you'll create a test database with simple todo list and configure access to it, so the Nginx website would be able to query data from DB and display it. 

First connect to the MYSQL root account. 

```
sudo mysql
mysql> CREATE DATABAE example_database;
```

Now you can create a new user and grant him full privileges on the database you have just created.

```
mysql> CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY '123456789';
```

To check the validation password in mysql you can use ```SHOW VARIABLES LIKE 'validate_password%';```

![image](https://user-images.githubusercontent.com/34083808/185736169-eff70ec1-8dd8-4ee0-baaa-3471c60d2be0.png)

and you can change those variable by ``` SET GLOBAL <variable_name>=<value>```

Now we need to give this user permission over the example_database.

```
mysql> GRANT ALL ON example_database .* TO 'example_user'@'%';

# loging again
sudo mysql -u example_user -p

mysql> SHOW DATABASES
```

![image](https://user-images.githubusercontent.com/34083808/185736299-377d0c67-b931-4bf7-b3f5-a69378638c55.png)

create database table named todo_list. 

![image](https://user-images.githubusercontent.com/34083808/185736371-ec107ecc-87a5-4358-a706-88ea39c3625a.png)

```
mysql> INSERT INTO example_database.todo_list (content) VALUES("My first importtant item");
mysql> SELECT * FROM example_database.todo_list;
```

Now you can create a PHP script that will connect to MySQL and query for your content. 

```
nano /var/www/projectlemp/todo_list.php
```

```php
<?php
$user= "example_user";
$password= "123456789";
$database="example_database";
$table="todo_list";

try {
   $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
   echo "<h2> TODO </h2><ol>";
   foreach ($db->query("SELECT content FROM $table") as $row){
      echo "<li>". $row['content']. "</li>";
   }
   echo "</ol>";
} catch (PDOException $e){
   print("ERROR!: " . $e->getMessage() . "<br/>");
   die();
}
```

![image](https://user-images.githubusercontent.com/34083808/185739811-3f1bea1b-dbdb-4bb1-8375-c7739ac63e68.png)

That all for project 2. Thank you very much!!!!.
