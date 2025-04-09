---
date: 2025-04-07
draft: false
title: "리눅스에서도 Sysmon을 사용해야 하는 이유!"
description: Sysmon은 eBPF 기반의 고급 보안 로깅 도구로, Linux 환경에서도 실시간 위협 탐지와 MITRE ATT&CK 연계를 통해 강력한 보안 가시성을 제공합니다.
featured_image: "cdn/respond/sysmon_linux.png"
tags: ["sysmon", "Linux 보안", "위협탐지", "eBPF", "MITRE ATT&CK", "PLURA"]
---

## **🚨 1. Sysmon이란 무엇인가?**

**Sysmon(System Monitor)은 Windows 및 Linux 환경에서 시스템 활동을 기록하고, 보안 탐지 및 위협 헌팅을 위한 중요한 정보를 제공하는 도구이다.**

<!--more-->

Microsoft에서 제공하는 Sysinternals Suite의 일부로, 보안 분석가들이 악성 활동을 탐지하는 데 필수적인 로그 데이터를 수집하는 역할을 한다.

하지만 여전히 많은 보안 운영자들은 **Sysmon이 Windows에서만 유용하다**고 생각하는데, 이는 **크나큰 착각**이다.

**Linux에서도 Sysmon은 강력한 보안 모니터링 및 위협 탐지를 가능하게 한다.**

![sysmon_linux](https://blog.plura.io/cdn/respond/sysmon_linux.png)


---


## **🔎 2. 왜 리눅스에서도 Sysmon을 사용해야 하는가?**

### **2-1. Linux Sysmon vs. Linux 로깅: 주요 차이점 비교**

**기존 Linux 로깅 시스템의 한계**

- Linux에는 `syslog`, `auditd`, `journald` 같은 기본 로깅 시스템이 있지만, **프로세스 실행 트래킹**, **파일 변경 감시**, **네트워크 연결 모니터링**을 종합적으로 제공하는 기능이 부족하다.
- `auditd`는 높은 수준의 커널 이벤트 로깅을 제공하지만, **설정이 어렵고, 분석이 복잡하며, 노이즈 로그가 많아 실시간 탐지에 불리**하다.

**Sysmon의 장점**

Sysmon은 **eBPF(Extended Berkeley Packet Filter)** 기반으로 동작하며, 커널 이벤트를 효과적으로 추적해 기존 보안 로깅 시스템보다 다음과 같은 이점을 제공한다.


| 기능 | 기존 Linux 로깅 (syslog/auditd) | Sysmon |
| --- | --- | --- |
| **프로세스 생성 로그 (ProcessCreate)** | 제한적 (`auditd` 설정 필요) | ✅ 강력한 프로세스 트래킹 가능 |
| **파일 생성 및 삭제 감시** | 가능하지만 설정 복잡 | ✅ 간편한 설정 |
| **네트워크 연결 로깅** | `netstat` 등으로 확인 가능 | ✅ 실시간 로깅 |
| **커널 모듈 로드 감지** | 제한적 (`dmesg` 사용) | ✅ 탐지 가능 |
| **Lateral Movement 탐지** | ❌ Auditd로는 어렵다 | ✅ Sysmon은 프로세스 및 네트워크 이벤트 연계 분석 가능 |
| **Noise Filtering (이벤트 필터링)** | ❌ 설정 없이 모든 이벤트 기록 | ✅ 유효한 이벤트만 필터링 가능 |

**즉, Sysmon은 커널에서 직접 데이터를 수집하고, JSON 형식의 가독성 높은 로그를 생성하며, 이벤트 필터링 기능을 통해 실질적인 위협 탐지가 가능하다.**



### ** 2-2. eBPF 기반 Sysmon이 강력한 이유**

🔹 **eBPF(Extended Berkeley Packet Filter)란?**

- 리눅스 커널에서 **네트워크 패킷 필터링 및 시스템 이벤트 감시를 최적화하는 기술**
- 보안 솔루션들이 eBPF를 활용하여 **오버헤드를 줄이면서 고급 탐지 기능을 제공**

🔹 **Sysmon은 eBPF를 활용하여 다음을 수행한다.**

✅ 네트워크 패킷 감시 (C2 서버 연결 탐지)

✅ 악성 프로세스 실행 감지 (랜섬웨어 실행 추적)

✅ 커널 모듈 로드 모니터링 (루트킷 탐지)

✅ 파일 변조 탐지 (데이터 유출 감시)

**즉, Sysmon은 리눅스 커널과 직접 연동하여 보다 정밀하고 효율적인 보안 로깅을 가능하게 한다.**




### **2-3. Sysmon for Linux의 주요 기능 (TID 매핑)**

Sysmon은 MITRE ATT&CK 프레임워크와 매핑되는 **중요한 이벤트 로깅 기능**을 제공한다.

| Sysmon 이벤트 | 설명 | 관련 MITRE ATT&CK TID |
| --- | --- | --- |
| **ProcessCreate** | 새로운 프로세스 실행 기록 | T1059 (Command and Scripting Interpreter) |
| **FileCreate** | 파일 생성 이벤트 감시 | T1203 (Exploitation for Client Execution) |
| **NetworkConnect** | 네트워크 연결 발생 시 로깅 | T1071 (Application Layer Protocol) |
| **ModuleLoad** | 커널 모듈 로딩 감지 | T1543.003 (Create or Modify System Process: Windows Service) |
| **ProcessTerminate** | 특정 프로세스 종료 감지 | T1489 (Service Stop) |

**이를 통해 Sysmon을 활용하면 리눅스에서도 보안 이벤트를 정밀하게 분석하고, 위협 탐지 정확도를 높일 수 있다.**


---


## **3. Sysmon for Linux를 활용한 실전 위협 탐지 시나리오**

### **3-1. 리눅스 서버에서 권한 상승(Sudo Exploit) 탐지**

**공격 시나리오**

- 공격자가 `wget`을 사용하여 악성 파일을 다운로드하고 실행하려 한다.
- Auditd는 `execve` 호출을 추적하지만, 설정이 복잡하며 **파일 실행 과정에서 어떤 네트워크 연결이 이루어졌는지 알기 어렵다.**
- Sysmon은 **프로세스 실행(`ProcessCreate`)과 네트워크 연결(`NetworkConnect`)을 한 번에 로깅**하여 악성 프로세스를 쉽게 탐지할 수 있다.

**Sysmon 탐지 규칙 예시 (YAML 구성)**

![sample01](https://github.com/user-attachments/assets/63908c7d-822c-409f-b314-b537e7b5f36b)



### **3-2. 리눅스에서 악성 네트워크 연결 탐지**

**공격 시나리오**

- 공격자가 **C2(Command & Control) 서버**와 연결하여 원격으로 악성 행위를 수행한다.
- Auditd는 네트워크 트래픽 감시 기능이 없어 이를 탐지하기 어렵다.
- Sysmon은 `NetworkConnect` 이벤트를 통해 **외부 C2 서버와의 연결을 실시간으로 감시**할 수 있다.

**Sysmon 탐지 규칙 예시 (YAML 구성)**

![sample02](https://github.com/user-attachments/assets/d8d79e81-3854-4530-aabb-b5776c658ad9)




### **3-3. Sysmon for Linux vs Auditd 비교표**

| 기능 | Auditd | Sysmon for Linux |
| --- | --- | --- |
| 설치 필요 여부 | 🚫 기본 내장 (`auditd` 서비스 활성화) | ✅ 별도 설치 필요 (`sysmon` 바이너리) |
| 프로세스 실행 감시 (`execve`) | ✅ 가능 | ✅ 가능 |
| 부모-자식 관계 추적 | ❌ 불가능 (개별 이벤트만 기록) | ✅ 가능 (`ProcessCreate` 이벤트) |
| 네트워크 활동 감시 | ❌ 제한적 (`syscall` 기반 감시 필요) | ✅ 가능 (`NetworkConnect` 이벤트) |
| 파일리스(Fileless) 공격 탐지 | ❌ 불가능 | ✅ 가능 (메모리 기반 실행 감지) |
| C2(Command & Control) 탐지 | ❌ 불가능 | ✅ 가능 (네트워크 연결 및 프로세스 연관 분석) |
| 파일 해시 출력 | ❌ 불가능 | ✅ 가능 ( `FileCreate`등) |
| 리소스 사용량 | ✅ 낮음 (커널 레벨 감시) | 🔶 다소 높은 편 (유저 공간에서 작동) |


---


## **4. 결론: 리눅스 보안 강화를 위한 필수 도구, Sysmon!**

**1. 보안 탐지 및 위협 헌팅 측면**

- Sysmon은 MITRE ATT&CK 프레임워크와 긴밀하게 연계되며, **권한 상승(T1548), 원격 코드 실행(T1059), 악성 프로세스 실행(T1203) 등의 공격 기법을 더 직관적으로 탐지**할 수 있다.

**2. 이벤트 필터링을 통한 보안 운영 최적화**

- Auditd는 **불필요한 이벤트까지 기록하여 노이즈가 많다.**
- Sysmon은 **필터링 기능(Event Filtering)을 제공하여 실제 위협 탐지 성능을 극대화**한다.

**3. SIEM 및 클라우드 환경과의 통합**

- Sysmon은 JSON 기반 로그를 생성하여 **Windows Sysmon, SIEM, XDR과 쉽게 연동 가능**하다.
- 클라우드 기반 서버 보호, 컨테이너 환경 보안에 최적화된 솔루션이다.

---

### **최종 선택: Sysmon이 적합한 환경**

✅ **SIEM과 연계하여 로그를 분석하는 환경**

✅ **네트워크 기반 공격 및 클라우드 환경까지 확장된 위협 헌팅이 필요한 환경**

✅ **운영의 단순화 및 효율적인 로그 관리가 요구되는 환경**

✅ **Windows, Linux 통합 보안 모니터링이 필요한 환경**

**즉, 실시간 위협 탐지와 보안 가시성을 높이기 위해서는 Sysmon이 적합한 솔루션이 될 수 있다.**

