---
date: 2019-02-14T00:00:00
draft: false
title: "오픈소스 웹 방화벽 WebKnight"
description: 
featured_image: "cdn/tech/webknight-1.png"
tags: 
---

WebKnight는 AQTRONIX사에서 개발한 IIS 웹서버에 설치할 수 있는 공개용 웹 방화벽입니다.
WebKnight는 ISAPI 필터 형태로 동작하며, IIS 서버 앞단에 위치하여 웹서버로 전달되기 이전에
IIS 웹서버로 들어온 모든 웹 요청에 대해 웹서버 관리자가 설정한 필터 룰에 따라 검증을 하고
SQL Injection 공격 등 특정 웹 요청을 사전에 차단합니다.

<!--more-->
---

## 1.설치 방법

* 아래 URL에서 WebKnight를 다운로드 받습니다.
  * http://www.aqtronix.com/?PageID=136
* 설치 전 IIS의 ISAPI필터를 설치합니다.

![1](https://github.com/user-attachments/assets/0ec025e7-4030-4e5e-aff9-c495b1d7bdb6)

* 압축을 푼 뒤 사용자의 시스템 종류에 맞는 폴더의 WebKnight.msi를 실행하여 설치를 진행합니다.

![2](https://github.com/user-attachments/assets/9610a9b2-5417-43d0-aae6-3ef5b6c2aa53)

![3](https://github.com/user-attachments/assets/740b2ea0-7167-44ce-9b17-e9f6882539e9)

![4](https://github.com/user-attachments/assets/47f19d94-1215-4150-bbcf-62fb46eb0fc6)

![5](https://github.com/user-attachments/assets/9295e393-8929-44ad-a873-ebe83b1d7691)

![6](https://github.com/user-attachments/assets/bb4b7224-891a-44ab-b3cf-3c42fd648998)

![7](https://github.com/user-attachments/assets/22a39a97-cb9f-4c75-b65f-b5361574e563)





* 기본 설치를 하면 C:Program FilesAQTRONIX WebKnight 폴더에 WebKnight설치가 됩니다.
동시에 인터넷 정보 서비스에 Global Filter로 ISAPI Filter에 자동 등록됩니다.
* IIS를 재시작 합니다.
* IIS 재시작 후에 관리자에서 정상적으로 설치가 완료되었을 경우 다음과 같이 WWW 서비스 마스터 속성에서 “ISAPI 필터” 탭에 다음과 같이 WebKnight 필터가 정상적으로 적용이 된 것을 확인할 수 있습니다.

![11](https://github.com/user-attachments/assets/a523d618-464e-41db-aa9c-aabc3e4256b0)


* 주요 파일
* 
![8](https://github.com/user-attachments/assets/3bf3d6b5-7d7a-4dff-8514-d09b96fae294)


◦ Config.exe : WebKnight의 설정파일을 읽어들여 조작 할 수 있게 해주는 파일
◦ denied.htm : 설정에서 ‘Response Directly’ 옵션을 통해 보여지는 기본 차단 메시지
◦ LogAnalysis.exe : 로그 분석기
◦ Robots.xml : User-Agent에 대한 DB 파일
◦ WebKnight.dll : ISAPI Filter 파일, WebKnight가 실제 동작하는 파일
◦ WebKnight.xml : WebKnight 동작을 제어할 수 있는 설정 파일

 

## 2.설정 방법

* Config.exe를 실행시켜 WebKnight.xml을 열어줍니다.
* 
![9](https://github.com/user-attachments/assets/e266d06d-f6d4-49c8-88f9-3dd735aaf3d9)

![10](https://github.com/user-attachments/assets/bd9b4f78-b37e-43b7-9ebe-22f70559a58f)


* 사용자의 환경에 맞춰 수정을 합니다.
자세한 수정 항목들은 참고 사이트의 pdf를 참고하여 작성합니다.
* 탐지 된 로그는 LogAnalysis.exe를 통해 확인할 수 있습니다.

## 참고 사이트
* http://www.kisa.or.kr/public/laws/laws3_View.jsp?mode=view&p_No=259&b_No=259&d_No=42
