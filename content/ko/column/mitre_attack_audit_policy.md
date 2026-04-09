---
title: "마이터 어택 관점에서 고급감사정책 활용: 2026년 실무 가이드"
date: 2026-04-09
draft: false
description: "Windows 고급감사정책을 MITRE ATT&CK 관점에서 다시 정리합니다. 이벤트 ID, auditpol, GPO, PowerShell 로깅, 추천 체크리스트까지 실무 중심으로 설명합니다."
featured_image: "cdn/column/mitre_attack_audit_policy.jpg"
tags: ["MITRE ATT&CK", "고급감사정책", "Windows Event Log", "Audit Policy", "PowerShell", "PLURA-XDR", "Security"]
---

🔍 **고급감사정책은 Windows 보안 로그를 ‘많이 남기는 기능’이 아니라, 공격 행위를 설명할 수 있게 만드는 최소한의 기록 체계입니다.**

오늘의 공격은 악성 파일 하나만으로 설명되지 않습니다.  
정상 계정 사용, PowerShell 실행, 원격 접속, 예약 작업 등록, 프로세스 생성과 같은 **정상 기능의 악용**이 더 흔합니다.

그래서 중요한 것은 단순 탐지가 아닙니다.  
**어떤 ATT&CK 기법이 어떤 로그로 남는지**, 그리고 **그 로그를 실제 운영 환경에서 어떻게 활성화할 것인지**입니다.

이 글에서는 Windows **고급감사정책(Advanced Audit Policy Configuration)** 을  
**MITRE ATT&CK 관점**에서 다시 정리합니다.

![고급감사정책 활용](https://blog.plura.io/cdn/column/mitre_attack_audit_policy.jpg)

<!--more-->

---

## 1. 왜 지금 다시 고급감사정책인가

Microsoft는 고급 감사 정책을 통해 기본 감사보다 더 세밀하게 하위 범주별 감사를 설정할 수 있도록 제공하며, Group Policy의 **Computer Configuration → Windows Settings → Security Settings → Advanced Audit Policy Configuration → System Audit Policies** 경로에서 관리하도록 안내합니다. 또한 고급 감사 정책이 기본 감사 정책에 의해 덮어써지지 않도록 주의해야 하며, 이런 충돌이 발생하면 **Event ID 4719**가 기록될 수 있습니다. 

문제는 많은 조직이 아직도  
- 로그인 성공/실패만 대충 남기고  
- 프로세스 생성은 끄고  
- PowerShell 로그는 비활성화한 채  
- “EDR이 있으니 충분하다”고 생각한다는 점입니다.

하지만 공격자는 이미 오래전부터  
**유효 계정(T1078)**, **PowerShell(T1059.001)**, **원격 서비스(T1021)**, **예약 작업(T1053.005)** 같은 기법을 활용해 왔습니다. MITRE ATT&CK도 이 기법들을 현재까지 핵심 기술로 유지하고 있습니다. 

즉, 고급감사정책은 오래된 기능이 아니라  
**LOTL 공격과 계정 기반 침해를 설명하는 데 여전히 가장 현실적인 기록 기반**입니다.

---

## 2. 핵심 원칙: “모든 로그”가 아니라 “설명 가능한 로그”

감사 정책의 목표는 로그를 무한히 늘리는 것이 아닙니다.  
핵심은 **ATT&CK 주요 기법을 추적할 수 있는 최소 로그 세트**를 확보하는 것입니다.

특히 실무에서 우선순위가 높은 것은 다음입니다.

- **로그온 / 로그온 실패**
- **특권 사용**
- **프로세스 생성**
- **계정 생성·변경·권한 그룹 추가**
- **예약 작업 / 서비스 설치**
- **PowerShell 스크립트 실행**
- **네트워크 연결 허용**
- **감사 정책 변경**

Microsoft 문서에서도 4624, 4625, 4688 같은 이벤트는 핵심적으로 다뤄지며, 모니터링 이벤트 목록에서도 프로세스 생성과 계정 관련 이벤트가 주요 관찰 대상으로 제시됩니다. 

---

## 3. MITRE ATT&CK 관점에서 꼭 봐야 할 감사 정책과 이벤트 ID

### 3-1. 유효 계정 사용: **T1078 Valid Accounts**

공격자는 탈취한 계정을 사용해 정상 로그인처럼 보이게 움직입니다.  
이 경우 가장 먼저 봐야 할 것은 **로그온 계열 이벤트**입니다.

주요 이벤트:
- **4624**: 성공한 로그온
- **4625**: 실패한 로그온
- **4648**: 명시적 자격 증명 사용 시도
- **4672**: 특수 권한이 할당된 로그온

Microsoft는 4624, 4625, 4648을 고급 감사 정책의 대표 예시로 제시하고 있습니다. ATT&CK의 T1078은 탈취한 기존 계정을 초기 침투, 지속성, 권한 상승, 회피에 사용할 수 있다고 설명합니다. 

실무 포인트:
- 동일 계정의 **짧은 시간 내 반복 실패(4625)** 후 성공(4624)
- 평소 사용하지 않던 서버에서의 관리자 로그온
- **4672**가 일반 사용자 워크스테이션에서 갑자기 발생
- **4648**이 `runas`, 배치, 스크립트 계열 프로세스와 함께 나타나는 경우

---

### 3-2. 명령 실행: **T1059 / T1059.001 PowerShell**

PowerShell은 여전히 가장 중요한 실행 기법 중 하나입니다. ATT&CK의 T1059.001은 PowerShell이 정보 수집과 코드 실행에 널리 악용된다고 설명합니다. Microsoft는 Script Block Logging을 활성화하면 처리되는 모든 스크립트 블록이 **Microsoft-Windows-PowerShell/Operational** 로그에 기록된다고 안내합니다. 

주요 로그:
- **4688**: `powershell.exe`, `pwsh.exe`, `cmd.exe`, `wscript.exe` 실행
- **PowerShell Operational 로그**: Script Block Logging, Module Logging, Transcription
- 필요 시 **Protected Event Logging** 적용

실무 포인트:
- `-enc`, `-nop`, `-w hidden` 같은 인자
- 사용자 문서 폴더·임시 폴더에서 시작된 PowerShell
- Office 문서, `mshta.exe`, `rundll32.exe`, `wscript.exe` 뒤따르는 PowerShell 실행
- 야간·비정상 계정 컨텍스트에서 발생하는 스크립트 실행

---

### 3-3. 원격 이동: **T1021 Remote Services**

ATT&CK의 T1021은 원격 연결을 허용하는 서비스에 유효 계정으로 로그인해 후속 행위를 수행하는 기법입니다. 이 범주는 RDP, SMB, WinRM, SSH 등 여러 원격 서비스로 확장됩니다. 

관련 로그:
- **4624 / 4625**: 원격 로그온 성공/실패
- **4648**: 명시적 자격 증명 사용
- **5156**: 허용된 네트워크 연결
- 필요 시 WinRM / TerminalServices Operational 로그 병행

실무 포인트:
- 서버 간 이례적인 계정 이동
- 관리자가 아닌 계정의 다수 서버 접근
- 새로 생성된 프로세스(4688) 직전 또는 직후의 원격 로그온
- **5156**와 프로세스 경로를 결합한 이상 네트워크 행위 확인

Microsoft는 **5156**을 Windows Filtering Platform이 연결을 허용할 때 기록하는 이벤트로 설명합니다. 

---

### 3-4. 지속성 확보: **T1053.005 Scheduled Task**

예약 작업은 침해 후 매우 자주 쓰이는 지속성 수단입니다. ATT&CK는 T1053.005에서 Windows Task Scheduler 남용을 명시적으로 설명합니다. Microsoft는 **4698**을 “새 예약 작업이 생성될 때마다” 기록되는 이벤트라고 설명합니다. 

주요 이벤트:
- **4698**: 예약 작업 생성
- **4688**: `schtasks.exe`, `powershell.exe`, `cmd.exe` 실행
- 경우에 따라 TaskScheduler Operational 로그 추가 확인

실무 포인트:
- `schtasks.exe /create` 직후 4698 발생
- SYSTEM 또는 고권한 계정으로 등록된 낯선 작업
- 작업 이름이 Windows 업데이트처럼 위장된 경우
- 로그인 직후 혹은 부팅 직후 실행되도록 설정된 항목

---

### 3-5. 계정 생성·권한 변경

공격자는 새 계정을 만들거나 기존 계정을 권한 그룹에 넣는 방식으로 지속성을 확보하기도 합니다. Microsoft는 **4720**을 사용자 계정 생성 이벤트로 설명합니다. 

실무에서 자주 보는 이벤트:
- **4720**: 사용자 계정 생성
- **4722**: 사용자 계정 사용
- **4728 / 4732**: 보안 그룹에 구성원 추가
- **4738**: 계정 변경
- **4672**: 고권한 계정 로그인 흔적

이 부분은 ATT&CK의 **Persistence**, **Privilege Escalation**, **Valid Accounts**와 자주 연결됩니다. 

---

## 4. 가장 먼저 켜야 할 추천 감사 정책 체크리스트

아래는 Windows 서버/클라이언트에서 우선 적용 가치가 높은 항목입니다.

### 권장 하위 범주
- **Logon**
- **Logoff** (선택)
- **Special Logon**
- **Audit Policy Change**
- **Process Creation**
- **User Account Management**
- **Security Group Management**
- **Other Object Access Events**  
- **Filtering Platform Connection**
- **Detailed File Share** (서버 성격에 따라 선택)
- **Credential Validation** (도메인 환경 우선)

### PowerShell 권장 항목
- **Script Block Logging**
- **Module Logging**
- **Transcription**
- **Protected Event Logging** (민감 스크립트 보호 목적)

PowerShell 문서는 Script Block Logging, Module Logging, Protected Event Logging을 모두 공식적으로 설명하며, 보호된 이벤트 로그는 공개키를 배포해 로그 내용을 암호화할 수 있다고 안내합니다. 

---

## 5. 실무 설정 예시: auditpol과 GPO

### 5-1. auditpol 예시

Microsoft는 `auditpol /set` 명령으로 시스템 감사 정책과 하위 범주를 직접 설정할 수 있도록 제공합니다. 

```powershell
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"Special Logon" /success:enable /failure:disable
auditpol /set /subcategory:"Process Creation" /success:enable /failure:disable
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
auditpol /set /subcategory:"Other Object Access Events" /success:enable /failure:enable
auditpol /set /subcategory:"Filtering Platform Connection" /success:enable /failure:disable
auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:enable
```

### 5-2. GPO 경로

고급 감사 정책의 기본 경로는 다음입니다. Microsoft 공식 문서도 동일 경로를 제시합니다. ([Microsoft Learn][1])

```text
Computer Configuration
 └ Windows Settings
   └ Security Settings
     └ Advanced Audit Policy Configuration
       └ System Audit Policies
```

### 5-3. 명령줄 포함 프로세스 생성 로그

**4688만 켜고 끝내면 부족합니다.**  
Microsoft는 프로세스 생성 이벤트에 명령줄을 포함하도록 별도 설정하는 절차를 안내하며, 이 설정은 현재 Intune/보안 베이스라인에서도 기본 활성화 항목으로 다뤄집니다. ([Microsoft Learn][2])

GPO 경로:

```text
Computer Configuration
 └ Policies
   └ Administrative Templates
     └ System
       └ Audit Process Creation
         └ Include command line in process creation events = Enabled
```

이 설정이 없으면 4688은 남아도,  
실제 분석에 필요한 **인자 정보**가 빠져 가치가 크게 떨어집니다.

---

## 6. PowerShell 로깅은 선택이 아니라 기본값이어야 합니다

PowerShell 문서는 Script Block Logging을 활성화하면 처리되는 모든 스크립트 블록이 이벤트 로그에 기록된다고 설명합니다. Module Logging은 선택한 모듈의 파이프라인 실행 이벤트를 기록하고, Protected Event Logging은 민감한 로그 내용을 암호화된 형태로 수집할 수 있게 합니다. ([Microsoft Learn][3])

권장 이유:

* 4688만으로는 난독화된 PowerShell 내용을 다 보기 어렵습니다.
* Script Block Logging은 실제 실행 스크립트의 복원에 큰 도움이 됩니다.
* 침해사고 후 포렌식에서 “무엇을 실행했는가”를 설명하기 쉬워집니다.

권장 구성:

1. Script Block Logging
2. Module Logging
3. Transcription
4. Protected Event Logging

---

## 7. 운영 시 주의할 점

### 7-1. 로그를 너무 많이 켜면 끝이 아니다

5156, 4688은 환경에 따라 로그량이 커질 수 있습니다. Microsoft도 프로세스 생성은 사용량에 따라 **중간~높은 볼륨**, 네트워크 연결 이벤트는 환경별 튜닝이 필요하다고 설명합니다. 따라서 모든 경고를 바로 알림화하기보다, **수집은 넓게 / 경보는 좁게**가 현실적입니다. ([Microsoft Learn][2])

### 7-2. 기본 감사 정책과 충돌하지 않게 해야 한다

고급 감사 정책을 썼는데 기본 감사 정책이 다시 덮어쓰면 운영자가 “왜 로그가 안 남지?”라는 상황을 겪게 됩니다. Microsoft는 이 충돌 가능성을 명시적으로 설명하고, 덮어쓰기 시 **4719**가 기록될 수 있다고 안내합니다. ([Microsoft Learn][2])

### 7-3. 로그는 남기는 것보다 연결하는 것이 중요하다

4624 하나만으로는 부족하고,  
**4624 → 4672 → 4688 → 5156 → 4698**처럼 이어 봐야 공격 흐름이 보입니다.

이 지점에서 SIEM, XDR, 포렌식 플랫폼의 가치가 생깁니다.

---

## 8. PLURA-XDR은 이 로그를 어떻게 다르게 활용하는가

기존 글처럼 제품 설명이 앞에 나오면 광고처럼 보입니다.  
중요한 것은 제품명이 아니라 **로그 활용 방식**입니다.

고급감사정책 로그의 한계는 보통 세 가지입니다.

1. 로그는 남는데 연결이 안 된다
2. 수집은 되는데 탐지 규칙이 약하다
3. 사고 후 설명이 어렵다

PLURA-XDR은 이 지점에서

* Windows 고급감사정책 로그
* 웹 요청/응답 로그
* 행위 기반 이벤트
* 대응 및 포렌식 흐름

을 하나의 분석 맥락으로 연결하는 데 초점을 둡니다.

특히 의미 있는 지점은 다음입니다.

* **계정 이벤트(4624/4625/4672)** 와 웹 로그인 이상 징후의 결합
* **4688 프로세스 생성** 과 LOLBAS/PowerShell 행위 분석의 결합
* **4698 예약 작업**, **4720 계정 생성**, **5156 네트워크 연결**을 침해 흐름으로 묶는 분석
* 탐지 이후 **포렌식과 대응**으로 이어지는 운영 구조

즉, 고급감사정책 로그는 PLURA-XDR의 보조 자료가 아니라,  
**해킹 사건을 설명하는 핵심 증거**가 됩니다.

---

## 9. 최소 권장 배포안

처음부터 모든 정책을 한 번에 켜기보다 아래 순서가 현실적입니다.

### 1단계: 반드시 켤 것

* Logon
* Special Logon
* Process Creation
* Audit Policy Change
* User Account Management
* Script Block Logging
* Include command line in process creation events

### 2단계: 서버/중요 자산 우선

* Security Group Management
* Other Object Access Events
* Filtering Platform Connection
* Scheduled Task 관련 추적

### 3단계: 고도화

* Module Logging
* Transcription
* Protected Event Logging
* 파일/공유/객체 접근 감사의 세분화

---

## ✍️ 결론

고급감사정책은 오래된 기능이 아닙니다.  
오히려 2026년에도 여전히 유효한 **Windows 공격 가시성의 출발점**입니다.

ATT&CK 기법은 멋진 분류표가 아니라  
실제 로그로 연결될 때 비로소 운영에 의미가 생깁니다.

* **T1078**은 4624/4625/4648/4672로
* **T1059.001**은 4688과 PowerShell 로그로
* **T1021**은 로그온과 네트워크 연결 이벤트로
* **T1053.005**는 4698과 프로세스 생성 이벤트로

구체화되어야 합니다. ([attack.mitre.org][4])

보안은 “탐지했다”에서 끝나지 않습니다.  
**무엇이, 어떻게, 어떤 계정으로, 어떤 프로세스를 통해, 어디까지 이어졌는지**를 설명할 수 있어야 합니다.

고급감사정책은 바로 그 설명의 시작점입니다.

---

## 📖 함께 읽기

* [MITRE ATT&CK 프레임워크에 대한 이해: 왜 LOLBAS와 LOLDrivers도 ATT&CK 관점으로 봐야 하는가](https://blog.plura.io/ko/column/mitre-attack-framework-understanding/)

---


[1]: https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/advanced-audit-policy-configuration?utm_source=chatgpt.com "Advanced Audit Policy Configuration settings"
[2]: https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/command-line-process-auditing?utm_source=chatgpt.com "Command line process auditing"
[3]: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logging_windows?view=powershell-7.6&utm_source=chatgpt.com "about_Logging_Windows - PowerShell"
[4]: https://attack.mitre.org/techniques/T1078/?utm_source=chatgpt.com "Valid Accounts, Technique T1078 - Enterprise"
