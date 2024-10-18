---
date: 2023-10-27
description: 
featured_image: 
tags: 
title: "[Windows] 공유폴더 취약점 대응"
---

### 개요
Windows는 관리 목적상 `ADMIN$`, `C$`, `D$`, `IPC$`를 기본적으로 공유하도록 설정되어 있습니다.

- **C$ & D$**: C드라이브에 대한 관리 목적
- **ADMIN$**: 윈도우 설치 폴더에 접근하는 관리 목적
- **IPC$**: 네트워크의 프로세스와 응용 프로그램 간의 통신 및 관리에 사용되는 Windows 기반 컴퓨터의 특수 공유 폴더

IPC$ 공유 폴더의 경우 "null 세션 연결"이라고도 불리며, 익명 사용자가 도메인 계정 및 네트워크 공유의 이름을 열거하는 것과 같은 특정 작업을 수행할 수 있습니다.

적절한 구성과 보안이 이루어지지 않으면 악의적인 행위자가 이를 악용하여 무단 액세스를 얻거나 Windows 네트워크에 대한 공격을 실행할 수 있습니다.

> #### 널 세션(Null Session) 취약점 (CVE-2022-1117)
> **취약 버전**: Windows NT 4.0 및 이전 버전 / NetBIOS 프로토콜 사용 버전
> - 윈도우 서버에 IPC$를 통한 원격 접속 시, 패스워드를 Null로 설정하여 접속할 수 있는 취약점.
> - Null 세션을 허용할 경우, 인증 절차 없이 IPC에 연결하여 사용자 정보를 탈취하거나 레지스트리에 접근하는 행위가 가능합니다.

> #### MITER ATT&CK 원격 서비스: SMB/Windows 관리자 공유 [T1021.002]
> - IPC$ 공유 폴더는 정보 수집 도구를 사용하여 MITER ATT&CK의 일환으로 시스템에 접근할 수 있는 경로를 제공합니다.
> - IPC$ 취약점이 존재할 경우, 시스템 간 이동 및 원격으로 명령을 실행할 수 있는 경로를 제공할 수 있습니다.

이처럼 공유 폴더는 보안을 위해 공유 설정을 OFF 하는 것이 좋지만, 관리적인 필요성으로 사용하는 경우 적절한 대응 방법이 필요합니다.

### 대응 방법

#### **[공유 폴더를 사용하지 않는 경우]**

1. **관리적 공유 폴더 제거하기(C$, D$ 등)**
   - 위치: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters`
   - `AutoShareWks` 값을 `REG_DWORD` 타입의 0으로 변경합니다.

2. **Null 세션 제거하기(IPC$)**
   - IPC$ 공유(Null 세션 연결)는 익명 사용자가 도메인 계정 및 네트워크 공유 이름을 열거하는 등 특정 작업을 수행할 수 있습니다.
   - IPC$는 제거할 수 없으므로 Null 세션을 제거하는 방법을 사용합니다.
   - 위치: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\LSA`
   - `restrictanonymous` 값을 `REG_DWORD` 타입의 1로 변경합니다 (기본값은 0).

#### **[공유 폴더를 사용할 경우]**

1. **최신 보안 업데이트 및 패치 적용**
   - 운영 체제와 관련된 서비스 및 프로그램에 대한 보안 업데이트와 패치를 정기적으로 적용하여 취약점을 해결합니다.

2. **방화벽 구성**
   - 시스템에 방화벽을 설정하여 악의적인 액세스를 제한하고 보호합니다.

3. **사용자 및 권한 관리**
   - 사용자 계정 및 권한을 적절하게 관리하여 불필요한 액세스를 제한하고 안전한 환경을 유지합니다.

4. **보안 소프트웨어 사용**
   - 악의적인 활동을 탐지하고 차단할 수 있는 보안 소프트웨어를 설치하고 유지합니다.

또한, 취약점에 대한 상세 내용은 시스템 및 환경에 따라 다를 수 있습니다.

### References
- [Windows IPC$ null session 공유 폴더 관련 정보](https://learn.microsoft.com/ko-kr/troubleshoot/windows-server/networking/inter-process-communication-share-null-session)
- [MITER ATT&CK: 원격 서비스 SMB/Windows 관리자 공유](https://attack.mitre.org/techniques/T1021/002/)
- [CVE-2002-1117](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2002-1117)
- [보안 관련 추가 정보](https://doqtqu.tistory.com/225)
