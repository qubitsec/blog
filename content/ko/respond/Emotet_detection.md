---
date: 2023-02-06T00:00:00
description: 
featured_image: 
tags: 
title: "EMOTET 탐지 필터"
---

![excel](https://github.com/user-attachments/assets/29f395fe-2696-452c-baea-303f6e6f835f)

> 이모텟(Emotet)은 개인으로부터 신용카드 정보 등을 훔치는 뱅킹 트로이 목마 바이러스이다. <br>
> 2014년부터 활동했으며 수년 동안 크게 발전해 기업 네트워크에 침투하고 다른 악성코드 유형으로 확산되는 중대한 위협이 되었다.
>
> 미국 국토안보부(DHS)는 2018년 7월 이모텟에 대한 경보를 발령하면서 "주로 다른 뱅킹 트로이 목마 바이러스의 다운로더 또는 드롭퍼(Dropper)로 기능하는 발전된 모듈식 뱅킹 트로이 목마 바이러스"라고 설명하면서, 퇴치하기가 매우 어려우며 일반적인 시그니처 기반 탐지를 회피하고 스스로 확산된다고 경고했다.  <br>
> 이 경보에서는 "이모텟 감염으로 주 정부나 지역자치단체들은 사건당 최대 100만 달러의 해결 비용이 발생했다"고 설명했다.

## EMOTET 탐지 필터

### 1. EMOTET 파일 수집

> * Excel 첨부파일을 통해 유포되는 것이 일반적이다.
> * 수집된 엑셀 파일 확인 (Virustotal)
> ![emotet00](https://github.com/user-attachments/assets/6603c3a9-8d9b-4060-af74-4d5255e0f76c)
> [그림1] 분석 진행할 Excel파일에 대한 Virustotal 결과

<br>

### 2. EMOTET 파일 실행

> * 감염된 엑셀 파일 실행 후 ‘콘텐츠 사용’ 버튼 클릭을 유도하는 문구를 확인할 수 있습니다.
>   ![emotet01](https://github.com/user-attachments/assets/73648c89-f963-43cf-b425-af5c8c024aa5)
>   [그림2] 매크로 허용 유도 문구

<br>

### 2-1. PLURA 탐지 필터

> * 필터명 : 콘텐츠 사용
> ![emotet11](https://github.com/user-attachments/assets/964ca044-b6af-41d1-8b62-65078cc11eb3)
> [그림3] 필터명: 콘텐츠 사용 탐지 로그

> * 필터명 : 엑셀 바로가기 생성
> ![emotet12](https://github.com/user-attachments/assets/2c7fc921-1bd5-4db6-b0ae-8d2ae42c5a90)
> [그림4] 필터명: 엑셀 바로가기 탐지 로그

<br>

### 3. 숨겨진 시트 해제

> * 숨겨진 시트를 모두 ‘숨기기 취소’ 처리 합니다.
> * 6개의 시트 모두 ‘시트 보호 해제’ 처리를 합니다.
> ![emotet03](https://github.com/user-attachments/assets/c70dd491-998e-4f16-b976-f52ed3619503)
> [그림5] 시트 숨기기 취소 및 시트 보호 해제

<br>

### 4. 매크로 항목 적용

> * 매크로 상자에서 ‘Auto_Open0.’를 선택합니다.
> * ‘Sheet6’의 ‘G열’을 숨기기 취소합니다.
> ![emotet06](https://github.com/user-attachments/assets/abc39208-5eef-42fb-b68b-a725b3f5aa68)
> [그림6] 매크로 허용

<br>

### 5. 셀 수식

> * ‘숨기기 취소’후 ‘G열’의 셀 수식입니다.
> ![emotet08](https://github.com/user-attachments/assets/fe4b6143-eeae-4642-8363-513ea76dc4b5)
> [그림7] G열의 숨겨졌던 셀 수식

<br>

### 6. ‘콘텐츠 사용’ 버튼 클릭(감염 진행)

> * ‘콘텐츠 사용’ 버튼을 클릭하면 순차적으로 명령어가 실행됩니다.
> * C:\Windows\System32 에 DLL유형으로 Emotet파일을 다운로드 합니다.
> * 다운받은 파일은 regsrv32.exe를 사용하여 DLL파일을 실행합니다.
> * 실행된 Emotet파일은 C&C서버를 통해 추가 명령을 받아 정보 탈취 등의 악성행위를 수행합니다.
> ![emotet09](https://github.com/user-attachments/assets/eedb5939-e34c-405b-ad3b-f6eb147b7cfa)
> [그림8] G열의 공격 명령어들

<br>

### 6-1. PLURA 탐지 필터

> * 필터명 : 이모텟 DLL 악성 파일 실행 (1)
> ![emotet13](https://github.com/user-attachments/assets/eef93658-fba7-4209-9967-c7120c5f43b2)
> 
> * 필터명 : 이모텟 DLL 악성 파일 실행 (2)
> ![emotet14](https://github.com/user-attachments/assets/2c8de873-1f5a-476d-bf79-d1adf9f43d54)
>
> * 필터명 : 이모텟 DLL 악성 파일 실행 (3)
> ![emotet15](https://github.com/user-attachments/assets/d5d1095f-be88-4f31-b771-5a6bd3936734)
>
> * 필터명 : 이모텟 DLL 악성 파일 실행 (4)
> ![emotet16](https://github.com/user-attachments/assets/ddb34d98-cc0d-4fea-9018-3320b6bdf6fe)
> [그림9] 필터명: 이모텟 DLL 악성 파일 실행 (1~4)

<br>

### 6-2. PLURA 상관 분석 탐지 필터

> * 상관 분석 탐지 필터를 통해 ‘정탐률’을 높일 수 있습니다.
> ![emotet18](https://github.com/user-attachments/assets/202e826c-4413-4710-b8e1-14eb78cda9d7)
> [그림10] 상관 분석 필터명: Emotet

<br>

### 7. C&C

> * aldina[.]jp/wp-admin/YvD46yh/
> * alliance-habitat[.]com/cache/lE8/
> * anguklaw[.]com/microsoft-clearscript/oVgMlzJ61/
> * andorsat[.]com/css/5xdvDtgW0H4SrZokxM/

<br>

### 8. IOC

> * SHA256 : 76323e3a53815b76193d22984da10a9d492d934d49a611fd541e7a78a88cf3c9

<br>

### 출처

* https://www.itworld.co.kr/tags/81617/Emotet/122207#csidxb0960f83251f39d83ca06e0918e9890
* https://www.virustotal.com/gui/file/76323e3a53815b76193d22984da10a9d492d934d49a611fd541e7a78a88cf3c9
* https://asec.ahnlab.com/ko/41365/













