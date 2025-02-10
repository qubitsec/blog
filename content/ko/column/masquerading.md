---
date: 2025-02-10T16:32:00
draft: false
description: 
featured_image: "cdn/column/masquerading.png"
tags: ["Masquerading", "CyberThreats", "EndpointSecurity", "ThreatHunting", "EDR_Security"]
title: "복사된 시스템 파일, 보안 솔루션은 동일하게 볼까?"
---

### 🕵️‍♂️ 마스커레이딩(Masquerading), 보안 솔루션은 정상 파일과 악성 파일을 어떻게 구별할까요?

사이버 공격은 점점 더 정교해지고 있으며, 그중에서도 마스커레이딩(Masquerading) 기법은 보안 솔루션을 우회하는 데 매우 효과적인 방식입니다. 이 기술은 정상적인 시스템 파일을 악용해 보안 탐지를 피하면서 악성 코드를 실행하는 데 활용됩니다. 그렇다면, 보안 솔루션은 복사된 시스템 파일을 어떻게 처리할까요?

<!--more-->

---

### 1. 마스커레이딩(Masquerading)이란 무엇인가?

마스커레이딩은 공격자가 자신의 정체를 숨기거나 다른 사용자의 권한을 가장하는 기법으로, **보안 시스템을 우회**하거나 **민감한 정보를 탈취**하는 데 사용됩니다. 이때 주로 위장하는 파일은 **운영체제의 기본 실행 파일**이나 **신뢰할 수 있는 프로그램**입니다.

🕵️‍♂️ **주로 위장하는 파일 유형**

마스커레이딩에서 **가장 많이 사용되는 파일**은 다음과 같습니다.

✅ **1) 윈도우 시스템 파일 (Windows Native Executables)**

Windows에 기본 내장된 실행 파일(EXE)은 보안 솔루션의 신뢰도를 우회하는 데 자주 사용됩니다.

- `cmd.exe`: 명령 프롬프트 실행 파일.
- `powershell.exe: PowerShell`: 스크립트 실행 도구.
- `wscript.exe`: Windows Script Host 실행 파일.

✅ **2) 일반적인 소프트웨어 파일**

공격자는 사용자들이 자주 사용하는 소프트웨어를 위장하여 의심을 피하려고 합니다.

- `chrome.exe`
- `notepad.exe`
- `excel.exe`

---

### 2. 마스커레이딩을 위해 사용하는 우회 기법

공격자는 단순히 파일 이름을 바꾸는 것이 아니라, **다양한 기술을 사용하여 탐지를 우회**합니다.

✅ **1) 비정상적인 경로에서 실행**

`cmd.exe`, `powershell.exe`, `explorer.exe` 등의 Windows 시스템 파일을 정상적인 위치가 아닌 **비정상적인 경로**(예: C:\ProgramData\cmd.exe)에서 실행하면 보안 솔루션을 우회할 수 있습니다.

✅ **2) 확장자 변경 또는 숨김**

- `malware.exe` → `explorer.exe`
- `ransomware.exe` → `winword.exe`
- `.exe` 확장자를 `.scr`, `.com`, `.bat`로 변경하여 탐지를 우회.

✅ **3) 코드 서명 위조**

공격자는 **Microsoft, Google, Adobe** 등의 인증된 코드 서명을 위조하여 신뢰할 수 있는 프로그램처럼 보이게 만들 수 있습니다.

---

### 3. 마스커레이딩을 통한 시스템 파일 복사 및 악성 코드 실행

![powershell](https://github.com/user-attachments/assets/a51f5d37-80d4-4bdf-b098-221b45e6a167)

[사진 1] Powershell을 통해 cmd.exe를 비정상적인 경로로 복사


먼저, Powershell에서 아래의 명령어를 통해 cmd.exe를 비정상적인 경로로 복사를 합니다.

```powershell
copy-item "$env:windir\System32\cmd.exe" -destination "$env:allusersprofile\cmd.exe"
start-process "$env:allusersprofile\cmd.exe"
sleep -s 5 
stop-process -name "cmd" | out-null
```

![error](https://github.com/user-attachments/assets/1125b7bd-935b-4078-93a7-fe26963a0ec8)

[사진 2] 복사 후, 에러 메시지


복사된 cmd.exe를 실행할 경우, 위 [사진 2]와 같이 오류가 발생했습니다.

![path](https://github.com/user-attachments/assets/ceb66c65-75d5-4eda-b9df-05f1e3813143)

[사진 3] 다른 해결 방안 제시


ChatGPT의 다른 해결 방안으로 다국어 사용자 인터페이스 파일인 `.mui` 파일을 복사한 cmd.exe가 위치한 비정상적인 경로에 넣어주면 해결이 가능하다고 합니다.

![copy](https://github.com/user-attachments/assets/ed15570e-974c-4235-84bb-2652550927a7)

[사진 4]C:\Windows\System32 경로에 있는 ko-KR 폴더를 복사


`.mui` 파일이 포함되어 있는 C:\Windows\System32 경로에 있는 `ko-KR` 폴더를 복사합니다.

![paste](https://github.com/user-attachments/assets/c2cf32bf-be54-4aba-bdc8-28af5860edb2)

[사진 5] 복사된 ko-KR 폴더를 복사된 cmd.exe가 있는 비정상적인 경로에 붙여 넣기


복사한 `ko-KR` 폴더를 복사한 cmd.exe가 위치한 비정상적인 경로에 넣어줍니다.

![cmd](https://github.com/user-attachments/assets/3cfe7cd0-e794-46fb-b898-444b658a072e)

[사진 6] 에러 메시지 없이 정상적으로 cmd.exe가 실행


cmd.exe가 정상적으로 실행되는 것을 확인할 수 있습니다.

### 4. 보안 솔루션 탐지 여부 데모

데모에 사용된 악성 코드는 지난 블로그에서 설명드린 **프로세스 할로잉(Process Hollowing)** 기법을 사용하여 악성 코드를 제작 후, 사용했습니다.

- [**프로세스 할로잉 (Process Hollowing) 알아보기**](https://www.notion.so/18f63ad52448802086fccc8ec082da38?pvs=21)

![defender](https://github.com/user-attachments/assets/7479837c-3cd8-460c-a868-fa3fb65d2c8e)

[사진 7 Microsoft Defender 탐지


hollow_test.exe가 Microsoft Defender에서 탐지.

![defender_log](https://github.com/user-attachments/assets/bea524f9-3f8e-4ce4-9fe5-fb7aef02b01d)

[사진 8] Microsoft Defender 보호 기록 (Trojan:Win32/Bearfoos.A!ml 탐지)


Microsoft Defender에서 Trojan:Win32/Bearfoos.A!ml 분류로 격리된 것을 확인.

![alyac](https://github.com/user-attachments/assets/527b6e6b-1e52-4c7b-a581-8590c84a9cc1)

[사진 9] 알약의 실시간 감시로 탐지하지 못함


![fail01](https://github.com/user-attachments/assets/fa954303-9385-487f-89be-8c41507fdf39)

[사진 10] 빠른 검사로 탐지 되지 않음.


![alyac_detect](https://github.com/user-attachments/assets/3dc8b5f6-82df-473e-b315-f816f899d921)

[사진 11] 정밀 검사로 탐지 되는 것을 확인


![answer](https://github.com/user-attachments/assets/fe785e6e-a3f3-4dcf-ac4e-15f991bd541a)

[사진 12] 성능이 낮은 보안 솔루션 추천에 대한 답변


다른 보안 솔루션에서도 탐지가 되는지 확인을 위해서 ChatGPT에게 성능이 낮은 무료 보안 솔루션을 추천 받았습니다.

![comodo](https://github.com/user-attachments/assets/ec570264-2a0e-48bb-9501-1ae8bbf9f8bc)

[사진 13] Comodo Free Antivirus


![comodo_fail](https://github.com/user-attachments/assets/a46b3e4f-ee73-4425-9e6f-da1a81d0bbe0)

[사진 14] Comodo의 실시간 감시로 탐지하지 못함


![comodo_fail_2](https://github.com/user-attachments/assets/c8d97477-7256-4b85-9bdb-90c713c42464)

[사진 15] Comodo의 빠른 검사로 탐지하지 못함


![comodo_fail_3](https://github.com/user-attachments/assets/760ebe77-6d12-49f0-8c55-cfa6c0239c2b)

[사진 16] Comodo의 지정 폴더 검사로 탐지하지 못함


![360_total_security](https://github.com/user-attachments/assets/110e3dbd-303c-4ebe-ad7e-905553b2c50b)

[사진 17] 360 Total Security


![360_TotalSecurity_success](https://github.com/user-attachments/assets/a9ebc215-ba8a-43a3-8849-98708ca10f8e)

[사진 18] 360 Total Security의 실시간 감시로 탐지되는 것을 확인


### 4. 마스커레이딩은 보안 솔루션의 “허점”을 노리는 기법

마스커레이딩을 하는 이유는 다음과 같습니다.

1. **정적 분석을 우회하기 위해** → 서명 기반 탐지를 피할 가능성이 있음.
2. **보안 솔루션의 정책을 회피하기 위해** → 일부 환경에서는 cmd.exe의 실행 경로를 감지하지 않음.
3. **이벤트 로깅 및 분석을 우회하기 위해** → SIEM이 정상 프로세스로 오인할 가능성이 있음.
4. **행위 기반 탐지를 어렵게 만들기 위해** → 일부  환경에서 비정상적인 cmd.exe를 허용할 가능성이 있음.

하지만 **EDR이 활성화된 환경에서는 마스커레이딩을 사용해도 탐지를 피하기 어렵습니다.**

그래서 공격자들은 `PowerShell`, `rundll32.exe`, `mshta.exe`, `wmic.exe` 같은 **LOLBins(Living Off the Land Binaries)**를 활용하는 방식으로 추가적인 우회 기법을 결합하기도 합니다.

💡 **방어 전략**:

✅ **EDR(Endpoint Detection & Response) 솔루션 활용** → 비정상적인 프로세스 실행 감지

✅ **SIEM(Security Information & Event Management) 로그 분석** → 정상적인 실행 파일이 비정상 경로에서 실행되는지 모니터링

✅ **애플리케이션 화이트리스트 적용** → 실행 가능한 프로그램을 제한하여 공격 차단

💀 **공격자는 항상 새로운 위장 기법을 연구하기 때문에, 보안 솔루션도 지속적으로 업데이트해야 합니다.**

---

### 📖 **함께 읽기**

- [마스커레이딩(Masquerading)](https://attack.mitre.org/techniques/T1036/)
- [프로세스 할로잉(Process Hollowing)](https://attack.mitre.org/techniques/T1055/012/)
