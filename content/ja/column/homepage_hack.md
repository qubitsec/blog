---
date: 2020-06-04T00:00:00
draft: false
title: "ホームページ改ざんハッキング技術が進化、セキュリティ強化が必要"
description: 
featured_image: "cdn/column/homepage_hack-1.png"
tags: ["ホームページ改ざん", "セキュリティ", "マルウェア", "ウェブシェル", "PLURA"]
---

ハッカーはウェブサイトを攻撃して必要な情報を盗み取った後、二次的な被害を引き起こすためにホームページにマルウェアを埋め込みます。

またはウェブシェルを利用して攻撃に成功したサイトに対し、持続的な接続を維持しようとします。

これらの攻撃はホームページ改ざんを通じて行われます。

インターネット記事によると、韓国インターネット振興院（KISA）では2015年以降、年間1,000件以上のホームページ改ざん攻撃が発生していると報告されています。

しかし、従来のSIEMやセキュリティ機器では、このような攻撃を効果的に防ぐ機能が実装されていません。

**PLURA製品**を使用すれば、数回のクリックで簡単にホームページ改ざんハッキングを検知し、管理することができます。

![homepage_hack](https://blog.plura.io/cdn/column/homepage_hack-1.png)
<!--more-->
---

# ホームページ改ざんハッキングの検知方法

## 1. [PLURAメニュー] → [フィルター] → [セキュリティ] → [ホームページ改ざん]<br>
![image](https://github.com/user-attachments/assets/bae4d0a1-6674-4f44-8aa4-7dffd0b823fa)

## 検知したいファイルパスを入力すると、そのファイルが改ざんされた際にフィルターで検知されます。<br><br>
![2020-06-04-13-07-01](https://github.com/user-attachments/assets/91ca78d3-41d8-49d2-a0b9-37b57ee799ab)

> * 例) ハッカーが `index.php` に iframe タグを利用してマルウェア配布サイトを挿入した場合<br><br>
> ![2020-06-04-13-33-43](https://github.com/user-attachments/assets/eacdbe97-5444-4022-9948-115581b6c7b2)
>
> * 実際に挿入されたマルウェアのHTMLコード<br><br>
> ![2020-06-04-13-31-28](https://github.com/user-attachments/assets/1d49c727-ea2a-4b35-bc36-8e79161a89a1)
>
> * 該当サイトの訪問者はマルウェア配布サイトに接続されました。（テスト環境のため、仮想ドメインで設定）<br><br>
> ![2020-06-04-13-31-56](https://github.com/user-attachments/assets/68d5cf4d-fbba-4f87-9765-2c29448c4103)
>
> * PLURAで該当ページの改ざんが検知されました。<br><br>
> ![2020-06-04-14-07-17](https://github.com/user-attachments/assets/d56e98ae-5be7-4a75-91c2-41afeff5490d)

**改ざんされたファイルのパスと名前を確認できるため、管理者は該当ファイルを点検し、ホームページ改ざん攻撃に対応することが可能です。**
