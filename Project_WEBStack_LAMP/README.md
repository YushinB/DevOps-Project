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


