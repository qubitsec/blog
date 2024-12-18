---
date: 2023-10-05
draft: false
title: "[Apache Tomcat] バージョン情報漏洩対策"
description: 
featured_image: "cdn/respond/http_status_500_Internal_server_error-1.png"
tags: ["Apache Tomcat", "セキュリティ", "バージョン情報", "サーバ設定", "脆弱性対策"]
---

## 概要

Apache Tomcatは、デフォルトの設定では**エラー発生時にサーバのバージョン情報が漏洩**する可能性があります。  
これは攻撃者がサーバの脆弱性を悪用するリスクを高めるため、**バージョン情報を隠す設定**が必要です。
<!--more-->
![http_status_500_Internal_server_error](https://blog.plura.io/cdn/respond/http_status_500_Internal_server_error-1.png)

---

## 対策方法

### 1. Tomcatサーバ設定ファイルに移動
Tomcatがインストールされているディレクトリの**`conf`**フォルダに移動し、**`server.xml`**ファイルを開きます。

![server.xml の例](https://github.com/user-attachments/assets/816c1b1f-2eaf-410a-be35-9300677ba210)

---

### 2. HTTPコネクタ設定を探す
`server.xml`ファイル内でHTTPコネクタの設定部分を探します。  
この設定は、主にHTTPリクエストに関する情報を処理します。

![HTTPコネクタの例](https://github.com/user-attachments/assets/76dd05ab-dbed-46de-ab0d-d791c8d6a6f6)

---

### 3. server.xml ファイルの編集
HTTPコネクタ設定で、以下のように`server`属性を追加または修正して、バージョン情報の漏洩を防ぎます。

```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           server="Apache"/>
```

![server.xml 修正例](https://github.com/user-attachments/assets/49e0a350-d94c-4c68-b437-04cf49233c1c)

この設定により、Tomcatのレスポンスヘッダから**バージョン情報の漏洩**を防ぐことができます。

---

### 4. 変更内容を保存
編集内容を保存し、エディタを閉じます。

---

### 5. Tomcatサーバを再起動
変更内容を適用するために、Tomcatサーバを再起動します。  
Tomcatインストールディレクトリの**`bin`**フォルダで以下のコマンドを実行します:

```bash
./shutdown.sh
./startup.sh
```

![Tomcat再起動](https://github.com/user-attachments/assets/d9a368f0-7e01-45e7-899e-d25d7079fe50)

---

## 結果

これらの手順を完了すると、Apache Tomcatの**バージョン情報が漏洩しなくなります**。  
これにより、サーバのセキュリティを強化し、攻撃対象となるリスクを軽減できます。

---

## 追加の推奨事項

- **定期的なセキュリティアップデート**  
  - Tomcatやサーバのオペレーティングシステムを最新の状態に保ちましょう。最新のパッチが適用されていないサーバは依然として攻撃にさらされる可能性があります。

- **サーバセキュリティチェックの実施**  
  - サーバログを定期的に確認し、セキュリティ脆弱性の検出ツールを活用して、追加のリスク要因を検出してください。

- **専門家の助言を活用**  
  - サーバ設定に不慣れな場合や追加のセキュリティ対策が必要な場合は、セキュリティ専門家に相談することをお勧めします。
