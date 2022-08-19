# What is a Technology stack ?.
A technology stack, also called a solutions stack, technology infrastructure, or a data ecosystem, is a list of all the technology services used to build and run one single application. They are acronymns for individual technologies used together for a spercific technology product. some examples are. 

- LAMP (Linux, Apache, MySQL, PHP or Python, or Perl).
- LEMP ( Linux, Nginx, MySQL, PHP or Python, or Perl).
- MERN (MongoDB, ExpressJS, ReactJS, NodeJS).
- MEAN (MongoDB, ExpressJS, Angular, NodeJS).

# Web Stack Implementation (Linux AWS EC2 MySQL PHP LAMP )

## Step 1: create virtual host machines by AWS EC2. 

![image](https://user-images.githubusercontent.com/34083808/185404393-95dc61b6-07ad-42ff-8c7b-d33ebedf0973.png)

launch new instance as folow with Ubuntu OS. 

![image](https://user-images.githubusercontent.com/34083808/185404931-407e926d-cdbe-4fc8-b28b-bf72f5662600.png)

![image](https://user-images.githubusercontent.com/34083808/185422488-5e43b58f-1fbd-42f3-a04d-5ee878444c84.png)

![image](https://user-images.githubusercontent.com/34083808/185424464-9ee32559-44e4-4178-8d8d-cecd2f1bfce7.png)

![image](https://user-images.githubusercontent.com/34083808/185426103-61c608f2-593a-42a8-a15b-30ddaaeee7f1.png)

After launching the new EC2 instance sucessfully. please use OpenSSH (linux), putty (window), MobaXtern. 

![image](https://user-images.githubusercontent.com/34083808/185427914-71db4f7e-da0b-4328-885f-30eccd07ff7c.png)

![image](https://user-images.githubusercontent.com/34083808/185427974-f9ffb701-0808-4f10-b9ec-1892b501af0f.png)

## Step 2: Installing APACHE and Updating the firewall. 

What Exactly is Apache ?. 

The Apache HTTP Server (/əˈpætʃi/ ə-PATCH-ee) is a free and open-source cross-platform web server software, released under the terms of Apache License 2.0. Apache is developed and maintained by an open community of developers under the auspices of the Apache Software Foundation ([Wiki](https://en.wikipedia.org/wiki/Apache_HTTP_Server)).

intall Apache using ubuntu's package manager 'apt'

```
# update a list of packages in package manager.
sudo apt update

# run apache2 package installation
sudo apt install apache2

# to verify that apache2 is running

sudo systemctl status apache2
```

![image](https://user-images.githubusercontent.com/34083808/185430296-85baa252-88b4-49d9-8800-7c1b3aecc20d.png)

Before we can reviev any traffic by our web server, we need to open TCP Port 80 which is the default port that web browsers use to access web pages on the internet. So, we need to update the security rule for inbound connection. Inbound connection mean the connection from outside to our virtual host. The current settup was allow port 22(ssh), 80 (http), 443 (https) can connect our virtual host from the internet. IP adress ```0.0.0.0\0``` mean that our VM can recive request from any Ip adress. 

![image](https://user-images.githubusercontent.com/34083808/185522567-fa25c23e-0183-4c05-a225-b7bd48e70cc6.png)


To check how we can access it locally in our Ubuntu shell.

```
# access by DNS name
curl http://localhost:80

# access by Ip adress
curl http://127.0.0.1:80
```
To check our Apache HTTP server can respond to requests from the internet, open a web browser and input follow url ```http://<public-ip-address>:80```

![image](https://user-images.githubusercontent.com/34083808/185533930-fb15643f-d218-43ad-9383-b985d787612c.png)

another way to retrive your Public IP Adress, other than check it in AWS web console is to use following command. 

```
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```

## step 3: Installing MYSQL.

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

## Step 4: Installing PHP. 
You have Apache installed to serve your content and MySQL installed to store and manage your data. PHP is the component of our setup that will process code to display dynamic content to the end user.  In adition, to the ```php``` package, you'll need ```php-mysql```, a php module that allows PHP to communicate with MySQL-based databases. You'll also need ``` libapache2-mod-php``` to enable Apache to handel PHP files. Core PHP packages will automatically be install as dependency. 

To install these 3 packages at onece. 

```
sudo apt install php libapache2-mod-php php-mysql
```

onnce the installing completed, your can check the version of php by ``` sudo php -v ```

At this point, your LAMP stack is completely installed and fully operational. 

To test your setup with a PHP script, it's best to setup a proper [Apache Virtual Host](https://httpd.apache.org/docs/2.4/vhosts/) to hold your website's files and folders. Virtual Host allows you to have multiple located on a single machine and users of the websites will not even notice it. 

![image](https://user-images.githubusercontent.com/34083808/185581488-db18032e-d795-412d-a527-403a720caa21.png)

## Step 5: Configure our first Virtual Host. 

Apache on Ubuntu 20.04 has one server block enabled by default that is configured to serve documents from the /var/www/html directory. We will leave this configuration as it is and create our own directory. 

```
# create our folder for web server
sudo mkdir /var/www/prokjectlamp

# change ownership of the directory with your current system user.
sudo chown -R $USER:$USER /var/www/prokjectlamp

# create and open new configuration file in Apache's site-avalable directory. 
sudo vi /etc/apache2/sites-available/projectlamp.conf

# file content
<VirtualHost *:80>
    ServerName projectlamp
    ServerAlias www.projectlamp
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/projectlamp
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
with this virtualhost configuration, we're telling Apache to serve projectlamp using /var/www/projectlamp as its web root directory. If you would like to test apache without a domain name, you can remove or comment out the options ServerName and ServerAlias by adding a # charactor in the begining of each option's lines.

You can now use a2ensite command to enable the new virtual host.

```
sudo a2ensite projectlamp

# to disable default website that come with apache.
sudo a2dissite 000-default

# To make sure your your configuration working file. 
sudo apache2ctl configtest

# reload Apache so these changes take effect:
sudo systemctl reload apache2
```

Create an index.html file in var/www/projectlamp folder for your website. So that we can test that the virtual host works as expected. 

```
sudo echo 'Hello LAMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' $(curl -s curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/projectlamp/index.html
```
the content of index.html file
```
Hello LAMP from hostname ec2-54-226-112-195.compute-1.amazonaws.com with public IP 54.226.112.195
```
your can access the webpage either by public-hostname(ec2-54-226-112-195.compute-1.amazonaws.com) nor IP adress(54.226.112.195). untill you setup an index.php file, we can leave it as it is. after that please change file name or remove it. 

Step 6: Enable PHP on the website.

With the default Directoryindex setting on apache, a file name index.html will alway take precedence over an index.php file. In case you want to change behavior. You'll need to edit the /etc/apache2/mods-enable/dir.conf file and change the order in which index.php file listed within Directoryindex. 

```
sudo vim /etc/apache2/mods-enable/dir.conf
<IfModule mod_dir.c>
    #Change This:
    # DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
    # to this
    DirectoryIndex index.php  index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```

after that, you need to reload Apache so the changes take effects. 
```
sudo systemctl reload apache2
```
create new index.php file to confirm that Apache is able to handle and process requests for PHP file.

```
sudo vim /var/www/projectlamp/index.php

# file contents
<?php
phpinfor();
```
When you finished, save and close the file, refresh the page and you will see a page similar to this. If you can see this page then your PHP installation is working as expected. After checking the relevent information about your php server throught that page. It's best to remove thie file you created as it contains sensitive information about PHP environment and your Ubuntu server. 

```
sudo rm /var/www/projectlamp/index.php
```

![image](https://user-images.githubusercontent.com/34083808/185646786-6368456d-3279-4bf7-99c2-52c9df6e1292.png)

