---
date: 2025-08-09
draft: true
description: "PowerShell Constrained Language Mode(CL​M)의 필요성과 운영 방법"
featured_image: "cdn/tech/powershell_clm.png"
tags: ["PowerShell", "Windows Security", "CLM", "Endpoint Security", "Privilege Management"]
title: "왜 PowerShell Constrained Language Mode(CL​M)를 사용해야 하는가?"
---

## PowerShell Constrained Language Mode란?

**PowerShell Constrained Language Mode(CL​M)**는  
Windows 환경에서 PowerShell의 실행 기능을 제한하여  
악성 스크립트 실행, 무단 시스템 변경, 권한 오남용 등을 방지하는 보안 모드입니다.

기본적으로 PowerShell은 관리자 권한이 없어도 많은 시스템 리소스에 접근할 수 있습니다.  
그러나 기업 환경에서는 **대부분의 PC 사용자가 PowerShell을 직접 사용할 필요가 없습니다.**

---

## 왜 CL​M이 필요한가?

- **권한 과다 부여 문제**
  - 집 PC뿐만 아니라 회사 PC에도 불필요하게 강력한 명령 실행 권한이 부여되어 있음
- **실제 사용률**
  - IT 부서나 개발자 외에는 PowerShell 사용률이 극히 낮음
- **보안 관리 효율성**
  - "아무도 타지 않는 F1 경주차를 회사 주차장에 세워두는 격" → 불필요한 성능·위험

> 비유: 집 근처 마트에 가는데 굳이 F1 경주차를 타야 할까요?  
> CL​M은 ‘일반 승용차’처럼 일상 업무에 필요한 기능만 제공하게 합니다.

---

## CL​M 동작 방식

![powershell_clm_mode](https://blog.plura.io/cdn/column/powershell_clm_diagram.png)

- 허용되는 명령어 및 .NET API만 사용 가능
- COM 객체, Win32 API, Add-Type 같은 고위험 함수 호출 제한
- 로컬 및 원격에서 실행되는 스크립트의 권한 레벨 자동 축소

---

## 운영 환경 예시

### 1. 그룹 정책(GPO) 적용
- Active Directory 환경에서 OU별로 CL​M 강제 적용
- 특정 보안 그룹만 Full Language Mode 허용

### 2. 로컬 보안 정책 적용
- 단독 PC 환경에서는 `__PSLockdownPolicy` 설정
- 보안 제품과 연동하여 이벤트 기반 전환 가능

---

## 보안 효과

- **제로데이 방어**
  - 아직 패치되지 않은 PowerShell 기반 악성 코드 차단
- **내부자 위협 감소**
  - 일반 직원이 PowerShell로 권한 상승 공격을 시도하는 것 방지
- **포렌식 강화**
  - 모든 PowerShell 명령 실행 내역을 이벤트 로그로 기록 가능

![powershell_attack_logs](https://blog.plura.io/cdn/column/powershell_attack_logs.png)

---

## 결론

PowerShell CL​M은  
- 불필요한 권한을 제거  
- 보안 사고 발생 가능성을 줄이며  
- 관리 효율성을 높이는 **간단하지만 강력한 방어책**입니다.

기업 환경에서 CL​M은 선택이 아니라 **기본 보안 설정**이 되어야 합니다.

---

### 📖 함께 읽기
- [Microsoft 공식 문서 – PowerShell Constrained Language Mode](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes)
- [Windows Defender Application Control과 CL​M 연계](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/wdac-and-clm)
- [실무 적용 가이드: 그룹 정책을 통한 CL​M 배포](https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/)

---
