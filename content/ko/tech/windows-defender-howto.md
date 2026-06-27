---
title: "PC와 서버에서 Windows Defender 사용하는 법"
date: 2026-06-27
draft: false
description: "Windows 10/11 PC와 Windows Server에서 Microsoft Defender Antivirus를 켜고, 점검하고, 검사하고, 업데이트하고, 로그를 확인하는 실무형 HowTo 매뉴얼입니다."
featured_image: "/cdn/tech/windows-defender-howto.png"
categories: ["tech"]
tags: ["Windows Defender", "Microsoft Defender Antivirus", "Windows Security", "Windows Server", "PowerShell", "Antivirus", "Endpoint Security", "EDR", "XDR", "PLURA-EDR", "PLURA-XDR"]
---

## PC와 서버에서 Windows Defender 사용하는 법

Windows 환경에서는 별도 백신을 설치하지 않아도 기본적으로 **Windows Defender**, 정확히는 **Microsoft Defender Antivirus**를 사용할 수 있습니다.

개인 PC에서는 Windows 보안 앱을 통해 쉽게 설정할 수 있고, 서버에서는 PowerShell 명령으로 상태 확인, 검사 실행, 업데이트, 정책 설정을 자동화할 수 있습니다.

이번 글에서는 다음 항목을 실무 기준으로 정리합니다.

- PC에서 Windows Defender 상태 확인하기
- 빠른 검사, 전체 검사, 사용자 지정 검사, 오프라인 검사 실행하기
- 실시간 보호, 클라우드 보호, 자동 샘플 제출, 변조 방지 설정하기
- Windows Server에서 Defender 설치 및 동작 확인하기
- PowerShell로 검사, 업데이트, 예약 검사 설정하기
- 서버 성능 문제를 분석하고 튜닝하기
- 제외 경로 설정 시 주의할 점
- Defender 로그와 이벤트 ID 확인하기
- 타사 백신, Microsoft Defender for Endpoint, Passive Mode, EDR Block Mode 이해하기
- Defender와 PLURA-EDR/XDR의 역할 구분하기

<!--more-->

---

## 1. Windows Defender와 Microsoft Defender Antivirus

예전에는 흔히 **Windows Defender**라고 불렀지만, 현재 Windows 10, Windows 11, Windows Server 환경에서는 **Microsoft Defender Antivirus**라는 이름으로 제공됩니다.

일반 사용자는 Windows 보안 앱에서 확인하고, 서버 운영자는 PowerShell, 그룹 정책, Intune, Microsoft Defender 포털 같은 관리 도구를 함께 사용하는 경우가 많습니다.

정리하면 다음과 같습니다.

| 구분 | 설명 |
|---|---|
| Windows 보안 | Windows에 포함된 보안 설정 앱 |
| Microsoft Defender Antivirus | 바이러스 및 악성코드 탐지/차단 기능 |
| Windows Defender Firewall | Windows 방화벽 |
| Microsoft Defender for Endpoint | 기업용 엔드포인트 보안/EDR 플랫폼 |
| PLURA-EDR | 엔드포인트 행위 탐지와 대응 |
| PLURA-XDR | 엔드포인트, 웹, 계정, 시스템, 네트워크 로그 통합 분석 |

이 글에서는 주로 **Microsoft Defender Antivirus**, 즉 Windows 기본 백신 기능을 다룹니다.

참고: [Windows에서 Microsoft Defender 바이러스 백신 개요 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-windows)

---

## 2. 작업 전 기본 원칙

Defender를 운영할 때 가장 중요한 원칙은 단순합니다.

```text
1. 실시간 보호는 기본적으로 켠다.
2. 보안 인텔리전스 업데이트를 최신 상태로 유지한다.
3. 검사 일정은 업무 영향이 적은 시간대로 조정한다.
4. 제외 경로는 최소 범위로만 설정한다.
5. Defender를 끄기 전에 성능 분석과 로그 확인을 먼저 한다.
6. 고도화된 공격 대응은 EDR/XDR 계층과 함께 본다.
```

특히 운영 서버에서는 성능 문제나 오탐이 발생했다고 해서 바로 Defender를 끄면 안 됩니다. 먼저 어떤 파일, 프로세스, 경로에서 문제가 생기는지 확인하고, 필요한 경우에만 최소 범위로 제외를 설정해야 합니다.

---

## 3. PC에서 Windows Defender 상태 확인하기

Windows 10/11 PC에서는 먼저 Defender가 켜져 있는지 확인해야 합니다.

### 3-1. Windows 보안 앱 열기

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

또는 시작 메뉴에서 다음을 검색합니다.

```text
Windows 보안
```

여기에서 다음 항목을 확인합니다.

- 현재 위협
- 바이러스 및 위협 방지 설정
- 보호 업데이트
- 랜섬웨어 방지
- 보호 기록
- 보안 공급자

참고: [Windows 보안 앱에서 Microsoft Defender 바이러스 백신 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-security-center-antivirus)

### 3-2. Defender가 꺼져 있는 것처럼 보이는 경우

타사 백신이 설치되어 있으면 Microsoft Defender Antivirus가 자동으로 비활성화되거나 제한된 주기적 검사 상태로 보일 수 있습니다.

이 경우 다음 항목을 확인합니다.

```text
Windows 보안
→ 설정
→ 공급자 관리
```

또는 다음 PowerShell 명령을 실행합니다.

```powershell
Get-MpComputerStatus | Select-Object AMRunningMode, AntivirusEnabled, RealTimeProtectionEnabled
```

---

## 4. PC에서 바이러스 검사 실행하기

Windows Defender 검사는 상황에 따라 다르게 실행합니다.

### 4-1. 빠른 검사

일반적인 점검은 **빠른 검사**로 시작합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 빠른 검사
```

빠른 검사는 자주 악성코드가 숨어드는 주요 위치를 검사합니다. PC가 느려졌거나, 의심 파일을 다운로드했거나, 기본 점검이 필요할 때 먼저 실행합니다.

### 4-2. 전체 검사

PC 전체를 점검하려면 **전체 검사**를 실행합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 검사 옵션
→ 전체 검사
→ 지금 검사
```

전체 검사는 시간이 오래 걸릴 수 있으므로 업무 중보다는 점심시간, 퇴근 후, 유지보수 시간에 실행하는 것이 좋습니다.

### 4-3. 사용자 지정 검사

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
웹 업로드 임시 저장 폴더
```

### 4-4. 파일 탐색기에서 바로 검사하기

특정 파일이나 폴더만 빠르게 확인하려면 파일 탐색기에서 해당 항목을 마우스 오른쪽 버튼으로 클릭한 뒤 다음 메뉴를 선택합니다.

```text
Microsoft Defender로 검사
```

Windows 11에서는 먼저 `더 많은 옵션 표시`를 눌러야 해당 메뉴가 보일 수 있습니다.

### 4-5. Microsoft Defender 오프라인 검사

악성코드가 실행 중인 Windows 환경 안에서 자신을 숨기는 경우가 있습니다. 이때는 **Microsoft Defender 오프라인 검사**를 사용할 수 있습니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 검사 옵션
→ Microsoft Defender 바이러스 백신(오프라인 검사)
→ 지금 검사
```

오프라인 검사를 실행하면 PC가 재시작됩니다. 실행 전에는 열려 있는 문서를 저장해야 합니다.

참고: [Microsoft Defender 오프라인 검사의 결과 실행 및 검토 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-offline)

---

## 5. PC에서 권장 설정 확인하기

Defender는 켜져 있는 것만으로 끝나지 않습니다. 아래 설정을 함께 확인해야 합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 바이러스 및 위협 방지 설정
→ 설정 관리
```

### 5-1. 실시간 보호

**실시간 보호**는 반드시 켜두는 것이 좋습니다.

```text
실시간 보호: 켬
```

실시간 보호가 꺼져 있으면 열거나 다운로드하는 파일이 즉시 검사되지 않을 수 있습니다.

### 5-2. 클라우드 제공 보호

```text
클라우드 제공 보호: 켬
```

클라우드 제공 보호는 새롭거나 의심스러운 파일에 대해 Microsoft 보안 인텔리전스를 활용해 더 빠르게 판단하도록 돕습니다.

### 5-3. 자동 샘플 제출

```text
자동 샘플 제출: 켬
```

의심 파일 분석에 도움을 주는 기능입니다. 다만 기업 환경에서는 개인정보, 내부 문서, 규정 준수 이슈가 있을 수 있으므로 조직 정책에 맞게 설정해야 합니다.

참고: [Microsoft Defender 바이러스 백신의 클라우드 보호 및 샘플 제출 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/cloud-protection-microsoft-antivirus-sample-submission)

### 5-4. 변조 방지

```text
변조 방지: 켬
```

변조 방지는 악성코드나 공격자가 Defender 설정을 임의로 끄지 못하도록 돕는 기능입니다.

단, 변조 방지가 켜져 있으면 일부 보안 설정 변경이 차단될 수 있습니다. 기업 환경에서는 개별 사용자가 임의로 변경하지 못하도록 Intune, Microsoft Defender for Endpoint, Configuration Manager 같은 중앙 관리 도구로 관리하는 것이 좋습니다.

참고: [Microsoft Intune을 사용하여 조직의 변조 방지 관리 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/manage-tamper-protection-intune)

---

## 6. 랜섬웨어 방지 설정하기

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

참고: [제어된 폴더 액세스 개요 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/controlled-folders)

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

운영 환경에서는 바로 차단 모드로 전환하기보다 `AuditMode`로 먼저 업무 영향도를 확인하는 방식을 권장합니다.

---

## 7. 보호 업데이트 확인하기

백신은 엔진과 보안 인텔리전스가 최신이어야 의미가 있습니다.

PC에서는 다음 경로에서 업데이트를 확인합니다.

```text
Windows 보안
→ 바이러스 및 위협 방지
→ 보호 업데이트
→ 업데이트 확인
```

PowerShell에서는 다음 명령을 사용합니다.

```powershell
Update-MpSignature
```

현재 엔진과 보안 인텔리전스 정보를 확인하려면 다음 명령을 실행합니다.

```powershell
Get-MpComputerStatus |
Select-Object AMProductVersion,
              AMEngineVersion,
              AntivirusSignatureVersion,
              AntivirusSignatureLastUpdated
```

업데이트 상태에서 특히 확인할 항목은 다음과 같습니다.

| 항목 | 확인 내용 |
|---|---|
| `AMProductVersion` | Defender 제품 버전 |
| `AMEngineVersion` | 악성코드 검사 엔진 버전 |
| `AntivirusSignatureVersion` | 보안 인텔리전스 버전 |
| `AntivirusSignatureLastUpdated` | 마지막 보안 인텔리전스 업데이트 시각 |

참고: [Microsoft Defender 바이러스 백신 보안 인텔리전스 및 제품 업데이트 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-updates)

---

## 8. Windows Server에서 Defender 사용하기

서버에서는 GUI보다 PowerShell로 확인하는 것이 일반적입니다.

Microsoft Defender Antivirus는 기본적으로 Windows Server 2016 이상에서 설치되고 작동합니다. Windows Server 2025 환경도 Windows Server 2016 이상 계열에 포함되지만, 실제 운영에서는 OS 버전, 설치 옵션, 관리 도구, Defender 플랫폼 버전에 따라 UI나 세부 정책 이름이 다를 수 있습니다.

따라서 서버 문서화 시에는 다음 정보를 함께 남겨야 합니다.

```text
서버 OS 버전
Defender 제품/엔진/플랫폼 버전
Defender 동작 모드
타사 백신 설치 여부
MDE 온보딩 여부
정책 적용 방식: 로컬 / GPO / Intune / Configuration Manager
```

참고: [Windows Server의 Microsoft Defender 바이러스 백신 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-on-windows-server)

### 8-1. Defender 설치 여부 확인

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

### 8-2. Windows 기능으로 확인하기

서버 기능 관점에서 확인하려면 다음 명령을 실행합니다.

```powershell
Get-WindowsFeature -Name Windows-Defender
```

### 8-3. Defender 설치 또는 재설치

Defender가 제거되어 있거나 설치되어 있지 않다면 다음 명령으로 설치할 수 있습니다.

```powershell
Install-WindowsFeature -Name Windows-Defender
```

필요한 경우 서버를 재시작합니다.

```powershell
Restart-Computer
```

Server Core 환경에서는 GUI가 없기 때문에 PowerShell, 명령 프롬프트, 원격 관리 도구를 기준으로 점검합니다.

---

## 9. 서버에서 Defender 상태 점검하기

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
              BehaviorMonitorEnabled,
              IoavProtectionEnabled,
              AntispywareEnabled,
              AntivirusSignatureVersion,
              AntivirusSignatureLastUpdated,
              IsTamperProtected
```

확인해야 할 값은 다음과 같습니다.

| 항목 | 확인 기준 |
|---|---|
| `AMRunningMode` | `Normal`, `Passive`, `EDR Block Mode` 등 정책에 맞는 상태 |
| `AMServiceEnabled` | `True` |
| `AntivirusEnabled` | `True` 또는 운영 정책에 맞는 상태 |
| `RealTimeProtectionEnabled` | `True` |
| `BehaviorMonitorEnabled` | `True` |
| `IoavProtectionEnabled` | `True` |
| `AntivirusSignatureLastUpdated` | 최신 날짜 |
| `IsTamperProtected` | 기업 정책에 맞는 상태 |

참고: [PowerShell cmdlet을 사용하여 Microsoft Defender 바이러스 백신 구성 및 실행 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/use-powershell-cmdlets-microsoft-defender-antivirus)

### 9-1. Get-MpComputerStatus 출력 예시

정상적인 서버에서는 대략 다음과 같은 값을 기대할 수 있습니다.

```powershell
Get-MpComputerStatus |
Select-Object AMRunningMode,
              AMServiceEnabled,
              AntivirusEnabled,
              RealTimeProtectionEnabled,
              BehaviorMonitorEnabled,
              IoavProtectionEnabled,
              AntivirusSignatureLastUpdated
```

예시:

```text
AMRunningMode                 : Normal
AMServiceEnabled              : True
AntivirusEnabled              : True
RealTimeProtectionEnabled     : True
BehaviorMonitorEnabled        : True
IoavProtectionEnabled         : True
AntivirusSignatureLastUpdated : 2026-06-27 오전 8:15:10
```

특히 `AMRunningMode`는 현재 Defender의 동작 모드를 확인할 때 중요합니다.

| 값 | 의미 |
|---|---|
| `Normal` | Defender가 기본 백신으로 동작 |
| `Passive` | 다른 백신이 주 보호 역할을 하고 Defender는 수동 모드로 동작 |
| `EDR Block Mode` | Defender for Endpoint 환경에서 EDR 판단에 따라 악성 아티팩트 차단 보조 역할 수행 |
| `SxS Passive` | 다른 백신과 함께 제한된 주기적 검사 형태로 동작하는 상태 |

참고: [Windows에서 Microsoft Defender 바이러스 백신 상태 확인 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-windows)

---

## 10. 서버에서 검사 실행하기

서버에서 검사를 실행할 때는 서비스 영향도를 고려해야 합니다.

### 10-1. 빠른 검사

```powershell
Start-MpScan -ScanType QuickScan
```

### 10-2. 전체 검사

```powershell
Start-MpScan -ScanType FullScan
```

전체 검사는 디스크 I/O와 CPU 사용량에 영향을 줄 수 있습니다. 운영 서버에서는 업무 피크 시간대를 피해서 실행하는 것이 좋습니다.

### 10-3. 특정 경로 검사

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
의심 파일 격리 임시 경로
```

### 10-4. 명령 프롬프트에서 검사하기

`MpCmdRun.exe`를 사용해 명령 프롬프트에서도 검사를 실행할 수 있습니다.

```cmd
MpCmdRun.exe -Scan -ScanType 1
```

전체 검사는 다음과 같습니다.

```cmd
MpCmdRun.exe -Scan -ScanType 2
```

사용자 지정 검사는 다음과 같습니다.

```cmd
MpCmdRun.exe -Scan -ScanType 3 -File D:\Upload
```

`MpCmdRun.exe`는 관리자 권한 명령 프롬프트에서 실행해야 하며, 환경에 따라 다음 경로로 이동한 뒤 실행해야 할 수 있습니다.

```cmd
cd /d "%ProgramData%\Microsoft\Windows Defender\Platform"
```

참고: [MpCmdRun 명령줄 도구로 Microsoft Defender 바이러스 백신 관리 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/command-line-arguments-microsoft-defender-antivirus)

---

## 11. 서버에서 예약 검사 설정하기

서버는 정기적인 예약 검사를 설정해 두는 것이 좋습니다.

### 11-1. 매일 빠른 검사 설정

예를 들어 매일 낮 12시 30분에 빠른 검사를 실행하려면 다음과 같이 설정합니다.

```powershell
Set-MpPreference `
  -ScanScheduleQuickScanTime 12:30:00 `
  -ScanScheduleOffset 0 `
  -RandomizeScheduleTaskTimes $false `
  -ScanOnlyIfIdleEnabled $false
```

### 11-2. 매주 전체 검사 설정

예를 들어 매주 수요일 12시 30분에 전체 검사를 실행하려면 다음과 같이 설정합니다.

```powershell
Set-MpPreference `
  -ScanParameters FullScan `
  -ScanScheduleDay Wednesday `
  -ScanScheduleTime 12:30:00 `
  -ScanScheduleOffset 0 `
  -RandomizeScheduleTaskTimes $false
```

### 11-3. 분산 실행 고려하기

다수 서버에서 같은 시간에 전체 검사가 실행되면 스토리지, CPU, 네트워크에 부하가 몰릴 수 있습니다. 이 경우 서버 그룹별로 검사 시간을 나누거나 예약 시작 시간을 분산해야 합니다.

예를 들어 서버 그룹별로 다음처럼 나눌 수 있습니다.

| 서버 그룹 | 검사 시간 |
|---|---|
| 웹 서버 | 수요일 12:30 |
| WAS 서버 | 목요일 12:30 |
| 파일 서버 | 토요일 02:00 |
| 백오피스 서버 | 일요일 03:00 |

참고: [PowerShell을 사용하여 바이러스 백신 검사 예약 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/schedule-antivirus-scans-powershell)

---

## 12. 서버에서 권장 보호 설정 적용하기

관리자 권한 PowerShell에서 다음 설정을 확인하거나 적용할 수 있습니다.

### 12-1. 실시간 보호 켜기

```powershell
Set-MpPreference -DisableRealtimeMonitoring $false
```

### 12-2. 행위 모니터링 켜기

```powershell
Set-MpPreference -DisableBehaviorMonitoring $false
```

### 12-3. 스크립트 검사 켜기

```powershell
Set-MpPreference -DisableScriptScanning $false
```

### 12-4. 다운로드 파일 및 첨부 파일 검사 켜기

```powershell
Set-MpPreference -DisableIOAVProtection $false
```

### 12-5. 클라우드 보호 켜기

```powershell
Set-MpPreference -MAPSReporting Advanced
```

### 12-6. 자동 샘플 제출 정책 설정

조직 정책에 맞게 자동 샘플 제출 수준을 지정할 수 있습니다.

```powershell
Set-MpPreference -SubmitSamplesConsent SendSafeSamples
```

민감 정보가 포함될 수 있는 서버에서는 조직의 개인정보·규정 준수 정책을 먼저 확인해야 합니다.

### 12-7. PUA 보호 켜기

PUA는 Potentially Unwanted Application의 약자로, 명확한 악성코드는 아니지만 광고 프로그램, 불필요한 툴바, 원치 않는 설치 프로그램처럼 업무 환경에 불필요하거나 위험할 수 있는 앱을 의미합니다.

```powershell
Set-MpPreference -PUAProtection Enabled
```

### 12-8. 권장 설정 확인

현재 설정을 확인합니다.

```powershell
Get-MpPreference |
Select-Object DisableRealtimeMonitoring,
              DisableBehaviorMonitoring,
              DisableScriptScanning,
              DisableIOAVProtection,
              MAPSReporting,
              SubmitSamplesConsent,
              PUAProtection
```

참고: [Microsoft Defender 바이러스 백신 기능 구성 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/configure-microsoft-defender-antivirus-features)

---

## 13. 서버 성능 튜닝하기

운영 서버에서 Defender 검사가 CPU나 디스크 I/O에 영향을 준다고 해서 바로 실시간 보호를 끄는 것은 권장되지 않습니다.

먼저 다음 순서로 확인합니다.

```text
1. 어떤 파일, 프로세스, 경로에서 부하가 발생하는가?
2. 전체 검사 때문인가, 실시간 검사 때문인가?
3. 예약 검사 시간대가 업무 피크 시간과 겹치는가?
4. 서버 역할에 따른 자동 제외가 이미 적용되는가?
5. 최소 범위의 제외로 해결 가능한가?
6. 제외 후에도 EDR/XDR에서 해당 경로의 행위를 볼 수 있는가?
```

참고: [Microsoft Defender 바이러스 백신에 대한 성능 분석기 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/tune-performance-defender-antivirus)

### 13-1. 성능 기록 수집

관리자 권한 PowerShell에서 성능 기록을 수집합니다.

```powershell
New-MpPerformanceRecording -RecordTo C:\Temp\MpPerf.etl
```

문제가 재현되는 작업을 수행한 뒤 기록을 중지하고, 결과를 분석합니다.

```powershell
Get-MpPerformanceReport `
  -Path C:\Temp\MpPerf.etl `
  -TopFiles 10 `
  -TopScansPerFile 10
```

이 결과를 바탕으로 실제로 부하를 유발하는 파일, 프로세스, 확장자, 경로를 확인합니다.

### 13-2. 예약 검사 CPU 사용률 조정

검사 중 평균 CPU 사용률을 낮추려면 다음과 같이 설정할 수 있습니다.

```powershell
Set-MpPreference -ScanAvgCPULoadFactor 30
```

중요한 점은 이 값이 **하드 리밋이 아니라 검사 엔진이 평균적으로 넘지 않도록 참고하는 지침값**이라는 것입니다. 값을 지나치게 낮추면 검사 시간이 길어질 수 있으므로 서버 역할과 업무 시간대를 고려해 조정해야 합니다.

확인 명령은 다음과 같습니다.

```powershell
Get-MpPreference | Select-Object ScanAvgCPULoadFactor
```

참고: [Set-MpPreference 참조 - Microsoft Learn](https://learn.microsoft.com/ko-kr/powershell/module/defender/set-mppreference?view=windowsserver2025-ps)

### 13-3. 예약 검사 분산 설정

대규모 서버 환경에서는 검사 시작 시간을 일부러 분산하는 것이 좋습니다.

```powershell
Set-MpPreference -SchedulerRandomizationTime 60
```

이 설정은 예약 작업이 지정된 시간 주변에서 분산 실행되도록 도와 여러 서버가 동시에 부하를 만들지 않게 하는 데 유용합니다.

### 13-4. 성능 문제 대응 순서

성능 문제가 발생하면 다음 순서로 대응합니다.

```text
1. 성능 기록 수집
2. 상위 파일/프로세스/경로 확인
3. 예약 검사 시간 조정
4. CPU 사용률 지침값 조정
5. 서버 역할 자동 제외 확인
6. 최소 범위의 사용자 지정 제외 적용
7. 제외 사유와 만료일 문서화
8. EDR/XDR 모니터링 유지
```

---

## 14. 제외 경로 설정하기

업무 서버에서는 Defender 검사 때문에 특정 애플리케이션 성능 문제가 발생할 수 있습니다.

이때 무조건 Defender를 끄기보다는 필요한 경로만 제한적으로 제외하는 것이 좋습니다.

### 14-1. 제외 경로 추가

```powershell
Add-MpPreference -ExclusionPath "D:\App\Data"
```

### 14-2. 제외 프로세스 추가

```powershell
Add-MpPreference -ExclusionProcess "backup.exe"
```

### 14-3. 제외 확장자 추가

```powershell
Add-MpPreference -ExclusionExtension ".log"
```

### 14-4. 제외 목록 확인

```powershell
Get-MpPreference |
Select-Object ExclusionPath, ExclusionProcess, ExclusionExtension
```

### 14-5. 제외 경로 제거

```powershell
Remove-MpPreference -ExclusionPath "D:\App\Data"
```

참고: [Add-MpPreference 참조 - Microsoft Learn](https://learn.microsoft.com/ko-kr/powershell/module/defender/add-mppreference?view=windowsserver2025-ps)

### 14-6. 절대 넓게 제외하지 말아야 할 경로

다음 경로는 특별한 승인 없이 제외하지 않는 것이 원칙입니다.

```text
C:\
C:\Windows
C:\Program Files
C:\Program Files (x86)
C:\Users
C:\Users\Public
C:\ProgramData
C:\Temp
웹 업로드 루트 전체
스크립트 실행 경로 전체
백업 저장소 전체
공유 폴더 전체
```

특히 웹 업로드 경로, 임시 폴더, 사용자 쓰기 가능 경로를 통째로 제외하면 공격자가 악성 파일을 저장하고 실행할 수 있는 안전지대를 만들어 줄 수 있습니다.

제외는 다음 원칙을 따릅니다.

```text
1. 전체 드라이브 제외 금지
2. OS 핵심 경로 제외 금지
3. 사용자 쓰기 가능 경로 전체 제외 금지
4. 웹 업로드 루트 전체 제외 금지
5. 필요한 파일, 확장자, 프로세스만 최소 범위로 제외
6. 제외 사유와 만료일 문서화
7. 정기 재검토
8. 제외 경로의 행위는 EDR/XDR로 계속 모니터링
```

Windows Server 2016 이상에서는 서버 역할에 따라 Defender가 자동 제외를 적용하는 항목이 있습니다. 따라서 AD DS, DNS, DHCP, Hyper-V, IIS, WSUS 같은 역할 서버에서는 사용자 지정 제외를 추가하기 전에 Microsoft의 서버 역할 자동 제외 문서를 먼저 확인하는 것이 좋습니다.

참고: [Windows Server Microsoft Defender 바이러스 백신 제외 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/configure-server-exclusions-microsoft-defender-antivirus)

### 14-7. 제외 설정 문서화 양식

제외가 꼭 필요하다면 다음 정보를 문서화해야 합니다.

| 항목 | 예시 |
|---|---|
| 제외 경로 | `D:\App\Data` |
| 제외 유형 | 경로 / 프로세스 / 확장자 |
| 제외 사유 | DB 임시 파일 성능 이슈 |
| 요청 부서 | 서비스 운영팀 |
| 승인자 | 보안 담당자 |
| 적용일 | 2026-06-27 |
| 재검토일 | 2026-09-27 |
| 대체 모니터링 | PLURA-EDR / PLURA-XDR 탐지 룰 적용 |

---

## 15. Defender 보호 기록 확인하기

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

격리된 파일은 무조건 복원하면 안 됩니다. 업무 파일로 보이더라도 먼저 탐지명, 파일 경로, 생성 주체, 실행 이력, 네트워크 연결 여부를 확인해야 합니다.

참고: [Microsoft Defender 바이러스 백신에서 격리된 파일 복원 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/restore-quarantined-files-microsoft-defender-antivirus)

기업 환경에서는 보호 기록만으로는 부족합니다. 이벤트 로그, SIEM, EDR, XDR로 탐지 이력을 별도로 수집하는 것이 좋습니다.

---

## 16. Defender 이벤트 로그 확인하기

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

한글 Windows에서는 다음과 비슷하게 보일 수 있습니다.

```text
응용 프로그램 및 서비스 로그
→ Microsoft
→ Windows
→ Windows Defender
→ Operational
```

참고: [Microsoft Defender 바이러스 백신 이벤트 ID 및 오류 코드 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/troubleshoot-microsoft-defender-antivirus)

### 16-1. 자주 보는 이벤트

| 이벤트 | 의미 |
|---|---|
| 검사 시작 | 수동 또는 예약 검사가 시작됨 |
| 검사 완료 | 검사가 완료됨 |
| 검사 중지 | 검사가 완료 전에 중지됨 |
| 위협 탐지 | 악성코드 또는 의심 항목 탐지 |
| 격리 | 위협 항목 격리 |
| 설정 변경 | Defender 설정 변경 |
| 제어된 폴더 액세스 차단 | 랜섬웨어 방지 기능이 파일 변경 차단 |

검사 상태 확인에 자주 쓰이는 이벤트 ID는 다음과 같습니다.

| 이벤트 ID | 의미 |
|---:|---|
| 1000 | 맬웨어 방지 검사가 시작됨 |
| 1001 | 맬웨어 방지 검사가 완료됨 |
| 1002 | 맬웨어 방지 검사가 완료되기 전에 중지됨 |
| 2030 | Microsoft Defender 오프라인 검사가 다음 재부팅에 실행되도록 구성됨 |

참고: [Microsoft Defender 바이러스 백신 검사 문제 해결 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/troubleshoot-mdav-scan-issues)

### 16-2. 운영자가 특히 주의할 이벤트

다음 상황은 반드시 확인해야 합니다.

```text
실시간 보호가 꺼진 이벤트
클라우드 보호가 꺼진 이벤트
제외 경로가 추가된 이벤트
반복적으로 탐지되는 파일
동일 사용자가 반복적으로 허용 처리한 이벤트
서버 업로드 경로에서 탐지된 이벤트
PowerShell, cmd, wscript, mshta, rundll32, regsvr32, certutil과 연결된 탐지 이벤트
웹 서버 프로세스에서 cmd.exe 또는 powershell.exe가 실행된 이벤트
```

이런 이벤트는 단일 탐지로 끝내지 말고 EDR/XDR에서 프로세스 트리, 계정, 네트워크 연결, 웹 로그와 함께 확인해야 합니다.

---

## 17. 그룹 정책, Intune으로 Defender 관리하기

기업 환경에서는 개별 PC마다 설정하는 방식보다 그룹 정책, Intune, Configuration Manager 같은 관리 도구를 통해 일괄 적용하는 것이 좋습니다.

### 17-1. 그룹 정책 경로

그룹 정책 경로는 다음과 같습니다.

```text
컴퓨터 구성
→ 관리 템플릿
→ Windows 구성 요소
→ Microsoft Defender 바이러스 백신
```

여기에서 다음 항목을 정책으로 관리할 수 있습니다.

- 실시간 보호
- 클라우드 보호
- 샘플 제출
- 제외 경로
- 검사 일정
- 검사 옵션
- 보안 인텔리전스 업데이트
- 알림
- 사용자 인터페이스 제한
- EDR in Block Mode

참고: [그룹 정책으로 Microsoft Defender 바이러스 백신 구성 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/use-group-policy-microsoft-defender-antivirus)

### 17-2. Intune과 Configuration Manager

Microsoft 365/Defender for Endpoint 환경에서는 Intune 또는 Configuration Manager를 통해 다음 설정을 중앙 관리할 수 있습니다.

```text
Defender Antivirus 정책
변조 방지
공격 표면 감소 규칙
제어된 폴더 액세스
네트워크 보호
보안 기준
제외 정책
```

특히 변조 방지가 켜져 있으면 로컬 관리자나 일부 관리 스크립트가 설정을 바꾸려고 해도 변경이 차단될 수 있습니다. 따라서 운영팀과 보안팀은 “어떤 도구가 최종 정책 소스인지”를 명확히 해야 합니다.

참고: [Configuration Manager 테넌트 연결로 변조 방지 관리 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/manage-tamper-protection-configuration-manager)

---

## 18. 다른 백신이 설치된 경우

PC에서는 호환되는 타사 백신이 설치되면 Microsoft Defender Antivirus가 자동으로 꺼지거나 제한된 상태가 될 수 있습니다.

서버에서는 더 주의해야 합니다.

Windows Server에서 타사 백신을 함께 사용하는 경우 Defender를 어떻게 둘 것인지 명확히 정해야 합니다.

| 구성 | 설명 |
|---|---|
| Defender 단독 사용 | Defender가 기본 백신 역할 수행 |
| 타사 백신 단독 사용 | Defender 비활성화 또는 제거 여부 검토 |
| Defender for Endpoint 사용 | Passive Mode 또는 EDR Block Mode 구성 가능 |
| 중복 백신 사용 | 성능 저하, 충돌, 탐지 누락 가능성 주의 |

참고: [다른 보안 제품과의 Microsoft Defender 바이러스 백신 호환성 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-compatibility)

### 18-1. Passive Mode와 EDR Block Mode 차이

Defender for Endpoint를 함께 사용하는 환경에서는 Defender Antivirus의 동작 모드를 반드시 확인해야 합니다.

```powershell
Get-MpComputerStatus | Select-Object AMRunningMode
```

| 모드 | 의미 | 사용 상황 |
|---|---|---|
| `Normal` | Defender가 기본 백신으로 동작 | Defender 단독 사용 |
| `Passive` | Defender가 수동 모드로 동작 | 타사 백신이 기본 백신인 경우 |
| `EDR Block Mode` | EDR 판단에 따라 악성 아티팩트 차단 보조 | Defender for Endpoint 연계 환경 |
| `SxS Passive` | 다른 백신과 함께 제한된 주기적 검사 형태로 동작 | 일부 클라이언트 환경 |

서버에서는 타사 백신을 설치했다고 해서 항상 Defender가 자동으로 Passive Mode가 되는 것은 아닙니다. 따라서 타사 백신과 함께 운영하는 경우 반드시 `AMRunningMode`를 확인해야 합니다.

### 18-2. 운영 시 확인 질문

```text
타사 백신이 기본 보호를 담당하는가?
Defender가 Normal Mode로 같이 동작하고 있지는 않은가?
Defender for Endpoint에 온보딩되어 있는가?
EDR Block Mode가 필요한 환경인가?
Defender 비활성화 시 대체 탐지와 대응 수단이 있는가?
```

---

## 19. Defender를 끄기 전에 확인할 것

Defender를 끄는 것은 마지막 선택이어야 합니다.

성능 문제나 오탐 문제가 있다면 먼저 다음 순서로 점검합니다.

```text
1. Defender 보안 인텔리전스가 최신인가?
2. 전체 서버가 아니라 특정 경로에서만 문제가 발생하는가?
3. MpPerformanceRecording으로 성능 원인을 확인했는가?
4. 예약 검사 시간이 업무 피크 시간과 겹치지는 않는가?
5. CPU 사용률 지침값 조정으로 해결 가능한가?
6. 서버 역할 자동 제외가 이미 적용되는가?
7. 필요한 경로만 최소 범위로 제외할 수 있는가?
8. 제외 설정을 문서화했는가?
9. Defender를 끄는 동안 대체 보안 수단이 있는가?
10. EDR 또는 XDR에서 해당 행위를 계속 볼 수 있는가?
```

특히 다음 방식은 피해야 합니다.

```text
문제 원인 확인 없이 Defender 전체 비활성화
C:\ 전체 제외
웹 업로드 루트 전체 제외
사용자 쓰기 가능 경로 전체 제외
운영 서버에서 승인 없이 실시간 보호 중지
장애 조치 후 제외 경로를 재검토하지 않음
```

---

## 20. 공통 오류 트러블슈팅

Defender가 정상 동작하지 않는다고 판단되면 바로 비활성화하기보다 다음 순서로 점검합니다.

### 20-1. 서비스 상태 확인

```powershell
Get-Service -Name WinDefend
```

명령 프롬프트에서는 다음을 실행합니다.

```cmd
sc query WinDefend
```

서비스가 보이지 않거나 중지되어 있다면 다음을 확인합니다.

```text
Defender 기능이 제거되었는가?
타사 백신 정책으로 비활성화되었는가?
그룹 정책 또는 Intune 정책이 적용되었는가?
서버가 Defender for Endpoint에 온보딩되어 있는가?
변조 방지가 설정 변경을 차단하고 있는가?
```

### 20-2. Defender 상태 확인

```powershell
Get-MpComputerStatus
```

명령 결과가 비어 있거나 오류가 발생하면 Defender 기능이 제거되었거나, PowerShell 권한이 부족하거나, 서비스가 비정상 상태일 수 있습니다.

### 20-3. 업데이트 재시도

```powershell
Update-MpSignature
```

명령 프롬프트에서는 다음 명령도 사용할 수 있습니다.

```cmd
MpCmdRun.exe -SignatureUpdate
```

### 20-4. 클라우드 보호 연결 확인

클라우드 보호 연결 문제를 의심할 때는 다음 명령을 사용할 수 있습니다.

```cmd
MpCmdRun.exe -ValidateMapsConnection
```

방화벽, 프록시, TLS 검사 장비가 Microsoft Defender 클라우드 서비스 연결을 차단하지 않는지 확인해야 합니다.

### 20-5. 특정 경로가 제외되었는지 확인

```cmd
MpCmdRun.exe -CheckExclusion -Path D:\Upload
```

또는 PowerShell에서 제외 목록을 확인합니다.

```powershell
Get-MpPreference |
Select-Object ExclusionPath, ExclusionProcess, ExclusionExtension
```

### 20-6. 진단 로그 수집

문제가 계속되면 진단 로그를 수집합니다.

```cmd
MpCmdRun.exe -GetFiles
```

수집된 파일은 기본적으로 다음 경로에 생성됩니다.

```text
C:\ProgramData\Microsoft\Windows Defender\Support\MpSupportFiles.cab
```

### 20-7. 플랫폼 업데이트 문제 시 롤백 검토

Defender 플랫폼 업데이트 이후 문제가 발생한 경우에만 마지막 단계로 플랫폼 롤백을 검토합니다.

```cmd
MpCmdRun.exe -RevertPlatform
```

운영 체제에 포함된 버전으로 되돌려야 하는 특수 상황에서는 다음 명령을 검토할 수 있습니다.

```cmd
MpCmdRun.exe -ResetPlatform
```

이 명령은 일반 점검 명령이 아니라 장애 대응용 명령입니다. 운영 서버에서는 변경 승인 후 실행하는 것이 좋습니다.

참고: [MpCmdRun 명령줄 도구로 Microsoft Defender 바이러스 백신 관리 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/command-line-arguments-microsoft-defender-antivirus)

---

## 21. 운영 점검 체크리스트

아래 항목을 주기적으로 확인합니다.

### 21-1. PC 점검

```text
[ ] 실시간 보호 켜짐
[ ] 클라우드 제공 보호 켜짐
[ ] 자동 샘플 제출 정책 확인
[ ] 변조 방지 켜짐
[ ] 보호 업데이트 최신
[ ] 보호 기록 확인
[ ] 랜섬웨어 방지 설정 확인
[ ] 타사 백신 설치 여부 확인
```

### 21-2. 서버 점검

```text
[ ] WinDefend 서비스 실행 중
[ ] AMRunningMode 확인
[ ] RealTimeProtectionEnabled = True
[ ] BehaviorMonitorEnabled = True
[ ] IoavProtectionEnabled = True
[ ] AntivirusSignatureLastUpdated 최신
[ ] 예약 검사 설정 확인
[ ] 성능 분석 기록 필요 여부 확인
[ ] 제외 경로 최소화
[ ] 제외 경로 문서화 및 재검토일 설정
[ ] 이벤트 로그 수집 확인
[ ] 탐지 이벤트 대응 절차 확인
[ ] EDR/XDR 연동 확인
```

### 21-3. PowerShell 점검 명령 모음

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
              BehaviorMonitorEnabled,
              IoavProtectionEnabled,
              AntivirusSignatureVersion,
              AntivirusSignatureLastUpdated,
              IsTamperProtected

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

# 성능 기록 수집
New-MpPerformanceRecording -RecordTo C:\Temp\MpPerf.etl

# 성능 보고서 분석
Get-MpPerformanceReport -Path C:\Temp\MpPerf.etl -TopFiles 10 -TopScansPerFile 10
```

### 21-4. 운영 서버 변경 관리 양식

Defender 설정을 바꿀 때는 아래 항목을 남기는 것이 좋습니다.

| 항목 | 내용 |
|---|---|
| 변경 대상 | 서버명, IP, 역할 |
| 변경 항목 | 제외 경로 / 예약 검사 / CPU 지침값 / 정책 변경 |
| 변경 사유 | 성능 이슈, 오탐, 신규 서비스 배포 등 |
| 영향 범위 | 서비스, 사용자, 보안 탐지 영향 |
| 대체 통제 | EDR/XDR 모니터링, 로그 수집, 접근 통제 |
| 승인자 | 운영 책임자, 보안 책임자 |
| 적용일 | YYYY-MM-DD |
| 재검토일 | YYYY-MM-DD |

---

## 22. Defender만으로 충분한가?

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
| PLURA-EDR | 엔드포인트 행위 탐지와 대응 |
| PLURA-XDR | 엔드포인트, 웹, 계정, 네트워크, 시스템 로그 통합 분석 |

Defender는 기본을 지키고, EDR은 이상 행위를 보고, XDR은 공격 흐름 전체를 연결해서 봅니다.

### 22-1. EDR/XDR에서 함께 봐야 할 행위

다음 행위는 Defender 탐지 여부와 별개로 EDR/XDR에서 함께 봐야 합니다.

```text
powershell.exe의 인코딩 명령 실행
cmd.exe를 통한 다운로드 또는 스크립트 실행
mshta.exe, rundll32.exe, regsvr32.exe, certutil.exe 악용
웹 서버 프로세스의 자식 셸 실행
비정상 외부 IP 연결
예약 작업 등록
서비스 생성
레지스트리 Run 키 변경
계정 생성 또는 권한 변경
```

이런 행위는 파일 기반 탐지만으로는 놓칠 수 있습니다. 따라서 Windows Defender 로그와 함께 프로세스 트리, 명령줄, 사용자, 네트워크, 웹 요청, 인증 로그를 연결해서 보는 구조가 필요합니다.

---

## 23. 결론

Windows 환경에서 기본 백신을 고민하고 있다면 먼저 Microsoft Defender Antivirus를 제대로 켜고 운영하는 것이 출발점입니다.

PC에서는 Windows 보안 앱으로 확인하고, 서버에서는 PowerShell로 점검하고, 기업 환경에서는 그룹 정책, Intune, Configuration Manager 같은 관리 도구로 표준화해야 합니다.

핵심은 다음과 같습니다.

```text
1. 실시간 보호를 켠다.
2. 클라우드 보호와 업데이트를 유지한다.
3. 정기 검사를 설정한다.
4. 성능 문제는 분석 후 튜닝한다.
5. 제외 경로는 최소화하고 문서화한다.
6. 이벤트 로그를 확인한다.
7. Defender를 끄기 전에 대체 보호 수단을 확인한다.
8. 고도화된 공격 대응은 EDR/XDR과 함께 본다.
```

Windows Defender는 기본 방어의 출발점입니다. 하지만 현대 공격을 제대로 보려면 Defender 로그와 엔드포인트 행위, 계정, 웹, 네트워크 로그를 함께 분석해야 합니다.

즉, 실무적으로는 다음 구성이 가장 현실적입니다.

> **Windows Defender로 기본 악성코드를 막고,  
> PLURA-EDR로 엔드포인트 행위를 탐지하며,  
> PLURA-XDR로 전체 공격 흐름을 분석합니다.**

---

## 참고 자료

- [Windows에서 Microsoft Defender 바이러스 백신 개요 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-windows)
- [Windows 보안 앱에서 Microsoft Defender 바이러스 백신 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-security-center-antivirus)
- [Windows Server의 Microsoft Defender 바이러스 백신 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-on-windows-server)
- [PowerShell cmdlet을 사용하여 Microsoft Defender 바이러스 백신 구성 및 실행 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/use-powershell-cmdlets-microsoft-defender-antivirus)
- [PowerShell을 사용하여 바이러스 백신 검사 예약 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/schedule-antivirus-scans-powershell)
- [Microsoft Defender 바이러스 백신 보안 인텔리전스 및 제품 업데이트 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-updates)
- [Microsoft Defender 바이러스 백신에 대한 성능 분석기 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/tune-performance-defender-antivirus)
- [Windows Server Microsoft Defender 바이러스 백신 제외 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/configure-server-exclusions-microsoft-defender-antivirus)
- [Microsoft Defender 바이러스 백신 이벤트 ID 및 오류 코드 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/troubleshoot-microsoft-defender-antivirus)
- [Microsoft Defender 바이러스 백신 검사 문제 해결 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/troubleshoot-mdav-scan-issues)
- [MpCmdRun 명령줄 도구로 Microsoft Defender 바이러스 백신 관리 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/command-line-arguments-microsoft-defender-antivirus)
- [다른 보안 제품과의 Microsoft Defender 바이러스 백신 호환성 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/microsoft-defender-antivirus-compatibility)
- [Microsoft Intune을 사용하여 조직의 변조 방지 관리 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/manage-tamper-protection-intune)
- [그룹 정책으로 Microsoft Defender 바이러스 백신 구성 - Microsoft Learn](https://learn.microsoft.com/ko-kr/defender-endpoint/use-group-policy-microsoft-defender-antivirus)

---

### 함께 읽기

- [PC와 서버의 백신은 윈도우즈 디펜더만으로 충분하다](https://blog.plura.io/ko/column/why-edr-is-necessary/)
- [PLURA에서 Microsoft Defender Antivirus 로그 확인하기](https://blog.plura.io/ko/respond/plura-microsoft-defender-logs/)
