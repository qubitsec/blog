---
date: 2023-02-20T00:00:00
description: 
featured_image: 
tags: ["ANONYMOUS LOGON", "NTLM V1", "보안 정책", "Microsoft", "KISA", "LAN Manager", "인증 보안"]
title: "ANONYMOUS LOGON, NTLM V1 사용 정책 중지"
---

![column-20230220-4](https://github.com/user-attachments/assets/2611df5b-5c37-4cf1-8ee8-56ee3c8cc0db)

## ANONYMOUS LOGON란?

익명 사용자 계정을 통해 **인증 없이 파일 및 폴더에 접근**할 수 있는 기능을 말합니다.  
이 설정이 활성화된 상태에서는 **보안 위협**이 증가할 수 있습니다.

---

## NTLM V1이란?

**NT (New Technology) LAN Manager**는 사용자 인증, 무결성, 기밀성을 제공하기 위한 **Microsoft 보안 프로토콜**입니다.  
하지만 NTLM V1은 **낮은 보안 수준** 때문에 오늘날 비활성화가 권장됩니다.  
- **보안 약점**: 8자리 암호 해시의 모든 조합을 6시간 이내에 해독 가능.  
- [관련 기사 읽기](https://arstechnica.com/information-technology/2012/12/25-gpu-cluster-cracks-every-standard-windows-password-in-6-hours/)

---

## ANONYMOUS LOGON 비활성화 방법

**참고**: [KISA 주요정보통신기반시설 W-42](https://github.com/QubitSecurity/VAS/tree/main/v.2021.03/windows)

### 설정 방법

| 항목            | 내용                                                                                      |
|-----------------|------------------------------------------------------------------------------------------|
| **점검 내용**   | `SAM 계정과 공유의 익명 열거 허용 안 함` 정책 설정 여부 점검                                    |
| **점검 목적**   | 익명 사용자에 의한 악의적인 계정 정보 탈취를 방지하기 위함                                          |
| **양호 기준**   | 보안 옵션 값이 설정되어 있는 경우                                                            |
| **취약 기준**   | 보안 옵션 값이 설정되어 있지 않는 경우                                                       |
| **조치 방법**   | Windows 2003, 2008, 2012, 2016, 2019<br> 1. **시작** > **실행** > `SECPOL.MSC`<br> 2. **로컬 정책** > **보안 옵션**<br> 3. `네트워크 액세스: SAM 계정과 공유의 익명 열거 허용 안 함` 및 `네트워크 액세스: SAM 계정의 익명 열거 허용 안 함`을 **사용**으로 설정 |

---

## NTLM V1 비활성화 방법

**참고**: [KISA 주요정보통신기반시설 W-77](https://github.com/QubitSecurity/VAS/tree/main/v.2021.03/windows)

### 설정 방법

| 항목            | 내용                                                                                      |
|-----------------|------------------------------------------------------------------------------------------|
| **점검 내용**   | LAN Manager 인증 수준 적절성 점검                                                            |
| **점검 목적**   | LAN Manager 인증 수준 설정을 통해 네트워크 로그온 인증 프로토콜을 결정하고 안전한 인증 절차를 적용하기 위함                     |
| **양호 기준**   | `LAN Manager 인증 수준` 정책이 `NTLMv2 응답만 보냄`으로 설정되어 있는 경우                          |
| **취약 기준**   | `LAN Manager 인증 수준` 정책이 `LM` 및 `NTLM` 인증으로 설정되어 있는 경우                          |
| **조치 방법**   | Windows 2003, 2008, 2012, 2016, 2019<br> 1. **시작** > **실행** > `SECPOL.MSC`<br> 2. **로컬 정책** > **보안 옵션**<br> 3. `네트워크 보안: LAN Manager 인증 수준` 정책을 `NTLMv2 응답만 보내기`로 설정 |

---

## 참고 자료

- [6시간 이내에 모든 표준 Windows 암호 크래킹 가능](https://arstechnica.com/information-technology/2012/12/25-gpu-cluster-cracks-every-standard-windows-password-in-6-hours/)
- [KISA 주요정보통신기반시설 보안 가이드](https://www.kisa.or.kr/)
