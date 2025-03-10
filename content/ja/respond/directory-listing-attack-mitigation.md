---
date: 2023-02-14T01:10:00
draft: false
title: "ディレクトリリスティング攻撃への対策"
description: ""
featured_image: "cdn/respond/directory_listing_attack-1.png"
tags: ["ディレクトリリスティング", "サイバーセキュリティ", "ウェブサーバー", "WAF", "アクセス制御"]
---

## 🏗️概要

ディレクトリリスティング攻撃は、デフォルトページ（例: "index.html"）が存在しない場合に、ウェブサーバーがディレクトリの内容を表示するように設定されているときに発生する脆弱性の一種です。攻撃者は、この脆弱性を悪用して、重要なファイルやディレクトリ構造などの機密情報に不正アクセスする可能性があります。

<!--more-->

ディレクトリリスティング攻撃中に、攻撃者はディレクトリの内容を検索して、ファイル名やディレクトリ名、ファイルサイズ、タイムスタンプなどの機密情報を露出させる可能性があります。その後、この情報を使用して、悪意のあるファイルアップロードや機密データへのアクセスなどの追加攻撃を開始する可能性があります。

ディレクトリリスティング攻撃を防ぐには、ウェブサーバーを安全に構成し、不正アクセスを防止するためのアクセス制御やその他のセキュリティ対策を実装することが重要です。

<br>

![directory_listing_attack](https://blog.plura.io/cdn/respond/directory_listing_attack-1.png)

## 🛠️対策方法

### 1. ディレクトリリスティングの無効化:

- ほとんどのウェブサーバーには、設定ファイルや管理パネルを通じてディレクトリリスティングを無効化するオプションがあります。

### 2. デフォルトページの使用:

- デフォルトページ（例: "index.html"）を作成することで、ディレクトリリスティングが有効な場合でも、ディレクトリの内容が表示されないようにすることができます。

### 3. アクセス制御の実装:

- Apacheの場合、.htaccessファイルや認証といったアクセス制御メカニズムを使用して、機密ディレクトリへのアクセスを制限します。

### 4. WAF（ウェブアプリケーションファイアウォール）の使用:

- WAFは、悪意のあるリクエストを検知してブロックし、ディレクトリリスティング攻撃から保護します。

### 5. ソフトウェアの最新化:

- ウェブサーバーソフトウェアやインストールされているアプリケーションを定期的に更新することで、既知の脆弱性を修正し、攻撃の可能性を防ぐことができます。

### 6. 設定およびアクセスログの定期的な監視:

- ウェブサーバーの設定やアクセスログを定期的に確認・監視し、安全性を確認することで、ディレクトリリスティング攻撃を防ぐことが重要です。
- また、ウェブサーバーの設定やセキュリティ対策に詳しくない場合は、専門家の助けを借りるか、セキュリティの専門家に相談することをお勧めします。

<br>

📖 一緒に読む
- [cwiki_DirectoryListings](https://cwiki.apache.org/confluence/display/httpd/DirectoryListings)
- [ngx_http_autoindex_module](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html)
- [microsoft_directorybrowse](https://learn.microsoft.com/en-us/iis/configuration/system.webserver/directorybrowse)
