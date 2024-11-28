---
date: 2020-12-22T00:01:00
description: 
featured_image: 
tags: ["コマンドインジェクション", "OWASP TOP 10", "セキュリティ脆弱性", "ウェブアプリケーションセキュリティ", "ハッキング防御"]
title: "Command Injection"
---

![blog_banner_20201222_1](https://github.com/user-attachments/assets/ec774277-6fd2-40db-96c2-4f8810e61c2d)

Command Injection（コマンドインジェクション）は、OWASP TOP 10 の1位であるインジェクションの一種であり、  
脆弱なアプリケーションを通じてホストOS上でシステムコマンドを実行することを目的とした攻撃です。

`system()` や `exec()` のようなOSシステムコマンドを実行する関数において、ユーザー入力値のフィルタリングが適切に行われない場合、  
攻撃者はこの脆弱性を悪用してシステムコマンドを呼び出すことが可能になります。

特に、アプリケーションがフォーム、クッキー、HTTPヘッダーなどの安全でないユーザーデータをシステムシェルに渡す際に  
Command Injection攻撃が発生する可能性があります。

Command Injectionによって以下のような被害が生じる可能性があります：

- 内部データの窃取および破損  
- システムアカウント情報の漏洩  
- バックドアの設置  
- 管理者権限の奪取  

結果として、サーバー全体が攻撃者に制御される危険な状況が発生します。[1][2]

---

## DVWAを利用したCommand Injectionの模擬ハッキング

![8 8 8 8](https://github.com/user-attachments/assets/8806bbac-2d42-434d-b50b-df3b72c454dc)

上の画面は、特定のIPアドレスに対してPingテストを行うアプリケーションの例です。  
`8.8.8.8` を入力すると正常にPingの結果が表示されます。

---

### シェルコマンドを利用した脆弱性の悪用

![ls-2](https://github.com/user-attachments/assets/89b4ce81-1ff7-49e1-907f-5c2a327ad807)

`8.8.8.8 | ls` を入力した結果、`ls` コマンドが実行されていることを確認できます。  
これはLinuxシェルコマンドのパイプライン（`|`）を利用してコマンドを接続し、OSコマンドを実行した例です。

---

### サーバーの機密情報へのアクセス

![cat1](https://github.com/user-attachments/assets/b00dd673-bb7f-462c-aa74-7552a1f1576f)  
![cat](https://github.com/user-attachments/assets/b02420da-722e-40e4-8ef5-58e9e68a100c)

上記のようにCommand Injectionを通じて `/etc/passwd` ファイルにアクセスできることが分かります。[3]  

---

## Command Injectionの防止方法

Command Injectionを防ぐためには以下の対策が必要です：

1. **入力値の検証およびパラメータ化**  
   ユーザー入力値にOSコマンドを実行できる文字が含まれているかを適切にフィルタリングし、ブロックします。

2. **PHPの組み込み関数を使用**  
   `escapeshellarg()` や `escapeshellcmd()` のような関数を使用してコマンドインジェクションを防止します。

3. **ホワイトリストの設定**  
   OSコマンドの使用が避けられない場合、許可されたコマンドのリスト（ホワイトリスト）を作成し、指定されたコマンドのみ実行できるように制限します。

---

## PLURAによる検出事例

PLURAのML検出機能によりCommand Injection攻撃を自動検出した結果です。

![ml01-1](https://github.com/user-attachments/assets/7ff23713-a89b-485c-bc5c-0a2382a0b9c9)  
![ml02-1](https://github.com/user-attachments/assets/4e6fe363-2377-411f-bf9e-e69881824cbd)  

---

## 参考

1. [OWASP - Command Injection](https://bit.ly/2WlCD7z)  
2. [オペレーティングシステムコマンドの実行脆弱性](https://bit.ly/3qXCvJE)  
3. [DVWA (Damn Vulnerable Web Application)](https://bit.ly/2IQQgIO)  
4. [OWASP - OS Command Injection Defense Cheat Sheet](https://bit.ly/2Kr73CW)  
