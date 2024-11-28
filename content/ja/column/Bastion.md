---
date: 2020-12-30T00:00:00
description: 
featured_image: 
tags: 
title: "Operating a Bastion Host"
---

![terraformawsbastion-1](https://github.com/user-attachments/assets/15b39548-c2ed-43fe-86f4-e4335f39f88d)

# What is a Bastion Host?
A Bastion Host is a server designed to provide access from a public network to a private network.

Typically, a Bastion Host operates on an Amazon EC2 instance within the public subnet of an Amazon VPC (Virtual Private Cloud). Linux instances reside in subnets that are not publicly accessible, and SSH access is allowed through a security group linked to the EC2 instance running the Bastion Host. Users connect to the Bastion Host, as illustrated in the following diagram, to access Linux instances.

![NM_diagram_061316_a](https://github.com/user-attachments/assets/0972fe30-7d5e-4e92-a1a5-81d603a1e4e0)

# Operating a Bastion Host
## A. EC2
### 1. Instances
1) Bastion Host  
   - **IP:** Public IP assigned  
   - **Subnet:** Deployed in Public Subnet1  

2) WebServer Instance1  
   - **IP:** No public IP assigned  
   - **Subnet:** Deployed in Private Subnet1  

![00](https://github.com/user-attachments/assets/abec3ff3-5c70-461e-be3d-a6c6de9db1b8)

### 2. Security Group
1) Bastion Host  
   - **Type:** SSH  
   - **Source:** Specify "My IP" to restrict access to the Bastion Host from the public IP of the Host PC (access control for Bastion Host).  

2) WebServer Instance1  
   - **Type:** SSH  
   - **Source:** Enter the IP assigned to the public subnet where the Bastion Host is located.  

![11](https://github.com/user-attachments/assets/d8ebbe8a-1fcf-4256-8ede-49b746b4afa1)

## B. VPC
### 1. VPC
   - **VPC CIDR:** 172.31.0.0/16  

![55](https://github.com/user-attachments/assets/d27ef032-09be-41ca-8049-a8dc95e301b7)

### 2. Subnet
   - **Private Subnet CIDR:** 172.31.16.0/20  
   - **Public Subnet CIDR:** 172.31.0.0/20  

### 3. Route Table
1) Private Route Table  
   - Routes only local network traffic.  

2) Public Route Table  
   - Sends non-local traffic to the internet gateway to enable external communication.  

### 4. ACL
1) Private Subnet ACL  
   - Configured to allow SSH access only to the Bastion Host.  

2) Public Subnet ACL  
   - Allows SSH requests from any location, with finer control set in the Security Group as needed.  

## C. SSH Access
### 1. Accessing the Bastion Host  
   - Use the Public IP.  

### 2. Upload the PEM File  
   - To access instances in the private subnet, the `.pem` file of the private subnet instance is required on the Bastion Host.  

### 3. SSH into the Private Subnet  
   ```bash
   $ ssh -i “plura.pem” ec2-user@172.31.20.117
   ```

![22](https://github.com/user-attachments/assets/c76591b9-caf7-474d-9445-3d7e8425ff34)

# Purpose of Operating a Bastion Host

![33-1](https://github.com/user-attachments/assets/c3f207b3-abf3-4abb-b44f-72d750646247)

The image above shows detection of approximately 11,000 login failures on a public server in one day. Public servers typically face tens of thousands of account compromise attempts daily. Even with firewall management, monitoring each server is challenging, and controlling all IP addresses can leave security gaps.

Operating a Bastion Host simplifies the management of access logs for private instances, consolidating and controlling them in one place. Crucially, the Bastion Host is the sole source of SSH traffic to the Linux instances.

![44-1](https://github.com/user-attachments/assets/07a841a2-7b47-48c7-b254-d244842407ad)

Additionally, PLURA detects successful key-based logins and provides filtered logs showing IP addresses, creation dates, and other details of access to private instances.

## References
- [How to Record SSH Sessions Through a Bastion Host](https://aws.amazon.com/ko/blogs/security/how-to-record-ssh-sessions-established-through-a-bastion-host/)  
- [Bastion Host Configuration Guide](https://galid1.tistory.com/365)  
- [Terraform Bastion Module](https://registry.terraform.io/modules/Guimove/bastion/aws/latest)  
