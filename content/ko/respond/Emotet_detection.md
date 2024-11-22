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

### 숨겨진 시트 해제

> * 숨겨진 시트를 모두 ‘숨기기 취소’ 처리 합니다.
> * 6개의 시트 모두 ‘시트 보호 해제’ 처리를 합니다.
> ![emotet03](https://github.com/user-attachments/assets/c70dd491-998e-4f16-b976-f52ed3619503)
> [그림5] 시트 숨기기 취소 및 시트 보호 해제

<br>

### 매크로 항목 적용

> 







