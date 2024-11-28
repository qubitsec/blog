---
date: 2017-02-23T00:00:00
description: 
featured_image: 
tags: 
title: "なぜGET/POSTログを分析するのか？"
---

![search-13476_640](https://github.com/user-attachments/assets/5db69b0c-3a81-4a52-88e6-6c644336be87)

## HTTPとは？
HTTP（Hypertext Transfer Protocol）は、クライアントとサーバー間の通信を可能にするプロトコルです。  
HTTPは、クライアントとサーバー間でリクエストとレスポンスのやり取りを行うプロトコルとして機能します。

クライアントとサーバー間のリクエストに使用されるリクエストメソッドには、GET、HEAD、POST、PUT、DELETE、OPTIONS、TRACE、CONNECT などがあります。しかし、セキュリティ上の理由から、多くのウェブサーバーはGETとPOSTの2つだけを許可しています。ここでは、多くのウェブサーバーで許可されているGET/POSTメソッドについて詳しく説明します。

## GETメソッド

```quote
/test/test_form.php?name1=value1&name2=value2
```
GETメソッドは、URL（URI）の形式でウェブサーバー側のデータをリクエストします。URLを通じて情報が公開されるため、ポータルサイトの検索キーワードの送信や掲示板のページ番号など、情報のリスクが少ない場面でよく使用されます。また、URLの長さには4096バイトの制限があるため、送信できるデータ量は限られています。

## POSTメソッド

```quote
POST /test/test_form.php HTTP/1.1
Host: plura.io
name1=value1&name2=value2
```
POSTメソッドは、クライアントからサーバーにデータを送信する際、リクエストデータをHTTP Bodyに含めてウェブサーバーに送信します。HTMLフォームを利用して情報を送信するため、ユーザーIDやパスワード、個人情報などの送信によく使用されます。POSTメソッドでは、ウェブサーバーの応答時間に応じてデータを送信することが可能です。

そのため、**PLURA Agent** は、クライアントがサーバーにリクエストしたデータをGETメソッドとPOSTメソッドに分けてログを分析します。

クライアントがHTTPサーバーにURL（URI）形式でウェブサーバー側のデータをリクエストすると（GETメソッド）、リクエストログを分析します。また、リクエストデータをHTTP Bodyに含めてウェブサーバーに送信すると（POSTメソッド）、POST Bodyのログを分析し、以下の情報を提供します。

- 攻撃の種類  
- 予想される被害度  
- 攻撃の目的情報  
- 攻撃の意図  
- 脆弱な経路  

さらに、対策方法も提示されるため、サーバーを安全に保護することが可能です。

## PLURA Agent のGETメソッドログ分析例

![015-1](https://github.com/user-attachments/assets/3394cebf-62da-4adc-9067-cf6597c71b27)

## PLURA Agent のPOSTメソッドログ分析例

![016-1](https://github.com/user-attachments/assets/37861a64-828c-49ea-9c5a-bfc8ee320726)
