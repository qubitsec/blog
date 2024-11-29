---
date: 2017-02-23T00:00:00
description: 
featured_image: 
tags: ["HTTP", "GET 방식", "POST 방식", "웹로그 분석", "보안", "PLURA"]
title: "우리는 왜 GET/POST 로그를 분석하는가?"
---

![HTTP GET/POST](https://github.com/user-attachments/assets/5db69b0c-3a81-4a52-88e6-6c644336be87)

## HTTP란?

HTTP(Hypertext Transfer Protocol)는 클라이언트와 서버 간의 통신을 가능하게 하는 프로토콜입니다.  
HTTP는 **요청-응답(Request-Response)** 구조로 작동하며, 클라이언트가 서버에 요청을 보내고 서버는 이에 대한 응답을 제공합니다.

HTTP 요청 방식은 GET, HEAD, POST, PUT, DELETE, OPTIONS, TRACE, CONNECT 등 여러 가지가 있습니다. 하지만 보안상의 이유로 대부분의 웹 서버는 **GET**과 **POST** 방식만을 허용합니다.  
아래에서 GET과 POST 방식에 대해 자세히 알아보겠습니다.

---

## GET 방식

```plaintext
/test/test_form.php?name1=value1&name2=value2
```

**GET 방식**은 URL(URI) 형식으로 데이터를 요청합니다. URL을 통해 요청 데이터를 노출하기 때문에 **검색어 전달**이나 **페이지 번호 전송** 등 **민감하지 않은 정보**에 주로 사용됩니다.  

### 특징
- **정보 노출**: 요청 데이터가 URL에 포함되므로 누구나 볼 수 있습니다.  
- **데이터 제한**: URL의 길이는 4096bytes로 제한되므로 전송 가능한 데이터 크기가 제한됩니다.  
- **사용 사례**: 검색어 전달, 게시판 페이지 전환 등.

---

## POST 방식

```plaintext
POST /test/test_form.php HTTP/1.1
Host: plura.io
name1=value1&name2=value2
```

**POST 방식**은 데이터를 HTTP Body에 담아 서버로 전송합니다. HTML Form을 통해 **개인 정보나 중요한 데이터**를 전송하는 데 주로 사용됩니다.  

### 특징
- **정보 보호**: 데이터가 URL에 노출되지 않아 GET 방식보다 상대적으로 안전합니다.  
- **데이터 크기 제한 없음**: 서버의 응답 지연 시간 내에서는 대량의 데이터를 전송할 수 있습니다.  
- **사용 사례**: 회원 아이디, 비밀번호, 개인정보 전송 등.

---

## PLURA의 GET/POST 방식 로그 분석

PLURA Agent는 클라이언트의 요청 데이터를 **GET 방식**과 **POST 방식**으로 나눠서 분석합니다.  

### GET 방식 로그 분석
- 클라이언트가 서버에 URL(URI) 형식으로 데이터를 요청하면, **Request에 남은 로그**를 분석합니다.

### POST 방식 로그 분석
- 클라이언트가 데이터를 HTTP Body에 담아 서버로 전송하면, **POST Body에 있는 로그**를 분석합니다.

### 분석 결과
- 공격 유형, 예상 피해도, 공격 목적 정보, 취약 경로를 시각화하여 보여줍니다.  
- 대응 방안까지 제공하여 서버를 안전하게 보호할 수 있도록 지원합니다.

---

## PLURA Agent GET 방식 웹로그 분석 예

![GET 방식 분석 예시](https://github.com/user-attachments/assets/3394cebf-62da-4adc-9067-cf6597c71b27)

---

## PLURA Agent POST 방식 웹로그 분석 예

![POST 방식 분석 예시](https://github.com/user-attachments/assets/37861a64-828c-49ea-9c5a-bfc8ee320726)

---

## 결론

POST 방식으로 들어오는 공격은 GET 방식보다 훨씬 많습니다. 이는 POST 방식이 클라이언트에서 서버로 데이터를 전송할 때 HTTP Body에 담아 전송하기 때문에, 기본적으로 서버 로그에 기록되지 않는 경우가 많기 때문입니다. 따라서, POST 데이터를 포함한 로그를 철저히 분석하고 관리하는 것은 보안상 필수적입니다.

HTTP의 GET과 POST 방식은 각각 고유한 장점과 단점을 가진 데이터 전송 방식으로, 웹 환경에서 가장 흔히 사용됩니다. 하지만 보안 관점에서 POST 방식은 기록되지 않는 경우가 많아, 제대로 관리되지 않을 경우 심각한 보안 위협으로 이어질 수 있습니다.

PLURA Agent는 GET과 POST 방식을 모두 분석하여, 클라이언트 요청 데이터를 실시간으로 모니터링하고 공격 유형, 예상 피해도, 대응 방안을 제공합니다. 이를 통해 보안 위협을 빠르게 식별하고 효과적으로 대응할 수 있습니다.

**우리는 왜 POST 로그를 분석해야 할까요?**  
POST 방식은 보안상 가장 큰 취약점으로 이어질 수 있는 영역이며, 이를 효과적으로 분석하는 것은 시스템 보안을 강화하기 위한 핵심적인 첫걸음입니다. GET과 POST 로그 분석은 단순한 데이터 기록을 넘어, 보안 위협에 선제적으로 대응하고 시스템을 안전하게 보호하기 위한 필수적인 과정입니다.
