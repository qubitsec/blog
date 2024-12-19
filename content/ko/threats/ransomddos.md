---
date: 2017-08-18T00:03:00
draft: false
title: "협박성 디도스 공격, 랜섬디도스(RansomDDoS)"
description: 
featured_image: "cdn/threats/ransomddos-1.png"
tags: ["랜섬디도스", "디도스 공격", "보안", "네트워크 보안", "DDoS", "TCP Syn Flood", "HTTP Flood", "ICMP Flood"]
---

## 개요

랜섬웨어(Ransomware)에 이어 랜섬디도스(Ransom DDoS)가 기승을 부리고 있습니다.

> **비트코인 등 금전을 지불하지 않을 경우, 디도스 공격으로 기업의 IT 전산 인프라를 마비시켜 서비스 운영에 장애를 일으키겠다고 협박하는 것**입니다.  
> 카스퍼스키랩은 '2017년 2분기 디도스 리포트'에서 랜섬디도스를 주요 트렌드로 꼽았습니다.  
> 시스코 또한 '2017 중기 사이버보안 보고서'를 통해 협박성 디도스 공격이 전 세계적으로 증가하고 있다고 발표했습니다.

Dos 및 DDoS 공격은 **단 몇 줄의 명령으로도 대상 서버에 막대한 피해**를 줄 수 있는 매우 위협적인 공격입니다.  
이 문서에서는 **Dos와 DDoS의 개념, 공격 종류, 대응 방법**을 자세히 살펴보겠습니다.
<!--more-->
![ransomddos](https://blog.plura.io/cdn/threats/ransomddos-1.png)

## Dos와 DDoS의 개념

### Dos(Denial of Service)
- **서비스 거부 공격**으로 정상적인 서비스를 지연시키거나 마비시키는 해킹 공격입니다.
- 한 대의 PC가 다른 서버를 공격하는 **1:1 공격 구조**를 가집니다.

### DDoS(Distributed Denial of Service)
- **분산 서비스 거부 공격**으로 Dos 공격의 확장된 형태입니다.
- 다수의 PC가 하나의 서버를 공격하는 **N:1 공격 구조**를 가집니다.
- **C&C 서버**를 통해 공격자는 좀비 PC들을 원격으로 제어하며 특정 시스템에 동시다발적인 트래픽을 발생시킵니다.

![DDos_Attack](https://github.com/user-attachments/assets/7e3b5e3a-f8ef-49cc-aca9-4a94da692c59)

---

## DDoS 공격 종류

### 1. TCP Syn Flood
TCP의 3-way handshake 과정을 악용하여 서버의 연결 요청을 초과시키는 공격입니다.

#### **TCP 3-way handshake**
1. 클라이언트가 서버에 **SYN 패킷**을 전송합니다.
2. 서버는 클라이언트에 **SYN-ACK 패킷**으로 응답합니다.
3. 클라이언트가 서버에 **ACK 패킷**을 보내 연결이 완료됩니다.

#### **TCP Syn Flood 공격**
- 공격자는 대량의 **SYN 패킷**을 전송한 후 **ACK 패킷을 보내지 않습니다.**
- 서버는 **Half Open 상태**로 ACK 패킷을 기다리며, **Backlog Queue**가 가득 차면 더 이상 정상적인 연결을 처리하지 못합니다.

---

### 2. UDP Flood
UDP의 **비연결성 및 비신뢰성** 특성을 악용하여 대량의 UDP 패킷을 전송, 서버 자원을 소모시키는 공격입니다.

---

### 3. TearDrop
패킷 재조합 과정에서 **offset 값을 조작**하여 수신자가 패킷을 재조합하지 못하도록 방해하는 공격입니다.

---

### 4. ICMP Flood
#### 대표적 공격: Smurf 공격
- 공격자가 victim의 IP를 소스로 한 **ICMP request** 패킷을 브로드캐스트로 전송.
- 네트워크 내 모든 호스트가 **victim에 ICMP reply**를 전송하여 대량의 트래픽이 발생.

---

### 5. Ping of Death
정상적인 크기보다 큰 ICMP 패킷을 전송하여 패킷 재조합 시 서버 자원을 과도하게 소모시키는 공격입니다.

---

### 6. HTTP Flood
대량의 웹페이지 요청으로 웹 서버가 과부하 상태에 빠지게 하는 공격입니다.

---

### 7. Cache Control Attack
HTTP 헤더의 캐시 옵션을 조작하여 웹 서버에 부하를 가하는 공격입니다.
- **‘no-store’**: 캐시에 데이터를 저장하지 않고 매번 서버에 요청.
- **‘must-revalidate’**: 캐시에 저장된 데이터를 매번 검증하도록 설정.

---

## DDoS 공격 대응 방법

### TCP Syn Flooding 대응
1. **백로그 큐 크기 늘리기**
   ```bash
   sysctl -w net.ipv4.tcp_max_syn_backlog=1024
   ```
2. **Syncookie 활성화**
   ```bash
   sysctl -w net.ipv4.tcp_syncookies=1
   ```
3. **방화벽 PPS 임계치 설정**  
   IP당 SYN 요청 제한.

---

### UDP/ICMP Flooding 대응
- UDP/ICMP 트래픽 **DROP** 설정.
- **Null 라우팅**으로 공격 트래픽을 가상 인터페이스로 라우팅.
- 운영 장비에서 **Inbound 패킷 임계치** 설정.

---

### TearDrop 대응
- **운영체제 보안 패치** 적용.

---

### Smurf 공격 대응
- 네트워크 라우터에서 **IP 브로드캐스트 비활성화**.

---

### HTTP Flooding 대응
- 콘텐츠 요청 횟수에 **임계치 설정**.
- 일정 시간 내 설정된 임계치를 초과하는 요청 IP를 방화벽으로 차단.

---

### Cache Control Attack 대응
- L7 스위치를 이용해 HTTP 헤더에 특정 문자열을 포함한 IP 접속 차단.

---

## 공격 결과 모니터링

### TCP Syn Flooding
`netstat` 명령으로 SYN-RECV 상태를 확인:
```bash
netstat -antop | grep SYN-RECV
```

---

### UDP Flooding
`ping` 명령으로 응답 시간이 증가하는지 확인:
```bash
ping <IP 주소>
```

---

### HTTP Flooding
`access_log`에서 동일 IP의 대량 요청 확인:
```bash
tail -f /var/log/apache2/access_log
```

---

### PLURA로 랜섬 DDoS 대응하기

랜섬 DDoS 공격은 네트워크와 웹 애플리케이션에 심각한 영향을 미칠 수 있습니다. PLURA는 통합 보안 플랫폼으로서, 다양한 랜섬 DDoS 공격에 효과적으로 대응할 수 있는 솔루션을 제공합니다.

#### **1. PLURA-WAF로 웹 기반 DDoS 공격 차단**
- **PLURA-WAF**는 네트워크 레벨에서 웹 애플리케이션에 대한 DDoS 공격을 일부 차단합니다.
- HTTP Flood, Cache Control Attack 등의 웹 DDoS 공격을 탐지하고 악의적인 요청을 차단하여 애플리케이션의 가용성을 유지합니다.

#### **2. PLURA-EDR로 랜섬웨어 설치 탐지 및 차단**
- **PLURA-EDR**은 랜섬웨어의 설치 및 실행을 탐지하여 차단합니다.
- 공격자가 DDoS와 함께 랜섬웨어를 배포하려는 시도를 방지하고, 호스트를 안전하게 보호합니다.

#### **3. PLURA-SIEM의 상관 분석으로 정교한 대응**
- **PLURA-SIEM**은 다양한 로그와 데이터를 통합하여 상관 분석을 수행합니다.
- 네트워크와 애플리케이션에서 발생하는 비정상적인 트래픽 패턴, 랜섬웨어 탐지, 공격 시도 등을 상관 분석하여 실시간 대응 전략을 제안합니다.
- 분석 결과를 기반으로 즉각적인 방어 조치를 실행하며, 사후 대응을 위한 자세한 인사이트를 제공합니다.


**PLURA는 WAF, EDR, SIEM의 강력한 통합 솔루션으로 랜섬 DDoS 공격에 효과적으로 대응하여, 기업의 IT 인프라를 안전하게 보호합니다.**
---

