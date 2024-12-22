---
date: 2020-12-30T00:00:00
draft: false
description: 
featured_image: "cdn/column/bastion_hosts-1.png"
tags: ["Bastion Host", "AWS", "VPC", "EC2", "보안", "Private Subnet"]
title: "Bastion Host 운영"
---

## Bastion Host란?

Bastion Host는 Public 네트워크에서 Private 네트워크에 대한 액세스를 제공하기 위한 목적을 가진 서버입니다.  
일반적으로 **Amazon VPC (Virtual Private Cloud)**의 Public Subnet에 위치한 Amazon EC2 인스턴스에서 실행됩니다.

- Linux 인스턴스는 Public Subnet에 연결된 Bastion Host를 통해 Private Subnet에 있는 리소스에 접근할 수 있습니다.  
- Bastion Host는 SSH 트래픽을 허용하며, Security Group을 통해 제어됩니다.

![bastion_host](https://blog.plura.io/cdn/column/bastion_hosts-1.png)
<!--more-->
---

다음 다이어그램은 Bastion Host를 통한 연결을 설명합니다:

![NM_diagram_061316_a](https://github.com/user-attachments/assets/0972fe30-7d5e-4e92-a1a5-81d603a1e4e0)

---

## Bastion Host 운영

### A. EC2 설정

#### 1. 인스턴스
1) **Bastion Host**
   - IP: Public IP 할당
   - Subnet: Public Subnet1에 배치

2) **WebServer Instance1**
   - IP: Public IP 없음
   - Subnet: Private Subnet1에 배치

![00](https://github.com/user-attachments/assets/abec3ff3-5c70-461e-be3d-a6c6de9db1b8)

---

#### 2. Security Group 설정
1) **Bastion Host**
   - **Type:** SSH  
   - **Source:** My IP (Bastion Host에 접속할 HostPC의 공인 IP를 지정)

2) **WebServer Instance1**
   - **Type:** SSH  
   - **Source:** Bastion Host의 Public Subnet에 할당된 IP 주소 지정

![11](https://github.com/user-attachments/assets/d8ebbe8a-1fcf-4256-8ede-49b746b4afa1)

---

### B. VPC 설정

#### 1. VPC
- **CIDR:** `172.31.0.0/16`

![55](https://github.com/user-attachments/assets/d27ef032-09be-41ca-8049-a8dc95e301b7)

---

#### 2. Subnet
- **Private Subnet:** `172.31.16.0/20`  
- **Public Subnet:** `172.31.0.0/20`

---

#### 3. Route Table
1) **Private Route Table**  
   - 로컬 네트워크 대역만 라우팅

2) **Public Route Table**  
   - 로컬 대역 외 트래픽은 인터넷 게이트웨이로 라우팅 (외부 통신 가능)

---

#### 4. Network ACL 설정
1) **Private Subnet ACL**  
   - Bastion Host에 대해서만 SSH 접속 허용

2) **Public Subnet ACL**  
   - 모든 소스에서 SSH 요청 허용 (필요시 Security Group에서 세부 제어)

---

### C. SSH 접속

1) **Bastion Host로 접속**  
   - Public IP 사용

2) **`pem` 파일 업로드**  
   - Bastion Host에서 Private Subnet의 Instance로 접속하려면 .pem 파일이 필요

3) **Private Subnet으로 SSH 접속**

```bash
$ ssh -i "plura.pem" ec2-user@172.31.20.117
```

![22](https://github.com/user-attachments/assets/c76591b9-caf7-474d-9445-3d7e8425ff34)

---

## Bastion Host 운영 목적

![33-1](https://github.com/user-attachments/assets/c3f207b3-abf3-4abb-b44f-72d750646247)

Public 서버 한 대에서 하루 동안 약 11,000건의 로그인 실패 탐지 사례입니다.  
Public 서버는 하루 수만~수십만 건의 계정 탈취 시도가 발생할 수 있습니다.

- 방화벽을 통해 관리하더라도 모든 IP를 통제하기 어려워 보안에 취약해질 수 있습니다.  
- **Bastion Host 운영 시, Private Instance의 액세스 로그를 한 곳에서 취합하여 관리가 용이합니다.**

**중요: Bastion Host는 Linux 인스턴스에 대한 유일한 SSH 트래픽 소스입니다.**

![44-1](https://github.com/user-attachments/assets/07a841a2-7b47-48c7-b254-d244842407ad)

PLURA는 공개키 로그인 성공 시, Private Instance로 액세스한 IP 주소 및 생성일을 필터링하여 탐지합니다.

---

### 📖 **함께 읽기**
- [AWS Bastion Host 사용 가이드](https://aws.amazon.com/ko/blogs/security/how-to-record-ssh-sessions-established-through-a-bastion-host/)  
- [Terraform Bastion Host 모듈](https://registry.terraform.io/modules/Guimove/bastion/aws/latest)  
- [Bastion Host 운영 방법](https://galid1.tistory.com/365)
