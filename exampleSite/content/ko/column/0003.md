---
date: 2024-06-03
description: 
featured_image: 
tags: 
title: "[WEB] 웹쉘 공격과 create_function 함수의 취약성"
---

![1](https://github.com/user-attachments/assets/82544822-d6b3-4df2-8513-bf5dadcc9680)

**Webshell(웹쉘)**

Web Shell은 웹 서버에 업로드된 후, 원격에서 서버를 제어할 수 있도록 해주는 악성 스크립트입니다. 이를 통해 공격자는 서버의 파일 시스템에 접근하고 명령을 실행할 수 있습니다.

> 주요 기능
> * 파일 관리: 업로드, 다운로드, 수정, 삭제
> * 명령 실행: 서버에서 shell 명령 실행
> * 네트워크 활동: 다른 시스템 공격 및 악성 코드 전파
> * 데이터베이스 접근: 민감한 정보 유출
 

**Webshell 실행/분석**

정보
![2](https://github.com/user-attachments/assets/e52fff0a-9b3d-4b55-b5d7-d39cea9d5533)


> **MD5:** 3cd5c4352b1379bd789ab3de7b76a196
> 
> **SHA-1:** 3a728d71ac418a906f9db78ba3fa935736eb02c9
> 
> **SHA-256:** ec04ce68129b58837f0b7b720f9dcb453d840f051ef9d1e2f7d197abf4167384

[사진 1] Virustotal Webshell 정보

 

코드 상세 정보

![3](https://github.com/user-attachments/assets/d8d93528-d568-4da4-8443-2edb30ae232c)

[사진 2] 웹쉘 – create_function 함수



**create_function 함수**

![4](https://github.com/user-attachments/assets/e84d1bc7-4464-4e90-b368-1a32f73235a8)

[사진 3] create_function 함수 정의

 

**PHP 버전별 Webshell 동작 여부**

PHP 4.0.1 ~ 7.1.x: 사용 가능

![5](https://github.com/user-attachments/assets/375fdb9d-fa8e-47a6-8bc0-a8d4706d95c3)


[사진 4] thanks.php 웹쉘 파일 출력결과

 

**PHP 7.2.0 ~ 7.4.x: 사용 가능하지만 deprecated**

> 출력결과
> 
> Deprecated: Function create_function() is deprecated in /path/to/file.php on line 2

create_function함수가 deprecated되었다는 경고 메시지가 출력되지만, 함수는 여전히 실행되어 예상한 결과(1 + 2 = 3)를 반환함.

 

**PHP 8.0 이상: 제거됨**

> 출력결과
>
> Fatal error: Uncaught Error: Call to undefined function create_function() in /path/to/file.php:2

create_function함수가 완전히 제거되었기 때문에, 위의 코드를 실행하면 다음과 같은 Fatal Error가 발생함.

 

**대응**

PHP 버전 업데이트는 새로운 기능과 성능 향상 외에도 중요한 보안 패치를 제공합니다. 예를 들어, create_function 함수는 보안 취약성으로 인해 PHP 7.2.0에서 사용 중단되고 PHP 8.0.0에서 제거되었습니다.

이를 통해 최신 버전 업데이트가 얼마나 중요한지 알 수 있습니다.

1. 보안 강화: 최신 버전은 이전 버전의 보안 취약점을 해결하여 웹쉘 공격 등으로부터 시스템을 보호합니다.
2. 성능 개선: 최적화된 성능으로 웹 애플리케이션의 응답 속도가 향상됩니다.
3. 새로운 기능: 최신 기능과 개선된 문법을 활용하여 더 효율적이고 안전한 코드를 작성할 수 있습니다.

따라서, PHP 버전 업데이트를 통해 보안과 성능을 유지하고, 최신 기능을 활용하여 Webshell 공격으로부터 방어를 할 수 있습니다.
 

[참조]

https://www.php.net/manual/en/function.create-function.php

https://www.virustotal.com/gui/file/ec04ce68129b58837f0b7b720f9dcb453d840f051ef9d1e2f7d197abf4167384/details
