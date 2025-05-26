---
title: "PLURAを活用したBPFDoor検出：Auditログとフォレンジックに基づく対応"
date: 2025-05-20
draft: false
description: "BPFDoorはリナックスシステムに密かに侵入するバックドアです。PLURAはauditログとフォレンジック分析を通じて、その挙動を段階的に識別し検出します。"
featured_image: "cdn/respond/bpfdoor_with_plura.png"
tags: ["BPFDoor", "Linuxバックドア", "フォレンジック", "Auditログ", "PLURA", "インシデント対応", "ソケット検出", "デモ", "demo"]
---

## 🔍 PLURAによるBPFDoor攻撃の検出

最近、Linuxベースのシステムを狙った高度な脅威の一つとしてBPFDoorが注目されています。BPFDoorはBPF（Berkeley Packet Filter）を悪用してバックドア通信を可能にするAPT型Linuxバックドアであり、セキュリティソリューションの回避を試み、メモリベースで動作するため検出と対応が非常に困難です。

しかし、PLURAはBPFDoorの主要な挙動をリアルタイムで検出・分析することができます。本記事では、PLURAを通じてBPFDoorをどのように検出するのか、具体的な検出項目と方法をご紹介します。

<!--more-->
![bpfdoor_with_plura](https://blog.plura.io/cdn/respond/bpfdoor_with_plura.png)

❗**BPFDoor攻撃は通常のログにはほとんど記録されません。** **その追跡にはAuditログの設定が必須です。**

---

### 1. BPFDoorファイルの削除検出

- 検出概要：

  - BPFDoorは実行後、自身のファイルを削除して痕跡を隠します。これはメモリベース実行（backdoor in memory）のための事前準備です。

- 検出ログ：

![BPFDoorファイル削除の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_01.png)

  - コマンド："`/bin/rm -f /dev/shm/kdmtmpflush`"

  - 分析：一時ファイルシステムに存在する悪性実行ファイルが、実行後すぐに削除された

  - セキュリティ的意味：ディスクに痕跡を残さないための自己削除行為であり、メモリ上にバックドアが存在する可能性が高い

---

### 2. BPFDoorファイルの権限変更検出

- 検出概要：

  - BPFDoorはchmodコマンドでファイルに実行権限を付与して実行可能にします。

- 検出ログ：

![BPFDoorファイル権限変更の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_02.png)

  - コマンド："`chmod 755 /dev/shm/kdmtmpflush`"

  - 分析：ファイルの実行を目的とした権限変更であり、攻撃準備段階に該当

  - セキュリティ的意味：攻撃者がアップロードした悪性ファイルを実行する前の段階

---

### 3. BPFDoorファイルの複製検出

- 検出概要：

  - BPFDoorはシステム内に複製されて実行され、パスや名前が偽装されることがあります。

- 検出ログ：

![BPFDoorファイル複製の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_03.png)

  - コマンド："`cp ./bpfdoor /dev/shm/kdmtmpflush`"

  - 分析：実際の悪性実行ファイルが /dev/shm に複製された

  - セキュリティ的意味：検出を避けるための場所移動および名前の変更

---

### 4. BPFDoorファイルの実行検出

- 検出概要：

  - ファイルが実行されると、実際にバックドア機能が有効になります。`execve`システムコールが発生し、実行ファイルのパスが確認されます。

- 検出ログ：

![BPFDoorファイル実行の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_04.png)

  - 実行ファイル："`/dev/shm/kdmtmpflush`"

  - 分析：ファイルがroot権限で実行され、`execve`システムコールでプロセスが生成された

  - セキュリティ的意味：バックドアが実行された地点であり、その後の通信・ソケット生成が続く

---

### 5. BPFDoor 初期化実行の検出（--init 使用）

- 検出概要

  - BPFDoorは `--init` フラグを用いてメモリベースで初期化実行されます。これはファイル削除後も動作を維持させるための重要な機能です。

- 検出ログ

![BPFDoor 初期化実行の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_05.png)

  - 実行コマンド: "`/dev/shm/kdmtmpflush --init`"

  - 分析: ファイル削除と同時にメモリ上での実行維持のため初期化処理を実行

  - セキュリティ的意味: 検出を回避し、長期間の隠密な実行を狙った戦略

---

### 6. BPFDoor ソケット生成の検出

- 検出概要

  - 実行された BPFDoor は外部コマンドを受信するために `socket()` システムコールを使い通信用ソケットを生成します。

- 検出ログ

![BPFDoor ソケット生成の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_06.png)

  - 偽装された comm フィールド: Hex → /sbin/udevd -d

  - 分析: 悪性プロセスが正規サービスのように偽装しソケットを生成

  - セキュリティ的意味: バックドア通信の開始点、偽装実行の検出が必要

- 🔥BPFDoor ソケットが検出された場合

  - 🔌 フォレンジックに基づく詳細分析

    - PLURAは異常な挙動が検出された後、フォレンジック機能により以下を詳細に分析します：

    - マジックバイト分析：BPFDoorに関連する固有シグネチャの検出（21139, 29269, 960051513, 36204, 40783）

      ![フォレンジック_マジックバイト](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_10.png)

    - 環境変数分析：隠蔽された悪性環境変数の有無を確認

      ![環境変数分析](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_07.png)
  
    - 疑わしいセッションおよびポート使用分析：非標準ポート使用（例：42391〜43390、8000）

      ![疑わしいセッションおよびポート使用分析](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_08.png)

---

### 7. iptables コマンドによるファイアウォール設定変更の検出

- 検出概要

  - BPFDoor は攻撃者のトラフィックを正常に受信するため、システムのファイアウォール規則を回避または削除します。

- 検出ログ

![iptables コマンドによるファイアウォール設定変更の検出](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_09.png)

  - 行動: NAT テーブルの規則削除（nft_unregister_rule）

  - 分析: iptables コマンドを使い PREROUTING/NAT 規則を回避

  - セキュリティ的意味: 既存のファイアウォール規則を削除して外部接続を許可しようとする攻撃者の意図

---

### 🛡️PLURA EDR 対応フィルター

PLURAは検出だけでなく、EDR対応フィルターを通じてBPFDoorプロセスをリアルタイムでブロックし、強制終了させることができます。

- EDRフィルター適用前

  ![EDRフィルター適用前](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_11.png)

- EDRフィルター適用後

  ![EDRフィルター適用後](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_12.png)

BPFDoorプロセスが実行されると、PLURAはこれを即時に検出し、該当プロセスを自動的にブロックおよび終了させます。  
その結果、リバースシェル接続の試みは失敗し、バックドアは正常に動作できません。  
結果的に、攻撃者は後続のコマンドや通信をまったく実行できなくなります。

![BPFDoor ソケット遮断フィルター](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_13.png)

---

### ✅ 結論

BPFDoorは高度に隠密で精巧なLinuxバックドアですが、PLURAは多様な挙動ベースの検出およびフォレンジック分析を通じて、その脅威をリアルタイムに識別・対応できます。

Linuxサーバーのセキュリティを強化し、APT攻撃に備えるためには、PLURAによる継続的なモニタリングと検出が必要です。

### 📺 一緒に見る
* [BPFDoor、こうして捕まえる！｜PLURAのAuditログベースリアルタイム検出デモ](https://youtu.be/Rkz7vNAM0ZY)

### 📖 関連資料を読む
* [LinuxでもSysmonを使うべき理由！](https://blog.plura.io/ja/respond/linux_sysmon/)
* [PLURAでMicrosoft Defender Antivirusログを確認する](https://blog.plura.io/ja/respond/plura-microsoft-defender-logs/)
* [Process Hollowing：攻撃手法と検出戦略](https://blog.plura.io/ja/respond/process_hollowing/)
* [MITRE ATT&CKの視点でEmotet（エモテット）を検出する](https://blog.plura.io/ja/respond/detecting-emotet-with-mitre-attck/)
* [RANSOMWARE相関分析フィルター](https://blog.plura.io/ja/respond/ransomeware_correlation_filter/)
