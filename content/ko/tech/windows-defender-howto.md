---
title: "PC와 서버에서 Windows Defender 사용하는 법"
date: 2026-06-27
draft: false
description: "Windows 10/11 PC와 Windows Server에서 Microsoft Defender Antivirus를 켜고, 점검하고, 검사하고, 업데이트하고, 로그를 확인하는 실무형 HowTo 매뉴얼입니다."
featured_image: "/cdn/tech/windows-defender-howto.png"
categories: ["tech"]
tags: ["Windows Defender", "Microsoft Defender Antivirus", "Windows Security", "Windows Server", "PowerShell", "Antivirus", "Endpoint Security", "EDR", "PLURA-EDR", "PLURA-XDR"]
---

## PC와 서버에서 Windows Defender 사용하는 법

Windows 환경에서는 별도 백신을 설치하지 않아도 기본적으로 **Windows Defender**, 정확히는 **Microsoft Defender Antivirus**를 사용할 수 있습니다.

개인 PC에서는 Windows 보안 앱을 통해 쉽게 설정할 수 있고, 서버에서는 PowerShell 명령으로 상태 확인, 검사 실행, 업데이트, 정책 설정을 자동화할 수 있습니다.

이번 글에서는 다음 항목을 실무 기준으로 정리합니다.

- PC에서 Windows Defender 상태 확인하기
- 빠른 검사, 전체 검사, 오프라인 검사 실행하기
- 실시간 보호, 클라우드 보호, 샘플 제출 설정하기
- Windows Server에서 Defender 설치 및 동작 확인하기
- PowerShell로 검사와 업데이트 실행하기
- 제외 경로 설정 시 주의할 점
- Defender 로그 확인 방법
- Defender와 EDR/XDR의 역할 구분

<!--more-->

---

## 1. Windows Defender와 Microsoft Defender Antivirus

예전에는 흔히 **Windows Defender**라고 불렀지만, 현재 Windows 10, Windows 11, Windows Server 환경에서는 **Microsoft Defender Antivirus**라는 이름으로 제공됩니다.

일반 사용자는 Windows 보안 앱에서 확인하고, 서버 운영자는 PowerShell이나 그룹 정책으로 관리하는 경우가 많습니다.

정리하면 다음과 같습니다.

| 구분 | 설명 |
|---|---|
| Windows 보안 | Windows에 포함된 보안 설정 앱 |
| Microsoft Defender Antivirus | 바이러스 및 악성코드 탐지/차단 기능 |
| Windows Defender Firewall | Windows 방화벽 |
| Microsoft Defender for Endpoint | 기업용 EDR/엔드포인트 보안 플랫폼 |

이 글에서는 주로 **Microsoft Defender Antivirus**, 즉 기본 백신 기능을 다룹니다.

Windows 보안 앱은 바이러스 및 위협 방지, 방화벽, Smart App Control 등을 포함하는 Windows 내장 보안 앱이며, Microsoft는 Defender Antivirus가 실시간 보호를 제공한다고 설명합니다.

참고: [Windows Security app - Microsoft Support](https://support.microsoft.com/en-us/windows/stay-protected-with-the-windows-security-app-2ae0363d-0ada-c064-8b56-6a39afb6a963)

---

## 2. PC에서 Windows Defender 상태 확인하기

Windows 10/11 PC에서는 먼저 Defender가 켜져 있는지 확인해야 합니다.

### 2-1. Windows 보안 앱 열기

아래 순서로 이동합니다.

```text
시작
→ 설정
→ Windows 보안
→ 바이러스 및 위협 방지
```

Windows 10에서는 다음 경로로 보일 수 있습니다.

```text
시작
→ 설정
→ 업데이트 및 보안
→ Windows 보안
→ 바이러스 및 위협 방지
```

여기서 다음 항목을 확인합니다.

- 현재 위협
- 바이러스 및 위협 방지 설정
- 보호 업데이트
- 랜섬웨어 방지
- 보호 기록

---

## 3. PC에서 바이러스 검사 실행하기

Windows Defender 검사는 상황에 따라 다르게 실행합니다.

### 3-1. 빠른 검사

일반적인 점검은 **빠른 검사**로 시작합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 빠른 검사
```

빠른 검사는 자주 악성코드가 숨어드는 주요 위치를 검사합니다. PC가 느려졌거나, 의심 파일을 다운로드했거나, 기본 점검이 필요할 때 먼저 실행합니다.

### 3-2. 전체 검사

PC 전체를 점검하려면 **전체 검사**를 실행합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 검사 옵션
→ 전체 검사
→ 지금 검사
```

전체 검사는 시간이 오래 걸릴 수 있으므로 업무 중보다는 점심시간, 퇴근 후, 유지보수 시간에 실행하는 것이 좋습니다.

### 3-3. 사용자 지정 검사

특정 폴더나 드라이브만 검사할 수도 있습니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 검사 옵션
→ 사용자 지정 검사
→ 지금 검사
```

예를 들어 다음 위치를 검사할 때 유용합니다.

```text
다운로드 폴더
USB 드라이브
압축 해제한 설치 파일 폴더
공유 폴더
의심 파일이 저장된 경로
```

### 3-4. Microsoft Defender 오프라인 검사

악성코드가 실행 중인 Windows 환경 안에서 자신을 숨기는 경우가 있습니다. 이때는 **Microsoft Defender 오프라인 검사**를 사용할 수 있습니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 검사 옵션
→ Microsoft Defender 오프라인 검사
→ 지금 검사
```

오프라인 검사를 실행하면 PC가 재시작됩니다. 따라서 실행 전에는 열려 있는 문서를 저장해야 합니다.

Microsoft는 오프라인 검사를 실행하면 PC가 다시 시작된 뒤 Windows 외부 환경에서 검사를 진행한다고 안내합니다.

참고: [Troubleshoot problems with detecting and removing malware - Microsoft Support](https://support.microsoft.com/en-us/defender/troubleshoot-problems-with-detecting-and-removing-malware)

---

## 4. PC에서 권장 설정 확인하기

Defender는 켜져 있는 것만으로 끝나지 않습니다. 아래 설정을 함께 확인해야 합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 바이러스 및 위협 방지 설정
→ 설정 관리
```

### 4-1. 실시간 보호

**실시간 보호**는 반드시 켜두는 것이 좋습니다.

```text
실시간 보호: 켬
```

실시간 보호가 꺼져 있으면 열거나 다운로드하는 파일이 즉시 검사되지 않을 수 있습니다.

Microsoft도 실시간 보호를 일시적으로 끌 수는 있지만, 꺼져 있는 동안 파일이 위협으로부터 검사되지 않아 장치가 취약해질 수 있다고 안내합니다.

참고: [Virus and threat protection in the Windows Security app - Microsoft Support](https://support.microsoft.com/en-au/windows/virus-and-threat-protection-in-the-windows-security-app-1362f4cd-d71a-b52a-0b66-c2820032b65e)

### 4-2. 클라우드 제공 보호

```text
클라우드 제공 보호: 켬
```

클라우드 제공 보호는 새롭거나 의심스러운 파일에 대해 Microsoft 보안 인텔리전스를 활용해 더 빠르게 판단하도록 돕습니다.

Microsoft는 클라우드 기반 보호와 자동 샘플 제출을 켜도록 안내하고 있습니다.

참고: [Troubleshoot problems with detecting and removing malware - Microsoft Support](https://support.microsoft.com/en-us/defender/troubleshoot-problems-with-detecting-and-removing-malware)

### 4-3. 자동 샘플 제출

```text
자동 샘플 제출: 켬
```

의심 파일 분석에 도움을 주는 기능입니다. 기업 환경에서는 개인정보, 내부 문서, 규정 준수 이슈가 있을 수 있으므로 조직 정책에 맞게 설정해야 합니다.

### 4-4. 변조 방지

```text
변조 방지: 켬
```

변조 방지는 악성코드나 공격자가 Defender 설정을 임의로 끄지 못하도록 돕는 기능입니다.

단, 이 기능이 켜져 있으면 일부 설정 변경이 제한될 수 있습니다. Microsoft는 변조 방지가 켜져 있을 경우 그룹 정책으로 변조 방지를 끌 수 없고, 변조 방지 대상 설정 변경이 무시될 수 있다고 설명합니다.

참고: [Use Group Policy to configure Microsoft Defender Antivirus - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/use-group-policy-microsoft-defender-antivirus)

---

## 5. 랜섬웨어 방지 설정하기

Windows Defender에는 **제어된 폴더 액세스** 기능이 있습니다. 영문으로는 **Controlled Folder Access, CFA**라고 합니다.

이 기능은 신뢰되지 않은 앱이 보호 폴더 안의 파일을 변경하지 못하도록 막아 랜섬웨어 피해를 줄이는 데 도움을 줍니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 랜섬웨어 방지 관리
→ 제어된 폴더 액세스
→ 켬
```

보호 대상 폴더에는 문서, 사진, 바탕 화면 등 주요 폴더가 포함될 수 있습니다. 업무 프로그램이 파일을 저장하지 못하는 문제가 생기면 허용된 앱으로 등록해야 합니다.

Microsoft는 제어된 폴더 액세스가 신뢰된 앱만 보호 폴더를 변경하도록 허용해 랜섬웨어 같은 위협으로부터 중요한 데이터를 보호한다고 설명합니다.

참고: [Controlled folder access overview - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/controlled-folder-access-overview)

### PowerShell로 설정하기

관리자 권한 PowerShell에서 다음 명령을 실행합니다.

```powershell
Set-MpPreference -EnableControlledFolderAccess Enabled
```

업무 프로그램 영향도를 먼저 확인하려면 감사 모드로 시작할 수 있습니다.

```powershell
Set-MpPreference -EnableControlledFolderAccess AuditMode
```

업무 영향이 없다고 판단되면 차단 모드로 전환합니다.

```powershell
Set-MpPreference -EnableControlledFolderAccess Enabled
```

특정 프로그램을 허용해야 하는 경우 다음과 같이 등록합니다.

```powershell
Add-MpPreference -ControlledFolderAccessAllowedApplications "C:\Program Files\App\App.exe"
```

---

## 6. 보호 업데이트 확인하기

백신은 엔진과 보안 인텔리전스가 최신이어야 의미가 있습니다.

PC에서는 다음 경로에서 업데이트를 확인합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 보호 업데이트
→ 업데이트 확인
```

Microsoft는 새로운 악성코드와 공격 기법으로부터 장치를 보호하려면 Microsoft Defender Antivirus를 최신 상태로 유지하는 것이 중요하다고 안내합니다.

참고: [Microsoft Defender Antivirus security intelligence and product updates - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-updates)

PowerShell에서는 다음 명령을 사용합니다.

```powershell
Update-MpSignature
```

현재 엔진과 시그니처 정보를 확인하려면 다음 명령을 실행합니다.

```powershell
Get-MpComputerStatus |
Select-Object AMProductVersion, AMEngineVersion, AntivirusSignatureVersion, AntivirusSignatureLastUpdated
```

---

## 7. Windows Server에서 Defender 사용하기

서버에서는 GUI보다 PowerShell로 확인하는 것이 일반적입니다.

Microsoft Defender Antivirus는 Windows Server 2016 이상, Windows Server 버전 1803 이상, Azure Stack HCI OS 23H2 이상 등을 지원하며, Windows Server 2012 R2는 Microsoft Defender for Endpoint 조건이 필요합니다.

참고: [Microsoft Defender Antivirus on Windows Server - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-on-windows-server)

### 7-1. Defender 설치 여부 확인

관리자 권한 PowerShell을 실행합니다.

```powershell
Get-Service -Name WinDefend
```

정상이라면 `Status`가 `Running`으로 표시됩니다.

```text
Status   Name       DisplayName
------   ----       -----------
Running  WinDefend  Microsoft Defender Antivirus Service
```

명령 프롬프트에서는 다음 명령도 사용할 수 있습니다.

```cmd
sc query WinDefend
```

Microsoft 공식 문서도 Windows Server에서 Defender가 실행 중인지 확인하는 방법으로 `Get-Service -Name windefend`와 `sc query Windefend`를 안내합니다.

참고: [Microsoft Defender Antivirus on Windows Server - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-on-windows-server)

### 7-2. Defender 설치 또는 재설치

Defender가 제거되어 있거나 설치되어 있지 않다면 다음 명령으로 설치할 수 있습니다.

```powershell
Install-WindowsFeature -Name Windows-Defender
```

GUI가 필요한 서버 환경에서는 서버 관리자 또는 역할 및 기능 추가 마법사에서 Windows Defender 관련 GUI 옵션을 확인합니다.

Microsoft는 Windows Server에서 PowerShell을 통해 `Install-WindowsFeature -Name Windows-Defender` 명령으로 Microsoft Defender Antivirus를 설치할 수 있다고 안내합니다.

---

## 8. 서버에서 Defender 상태 점검하기

서버에서는 다음 명령으로 Defender 상태를 확인합니다.

```powershell
Get-MpComputerStatus
```

운영자가 자주 확인할 항목만 추려서 보려면 다음과 같이 실행합니다.

```powershell
Get-MpComputerStatus |
Select-Object AMRunningMode,
              AMServiceEnabled,
              AntivirusEnabled,
              RealTimeProtectionEnabled,
              IoavProtectionEnabled,
              AntispywareEnabled,
              AntivirusSignatureVersion,
              AntivirusSignatureLastUpdated
```

확인해야 할 값은 다음과 같습니다.

| 항목 | 확인 기준 |
|---|---|
| AMRunningMode | Normal 또는 정책에 맞는 상태 |
| AMServiceEnabled | True |
| AntivirusEnabled | True |
| RealTimeProtectionEnabled | True |
| IoavProtectionEnabled | True |
| AntivirusSignatureLastUpdated | 최신 날짜 |

Microsoft는 Defender PowerShell cmdlet으로 `Get-MpComputerStatus`, `Set-MpPreference`, `Update-MpSignature`, `Start-MpScan`, `Get-MpThreat` 또는 `Get-MpThreatDetection` 등을 사용할 수 있다고 안내합니다.

참고: [Use PowerShell cmdlets to configure and run Microsoft Defender Antivirus - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/use-powershell-cmdlets-microsoft-defender-antivirus)

---

## 9. 서버에서 검사 실행하기

서버에서 검사를 실행할 때는 서비스 영향도를 고려해야 합니다.

### 9-1. 빠른 검사

```powershell
Start-MpScan -ScanType QuickScan
```

### 9-2. 전체 검사

```powershell
Start-MpScan -ScanType FullScan
```

전체 검사는 디스크 I/O와 CPU 사용량에 영향을 줄 수 있습니다. 운영 서버에서는 업무 피크 시간대를 피해서 실행하는 것이 좋습니다.

### 9-3. 특정 경로 검사

```powershell
Start-MpScan -ScanType CustomScan -ScanPath "D:\Upload"
```

예를 들어 웹 서버라면 다음 경로를 우선 점검할 수 있습니다.

```text
웹 업로드 디렉터리
임시 파일 디렉터리
배포 파일 디렉터리
공유 폴더
사용자 업로드 저장소
```

---

## 10. 서버에서 예약 검사 설정하기

서버는 정기적인 예약 검사를 설정해 두는 것이 좋습니다.

### 10-1. 매일 빠른 검사 설정

예를 들어 매일 낮 12시 30분에 빠른 검사를 실행하려면 다음과 같이 설정합니다.

```powershell
Set-MpPreference `
  -ScanScheduleQuickScanTime 12:30:00 `
  -ScanScheduleOffset 0 `
  -RandomizeScheduleTaskTimes $false `
  -ScanOnlyIfIdleEnabled $false
```

### 10-2. 매주 전체 검사 설정

예를 들어 매주 수요일 12시 30분에 전체 검사를 실행하려면 다음과 같이 설정합니다.

```powershell
Set-MpPreference `
  -ScanParameters FullScan `
  -ScanScheduleDay Wednesday `
  -ScanScheduleTime 12:30:00 `
  -ScanScheduleOffset 0 `
  -RandomizeScheduleTaskTimes $false
```

Microsoft는 예약 검사 설정에 `Set-MpPreference`를 사용하며, `ScanParameters`는 `QuickScan` 또는 `FullScan`, `ScanScheduleDay`는 요일, `ScanScheduleTime`은 로컬 컴퓨터 기준 시간으로 지정한다고 설명합니다.

참고: [Schedule Microsoft Defender Antivirus scans using PowerShell - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/schedule-antivirus-scans-powershell)

---

## 11. 서버에서 권장 보호 설정 적용하기

관리자 권한 PowerShell에서 다음 설정을 확인하거나 적용할 수 있습니다.

### 11-1. 실시간 보호 켜기

```powershell
Set-MpPreference -DisableRealtimeMonitoring $false
```

### 11-2. 행위 모니터링 켜기

```powershell
Set-MpPreference -DisableBehaviorMonitoring $false
```

### 11-3. 스크립트 검사 켜기

```powershell
Set-MpPreference -DisableScriptScanning $false
```

### 11-4. 다운로드 파일 및 첨부 파일 검사 켜기

```powershell
Set-MpPreference -DisableIOAVProtection $false
```

### 11-5. 클라우드 보호 켜기

```powershell
Set-MpPreference -MAPSReporting Advanced
```

### 11-6. PUA 보호 켜기

PUA는 Potentially Unwanted Application의 약자로, 명확한 악성코드는 아니지만 광고 프로그램, 불필요한 툴바, 원치 않는 설치 프로그램처럼 업무 환경에 불필요하거나 위험할 수 있는 앱을 의미합니다.

```powershell
Set-MpPreference -PUAProtection Enabled
```

Microsoft의 PowerShell 평가 가이드도 클라우드 보호, 실시간 보호, 행위 모니터링, 스크립트 검사, PUA 보호 등을 `Set-MpPreference`로 설정하는 예시를 제공합니다.

참고: [Evaluate Microsoft Defender Antivirus using PowerShell - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-using-powershell)

---

## 12. 제외 경로 설정하기

업무 서버에서는 Defender 검사 때문에 특정 애플리케이션 성능 문제가 발생할 수 있습니다.

이때 무조건 Defender를 끄기보다는 필요한 경로만 제한적으로 제외하는 것이 좋습니다.

### 12-1. 제외 경로 추가

```powershell
Add-MpPreference -ExclusionPath "D:\App\Data"
```

### 12-2. 제외 프로세스 추가

```powershell
Add-MpPreference -ExclusionProcess "backup.exe"
```

### 12-3. 제외 확장자 추가

```powershell
Add-MpPreference -ExclusionExtension ".log"
```

### 12-4. 제외 목록 확인

```powershell
Get-MpPreference |
Select-Object ExclusionPath, ExclusionProcess, ExclusionExtension
```

### 12-5. 제외 경로 제거

```powershell
Remove-MpPreference -ExclusionPath "D:\App\Data"
```

Microsoft는 `Add-MpPreference`로 제외 경로, 제외 확장자, 제외 프로세스를 추가할 수 있으며, 예를 들어 `Add-MpPreference -ExclusionPath 'C:\Temp'` 명령은 해당 폴더를 예약 검사와 실시간 검사에서 제외한다고 설명합니다.

참고: [Add-MpPreference - Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/defender/add-mppreference?view=windowsserver2025-ps)

### 제외 설정 시 주의사항

제외 설정은 성능 문제를 줄이는 데 도움이 되지만, 동시에 보안 사각지대를 만들 수 있습니다.

다음 경로는 가급적 제외하지 않는 것이 좋습니다.

```text
C:\
C:\Windows
C:\Users
C:\Users\Public
C:\ProgramData
C:\Temp
웹 업로드 전체 경로
스크립트 실행 경로 전체
```

제외가 꼭 필요하다면 다음 정보를 문서화해야 합니다.

| 항목 | 예시 |
|---|---|
| 제외 경로 | D:\App\Data |
| 제외 사유 | DB 임시 파일 성능 이슈 |
| 요청 부서 | 서비스 운영팀 |
| 승인자 | 보안 담당자 |
| 적용일 | 2026-06-27 |
| 재검토일 | 2026-09-27 |

---

## 13. Defender 보호 기록 확인하기

PC에서는 Windows 보안 앱에서 보호 기록을 볼 수 있습니다.

```text
Windows 보안
→ 보호 기록
```

여기에서 다음 내용을 확인할 수 있습니다.

- 탐지된 위협
- 격리된 항목
- 제거된 항목
- 차단된 앱
- 주의가 필요한 보안 항목

단, 보호 기록은 장기간 보관용 로그가 아닙니다. Microsoft는 Windows 보안 앱의 보호 기록이 2주 동안만 이벤트를 보관한다고 설명합니다.

참고: [Protection History in the Windows Security app - Microsoft Support](https://support.microsoft.com/en-us/windows/security/windows-security/protection-history-in-the-windows-security-app)

따라서 기업 환경에서는 이벤트 로그, SIEM, XDR 연동을 통해 탐지 이력을 별도로 수집하는 것이 좋습니다.

---

## 14. Defender 이벤트 로그 확인하기

PC와 서버 모두 이벤트 뷰어에서 Defender 로그를 확인할 수 있습니다.

```text
실행
→ eventvwr.msc
→ Applications and Services Logs
→ Microsoft
→ Windows
→ Windows Defender
→ Operational
```

또는 한글 Windows에서는 다음과 비슷하게 보일 수 있습니다.

```text
응용 프로그램 및 서비스 로그
→ Microsoft
→ Windows
→ Windows Defender
→ Operational
```

Microsoft는 Defender Antivirus 이벤트를 확인하려면 이벤트 뷰어에서 `Applications and Services Logs > Microsoft > Windows > Windows Defender > Operational` 경로로 이동하라고 안내합니다.

참고: [Troubleshoot Microsoft Defender Antivirus - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/troubleshoot-microsoft-defender-antivirus)

### 자주 보는 이벤트

| 이벤트 | 의미 |
|---|---|
| 검사 시작 | 수동 또는 예약 검사가 시작됨 |
| 검사 완료 | 검사가 완료됨 |
| 위협 탐지 | 악성코드 또는 의심 항목 탐지 |
| 격리 | 위협 항목 격리 |
| 설정 변경 | Defender 설정 변경 |
| 제어된 폴더 액세스 차단 | 랜섬웨어 방지 기능이 파일 변경 차단 |

운영자는 특히 다음 상황을 주의해서 봐야 합니다.

```text
실시간 보호가 꺼진 이벤트
제외 경로가 추가된 이벤트
반복적으로 탐지되는 파일
동일 사용자가 반복적으로 허용 처리한 이벤트
서버 업로드 경로에서 탐지된 이벤트
PowerShell, cmd, wscript, mshta 등과 연결된 탐지 이벤트
```

---

## 15. 그룹 정책으로 Defender 관리하기

기업 환경에서는 개별 PC마다 설정하는 방식보다 그룹 정책 또는 관리 도구를 통해 일괄 적용하는 것이 좋습니다.

그룹 정책 경로는 다음과 같습니다.

```text
컴퓨터 구성
→ 관리 템플릿
→ Windows 구성 요소
→ Microsoft Defender Antivirus
```

여기에서 다음 항목을 정책으로 관리할 수 있습니다.

- 실시간 보호
- 클라우드 보호
- 제외 경로
- 검사 일정
- 검사 옵션
- 보안 인텔리전스 업데이트
- 알림
- 사용자 인터페이스 제한

Microsoft는 그룹 정책 관리 편집기에서 `Computer configuration > Administrative templates > Windows components > Microsoft Defender Antivirus` 경로로 이동해 Defender Antivirus 설정을 구성할 수 있다고 안내합니다.

참고: [Use Group Policy to configure Microsoft Defender Antivirus - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/use-group-policy-microsoft-defender-antivirus)

---

## 16. 다른 백신이 설치된 경우

PC에서는 호환되는 타사 백신이 설치되면 Microsoft Defender Antivirus가 자동으로 꺼지거나 수동/수동에 가까운 상태가 될 수 있습니다.

서버에서는 조금 더 주의해야 합니다.

Windows Server에서 타사 백신을 함께 사용하는 경우 Defender를 어떻게 둘 것인지 명확히 정해야 합니다.

| 구성 | 설명 |
|---|---|
| Defender 단독 사용 | Defender가 기본 백신 역할 수행 |
| 타사 백신 단독 사용 | Defender 비활성화 또는 제거 고려 |
| Defender for Endpoint 사용 | Passive Mode 또는 EDR in Block Mode 구성 가능 |
| 중복 백신 사용 | 성능 저하, 충돌, 탐지 누락 가능성 주의 |

Microsoft는 Windows Server 2016 이상에서 타사 백신을 설치한다고 해서 Defender Antivirus가 자동으로 Passive Mode로 들어가지는 않으며, 여러 백신이 설치되어 문제가 생기지 않도록 Passive Mode 설정이 필요할 수 있다고 설명합니다.

참고: [Microsoft Defender Antivirus compatibility - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-compatibility)

서버에서 현재 동작 모드는 다음 명령으로 확인합니다.

```powershell
Get-MpComputerStatus | Select-Object AMRunningMode
```

예상 가능한 값은 환경에 따라 다음과 같습니다.

```text
Normal
Passive
EDR Block Mode
```

---

## 17. Defender를 끄기 전에 확인할 것

Defender를 끄는 것은 마지막 선택이어야 합니다.

성능 문제나 오탐 문제가 있다면 먼저 다음 순서로 점검합니다.

1. 최신 업데이트가 적용되어 있는가?
2. 전체 서버가 아니라 특정 경로에서만 문제가 발생하는가?
3. 해당 경로를 최소 범위로 제외할 수 있는가?
4. 제외 설정을 문서화했는가?
5. Defender를 끄는 동안 대체 보안 수단이 있는가?
6. EDR 또는 XDR에서 해당 행위를 계속 볼 수 있는가?

Microsoft도 단일 파일이나 폴더만 제외하려는 경우 전체 보호를 끄는 것보다 제외 항목을 추가하는 것이 더 안전하다고 안내합니다.

참고: [Virus and threat protection in the Windows Security app - Microsoft Support](https://support.microsoft.com/en-au/windows/virus-and-threat-protection-in-the-windows-security-app-1362f4cd-d71a-b52a-0b66-c2820032b65e)

---

## 18. 운영 점검 체크리스트

아래 항목을 주기적으로 확인합니다.

### PC 점검

```text
[ ] 실시간 보호 켜짐
[ ] 클라우드 제공 보호 켜짐
[ ] 자동 샘플 제출 정책 확인
[ ] 변조 방지 켜짐
[ ] 보호 업데이트 최신
[ ] 보호 기록 확인
[ ] 랜섬웨어 방지 설정 확인
```

### 서버 점검

```text
[ ] WinDefend 서비스 실행 중
[ ] AMRunningMode 확인
[ ] RealTimeProtectionEnabled = True
[ ] AntivirusSignatureLastUpdated 최신
[ ] 예약 검사 설정 확인
[ ] 제외 경로 최소화
[ ] 이벤트 로그 수집 확인
[ ] 탐지 이벤트 대응 절차 확인
```

### PowerShell 점검 명령 모음

```powershell
# Defender 서비스 확인
Get-Service -Name WinDefend

# Defender 상태 확인
Get-MpComputerStatus

# 주요 상태만 확인
Get-MpComputerStatus |
Select-Object AMRunningMode,
              AMServiceEnabled,
              AntivirusEnabled,
              RealTimeProtectionEnabled,
              AntivirusSignatureVersion,
              AntivirusSignatureLastUpdated

# 업데이트
Update-MpSignature

# 빠른 검사
Start-MpScan -ScanType QuickScan

# 전체 검사
Start-MpScan -ScanType FullScan

# 특정 경로 검사
Start-MpScan -ScanType CustomScan -ScanPath "D:\Upload"

# 설정 확인
Get-MpPreference

# 제외 목록 확인
Get-MpPreference |
Select-Object ExclusionPath, ExclusionProcess, ExclusionExtension

# 탐지 이력 확인
Get-MpThreat
Get-MpThreatDetection
```

---

## 19. Defender만으로 충분한가?

기본 백신 관점에서는 Windows Defender, 즉 Microsoft Defender Antivirus만으로도 많은 환경에서 기본 보호를 시작할 수 있습니다.

하지만 Defender는 어디까지나 **기본 악성코드 방어 계층**입니다.

현대 공격은 단순히 악성 파일 하나로만 움직이지 않습니다.

예를 들어 다음과 같은 흐름이 더 중요합니다.

```text
웹 서버 취약점 공격
→ cmd.exe 실행
→ powershell.exe 실행
→ 외부 IP 연결
→ 계정 추가
→ 예약 작업 등록
→ 내부 이동
```

이런 공격은 파일 하나만 보고 판단하기 어렵습니다.

따라서 실무 보안 구조는 다음처럼 나누는 것이 좋습니다.

| 계층 | 역할 |
|---|---|
| Windows Defender | 기본 악성코드 차단 |
| EDR | 엔드포인트 행위 탐지와 대응 |
| XDR | 엔드포인트, 웹, 계정, 네트워크, 시스템 로그 통합 분석 |

Defender는 기본을 지키고, EDR은 이상 행위를 보고, XDR은 공격 흐름 전체를 연결해서 봅니다.

---

## 20. 결론

Windows 환경에서 기본 백신을 고민하고 있다면 먼저 Microsoft Defender Antivirus를 제대로 켜고 운영하는 것이 출발점입니다.

PC에서는 Windows 보안 앱으로 확인하고, 서버에서는 PowerShell로 점검하고, 기업 환경에서는 그룹 정책이나 관리 도구로 표준화해야 합니다.

핵심은 다음과 같습니다.

```text
1. 실시간 보호를 켠다.
2. 클라우드 보호와 업데이트를 유지한다.
3. 정기 검사를 설정한다.
4. 제외 경로는 최소화한다.
5. 이벤트 로그를 확인한다.
6. Defender를 끄기 전에 대체 보호 수단을 확인한다.
7. 고도화된 공격 대응은 EDR/XDR과 함께 본다.
```

Windows Defender는 기본 방어의 출발점입니다. 하지만 현대 공격을 제대로 보려면 Defender 로그와 엔드포인트 행위, 계정, 웹, 네트워크 로그를 함께 분석해야 합니다.

즉, 실무적으로는 다음 구성이 가장 현실적입니다.

> **Windows Defender로 기본 악성코드를 막고,  
> PLURA-EDR로 엔드포인트 행위를 탐지하며,  
> PLURA-XDR로 전체 공격 흐름을 분석합니다.**

---

### 함께 읽기

- [PC와 서버의 백신은 윈도우즈 디펜더만으로 충분하다](https://blog.plura.io/ko/column/why-edr-is-necessary/)
- [PLURA에서 Microsoft Defender Antivirus 로그 확인하기](https://blog.plura.io/ko/respond/plura-microsoft-defender-logs/)

---

### 참고 자료

- [Stay protected with the Windows Security app - Microsoft Support](https://support.microsoft.com/en-us/windows/stay-protected-with-the-windows-security-app-2ae0363d-0ada-c064-8b56-6a39afb6a963)
- [Virus and threat protection in the Windows Security app - Microsoft Support](https://support.microsoft.com/en-au/windows/virus-and-threat-protection-in-the-windows-security-app-1362f4cd-d71a-b52a-0b66-c2820032b65e)
- [Microsoft Defender Antivirus on Windows Server - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-on-windows-server)
- [Use PowerShell cmdlets to configure and run Microsoft Defender Antivirus - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/use-powershell-cmdlets-microsoft-defender-antivirus)
- [Schedule Microsoft Defender Antivirus scans using PowerShell - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/schedule-antivirus-scans-powershell)
- [Controlled folder access overview - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/controlled-folder-access-overview)
- [Troubleshoot Microsoft Defender Antivirus - Microsoft Learn](https://learn.microsoft.com/en-us/defender-endpoint/troubleshoot-microsoft-defender-antivirus)
