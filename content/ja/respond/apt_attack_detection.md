---
date: 2022-03-14T00:00:00
description: 
featured_image: 
tags: ["APT攻撃", "MITRE ATT&CK", "サイバーセキュリティ", "マルウェア", "PLURA"]
title: "高度持続脅威（APT）攻撃"
---

![blog_banner-220318-44](https://github.com/user-attachments/assets/ad176ad3-afa4-4387-b330-0ea017d0ac8d)

C社では、システムのCPUに負荷がかかり障害が発生するなど、持続的な脅威にさらされていました。
<br>CPUに負荷を与える要因を探しましたが、原因を特定することができませんでした。

さまざまなアンチウイルスソフトウェアをインストールして検出を試みましたが、いずれも効果がありませんでした。

システムを再インストールするにはリスクが大きすぎて、踏み切ることができません。<br>
特に週末には必ずと言っていいほど障害が発生し、出勤する羽目になっています。
<br>

## 対応方法
最近のAPT攻撃は、既知のマルウェアを使用せず、<br>
PowerShellなどのスクリプトを利用したマルウェアは、アンチウイルスソフトウェアでは検出が非常に困難です。

>**PLURAは、マルウェアの動作を分析して検出します。<br>
><br>
>MITRE ATT&CKに基づいて検出を行い、<br>
>検出結果は5W1Hに従って提供されるため、原因を把握し対応するのに十分です。**
<br>

## 内部ブログ
- MITRE ATT&CKを理解する : https://blog.plura.io/ko/column/mitre/
<br>

## 関連動画 
- ハッキング検出デモ > APT29（MITRE ATT&CK）: https://youtu.be/ZrV9dGkwA_U?si=LOYnNc2wyVr-h9wR
