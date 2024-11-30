---
date: 2021-08-14T01:00:00
title: "IPv6環境でcurlを使用したウェブアクセス確認"
description: 
featured_image: ""
tags: ["IPv6", "curl", "Apache Tomcat", "ネットワーク"]
---

![blog_banner_20210817_2](https://github.com/user-attachments/assets/98b8f92e-a4e9-404e-a99b-c47316ca870d)

## 環境設定

### 1) クライアント

![curl](https://github.com/user-attachments/assets/90f62990-f84c-4d79-b88b-3125c1eb4783)

### 2) ウェブサーバー: Apache Tomcat with IPv6

![tomcat-netstat-ipv6](https://github.com/user-attachments/assets/0df328ea-7323-4d6f-8237-d6d87fc664c8)

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
