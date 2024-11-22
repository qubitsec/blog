---
date: 2021-05-12T00:03:00
description: 
featured_image: 
tags: 
title: "PHP WEBSHELL 악성코드"
---

![0](https://github.com/user-attachments/assets/fb870851-88a2-4591-8cc0-fc159d7eb73b)


### WEBSHELL?
웹 서버의 업로드 취약점을 통하여 시스템에 명령을 내릴 수 있는 코드를 말합니다.
간단한 서버 스크립트(JSP, PHP, ASP ...)로 만드는 방법이 널리 사용됩니다.¹⁾

Microsoft 탐지 및 대응팀에 따르면 Webshell 공격은 2020년 대비 2021년에 2배 증가하였으며, 전 세계적으로 꾸준히 위협이 되고 있는 공격입니다.²⁾

다음 스크린샷은 최근 PLURA V5 에서 탐지된 악성코드입니다.
![1 (1)](https://github.com/user-attachments/assets/1df3a84e-5fcc-48ff-9229-0c4a7a9ea54d)<br>
[이미지 1] WEBSHELL>FILE EXECUTION - 위험성 높은 함수 호출 탐지

이 악성코드는 GET 방식으로 PHP 코드를 전송 시도하였으며, 주요 데이터는 base64로 인코딩되었습니다.
디코딩 값 확인 결과 http://.../rookie.php 파일을 ./data/.../xmm.php 로 copy 및 출력합니다.

*가상 환경에서 해당 악성코드 Test 진행
![22](https://github.com/user-attachments/assets/7f263c6d-1c0f-495b-b51e-6c42ba607d4b)<br>
[이미지 2] test.php 코드<br><br>

![2-3](https://github.com/user-attachments/assets/66104249-74ed-4817-8f12-bb28b345a420)<br>
[이미지 3] test.php 접속<br><br>

![4 (1)](https://github.com/user-attachments/assets/06f4abc5-75fb-4313-b50b-c481bc813e0e)<br>
[이미지 4] 외부 IP 주소로 아웃바운드 행위 발생<br><br>

![5-1](https://github.com/user-attachments/assets/2912c085-8013-4bd5-a451-dd5c6bb3287f)<br>
[이미지 5] test2.php 코드
외부에 위치한 rookie.php 파일을 내부에 test2.php 파일로 copy<br><br>

![6](https://github.com/user-attachments/assets/f9bfae03-d992-48dc-a470-15836c3c3f10)<br>
[이미지 6] test2.php 접속<br><br>

![7](https://github.com/user-attachments/assets/946b893f-32e5-45e1-a782-b7f9b08150ae)<br>
[이미지 7] test2.php Webshell 실행<br><br>

다행히 해당 악성코드가 발견된 업체에서는 이 코드가 실행되지 않았습니다.
하지만 만약 이처럼 취약점이 존재하여 Webshell과 같은 파일이 다운로드 및 업로드되고 실행이 된다면 공격자는 매우 간단히 시스템을 장악할 수 있습니다.

**PLURA V5는 Webshell 공격 유형을 분석하고 이를 자동으로 탐지하고 차단하고 있습니다.**

## 참조
- 1) 위키백과, https://ko.wikipedia.org/wiki/%EC%9B%B9_%EC%85%B8
- 2) 마이크로소프트, https://www.microsoft.com/security/blog/2021/02/11/web-shell-attacks-continue-to-rise/

## 영상
- Webshell 해킹 데모 : https://youtu.be/BszuH4SoZUg?si=mdAoMVVcNuRxSUtZ

