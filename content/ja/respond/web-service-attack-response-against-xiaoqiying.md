---
date: 2023-02-20T02:00:00
title: "ウェブサービス攻撃への対応 against シャオチーニン(Xiaoqiying)"
description: ""
featured_image: ""
tags: ["PLURA-SIEM", "WAF", "Post-body", "ウェブセキュリティ", "クレデンシャルスタッフィング", "攻撃対策"]
---

![ウェブサービス保護](https://github.com/user-attachments/assets/ec557af0-de13-4f7e-a253-b9f17f5b51ea)

## 概要

ウェブサービスを保護するために必須の製品は、**ウェブアプリケーションファイアウォール(WAF)** です。  
ネットワーク型侵入防止システム(NIPS, Network-based Intrusion Prevention System)と併用される場合もありますが、  
NIPSは現代の環境では適さず、ネットワークの複雑化により障害のリスクを高めるため、むしろ除去が推奨されます。

---

## ウェブアプリケーションファイアウォール(WAF)の限界

**WAFが防げなかった攻撃はどうなるのでしょうか？**

- WAFはアカウント乗っ取り攻撃である**クレデンシャルスタッフィング(Credential Stuffing)** に対応できません。  
- また、WAFが見逃した攻撃を**NIPSが検知できる可能性は非常に低い**です。

---

## SIEMソリューションの役割

**統合セキュリティイベント管理(SIEM)ソリューションは、すべてのイベントを収集し、相関分析によって異常を検知します。**  
しかし、SIEM自体には分析機能がなく、セキュリティ製品から検知情報を含むログを収集することで機能します。

**例:**  
| セキュリティ機器                   | 通過 (pass) | ブロック (deny) | 本文情報 |
|----------------------------------|-------------|----------------|----------|
| **ファイアウォール (Firewall)**   |      O      |      O         |     X    |
| **ネットワーク型侵入防止システム (NIPS)** |      O      |      O         |     X    |
| **ウェブアプリケーションファイアウォール (WAF)** |      O      |      O         |     O    |

---

## リクエストボディ(Post-body)とSIEMの限界

### リクエストボディ(Post-body)とは？

- ブラウザ上で入力されたデータをウェブサーバーに送信するデータ領域です。  
  - 例: ログイン時に入力されるIDとパスワードなど。  
- 攻撃者はここに**SQLインジェクション**や**クロスサイトスクリプティング(XSS)** といった悪意のあるデータを挿入する可能性があります。

**問題点: リクエストボディはウェブサーバーログに記録されません。**

ウェブログは、接続元IP、ブラウザの種類、クッキー、アクセス経路などの**ヘッダー情報のみ記録**するため、  
SIEMがウェブログを分析しても異常を検知することが難しい構造的な限界があります。

---

## PLURA-SIEMの解決策

**PLURA-SIEM**は、特許技術を活用して**リクエストボディ(Post-body)** をウェブログに記録し、分析することで異常を検知します。  
この革新的な機能により、SIEMソリューションの限界を克服し、より効果的な攻撃対策を提供します。

---

## 要約

1) WAFは**クレデンシャルスタッフィング攻撃**に対応できない。  
2) SIEMソリューションは**ウェブログだけでは異常を検知することが難しい**。  
3) リクエストボディ(Post-body)は**ウェブログに記録されない**。  
4) **PLURA-SIEM**はリクエストボディを記録し、分析することで**異常を検知する**。

---

## 参考リンク

- [1] [クレデンシャルスタッフィング攻撃への対応](https://blog.plura.io/ko/respond/credential_stuffing_response/)  
- [2] キュービットセキュリティ, ‘リアルタイムログ分析に基づく攻撃検知システムおよび方法’ (登録番号: 10-1896267)