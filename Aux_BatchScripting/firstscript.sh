#! /bin/bash

echo "Welcome to bash script"
echo 

# Checking system uptime
echo "##################################"
echo "the uptime of the system is:"
uptime
echo

# memory Unitization
echo "##################################"
echo "memory utilization"
free -m
echo
#Disk Utilization
echo "##################################"
echo "Disk Utilization"
df -h
