---
date: 2023-01-11T02:00:00
draft: false
title: "마이터 어택 관점에서 Emotet (이모텟) 탐지하기"
description: ""
featured_image: "cdn/respond/detecting-emotet-with-mitre-attck-1.png"
tags: ["emotet", "마이터어택"]
---

**이모텟 (Emotet ) 악성코드는 2022년 하반기 일본에 유행하여 큰 피해를 주었고**

우리나라에도 2022년 11월 알약에서 주의가 필요하다고 발표하고 있습니다.

주로 스팸메일을 통하여 유포되고 있습니다.
<!--more-->
![detecting-emotet-with-mitre-attck](https://blog.plura.io/cdn/respond/detecting-emotet-with-mitre-attck-1.png)

<br>

이런 알림 주의보처럼 이미 알약 등 여타의 안티 바이러스 제품에서 탐지 규칙(Rule)을 제공하고 있지만

여전히 피해가 발생하고 있습니다.

<br>

기본적으로 매크로 기반의 악성 코드는 변경이 매우 쉽습니다.

악성코드 제작자는 매우 빠르게 코드를 변경하여 안티 바이러스 탐지를 우회시킬 수 있습니다.

<br>

**우리는 마이터 어택 관점에서 원천적으로 우회 공격을 포함하여 빠르게 탐지할 수 있는 방안을 제안합니다.**
<br>
<br>

## 1. Emotet (이모텟) 악성 코드 기본 동작 원리

**1) PC에서 실행된 워드(엑셀, HWP, PDF 등) 파일은 백그라운드로 C&C 서버에 접속하여 악성코드를 다운 받습니다.**

**2) 악성코드는 여러 단계를 거쳐 트로이 목마를 설치하여 원격 접속이 가능하도록 해커와 통신합니다.**

<br>

## 2. 마이터 어택 관점에서 이모텟 탐지하기

**1) 이모텟 악성코드가 실행되면 백그라운드로 외부  C&C 서버 접속하여 파일 다운로드하도록 동작되어 있습니다.**
<br>

**2) 악성코드는 파워쉘을 호출하여 실행합니다. 이때 코드는 base64 인코딩되어 내용을 하기 위하여 디코딩해야 합니다.**

해당 악성코드를 받는 C&C 서버는 주소 형태를 분석할 때 Wordpress 이용 사이트를 공격하여 악성 코드를 숨겨 두었습니다.

해당 사이트가 외관상 보통의 사이트였다면 해커는 장기간 C&C 서버로 활용할 수 있을 것입니다.

> **- PowerShell[1059.001]** <br>
![m-2-800x372](https://github.com/user-attachments/assets/bf898135-6d43-4288-b0e5-4ebfe7995f40)<br><br>
> 공격자는 실행을 위해 PowerShell 명령 및 스크립트를 남용 할 수 있습니다.<br>
> PowerShell은 Windows 운영 체제에 포함 된 강력한 대화 형 명령 줄 인터페이스 및 스크립팅 환경입니다.<br>
> 공격자는 PowerShell을 사용하여 정보 검색 및 코드 실행을 포함한 다양한 작업을 수행 할 수 있습니다.<br>
> 예를 들어 실행 파일을 실행하는 데 사용할 수 있는 Start-Process cmdlet과 로컬 또는 원격 컴퓨터에서 명령을 실행하는 Invoke-Command cmdlet이 있습니다.<br>
> (PowerShell을 사용하여 원격 시스템에 연결하려면 관리자 권한이 필요함)
<br>

**3) 계속하여 PowerShell 을 이용하여 다운로드 받은 파일을 임시 폴더 (Temp)에 저장 > 실행 > 삭제 순서로 진행됩니다.**

> - 임시 폴더 Temp\ __PSScriptPolicyTest_krutadkh.taj.ps1
![m-6](https://github.com/user-attachments/assets/9644c444-42b0-4853-b9b6-b6dfbcce83d8)
![m-7](https://github.com/user-attachments/assets/6b163ed0-3015-4502-9a29-4762398b14da)

<br>

**4)  악성 코드가 외부 C&C 서버에 접속하기 위하여 생성한 PowerShell 용 스크립트 탐지**

이 스크립트 내에서는 명확하게 C&C 서버가 워드프레스 사이트인 것을 확인할 수 있습니다.

> - 마이터 어택 탐지 필터 ID: PowerShell [T1059.001]
![m-5-1024x295](https://github.com/user-attachments/assets/4324b75e-3366-4838-8d1a-aaff3a81c0d0)

<br>

**5) 이번에는 악성코드가 스케줄러 등록합니다.**

![m-9-300x86](https://github.com/user-attachments/assets/1ef730eb-89ea-4982-9803-b8d67fba420b)<br>

> - 이벤트 로그의 상세 내역<br><br>
![m-10-273x300](https://github.com/user-attachments/assets/453004ac-dd54-4a6a-a316-c389770fb370)<br><br>
> - XML 뷰어에서 확인<br><br>
![m-11-225x300](https://github.com/user-attachments/assets/899ec693-cb58-4743-bc32-5b37356c99a4)

<br>

**6) 이제 악성코드는 해당 시스템에 트로이목마를 설치하여 원격에서 접속이 가능하도록 합니다.**<br>
> - 시스템 탐지 필터 : exe 파일 생성 by PowerShell <br>
> **PowerShell 프로세스에 의해 exe 파일 생성 시 발생되는 로그입니다.**
![m-3](https://github.com/user-attachments/assets/0b9e940d-b66a-4370-a362-e2bd40283e34)

<br>

**7) 매트릭스를 이용하여 공격이 어떤 단계에서 진행되고 있는지 한눈에 파악할 수 있습니다.**

![m-4-800x450](https://github.com/user-attachments/assets/6e9624b2-869e-484c-b0af-d17bafdb84e5)

<br>

마이터 어택 프레임워크의 장점은 악성 코드를 탐지하는 종래의 방식에서 한 발짝 더 나아가

악성 코드가 어떻게 해동하는 가를 모니터링하므로, 우회 공격을 포함하여 보다 넓은 범위에서 탐지할 수 있습니다.

📖 함께 읽기

1. [wiki_emotet](https://en.wikipedia.org/wiki/Emotet)

2. [alyac_emotet](https://blog.alyac.co.kr/4971)



