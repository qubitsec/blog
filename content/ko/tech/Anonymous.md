---
date: 2023-02-20T00:00:00
description: 
featured_image: 
tags: 
title: "ANONYMOUS LOGON, NTLM V1 사용 정책 중지"
---

![column-20230220-4](https://github.com/user-attachments/assets/2611df5b-5c37-4cf1-8ee8-56ee3c8cc0db)

## ANONYMOUS LOGON?
익명 사용자 계정을 통해 인증을 받지 않은 상태에서 파일과 폴더에 액세스할 수 있다.

## NTLM V1?
NT(New Technology) LAN Manager

사용자에게 인증, 무결성 및 기밀성을 제공하기 위한 Microsoft 보안 프로토콜 제품

가능한 모든 8자리 암호 해시 순열을 6시간 이내에 해독할 수 있다고 한다.

## ANONYMOUS LOGON 비활성화 방법
참고: KISA 주요정보통신기반시설 W-42

|항목|내용|
|---|---|
| 점검내용	| ‘SAM 계정과 공유의 익명 열거 허용 안 함’ 정책 설정 여부 점검 | 
|점검목적	|익명 사용자에 의한 악의적인 계정 정보 탈취를 방지하기 위함|
|판단기준-양호	|해당 보안 옵션 값이 설정 되어 있는 경우|
|판단기준-취약	|해당 보안 옵션 값이 설정 되어 있지 않는 경우|
|점검 및 조치 사례	|Windows 2003, 2008, 2012, 2016, 2019 <br> Step 1) 시작> 실행> SECPOL.MSC> 로컬 정책> 보안 옵션 <br> Step 2) “네트워크 액세스 : SAM 계정과 공유의 익명 열거 허용 안 함”과 “네트워크 액세스 : SAM 계정의 익명 열거 허용 안 함”에 “사용” 선택|

 
## NTLM V1 비활성화 방법
참고: KISA 주요정보통신기반시설 W-77


|항목|내용|
|---|---|
|점검내용	|LAN Manager 인증 수준 적절성 점검|
|점검목적|	Lan Manager 인증 수준 설정을 통해 네트워크 로그온에 사용할 Challenge/Response 인증 프로토콜을 결정하며, 안전한 인증 절차를 적용하기 위함 |
|판단기준-양호	|“LAN Manager 인증 수준” 정책에 “NTLMv2 응답만 보냄”이 설정되어 있는 경우|
|판단기준-취약	|“LAN Manager 인증 수준” 정책에 “LM” 및 “NTLM”인증이 설정되어 있는 경우|
|점검 및 조치 사례	|Windows 2003, 2008, 2012, 2016, 2019 <br> Step 1) 시작> 실행> SECPOL.MSC> 로컬 정책> 보안 옵션 <br> Step 2) “네트워크 보안: LAN Manager 인증 수준” 정책에 NTLMv2 응답만 보내기 설정|

## 참고
* 6시간 이내에 모든 표준 Windows 암호를 크래킹, https://arstechnica.com/information-technology/2012/12/25-gpu-cluster-cracks-every-standard-windows-password-in-6-hours/
