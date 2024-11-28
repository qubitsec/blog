---
date: 2020-12-22T00:01:00
description: 
featured_image: 
tags: ["Command Injection", "OWASP TOP 10", "보안 취약점", "웹 애플리케이션 보안", "해킹 방어"]
title: "Command Injection"
---

![blog_banner_20201222_1](https://github.com/user-attachments/assets/ec774277-6fd2-40db-96c2-4f8810e61c2d)

Command Injection(명령어 주입)은 OWASP TOP 10 중 1위인 Injection 유형 중 하나로,  
취약한 애플리케이션을 통해 호스트 OS에서 시스템 명령을 실행하는 것을 목표로 하는 공격입니다.  

`system()`, `exec()`와 같은 OS 시스템 명령어를 실행할 수 있는 함수에 대해 사용자 입력값 필터링이 제대로 이루어지지 않을 경우,  
공격자가 시스템 명령어를 호출할 수 있는 취약점을 악용할 수 있습니다.  

특히, 애플리케이션이 안전하지 않은 사용자 제공 데이터(양식, 쿠키, HTTP 헤더 등)를 시스템 셸에 전달할 때  
Command Injection 공격이 가능합니다.  

Command Injection은 다음과 같은 피해를 초래할 수 있습니다.

- 내부 데이터 탈취 및 손상  
- 시스템 계정 정보 유출  
- 백도어 설치  
- 관리자 권한 탈취  

결과적으로 서버 전체를 해커가 제어할 수 있게 되는 심각한 보안 위협입니다. [1][2]  

---

## DVWA를 이용한 Command Injection 모의해킹

![8 8 8 8](https://github.com/user-attachments/assets/8806bbac-2d42-434d-b50b-df3b72c454dc)

위 화면은 특정 IP 주소에 대해 Ping 테스트를 수행하는 애플리케이션의 예제입니다.  
`8.8.8.8`을 입력하면 정상적으로 Ping 결과가 출력됩니다.

---

### 쉘 명령어를 이용한 취약점 악용

![ls-2](https://github.com/user-attachments/assets/89b4ce81-1ff7-49e1-907f-5c2a327ad807)

`8.8.8.8 | ls`를 입력한 결과, `ls` 명령어가 실행되는 것을 확인할 수 있습니다.  
이는 리눅스 쉘 명령어 문법의 파이프라인(`|`)을 이용해 명령어를 연결하여 OS 명령어를 실행한 사례입니다.

---

### 서버의 민감한 정보 접근

![cat1](https://github.com/user-attachments/assets/b00dd673-bb7f-462c-aa74-7552a1f1576f)  
![cat](https://github.com/user-attachments/assets/b02420da-722e-40e4-8ef5-58e9e68a100c)

위와 같이 Command Injection을 통해 `/etc/passwd` 파일에 접근할 수 있는 모습을 보여줍니다. [3]  

---

## Command Injection 방지 방법

Command Injection을 예방하기 위해 다음과 같은 조치가 필요합니다.

1. **입력값 검증 및 매개변수화:**  
   사용자 입력값에 OS 명령어 실행 가능 문자가 포함되어 있는지 필터링 및 차단합니다.  

2. **PHP 내장 함수 사용:**  
   `escapeshellarg()`, `escapeshellcmd()` 등의 함수로 명령어 인젝션을 방지합니다.  

3. **화이트리스트 설정:**  
   OS 명령어 사용이 불가피한 경우, 허용 가능한 명령어 리스트(명령어 화이트리스트)를 선정하여 특정 명령어만 실행되도록 제한합니다.  

---

## PLURA 탐지 사례

PLURA의 ML 탐지 기능으로 Command Injection 공격을 자동으로 탐지한 결과입니다.

![ml01-1](https://github.com/user-attachments/assets/7ff23713-a89b-485c-bc5c-0a2382a0b9c9)  
![ml02-1](https://github.com/user-attachments/assets/4e6fe363-2377-411f-bf9e-e69881824cbd)  

---

## 참고

1. [OWASP - Command Injection](https://bit.ly/2WlCD7z)  
2. [운영체제 명령 실행 취약점](https://bit.ly/3qXCvJE)  
3. [DVWA (Damn Vulnerable Web Application)](https://bit.ly/2IQQgIO)  
4. [OWASP - OS Command Injection Defense Cheat Sheet](https://bit.ly/2Kr73CW)  
