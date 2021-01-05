# This repository contains the files needed to set up a secure NiFi-Registry via docker at GCP


## Follow the steps below to make the necessary settings

- Create a GCP account and a new project
- For this project we will use a virtual machine, an instance group, a website domain, an SSL certificate, a DNS zone, a static address and a load balancer

**Let's start by configuring the virtual machine that we will use to configure the NiFi-Registry:**  
- Access the VM instance menu through the link below and go to "create instance"  
https://console.cloud.google.com/compute/instances
- Give your instance a name, make sure the region is marked as "us-central1" and in Zone select "us-central1-f"
- Select the E2 series and the machine type according to the amount of memory that will be needed, in my case I used the 8 GB machine
- Change the Boot Disk and in Operating System select "Container Optimized OS" and select the latest stable version available
- Remember to check the Firewall check-boxes: "Allow HTTP traffic" and "Allow HTTPS traffic"
- Click on "Create" and wait while your instance starts up

**Now we will install NiFi in our created instance**
- Click the SSH button to connect to the machine
- Clone your repository using the ```git``` command  
```git clone https://github.com/tatianamara/registry-configuration.git```  
```cd registry-configuration```  


- Download and run the Docker Compose image. Check the Docker Compose tags to use the latest version  
```docker run docker / compose: 1.27.4 version```  
- Make sure you have write permission on the directory  
```$ pwd```  
```/home/username/registry-configuration```  
- Run the Docker Compose command to run the code.  
For the Docker Compose container to have access to the Docker daemon, mount the Docker socket with the -v /var/run/docker.sock:/var/run/docker.sock option.  
To make the current directory available to the container, use the option -v "$ PWD: $ PWD" to mount it as a volume and -w = "$ PWD" to change the working directory.  
```docker run --rm \```    
```-v /var/run/docker.sock:/var/run/docker.sock \```  
```-v "$PWD:$PWD" \```  
```-w="$PWD" \```  
```docker/compose:1.27.4 up```  

**Now we are almost ready to access NiFi-Registry via the external IP provided by GCP, but first we need to create a Firewall rule to release the ports that Registry will use**  
- In the side menu go to Network -> VPC Network -> Firewall
- Click on "Create Firewall Rule", choose a name for your rule
- In destination tags, place "http-server", "https-server"
- In IP ranges, enter: "0.0.0.0/0"
- And finally in Protocols and ports add the ports that will be used in the project, in our case they will be: "18080", "443"
- Click create rule

**Done! We are now able to access NiFi via the external IP, just click on it and add in the path ": 18080/nifi-registry" to access**  
**Note: for now it is only accessible via HTTP connection**

## Registry and NiFi connection
- Access the NiFi interface, click on the menu in the upper right corner and access the controller settings
- In Registry Clients add a connection to the Registry
- Give a name and in the URL paste the URL you use to access the Registry interface and click on ADD
- If you have not yet configured the nifi, follow this tutorial: https://github.com/tatianamara/nifi-configuration-docker

**Ok, now just create a new Process Group, right click and select the "version" option, select the Registry Bucket you want to use and place a commit message**  

## HTTPS connection configuration
- To configure the HTTPS connection, follow this tutorial: https://www.notion.so/How-to-set-up-a-secure-connection-in-GCP-0325d073fa0e42148fcb68c487099673
