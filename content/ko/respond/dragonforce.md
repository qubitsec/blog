---

title: "RansomHub의 몰락… 그 잔해 위에 탄생한 DragonForce"
date: 2025-07-11
draft: false
description: "침투, 암호화, 탐지 대응 전략 완전 해부"
featured_image: "cdn/respond/dragonforce.png"
tags: ["랜섬웨어", "DragonForce", "공격 탐지", "hacking", "ransomware", "RansomHub", "PLURA-XDR"]

---

### 🧩 DragonForce 랜섬웨어 개요

| 항목 | 내용 |
| --- | --- |
| 최초 공개 | 2024.10, 다크웹 유출 기반 분석 |
| 주요 활동 그룹 | RansomHub 해체 이후 다수 제휴자 흡수하여 영향력 확대 |
| 사용 기술 | ChaCha8 대칭 암호화 + RSA-4096 키 암호화 구조 |
| 피해 지표 | `readme.txt` 랜섬노트 생성, `.dragonforce_encrypted` 확장자 부착 |
| 탐지 난이도 | 중간–높음: 단일 정적 시그니처 회피 및 빠른 암호화 속도 |

<!--more-->

![dragonforce](https://blog.plura.io/cdn/respond/dragonforce.png)

---

### 💡 DragonForce 블로그

- 피해자 게시물
    
    ![dragonforce_01](https://blog.plura.io/cdn/respond/dragonforce_01.png)
    
    > 랜섬웨어 운영 그룹은 피해 기업이나 기관의 명단을 블로그에 공개하며, 협박 수단으로 사용합니다.
    > 
    
- 피해자 파일 게시
    
    ![dragonforce_02](https://blog.plura.io/cdn/respond/dragonforce_02.png)
    
    > 협상이 지연되거나 거부될 경우, 탈취한 내부 문서나 민감 파일을 업로드하여 추가 압박을 가합니다.
    > 

---

### ⚙️ 동작 메커니즘

### ① 복호화 불가능한 파일 암호화

- ChaCha8을 이용한 빠른 파일 암호화
- RSA-4096으로 세션 키 암호화

### ② 백업 및 복구 기능 무력화

- `vss` 호출
- `cmd.exe /c C:\Windows\System32\wbem\WMIC.exe shadowcopy where "ID='{***}'" delete` 실행

### ③ 감지 회피 및 자동 실행 등록

- `RunOnce` 레지스트리에 persistence 등록
- `readme.txt`에 랜섬노트 생성 후 사용자 데스크탑에 배치

---

### ❗탐지가 어려운 이유

| 탐지 회피 요소 | 설명 |
| --- | --- |
| 고속 암호화 | 수천 개 파일을 수초 내 암호화하여 탐지 대응 시간 부족 |
| 시스템 복원 삭제 | 복구 지점 무력화로 파일 복원 불가능 |
| 표준 LOLBin 사용 | PowerShell, rundll32 등 정상 Windows 구성 요소만 사용 |

---

### 🛡️ MITRE ATT&CK 매핑

| 전술(Tactic) | 기법 (TID) | 설명 |
| --- | --- | --- |
| Impact | T1486 데이터 암호화 | ChaCha8 + RSA-4096 파일 암호화 |
| Defense Evasion | T1070.004 파일 삭제 | 원본 삭제, 로그 회피 |
| Defense Evasion | T1055.001 프로세스 인젝션 | 정상 프로세스 내에서 실행 (정황 의심됨) |
| Execution | T1059.001 PowerShell 사용 | LOLBin으로 암호화 시작 |
| Persistence | T1547.001 Run Key 등록 | RunOnce에 악성 명령어 등록 |

---

### 🔍 PLURA-XDR 탐지 전략 기반 룰 요약

| 카테고리 | 필터 내용 요약 | 중요도 |
| --- | --- | --- |
| 백업 방해 | VSS 파일 삭제 (`vssadmin delete`) | 높음 |
| 권한 상승 | `Administrators`권한 획득 후 프로세스 종료 | 높음 |
| 복구 방해 | `bcdedit`,`wbadmin`,`wmic`통한 복구 무력화 (T1490) | 높음 |
| 파일 조작 | 파일 이름 변경 및`readme.txt`생성 감지 (T1222, T1486) | 중간 |
| UI 변조 | 바탕화면 변경, 배경 이미지 및 사용자 설정 레지스트리 수정 | 낮음 |

---

## 주요 현상

- 변경된 배경화면
    
    ![dragonforce_03](https://blog.plura.io/cdn/respond/dragonforce_03.png)
    
    > 감염 후, 바탕화면 배경을 위협 메시지가 담긴 이미지로 변경하여 사용자에게 랜섬웨어 감염 사실을 인지시키고 심리적 압박을 유도합니다.
    > 
    
- 생성된 랜섬노트
    
    ![dragonforce_04](https://blog.plura.io/cdn/respond/dragonforce_04.png)
    
    > 각 디렉터리에 `readme.txt` 형태의 랜섬노트를 생성하여 복호화 방법 제공합니다.
    > 
    
- 파일 아이콘 변경
    
    ![dragonforce_05](https://blog.plura.io/cdn/respond/dragonforce_05.png)
    
    > 암호화된 파일들은 확장자가 `.dragonforce_encrypted`로 변경되며, 기본 프로그램 연동이 해제되어 아이콘이 비정상적으로 표시됩니다.
    > 

- DragonForce 메신저 지원
    
    ![dragonforce_06](https://blog.plura.io/cdn/respond/dragonforce_06.png)
    
    ![dragonforce_07](https://blog.plura.io/cdn/respond/dragonforce_07.png)
    
    > 피해자가 직접 공격자와 연락할 수 있도록 Tor 기반 메신저 페이지를 운영하며, 협상 및 복호화 테스트를 유도합니다.
    > 
    
    ![dragonforce_08](https://blog.plura.io/cdn/respond/dragonforce_08.png)
    
    > 최대 3개, 4MB 크기의 파일 복구를 제공하여, 신뢰를 얻는 기능도 제공되고 있습니다.
    > 
    

---

## 실전 PLURA-XDR 탐지

> 이 분석은 PLURA-XDR 기반에서 탐지된 DragonForce 랜섬웨어의 특징을 바탕으로 작성되었습니다.
> 
- 상관분석 탐지
    
    ![dragonforce_09](https://blog.plura.io/cdn/respond/dragonforce_09.png)
    
    > PLURA-XDR에서는 이벤트 기반 탐지뿐만 아니라 다양한 공격 단계를 상관 분석하여 DragonForce와 같은 다단계 랜섬웨어 행위를 정밀하게 탐지할 수 있습니다.
    > 
    

### PLURA 탐지 세부사항

1. 볼륨 쉐도우 삭제 탐지
    
    ```xml
    <EventData>
    	<Data Name="SubjectUserSid">SID</Data>
    	<Data Name="SubjectUserName">qubit</Data>
    	<Data Name="SubjectDomainName">DESKTOP-Qubit</Data>
    	<Data Name="SubjectLogonId">0x1dedd</Data>
    	<Data Name="NewProcessId">0x16d8</Data>
    	<Data Name="NewProcessName">C:\Windows\System32\wbem\WMIC.exe</Data>
    	<Data Name="TokenElevationType">%%1937</Data>
    	<Data Name="ProcessId">0x538</Data><Data Name="CommandLine">C:\Windows\System32\wbem\WMIC.exe  shadowcopy where "ID='{ID}'" delete</Data>
    	<Data Name="TargetUserSid">S-1-0-0</Data>
    	<Data Name="TargetUserName">-</Data>
    	<Data Name="TargetDomainName">-</Data>
    	<Data Name="TargetLogonId">0x0</Data>
    	<Data Name="ParentProcessName">C:\Windows\System32\cmd.exe</Data>
    	<Data Name="MandatoryLabel">S-1-16-12288</Data>
    </EventData>
    ```
    
2. 프로세스 종료 탐지
    
    ```xml
    <EventData>
    	<Data Name="RuleName">-</Data>
    	<Data Name="UtcTime">2025-07-02 07:28:52.533</Data>
    	<Data Name="ProcessGuid">{abcde123-abc9-1234-a100-000000000300}</Data>
    	<Data Name="ProcessId">7652</Data>
    	<Data Name="Image">C:\Users\qubit\AppData\Local\Microsoft\OneDrive\OneDrive.exe</Data>
    	<Data Name="User">DESKTOP-QUBIT\qubit</Data>
    </EventData>
    ```
    
3. 파일 및 디렉토리 권한 수정 탐지
    
    ```xml
    <EventData>
    	<Data Name="SubjectUserSid">SID</Data>
    	<Data Name="SubjectUserName">qubit</Data>
    	<Data Name="SubjectDomainName">DESKTOP-QUBIT</Data>
    	<Data Name="SubjectLogonId">0x1dedd</Data>
    	<Data Name="ObjectServer">Security</Data>
    	<Data Name="ObjectType">File</Data>
    	<Data Name="ObjectName">C:\ProgramData\Microsoft\User Account Pictures\user-40.png</Data><Data Name="HandleId">0x864</Data>
    	<Data Name="TransactionId">{00000000-0000-0000-0000-000000000000}</Data>
    	<Data Name="AccessList">%%1538\r\n\t\t\t\t%%1541\r\n\t\t\t\t%%4416\r\n\t\t\t\t%%4417\r\n\t\t\t\t%%4418\r\n\t\t\t\t%%4419\r\n\t\t\t\t%%4420\r\n\t\t\t\t%%4423\r\n\t\t\t\t%%4424\r\n\t\t\t\t</Data>
    	<Data Name="AccessReason">%%1538:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%1541:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4416:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4417:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4418:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4419:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4420:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4423:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4424:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t</Data>
    	<Data Name="AccessMask">0x12019f</Data>
    	<Data Name="PrivilegeList">-</Data>
    	<Data Name="RestrictedSidCount">0</Data>
    	<Data Name="ProcessId">0x17f0</Data>
    	<Data Name="ProcessName">C:\Users\qubit\Desktop\70afd8efb34382badead93ae104d958256de6be8054227ccc85fe95d5c5f9db0\70afd8efb34382badead93ae104d958256de6be8054227ccc85fe95d5c5f9db0.exe</Data><Data Name="ResourceAttributes">-</Data>
    </EventData>
    ```
    
4. 랜섬파일 수정 탐지
    
    ```xml
     <EventData>
    	 <Data Name="RuleName">-</Data>
    	 <Data Name="UtcTime">2025-07-02 07:29:00.063</Data>
    	 <Data Name="ProcessGuid">{abcde123-abc9-1234-a100-000000000300}</Data>
    	 <Data Name="ProcessId">6128</Data>
    	 <Data Name="Image">C:\Users\qubit\Desktop\DragonForce.exe</Data>
    	 <Data Name="TargetFilename">C:\Users\Default\Documents\readme.txt</Data>
    	 <Data Name="CreationUtcTime">2025-07-02 07:29:00.063</Data>
    	 <Data Name="User">DESKTOP-QUBIT\qubit</Data>
    </EventData>
    ```
    
---

### 대응 및 보안 권장 사항

- Defender의 제어된 폴더 액세스(CFA) 기능 활성화
- VSS 서비스 주기적 상태 모니터링 및 변경 이벤트 알림

---

## 📚 PLURA-Blog

- [지금 랜섬웨어가 진행 중이라면, 당신은 알 수 있습니까?](https://blog.plura.io/ko/column/why-plura-xdr-merit-ransomware/)
- [고급 랜섬웨어 대응 전략: 노트북 전원 차단이 왜 중요한가](https://blog.plura.io/ko/respond/ransomware-shutdown-awareness/)
- [협박성 디도스 공격, 랜섬디도스(RansomDDoS)](https://blog.plura.io/ko/threats/ransomddos/)
- [PC와 서버의 백신은 윈도우즈 디펜더만으로 충분하다](https://blog.plura.io/ko/column/why-edr-is-necessary/)
