---
date: 2021-04-28T00:03:00
description: 
featured_image: 
tags: ["カスタムルール", "ウェブハッキング", "ウェブファイアウォール", "ゼロデイ脆弱性", "WPScan"]
title: "カスタムルールフィルター (ウェブ & ウェブファイアウォール)"
---

![0 (1)](https://github.com/user-attachments/assets/6a921cb9-fe12-4ab3-845a-1a7de939da76)

ウェブハッキングは、ウェブサイトの脆弱性を攻撃する技術で、ウェブページを通じて権限のないシステムにアクセスしたり、データ漏洩や破壊などの行為が行われます。  
特にウェブアプリケーションを通じてハッキングが主に発生します。

OWASPは、10大ウェブアプリケーションの脆弱性を発表しており、PLURAはこれを基にウェブ攻撃タイプの分析を通じて検出パターンを登録し、管理しています。

ハッカーは、ゼロデイ脆弱性という、以前報告されていない新たな欠陥を探し回っています。  
これらが発見された直後、セキュリティ専門家は、1つのエクスプロイトが悪用されていることを追跡し、目撃することができます。  
目撃した瞬間、PLURAユーザーはその攻撃を検出または遮断するフィルターを登録できます。  
**ゼロデイ脆弱性が発表され、パッチが適用されるのを待つことなく、すぐに自社のサーバーを保護できます。**

ハッカーがWPScanというツールを利用してWordPressの脆弱性を探索しています。  
![01-4](https://github.com/user-attachments/assets/3b3d6986-6376-448f-a64f-f1fbaf821238)

PLURAは、このような多数のセキュリティ脆弱性をスキャンする無差別攻撃を基本的には検出/遮断しません。  
その理由の一つは、これを全て検出すると過剰な検出（過検出）により業務負荷が増大する副作用があるためです。

しかし、もしスキャン攻撃も検出/遮断したい場合、PLURA全体のログを元にフィルター登録をして対応することができます。  
![02-2](https://github.com/user-attachments/assets/997409b6-165c-4099-a090-72e4f1486720)

WPScanの結果、このサーバーでxmlrpcの脆弱性が検出されました。  
![03-1 (1)](https://github.com/user-attachments/assets/09477163-0655-4419-90a3-3ab90fd81c4b)

xmlrpcの脆弱性はブルートフォース攻撃に利用されており、PLURAで検出しています。  
![04-5](https://github.com/user-attachments/assets/948fd06e-b1bb-4468-96ef-74024ce58cba)

ユーザーがWordPress管理者IDを登録してユーザーフィルタリングを行えば、攻撃の有無を検出するだけでなく、IDの漏洩有無もリアルタイムで検出できます。

WordPressには独自の脆弱性もありますが、脆弱なプラグインを通じた攻撃がほとんどです。  
![05-1](https://github.com/user-attachments/assets/d8709496-c7f8-44f0-9a98-c931451bb003)

ユーザーが登録したまたは有効化したプラグインではない場合、それは非常に大きなセキュリティリスクになります。  
![06-2](https://github.com/user-attachments/assets/486904c3-18fb-41b0-8e9a-1b7111cf5da5)

ユーザーはインストールされているWordPressプラグインのリストを収集して管理する必要があります。  
このリストを含めて、除外して有効化されたプラグインに関するログをリアルタイムで検出できます。

알겠습니다! 다음은 수정된 내용입니다:

---

## 参考

- [脆弱性 - Wikipedia](https://ja.wikipedia.org/wiki/%E8%84%86%E5%BC%B1%E6%80%A7)

---