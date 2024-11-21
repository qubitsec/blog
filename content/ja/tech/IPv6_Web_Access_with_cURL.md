---
date: 2021-08-14T01:00:00
title: "IPv6環境でcurlを使用したウェブアクセス確認"
description: "IPv6環境でcurlを使用してウェブアクセスをテストし、Apache Tomcatサーバーログを確認する方法"
featured_image: ""
tags: ["IPv6", "curl", "Apache Tomcat", "ネットワーク"]
---

![IPv6 Web Access Check](https://github.com/user-attachments/assets/99bea80c-7c98-4748-923a-16d1fac782db)

## 環境設定

### 1) クライアント

![Client Setup](https://github.com/user-attachments/assets/13e531c9-31c0-4ca8-86b3-af23cffec45b)

### 2) ウェブサーバー: Apache Tomcat with IPv6

![Web Server Setup](https://github.com/user-attachments/assets/77bb2979-9f47-48d4-aedc-e21bf4abff59)

---

## アクセス確認

### 1) クライアントでcurlを使用

IPv6アドレスを使用する際には、**インターフェースを明示的に指定**する必要があります。

```bash
curl -g -6 "http://[fe80::20c:29ff:fe2f:52de%ens192]:8080/daytime"
```

出力例:

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

### 2) サーバーログ確認

Apache Tomcatサーバーのアクセスログを確認し、リクエスト情報をチェックします。

```bash
tail /var/log/plura/weblog.log
```

ログ出力例:

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

## その他のテスト

### 1) IPv6でpingをテスト

IPv6アドレスにpingを送信するコマンド:

```bash
ping6 -I ens192 fe80::20c:29ff:fe2f:52de
```

### 2) IPv6でtelnetをテスト

IPv6アドレスとポートを使用したtelnetテスト:

```bash
telnet -6 fe80::20c:29ff:fe2f:52de%ens192 8080
```

---

## 参考資料

- [Ping IPv6 Address on Windows/Linux CLI](https://linoxide.com/ping-ipv6-address-windows-linux-cli/)
