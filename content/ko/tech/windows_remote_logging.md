---
date: 2019-06-24T00:01:00
draft: false
title: "Windows Remote Logging"
description: 
featured_image: "cdn/tech/windows_remote_logging-1.png"
tags: ["Windows", "Remote Logging", "Windows Event Collector", "Active Directory", "로그 관리", "보안"]
---

Active Directory 환경에서 **Windows Event Collector(WEC)**를 구성하면 원격 이벤트 로그를 중앙에서 수집하고 관리할 수 있습니다.  
이 기능은 중앙 집중식 로그 관리 및 모니터링을 가능하게 하며, 조직의 보안 및 운영 효율성을 향상시킵니다.
<!--more-->
---

## 1. 이벤트 전달 및 수집을 위한 컴퓨터 구성

### 주요 고려사항

- **단방향 구독만 사용 가능**
  - 로그는 이벤트 소스에서 수집기로 한 방향으로만 전달됩니다.
  
- **방화벽 예외 설정 필요**
  - 각 시스템에서 원격 이벤트 로그 관리 기능에 대한 방화벽 예외를 추가해야 합니다.
  - HTTPS 프로토콜을 사용하는 경우, 해당 포트도 방화벽에서 열어야 합니다.

- **계정 권한 설정**
  - 각 시스템의 **Event Log Readers 그룹**에 관리자 권한이 있는 계정을 추가해야 합니다.

- **서비스팩 및 핫픽스**
  - Microsoft에서 권장하는 최신 서비스팩 및 핫픽스를 설치해야 오류를 방지할 수 있습니다.

### 구성 단계
1. **Windows Remote Management(WINRM) 활성화**
   ```bash
   winrm quickconfig
   ```

2. **수집기 시스템에서 로그 그룹 설정**
   - 수집기 서버에서 이벤트 로그를 저장하고 분석할 로그 그룹을 설정합니다.

3. **방화벽 규칙 활성화**
   - `윈도우 방화벽 고급 보안`에서 **원격 이벤트 로그 관리** 및 **HTTPS** 규칙을 활성화합니다.

4. **구독 설정**
   - 이벤트 뷰어(Event Viewer)에서 구독(Subscription)을 생성합니다.
   - 소스 컴퓨터에서 보내는 이벤트를 수집기 서버로 전달하도록 설정합니다.

**참고 자료:**  
- [Microsoft 공식 문서 - 컴퓨터 구성](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc748890(v=ws.11))

---

## 2. Windows Event Collector 사용 방법

Windows Event Collector를 활용하여 이벤트를 수집하려면 아래 단계를 따릅니다:

### 단계별 가이드

1. **수집기 서버에서 수집기 서비스 실행**
   ```bash
   wecutil qc
   ```

2. **이벤트 구독 설정**
   - 이벤트 뷰어(Event Viewer)를 열고, **구독(Subscription)** 섹션에서 새 구독을 생성합니다.
   - 소스 컴퓨터와 수집기 서버 간의 연결을 설정합니다.

3. **필터링 및 구독 조건 정의**
   - 특정 이벤트 ID, 소스, 또는 수준(Level)별로 필터를 설정하여 로그 데이터를 선별합니다.

4. **HTTPS 연결 설정(선택 사항)**
   - HTTPS 연결을 사용하려면, 인증서를 설치하고 수집기를 HTTPS를 통해 수신하도록 구성합니다.
   - 예:
     ```bash
     winrm create https
     ```

**참고 자료:**  
- [Microsoft 공식 문서 - 이벤트 수집기 사용법](https://docs.microsoft.com/ko-kr/windows/desktop/WEC/using-windows-event-collector)

---

## 3. Remote Logging의 장점

- **중앙 집중식 관리**
  - 분산된 여러 시스템의 로그를 한곳에서 관리할 수 있어 효율적입니다.

- **보안 강화**
  - 원격지에서 발생한 보안 이벤트를 실시간으로 수집하여 빠르게 대응할 수 있습니다.

- **분석 및 모니터링 용이**
  - 이벤트 데이터를 중앙에서 분석하고, 보안 위협이나 운영 문제를 모니터링할 수 있습니다.

---

## 4. 활용 사례

1. **보안 위협 탐지**
   - 공격자가 시스템에 로그인하려는 시도를 중앙에서 실시간으로 감지.

2. **컴플라이언스 준수**
   - GDPR, ISO 27001 등 규정에 따른 로그 데이터 관리 및 보관.

3. **운영 최적화**
   - 장애 발생 시 이벤트 로그를 통해 근본 원인을 빠르게 파악.

---

## 📖 함께 읽기

- [Microsoft 공식 문서 - Windows Event Forwarding](https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection)  
- [Windows Remote Management 가이드](https://docs.microsoft.com/en-us/windows/win32/winrm/portal)
