---
title: "RAM 안의 비밀번호를 노린다 – T1003.001: LSASS 메모리 덤프 공격"
date: 2025-06-20
draft: false
description: "T1003.001 기법(LSASS 메모리 덤프)을 활용한 자격 증명 탈취 방법과 Event ID 기반 탐지·LSASS PPL·Credential Guard 등 대응 전략을 정리합니다."
featured_image: "/cdn/respond/attck-T1003-os-credential-dumping.png"
tags: ["MITRE ATT&CK", "T1003.001", "LSASS Memory", "Credential Dumping", "RAM 공격", "EDR", "PLURA‑XDR", "사이버보안"]
---

> **요약 3줄**  
> 1️⃣ 공격자는 `lsass.exe`의 메모리를 덤프해 패스워드 해시·토큰을 탈취합니다.  
> 2️⃣ _Event ID 4656/10_ 등 프로세스‑핸들 접근 로그로 탐지가 가능합니다.  
> 3️⃣ **LSASS PPL + Credential Guard + ASR 규칙**으로 선제 차단하세요.

![ATT&CK 아이콘과 LSASS 메모리 덤프 개요](https://blog.plura.io/cdn/respond/attck-T1003-os-credential-dumping.png)

<!--more-->

## 🔎 관련 MITRE ATT&CK 기법

| ID | 이름 | 핵심 내용 |
|----|------|-----------|
| **T1003.001** | **OS Credential Dumping: LSASS Memory** | `lsass.exe` 프로세스 메모리를 덤프하여 패스워드 해시·Kerberos 티켓 등을 추출 |
| **T1560.001** | Archive Collected Data: `.zip` | 탈취된 해시를 ZIP으로 압축·암호화 후 외부로 반출 |
| **T1078** | Valid Accounts | 덤프한 해시 재사용으로 수평 이동(Lateral Movement) |

> 📌 **왜 LSASS인가?**  
> LSASS(Local Security Authority SubSystem)는 로그인·SSO 자격 증명을 메모리에 평문(또는 해시) 형태로 보유합니다. 시스템 권한만 획득하면 _공격 대비 비용 ≤ 보상_ 구조가 완성됩니다.

---

## 🧑‍💻 공격 워크플로 (예시)

1. **권한 상승** – `CVE‑2022‑24521` 등 커널 취약점·DACL 오류로 SYSTEM 권한 확보  
2. **메모리 덤프**  
   ```powershell
   procdump.exe -accepteula -ma lsass.exe lsass.dmp   # Sysinternals 활용
   rundll32.exe C:\windows\system32\comsvcs.dll, MiniDump  # LOLBIN 기법
   ```

3. **크랙** – `Mimikatz sekurlsa::minidump lsass.dmp`
4. **재사용** – `psexec /hashes:<NTLM>`으로 SMB 세션 가로채기

---

## 🛠 탐지 포인트

| 로그 원천                | 이벤트 ID                                  | 의미                                                 |
| -------------------- | --------------------------------------- | -------------------------------------------------- |
| **Windows Security** | **4656** (특권 프로세스 핸들 요청)                | `ProcessName: lsass.exe`에 대한 `GrantedAccess: 0x40` |
| **Sysmon**           | **10**                                  | `lsass.exe`에 **PROCESS\_ACCESS** 발생                |
| **ETW**              | `Microsoft‑Windows‑Kernel‑Process/4674` | `HANDLE_DUPLICATE` → 핸들 복제 시도                      |

> 🎯 **팁** – “`TargetImage contains lsass.exe` AND `CallTrace not contains \Windows\System32\lsass.exe`” 조건으로 오탐 최소화

---

## 🛡 대응 · 차단 전략

| 조치                                      | 명령/경로                                                                                | 설명                                 |
| --------------------------------------- | ------------------------------------------------------------------------------------ | ---------------------------------- |
| **LSASS PPL** (Protected Process Light) | `reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v RunAsPPL /t REG_DWORD /d 1 /f` | 서명된 드라이버가 없으면 핸들 접근 차단             |
| **Credential Guard**                    | `Windows Features → Device Guard → Enable`                                           | 가상화‑기반 보안(VBS)으로 인증 토큰 격리          |
| **ASR 규칙**                              | `Block credential stealing from LSASS` <br>`GUID: 9E6B...`                           | Microsoft Defender for Endpoint 적용 |
| **PLURA‑XDR**                           | 실시간 핸들 접근 로깅 + MITRE 매핑                                                              | EVENT 10→자동 차단 & KQL 검색 지원         |

```powershell
# LSASS PPL 활성화 스크립트 (Windows 10 20H2+)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d 1 /f
Write-Output "[+] LSASS가 Protected Process Light 모드로 전환되었습니다."
```

> ☢ **주의** : Registry 수정 전, 테스트 환경에서 호환성 확인 필수입니다.

---

## 📚 실제 사례 & 교훈

| 연도       | 캠페인               | LSASS 연관성·시사점                                |
| -------- | ----------------- | -------------------------------------------- |
| **2022** | **HermeticWiper** | 디스크 파괴 이전 LSASS 메모리와 복구 섹터에 흔적을 남겨 복원 방해     |
| **2017** | **NotPetya**      | WMI·PSExec로 확산 시 탈취한 해시 재사용 → 광범위 수평 이동      |
| **2019** | **LockerGoga**    | 빠른 암호화와 병행해 LSASS 접근, 로컬·도메인 해시 탈취로 감염 범위 확대 |

---

## ⚖ 면책 조항

본 글은 교육·연구 목적입니다. 운영 환경에 설정을 적용하기 전 **전문가와 상의**하고, 백업 및 테스트 절차를 준수하십시오. 공격 그룹·샘플별 동작은 서로 다를 수 있습니다.

---

## 🔚 결론

* **lsass.exe 메모리**는 “황금 열쇠”입니다. 관리자는 *EVENT ID → LSASS PPL → Credential Guard* 세 단계를 반드시 적용하세요.
* **공격보다 탐지가 먼저**입니다. EDR / SIEM에 상세 이벤트를 전송해 MITRE ATT\&CK 기반 모니터링 체계를 구축하세요.
* **PLURA‑XDR**는 LSASS 핸들 요청을 실시간 가시화하고, 차단 정책을 자동화해 침해 범위를 최소화합니다.

> *Protect Process, Protect Credentials, Protect Enterprise.*
