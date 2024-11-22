---
date: 2020-12-22T00:01:00
description: 
featured_image: 
tags: 
title: "Command Injection"
---

![blog_banner_20201222_1](https://github.com/user-attachments/assets/ec774277-6fd2-40db-96c2-4f8810e61c2d)

Command Injection (명령어 주입)은 OWASP TOP 10 중 1위인 Injection의 유형 중 하나로

취약한 애플리케이션을 통해 호스트 OS에서 시스템 명령을 실행하는 것을 목표로 하는 공격입니다.

system(), exec()와 같은 OS 시스템 명령어를 실행할 수 있는 함수를 통해 사용자 입력값에 필터링이 제대로 이루어지지 않을 경우,

공격자가 시스템 명령어를 호출할 수 있는 취약점을 악용하여

애플리케이션이 안전하지 않은 사용자 제공 데이터 (양식, 쿠키, HTTP 헤더 등)를 시스템 셸에 전달할 때 명령 주입 공격이 가능합니다.

Command Injection을 통해 내부 데이터 탈취 및 손상, 시스템 계정 정보 유출, 백도어 설치, 관리자 권한 탈취 등의 피해가 발생할 수 있습니다.

서버 전체를 해커가 명령할 수 있게 되는 위험한 공격입니다.[1][2]
<br><br>



다음은 DVWA를 이용한 Command Injection 모의해킹 과정과 이에 대한 PLURA V5 탐지 내용입니다.

![8 8 8 8](https://github.com/user-attachments/assets/8806bbac-2d42-434d-b50b-df3b72c454dc)

IP 주소를 입력하면 해당 기기의 Ping 테스트를 수행하고 있습니다. 8.8.8.8을 입력한 결과는 위와 같습니다.

![ls-2](https://github.com/user-attachments/assets/89b4ce81-1ff7-49e1-907f-5c2a327ad807)

그러나 8.8.8.8 | ls를 입력하니 ls 명령어가 실행되는 모습을 볼 수 있습니다.

위에서 사용한  파이프라인 ( | )과 같이 리눅스 쉘 명령어 문법을 이용해서 명령어 간의 고리를 연결하여 OS 명령어를 수행한 것입니다. 

그렇다면 우리가 해커라면 서버의 중요한 정보에 접근할 수 있다는 것을 알 수 있습니다.

![cat1](https://github.com/user-attachments/assets/b00dd673-bb7f-462c-aa74-7552a1f1576f)

![cat](https://github.com/user-attachments/assets/b02420da-722e-40e4-8ef5-58e9e68a100c)

위와 같이 /etc/passwd에 접근할 수 있습니다. [3]<br><br>




Command Injection을 예방하기 위해서는 우선 입력값에 대한 검증 및 매개변수화가 필요합니다.

사용자 입력값에 OS 명령어를 실행할 수 있는 문자가 포함되어 있는지 적절히 필터링하여 차단하는 과정을 진행합니다.

PHP의 escapeshellarg() , escapeshellcmd() 함수를 이용하는 방법도 있습니다.

불가피하게 웹 애플리케이션 운영 상 OS 명령어를 사용해야 하는 상황의 경우,

허용 가능한 명령어 리스트(명령어 화이트 리스트)를 선정하여 해당 명령어만 실행할 수 있도록 설정합니다. [4]


다음은 PLURA V5 ML탐지 기능으로 자동으로 탐지된 결과입니다.

![ml01-1](https://github.com/user-attachments/assets/7ff23713-a89b-485c-bc5c-0a2382a0b9c9)

![ml02-1](https://github.com/user-attachments/assets/4e6fe363-2377-411f-bf9e-e69881824cbd)

## 참고
- [1] OWASP - Command Injection : https://bit.ly/2WlCD7z
- [2] 운영체제 명령 실행 취약점: https://bit.ly/3qXCvJE
- [3] DVWA (Damn Vulnerable Web Application) : https://bit.ly/2IQQgIO
- [4] OWASP - OS Command Injection Defense Cheat Sheet : https://bit.ly/2Kr73CW[/fusion_builder_column][/fusion_builder_row][/fusion_builder_container]
