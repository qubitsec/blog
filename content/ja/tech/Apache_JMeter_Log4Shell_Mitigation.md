---
date: 2021-12-14T00:00:00
title: "Apache JMeter Log4Shell 対応方法"
description: "Apache JMeterに関連するLog4j脆弱性（Log4Shell）への対応方法"
featured_image: ""
tags: ["Apache JMeter", "Log4j", "Log4Shell", "セキュリティ", "脆弱性"]
---

![Apache JMeter Log4Shell 対応](https://github.com/user-attachments/assets/4d3f3dfe-9bc0-428b-b733-3a969fe9e2b7)

Apacheソフトウェア財団は、Log4j 2に発生した脆弱性を解決するためのセキュリティアップデートを推奨しています。  
Apache JMeterは主にユーザーPCで使用されるため、特に注意が必要です。  
この脆弱性はサーバーだけでなくクライアント環境にも影響を与える可能性があります。

> 攻撃者はこの脆弱性を利用してマルウェア感染などの被害を引き起こす可能性があります。  
> **最新バージョンにアップデートを行う必要があります。**

---

## 対応方法

Log4jのJNDIパーシングは、リモートコード実行の脆弱性を引き起こすため、該当機能を**修正**または**無効化**する必要があります。  
以下の方法のいずれかを選択して対応してください。

### 1. Log4jバージョンをアップグレード
- **Log4jバージョン2.15.0以上**にアップグレード（Java 8のサポートが必要）

---

### 2. Log4j V2.10.0以上の場合、以下の方法を使用
- **ⓐ Javaの実行引数（Arguments）にシステムプロパティを追加**  
  ```bash
  -Dlog4j2.formatMsgNoLookups=true
  ```

- **ⓑ Java実行アカウントの環境変数またはシステム変数を設定**  
  ```bash
  LOG4J_FORMAT_MSG_NO_LOOKUPS=true
  ```

---

### 3. Log4j V2.7.0以上の場合
- **Log4j設定ファイルを修正**  
  - `log4j.xml`などの設定ファイルで`PatternLayout`プロパティの`%m`を以下のように変更します:  
    ```xml
    %m{nolookups}
    ```

---

### 4. Log4jバージョンが上記基準未満の場合
- **JndiLookupクラスおよびJndiManagerクラスがロードされないように対応**する必要があります。  
- Log4j Coreを直接ビルドするか、プロジェクト内でパッケージ名まで一致させたダミークラスを作成して無効化します。

---

## 参考資料

- [Windows ForFilesコマンドの使用](https://docs.microsoft.com/ko-kr/windows-server/administration/windows-commands/forfiles)
