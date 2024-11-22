---
date: 2020-12-30T00:00:00
description: 
featured_image: 
tags: 
title: "Bastion Host 운영"
---

![terraformawsbastion-1](https://github.com/user-attachments/assets/15b39548-c2ed-43fe-86f4-e4335f39f88d)

# Bastion Host?
Public 네트워크에서 Private 네트워크에 대한 액세스를 제공하기 위한 목적을 가진 서버입니다.

Bastion Host는 일반적으로 Amazon VPC (Virtual Private Cloud)의 Public Subnet에 있는 Amazon EC2 인스턴스에서 실행됩니다.
Linux 인스턴스는 공개적으로 액세스할 수 없는 Subnet에 있으며,  Bastion Host를 실행하는 기본 EC2 인스턴스에 연결된 Security Group에 연결된 Security Group에서 SSH 액세스를 허용하는 Security Group으로 설정됩니다.
Bastion Host 사용자는 다음 다이어그램에 설명된대로, Bastion Host에 연결하여 Linux 인스턴스에 연결합니다.

![NM_diagram_061316_a](https://github.com/user-attachments/assets/0972fe30-7d5e-4e92-a1a5-81d603a1e4e0)

# Bastion Host 운영
## A. EC2
### 1. 인스턴스
1) Bastion Host
* IP: Public IP 할당
* Subnet: Public Subnet1에 배치

2) WebServer Instance1
* IP: Public IP 부여하지 않는다.
* Subnet: Private Subnet1에 배치
![00](https://github.com/user-attachments/assets/abec3ff3-5c70-461e-be3d-a6c6de9db1b8)

### 2. Security Group
1) Bastion Host
* Type: SSH
* Source: My IP를 지정하여 Bastion Host로 접속할 HostPC의 공인 IP를 지정해준다. (Bastion Host 접속 제어)

### 2) WebServer Instance1
* Type: SSH
* Source: Bastion Host의 Public Subnet에 할당된 IP를 입력한다.
![11](https://github.com/user-attachments/assets/d8ebbe8a-1fcf-4256-8ede-49b746b4afa1)

## B. VPC
### 1. VPC
* vpc: 172.31.0.0/16
![55](https://github.com/user-attachments/assets/d27ef032-09be-41ca-8049-a8dc95e301b7)

### 2. Subnet
* Private Subnet: 172.31.16.0/20
* Public Subnet: 172.31.0.0/20

### 3. RouteTable
1) Private RouteTable
– 로컬 네트워크 대역만 라우팅한다.
2) Public RouteTable
– 로컬 대역외의 트래픽은 인터넷 게이트웨이로 보내어 외부와의 통신이 가능하도록 한다.

### 4. ACL
1) PrivateSubnet ACL
– Bastion Host에 대해서만 SSH 접속을 허용하도록 설정
2) PublicSubnet ACL
– 어떤 곳에서든지 SSH 요청을 가능하도록 한 다음 SecurityGroup에서 필요시 더 세부설정을 한다.

## C. SSH 접속
### 1. Bastion Host로 접속
– Public IP 사용

### 2. pem 파일 업로드
– Bastion Host에서 Private Subnet의 Instance로 접속하기 위해서는 Private Subnet Instance의 .pem 파일이 필요하다

### 3. Private Subnet으로 ssh 접속
$ ssh -i “plura.pem” ec2-user@172.31.20.117
![22](https://github.com/user-attachments/assets/c76591b9-caf7-474d-9445-3d7e8425ff34)

# Bastion Host 운영 목적

![33-1](https://github.com/user-attachments/assets/c3f207b3-abf3-4abb-b44f-72d750646247)

Public 서버 1대에서 하루동안 발생된 로그인 실패 (약 11,000건) 탐지목록입니다. 이와 같이 Public서버는 보통 하루에 수만~수십만건의 계정 탈취 공격을 받습니다.
방화벽 장비를 통해 관리를 하더라도 서버별 확인하는 것은 어려울 수 있으며, 모든 IP 주소를 통제할 수 없기 때문에 보안에 취약해질 수 있습니다.

Bastion Host 운영 시, Private Instance에서 발생되는 계정 액세스 로그들을 한곳에서 취합 및 제어하기에 관리가 보다 용이해집니다.
중요한 것은 Bastion Host가 Linux 인스턴스에 대한 유일한 SSH 트래픽 소스라는 것입니다.

![44-1](https://github.com/user-attachments/assets/07a841a2-7b47-48c7-b254-d244842407ad)

또한, PLURA에서는 공개키 로그인 성공 시, 해당 로그 필터탐지 하여 Private Instance로 액세스한 IP 주소, 생성일 등 확인할 수 있습니다.

## 참조
* https://aws.amazon.com/ko/blogs/security/how-to-record-ssh-sessions-established-through-a-bastion-host/
* https://galid1.tistory.com/365
* https://registry.terraform.io/modules/Guimove/bastion/aws/latest



