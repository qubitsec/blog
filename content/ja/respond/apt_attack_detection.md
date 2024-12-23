---
date: 2022-03-14T00:00:00
draft: false
title: "高度持続脅威（APT）攻撃"
description: 
featured_image: "cdn/respond/advanced_persistent_threat-1.png"
tags: ["APT攻撃", "MITRE ATT&CK", "サイバーセキュリティ", "マルウェア", "PLURA"]
---

C社では、システムのCPUに負荷がかかり障害が発生するなど、持続的な脅威にさらされていました。
<br>CPUに負荷を与える要因を探しましたが、原因を特定することができませんでした。

<!--more-->

さまざまなアンチウイルスソフトウェアをインストールして検出を試みましたが、いずれも効果がありませんでした。

システムを再インストールするにはリスクが大きすぎて、踏み切ることができません。<br>
特に週末には必ずと言っていいほど障害が発生し、出勤する羽目になっています。
<br>

![advanced_persistent_threat](https://blog.plura.io/cdn/respond/advanced_persistent_threat-1.png)

---

## 🛠️対応方法
最近のAPT攻撃は、既知のマルウェアを使用せず、<br>
PowerShellなどのスクリプトを利用したマルウェアは、アンチウイルスソフトウェアでは検出が非常に困難です。

>**PLURAは、マルウェアの動作を分析して検出します。<br>
><br>
>MITRE ATT&CKに基づいて検出を行い、<br>
>検出結果は5W1Hに従って提供されるため、原因を把握し対応するのに十分です。**
<br>

## 📖一緒に読む
- [MITRE ATT&CKについて](https://blog.plura.io/ko/column/mitre_attck/)  
- [マイターアタックの観点から高度な監査政策](https://blog.plura.io/ko/column/mitre_attack_audit_policy/)

## 関連動画 
▶️[APT29](https://www.youtube.com/watch?v=fqLpY4NEDXc)
