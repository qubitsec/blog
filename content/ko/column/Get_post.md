---
date: 2017-02-23T00:00:00
description: 
featured_image: 
tags: 
title: "우리는 왜 GET/POST 로그를 분석하는가?"
---

![search-13476_640](https://github.com/user-attachments/assets/5db69b0c-3a81-4a52-88e6-6c644336be87)

## HTTP란?
HTTP(Hypertext Transfer Protocol)는 클라이언트와 서버 간의 통신을 가능하게 합니다. <br>
HTTP는 클라이언트와 서버간의 요청 – 응답 프로토콜로 작동합니다.

클라이언트와 서버 간의 요청에 사용되는 요청방식은 GET, HEAD, POST, PUT, DELETE, OPTIONS, TRACE, CONNECT 이 있습니다. 하지만, 보안상의 이유로 웹서버가 GET, POST 2개 만을 허용하는 경우가 대부분입니다.
대부분의 웹서버에서 허용하는 GET/POST 방식에 대해서 알아보겠습니다.

## GET방식

```quote
/test/test_form.php?name1=value1&name2=value2
```
GET 방식은 URL(URI) 형식으로 웹서버 측 데이터를 요청합니다. URL을 통해 정보를 노출하기 때문에 주로 포털사이트의 검색어 전달, 게시판 페이지 번호 등 정보의 위험도와 관계없는 부분에서 많이 사용됩니다. 또한 URL 주소의 한계 길이인 4096bytes를 넘을 수 없으므로 Data의 양은 한정되어있습니다.

## POST방식

```quote
POST /test/test_form.php HTTP/1.1
Host: plura.io
name1=value1&name2=value2
```
POST 방식은 클라이언트에서 서버로 데이터를 요청할 때 요청데이터를 HTTP Body에 담아 웹서버로 전송합니다. HTML Form을 이용하여 정보 전달 하기 때문에 회원아이디, 비밀번호, 개인정보 등 개인 정보 전송에 많이 사용됩니다. POST 방식으로는 웹 서버의 응답 지연 시간만큼 전송 가능합니다.

그래서, PLURA Agent 는 클라이언트가 서버로 요청한 데이터를 GET 방식과 POST방식으로 나눠서 로그를 분석합니다.

클라이언트가 HTTP Server에 URL(URI)형식으로 웹 서버측 데이터를 요청하면(GET 방식) Request에 남아있는 로그를 분석하고,
요청데이터를 HTTP Body에 담아 웹 서버로 전송하면(POST 방식) POST Body에 있는 로그를 분석하여
공격유형, 예상피해도, 공격목적정보, 공격목적, 취약경로를 보여줍니다. 
또한, 대응방안까지 알려줘 서버를 안전하게 지킬 수 있습니다.

## PLURA Agent GET방식 웹로그 분석 예

![015-1](https://github.com/user-attachments/assets/3394cebf-62da-4adc-9067-cf6597c71b27)

## PLURA Agent POST방식 웹로그 분석 예

![016-1](https://github.com/user-attachments/assets/37861a64-828c-49ea-9c5a-bfc8ee320726)
