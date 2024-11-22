---
date: 2023-03-15T00:00:00
description: 
featured_image: 
tags: 
title: "Kubernetes(k8s) with PLURA"
---

![blog-20230320-1](https://github.com/user-attachments/assets/2ea93b57-2e8a-42c2-93ba-cbd06f466a6e)

# 0. Overview

PLURA는 다음을 대상으로 로그를 생성/수집/분석하여 이상징후를 제공하는 통합 보안 이벤트 관리(SIEM) 서비스입니다.

> - 운영체제: 이벤트로그, syslog, auditlog  
> - 웹서버: 액세스 로그 (요청본문 & 응답본문 포함)  
> - 응용프로그램: 모든 종류의 TEXT 파일  
> - 네트워크제품: syslog  
> - 정보보호제품: syslog  

본 게시글은 Kubernetes 환경에서 PLURA를 이용하여 Container에서 생성되는 Application Log, Syslog, 그리고 Web Log의 수집 및 분석 방법을 안내합니다.

---

# 1. Precondition

본 게시글은 아래 내용을 다루지 않습니다.

- Controller
  - DaemonSet
  - StatefulSet
- Node-level logging
- PLURA Agent의 Container Image

쿠버네티스는 환경에 따라 다양한 구성을 가지며, 각 구성에 따라 설정이 달라집니다.  
따라서, 올바른 설정을 적용하려면 현재 환경과 구성을 파악하여 그에 맞는 설정을 해야 합니다.

---

# 2. Installation

1개의 Master-Node와 2개의 Worker-Node로 구성된 k8s 환경을 준비하고, 아래 그림과 같이 각각의 Worker-Node에 PLURA를 설치합니다.

![k8s_plura_drawio](https://github.com/user-attachments/assets/4b0d8714-dfd2-43e9-9651-1965d0c88de3)

![12](https://github.com/user-attachments/assets/4da3d45f-701f-4961-ab83-dba545d302d0)

![13](https://github.com/user-attachments/assets/a2b1e34f-2f47-4120-842a-ae4edcafe2d8)

---

# 3. k8s deployment example for Application Log

## nginx-deployment.yml

아래는 Application Log를 수집하며, worker-node에서 실행될 nginx 오브젝트의 구성 파일 예시입니다.

```yaml
apiVersion: apps/v1  # 쿠버네티스 api 버전
kind: Deployment    # 생성할 오브젝트 종류
metadata:
  name: nginx-deployment  # deployment의 이름
  labels:
    app: nginx           # label 지정
spec: 
  replicas: 3           # 3개의 pod 설정
  selector:             # deployment가 관리할 pod를 찾는 방법 정의
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:           # pod의 label
        app: nginx
    spec:
      containers:       # 컨테이너 설정
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80


해당 파일을 사용해 nginx를 배포할 경우, nginx의 access log 경로는 /var/log/containers이며 원본 경로는 /var/log/pods입니다.

![14](https://github.com/user-attachments/assets/da429c8c-6a09-4757-ab68-9ceec1714ed4)

오브젝트의 로그 경로는 구성 파일에서 재정의 할 수 있으며, PLURA의 Application Log를 이용하여 access log를 수집할 수 있습니다.

```

## PLURA
nginx의 access log를 응용 프로그램 원본 로그 수집 경로에 추가합니다.

![31](https://github.com/user-attachments/assets/585ac061-e01f-4dca-b9b5-c8502500ec88)

이제 worker-node에서 발생하는 nginx의 access log를 PLURA 응용프로그램로그에서 확인 할 수 있습니다.

![32](https://github.com/user-attachments/assets/68ab7bff-3994-4adb-baa8-d5e8e3d01bc0)



# 4. Kubernetes Deployment Example for Syslog

Syslog를 수집하기 위해서 필요한 항목과 순서는 다음과 같습니다.

1. Host와 Container의 `/var/log/plura` 디렉토리 공유
2. Worker Node에 PLC 설치(참고)
3. 각 pod에서 rsyslog 설치 및 rsyslog.conf 설정
4. PLC 설정

## internal ip 확인

각 pod 내부에 접속하여, 내부 ip를 확인합니다.

![pod_internal_ip](https://github.com/user-attachments/assets/4fc2be9c-8689-440a-9237-267c4a7d4e30)

## rsyslog.conf

rsyslog.conf 파일에서 kernel log 수집 모듈인 “imklog” 를 비활성화 하고, syslog를 전송받을 부모 서버의 내부 IP주소를 설정합니다.
```quote
…(생략)
#module(load=”imklog”) // kernel log 수집 모듈 비활성화
…(생략)
*.info @10.244.2.1
```

rsyslog service를 재시작 합니다.
```quote
# service rsyslog restart
```

worker node의 /var/log/plura 디렉토리에서 ceelog-{내부 ip}.log 파일 생성을 확인합니다.

![varlogplura_ceelog](https://github.com/user-attachments/assets/691fc6cc-2cb2-4edf-9e85-40d460bca0f3)


## PLURA
syslog를 전송하는 각 pod를 자식 서버로 등록합니다.

이제 worker-node의 각 pod에서 발생하는 syslog를 PLURA 시스템로그에서 확인 할 수 있습니다.

![k8s_plura_syslog-1024x435](https://github.com/user-attachments/assets/f29795f2-9ce7-4b58-8129-b4bf2bcbd406)


# 5. k8s deployment example for Web Log

Web Log를 수집하기 위해서 주의해야 할 항목은 다음과 같습니다.

1. Host와 Container의 ‘/var/log/plura’ 디렉토리 공유
2. 각 node에서 실행되는 nginx의 구성 파일 디렉토리에 plura.conf 복사(/etc/nginx/nginx.conf 참고)
3. modplura 설정

## plura_docker.yml

각 node는 Volume을 정의하는 부분에서 ‘/var/log/plura’를 선언하여 Host와 Container가 해당 디렉토리를 공유합니다.

아래는 worker-node에서 실행될 nginx 오브젝트의 구성 파일 예시입니다. 

```quote
apiVersion: apps/v1
kind: Deployment
metadata:
name: nginx-deployment
labels:
app: nginx
spec:
replicas: 3
selector:
matchLabels:
app: nginx
template:
metadata:
labels:
app: nginx
spec:
volumes:
– name: plura
hostPath:
path: /var/log/plura
containers:
– name: nginx
image: nginx:1.14.2
ports:
– containerPort: 80
volumeMounts:
– name: plura
mountPath: /var/log/plura
strategy:
type: RollingUpdate
rollingUpdate:
maxUnavailable: 1
```

## plura.conf
PLURA는 Web 의 Access log와 Post-body 수집을 위하여 nginx의 logformat을 재정의 합니다.

![plura_conf_nginx](https://github.com/user-attachments/assets/0219cf25-0000-4770-9045-bfec4ebb12e2)

해당 파일을 nginx conf 경로(/etc/nginx/conf.d)를 참고하여 각 worker node의 pod에 복사 하거나, nginx 오브젝트의 구성 파일(nginx-deployment.yml)에 등록합니다.

![plura_conf_nginx2](https://github.com/user-attachments/assets/b64b32eb-099b-49e2-a1c6-375b4b2eeaa3)

## PLURA

plura.conf를 통해 재정의된 nginx의 로그를 웹 로그 수집 경로에 추가합니다.

## 웹로그 수집 활성화
plura.io >
[시스템] > [시스템관리] > worker node > [설정] > 웹로그 수집 ‘On’ & ‘/var/log/plura/weblog.log’ 등록

![modplura_enable](https://github.com/user-attachments/assets/42fcd1f0-92bf-4602-a01d-91c0a251c18f)

이제 worker-node에서 발생하는 nginx의 access log를 PLURA 웹로그에서 확인 할 수 있습니다.

![k8s_plura_weblog-1024x514](https://github.com/user-attachments/assets/5ea8edb9-f159-4182-9ab2-b879be498b00)

# x. Environment Info
| Host	|OS|	Role|	IP(NAT)|	IP(Host-Only-Network)|
|---|---|---|---|---|
|k8s-master	|Rocky 8.6	|Master-Node	|172.16.14.89|	192.168.100.201|
|k8s-worker1|	Rocky 8.6	|Worker-Node-1|	172.16.14.90|	192.168.100.202|
|k8s-worker2	|Rocky 8.6|	Worker-Node-2|	172.16.14.91|	192.168.100.203|
* Kubernetes
  * Version: 1.26.2
  * CRI: containerd
  * CNI: flannel
