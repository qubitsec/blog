---
date: 2021-08-14T01:00:00
title: "IPv6 기반에서 curl 이용하여 웹 접속 체크"
description: "IPv6 환경에서 curl을 이용한 웹 접속 테스트와 Apache Tomcat 서버 로그 확인 방법"
featured_image: ""
tags: ["IPv6", "curl", "Apache Tomcat", "네트워크"]
---

![blog_banner_20210817_2](https://github.com/user-attachments/assets/a6b13908-3d5b-457d-936a-3c784e84906c)

## 환경 설정

### 1) 클라이언트

![curl](https://github.com/user-attachments/assets/404c561e-7c83-418f-a891-d05c78d693e8)

### 2) 웹 서버: Apache Tomcat with IPv6

![tomcat-netstat-ipv6](https://github.com/user-attachments/assets/c905e280-6e1d-4f5c-b1b2-c5d91071fdfc)

---

## 접속 테스트

### 1) 클라이언트에서 curl 사용

IPv6 주소를 사용할 때 **인터페이스를 명시적으로 지정**해야 합니다.

```bash
curl -g -6 "http://[fe80::20c:29ff:fe2f:52de%ens192]:8080/daytime"
```

출력 예시:

```html
<html>
<head>
<title>DayTime</title>
</head>
<body>
<div style="font-size: 40px; text-align: center; font-weight: bold">
2021/8/14 8:31
</div>
</body>
</html>
```

---

### 2) 서버 로그 확인

Apache Tomcat 서버의 접근 로그를 확인하여 요청 정보를 확인할 수 있습니다.

```bash
tail /var/log/plura/weblog.log
```

로그 출력 예시:

```json
{
  "Remote-addr": "fe80:0:0:0:882:75bf:f497:e378%2",
  "X-forwarded-for": "-",
  "Request-date": "14/Aug/2021:08:31:40.924 +0900",
  "Method": "GET",
  "Request": "GET /daytime HTTP/1.1",
  "Host": "172.16.0.230",
  "Uri": "/daytime",
  "Cookie": "-",
  "Refere": "-",
  "User-Agent": "curl/7.78.0",
  "Status": "200",
  "Resp-Content-Length": "159"
}
```

---

## 추가 테스트

### 1) IPv6로 ping 테스트

IPv6 주소로 ping을 보내는 명령:

```bash
ping6 -I ens192 fe80::20c:29ff:fe2f:52de
```

### 2) IPv6로 telnet 테스트

IPv6 주소와 포트를 이용한 telnet 테스트:

```bash
telnet -6 fe80::20c:29ff:fe2f:52de%ens192 8080
```

---

## 참고 자료

- [Ping IPv6 Address on Windows/Linux CLI](https://linoxide.com/ping-ipv6-address-windows-linux-cli/)
