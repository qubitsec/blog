---
date: 2020-12-21T00:00:00
description: 
featured_image: "cdn/column/matrix-1.png"
tags: ["MITRE ATT&CK", "セキュリティフレームワーク", "APT攻撃", "サイバーセキュリティ", "PLURA"]
title: "MITRE ATT&CKの理解"
---

マイター（MITRE）は、脆弱性データベースであるCVE（Common Vulnerabilities and Exposures）を監督する非営利団体であり、ATT&CK（Adversarial Tactics, Techniques, and Common Knowledge）というサイバー攻撃戦術および技術に関する情報を提供するセキュリティフレームワークを提供しています。

![Mitre_matrix](https://blog.plura.io/cdn/column/matrix-1.png)

<!--more-->
---

Windowsエンタープライズネットワークに対するAPT攻撃のTTP（戦術、技術、手順）を文書化することで始まり、攻撃者がエンドポイントまたはシステムと相互作用する際に発生する行動パターンを分析し、攻撃者の行動を識別するフレームワークを提供します。  
攻撃者の目標を示す戦術（Tactics）は、偵察からデータ流出または攻撃の最終目標までを線形に示し、目標達成のための具体的な攻撃技術（Techniques）を分類して提供します。

2018年1月にATT&CK v1が発表され、2021年4月にはATT&CK v9が発表されました。

## MITRE ATT&CKの構造

* **ATT&CK Matrix**  
  - 戦術（Tactic）と技術（Technique）の概念および関係を視覚化。  
  - 各Tacticは複数のTechniqueを含む。  
  - Tacticは攻撃目的によって異なる。

* **ATT&CK Tactics**  
  - 攻撃目的に応じた攻撃者の行動を表す。  
  - 各Techniqueのカテゴリとしての役割を果たす。  
  - 永続性、情報探索、実行、データ抽出など、攻撃者の目的ごとに分類。

* **ATT&CK Techniques**  
  - 攻撃者がTacticを達成するための具体的な方法を示す。  
  - Techniqueを使用することによる結果（被害）を明記。  
  - 各Tacticに応じて多様なTechniqueが存在する。

---

## MITRE ATT&CKの構成

* **ATT&CK Mitigations**  
  - 防御者（管理者）が攻撃を防止し、検知するために取るべき行動を指す。  
  - セキュリティ目的やシステム状況に応じて重複してMitigationを適用可能。

* **ATT&CK Groups**  
  - 公開されたハッカーグループの情報および攻撃技術を分析し整理。  
  - 使用された攻撃手法や活動の分析に基づきグループを特定。  
  - 攻撃で使用されたTechniqueおよびソフトウェアリストを含む。  
  - 各グループに関連する他のグループ情報や攻撃対象、特徴も提供。

---

## ATT&CK For Enterprise Matrix

* **構成と目的**  
  - 企業ネットワークに対する14のTactic、205のTechniqueをカテゴリごとにリスト化。  
  - Cyber Kill Chainモデルの5段階（Deliver, Exploit, Control, Execute, Maintain）に対応。  
  - 攻撃者のTTP、ネットワーク攻撃活動の特徴に基づいて作成。

* **活用方法**  
  - 防御優先順位の設定。  
  - 防御システム間の機能・性能分析。  
  - 脆弱性分析とMitigationの統合。  

* **対応プラットフォーム**  
  - Windows、macOS、Linux  
  - AWS、GCP、Azure、Azure AD、Office 365、SaaS

---

## ATT&CK For Enterprise Tactics

* **Tactics（14種類）**  
  - TA0043: 偵察（Reconnaissance）  
  - TA0042: リソース開発（Resource Development）  
  - TA0001: 初期アクセス（Initial Access）  
  - TA0002: 実行（Execution）  
  - TA0003: 永続性（Persistence）  
  - TA0004: 権限昇格（Privilege Escalation）  
  - TA0005: 防御回避（Defense Evasion）  
  - TA0006: 資格情報取得（Credential Access）  
  - TA0007: 情報探索（Discovery）  
  - TA0008: 内部移動（Lateral Movement）  
  - TA0009: データ収集（Collection）  
  - TA0011: 指令と制御（Command And Control）  
  - TA0010: データ流出（Exfiltration）  
  - TA0040: 影響（Impact）

* **Techniques（205種類）**  
  - 初期アクセス（Initial Access）：Valid Account, Exploit Public-Facing Application  
  - 実行（Execution）：Command-Line Interface, PowerShell Scripting  
  - 永続性（Persistence）：Web Shell, Scheduled Task  
  - 防御回避（Defense Evasion）：Scripting, Disabling Security Tools  
  - 内部移動（Lateral Movement）：Remote Desktop Protocol, Remote Service  

---

## PLURA APT29 (MITRE ATT&CK) ハッキング検知デモ動画
https://www.youtube.com/watch?v=fqLpY4NEDXc&embeds_referring_euri=http%3A%2F%2Fblog.plura.io%2F&source_ve_path=MjM4NTE
