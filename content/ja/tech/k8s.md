---
date: 2023-03-15T00:00:00
description: 
featured_image: 
tags: ["Kubernetes", "k8s", "PLURA", "로그 수집", "웹 로그", "syslog", "컨테이너 로그", "보안"]
title: "Kubernetes(k8s) with PLURA"
---

![blog-20230320-1](https://github.com/user-attachments/assets/2ea93b57-2e8a-42c2-93ba-cbd06f466a6e)

## 0. 개요

PLURA는 다음을 대상으로 **로그 생성/수집/분석 및 이상 징후 탐지**를 제공하는 통합 보안 이벤트 관리(SIEM) 서비스입니다.

> - 운영체제: 이벤트 로그, syslog, auditlog  
> - 웹서버: 액세스 로그 (요청 본문 & 응답 본문 포함)  
> - 응용프로그램: 모든 종류의 텍스트 파일  
> - 네트워크 제품: syslog  
> - 정보보호 제품: syslog  

이 문서는 **Kubernetes 환경**에서 PLURA를 사용하여 컨테이너에서 생성되는 **Application Log, Syslog, Web Log**의 수집 및 분석 방법을 안내합니다.

---

## 1. 전제 조건

본 문서에서 다루지 않는 내용:
- **컨트롤러**: DaemonSet, StatefulSet
- **Node-level logging**
- **PLURA Agent의 컨테이너 이미지**

Kubernetes는 환경에 따라 다양한 구성을 가질 수 있으며, 각 환경에 적합한 설정이 필요합니다.  
따라서, 본 문서는 일반적인 구성 사례를 기준으로 작성되었습니다.

---

## 2. 설치

1개의 Master-Node와 2개의 Worker-Node로 구성된 Kubernetes 환경에서, 각 Worker-Node에 PLURA를 설치합니다.

![k8s_plura_drawio](https://github.com/user-attachments/assets/4b0d8714-dfd2-43e9-9651-1965d0c88de3)

---

## 3. Kubernetes Application Log 수집 예제

### nginx-deployment.yml

다음은 Worker-Node에서 실행될 **nginx 오브젝트의 구성 파일**입니다.

```yaml
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
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

### 로그 경로

- nginx의 Access Log 경로: `/var/log/containers` (원본 경로: `/var/log/pods`)  
- **PLURA를 활용한 Application Log 수집**: 로그 경로를 구성 파일에서 재정의하여 수집 경로에 추가합니다.

![14](https://github.com/user-attachments/assets/da429c8c-6a09-4757-ab68-9ceec1714ed4)

### PLURA에서 로그 확인

nginx의 Access Log를 PLURA에 등록하고, Worker-Node에서 발생하는 로그를 PLURA 응용프로그램 로그에서 확인합니다.

![31](https://github.com/user-attachments/assets/585ac061-e01f-4dca-b9b5-c8502500ec88)  
![32](https://github.com/user-attachments/assets/68ab7bff-3994-4adb-baa8-d5e8e3d01bc0)

---

## 4. Kubernetes Syslog 수집 예제

### 필수 항목 및 순서

1. Host와 Container의 `/var/log/plura` 디렉토리 공유  
2. Worker Node에 PLC 설치  
3. 각 Pod에서 rsyslog 설치 및 `rsyslog.conf` 설정  
4. PLC 설정  

### 내부 IP 확인

각 Pod 내부에 접속하여 내부 IP를 확인합니다.

![pod_internal_ip](https://github.com/user-attachments/assets/4fc2be9c-8689-440a-9237-267c4a7d4e30)

### rsyslog.conf 설정

- **Kernel Log 비활성화** 및 **Syslog 전송 서버 IP 설정**:
```plaintext
... (생략)
# module(load="imklog") // Kernel Log 수집 모듈 비활성화
... (생략)
*.info @10.244.2.1
```

- rsyslog 서비스 재시작:
```bash
service rsyslog restart
```

Worker Node의 `/var/log/plura` 디렉토리에서 `ceelog-{내부 IP}.log` 파일 생성을 확인합니다.

![varlogplura_ceelog](https://github.com/user-attachments/assets/691fc6cc-2cb2-4edf-9e85-40d460bca0f3)

---

## 5. Kubernetes Web Log 수집 예제

### 주의사항

1. Host와 Container의 `/var/log/plura` 디렉토리 공유  
2. 각 Node에서 실행되는 nginx 구성 파일 디렉토리에 `plura.conf` 복사 (/etc/nginx/nginx.conf 참고)  
3. modplura 설정  

### plura_docker.yml

아래는 Worker Node에서 실행될 nginx 오브젝트 구성 파일 예시입니다.

```yaml
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
        - name: plura
          hostPath:
            path: /var/log/plura
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
          volumeMounts:
            - name: plura
              mountPath: /var/log/plura
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxUnavailable: 1
```

### PLURA에서 로그 활성화

- PLURA Web Log 수집 경로에 재정의된 nginx 로그 경로 추가: `/var/log/plura/weblog.log`
- Web Log 수집 활성화:  
  `PLURA.io > 시스템 관리 > Worker Node 설정 > 웹 로그 수집 On`

![modplura_enable](https://github.com/user-attachments/assets/42fcd1f0-92bf-4602-a01d-91c0a251c18f)

이제 Worker Node에서 발생하는 nginx의 Access Log를 PLURA 웹 로그에서 확인할 수 있습니다.

![k8s_plura_weblog-1024x514](https://github.com/user-attachments/assets/5ea8edb9-f159-4182-9ab2-b879be498b00)

---

## 환경 정보

| Host        | OS       | Role          | IP (NAT)      | IP (Host-Only-Network) |
|-------------|----------|---------------|----------------|-------------------------|
| k8s-master  | Rocky 8.6 | Master-Node   | 172.16.14.89   | 192.168.100.201         |
| k8s-worker1 | Rocky 8.6 | Worker-Node-1 | 172.16.14.90   | 192.168.100.202         |
| k8s-worker2 | Rocky 8.6 | Worker-Node-2 | 172.16.14.91   | 192.168.100.203         |

### Kubernetes 구성

- **Version**: 1.26.2  
- **CRI**: containerd  
- **CNI**: flannel  
