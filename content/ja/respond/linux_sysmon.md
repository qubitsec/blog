---
date: 2025-04-07
draft: false
title: "LinuxでもSysmonを使うべき理由！"
description: SysmonはeBPFベースの高度なセキュリティロギングツールであり、Linux環境でもリアルタイム脅威検知とMITRE ATT&CKとの連携を通じて強力なセキュリティ可視性を提供します。
featured_image: "cdn/respond/sysmon_linux.png"
tags: ["sysmon", "Linuxセキュリティ", "脅威検知", "eBPF", "MITRE ATT&CK", "PLURA"]
---

## **🚨 1. Sysmonとは何か？**

**Sysmon（System Monitor）は、WindowsおよびLinux環境においてシステムアクティビティを記録し、セキュリティ検知および脅威ハンティングのための重要な情報を提供するツールである。**

<!--more-->

Microsoftが提供するSysinternals Suiteの一部であり、セキュリティ分析者が悪意のある活動を検知するために必須となるログデータを収集する役割を果たす。

しかし、多くのセキュリティ運用者はいまだに **SysmonはWindowsでのみ有効** と考えており、これは **大きな誤解** である。

**LinuxにおいてもSysmonは強力なセキュリティモニタリングおよび脅威検知を可能にする。**

![sysmon_linux](https://blog.plura.io/cdn/respond/sysmon_linux.png)

---

## **2. なぜLinuxでもSysmonを使うべきか？**

### **2-1. Linux Sysmon vs. Linuxログ：主な違いの比較**

**従来のLinuxログシステムの限界**

- Linuxには`syslog`、`auditd`、`journald`などの基本的なロギングシステムがあるが、**プロセス実行の追跡、ファイル変更の監視、ネットワーク接続のモニタリング**を総合的に提供する機能が不足している。
- `auditd`は高レベルのカーネルイベントロギングを提供するが、**設定が難しく、分析が複雑で、ノイズログが多く、リアルタイム検知に不利**である。

**Sysmonの利点**

Sysmonは **eBPF（Extended Berkeley Packet Filter）** をベースに動作し、カーネルイベントを効果的に追跡して、従来のセキュリティロギングシステムより以下のような利点を提供する。

| 機能 | 従来のLinuxログ（syslog/auditd） | Sysmon |
| --- | --- | --- |
| **プロセス作成ログ（ProcessCreate）** | 制限あり（`auditd`設定が必要） | ✅ 強力なプロセストラッキングが可能 |
| **ファイルの作成と削除の監視** | 可能だが設定が複雑 | ✅ 簡単に設定可能 |
| **ネットワーク接続ログ** | `netstat`などで確認可能 | ✅ リアルタイムロギング |
| **カーネルモジュールのロード検出** | 制限あり（`dmesg`使用） | ✅ 検出可能 |
| **Lateral Movement検出** | ❌ `auditd`では困難 | ✅ Sysmonはプロセスとネットワークイベントの関連分析が可能 |
| **ノイズフィルタリング（イベントフィルタリング）** | ❌ すべてのイベントを記録 | ✅ 有効なイベントのみをフィルタリング可能 |

**つまり、Sysmonはカーネルから直接データを収集し、JSON形式の可読性の高いログを生成し、イベントフィルタリング機能により実質的な脅威検知が可能である。**

### **2-2. eBPFベースのSysmonが強力な理由**

🔹 **eBPF（Extended Berkeley Packet Filter）とは？**

- Linuxカーネルにおいて **ネットワークパケットのフィルタリングやシステムイベント監視を最適化する技術**
- セキュリティソリューションはeBPFを活用し、**オーバーヘッドを減らしつつ高度な検知機能を提供**

🔹 **SysmonはeBPFを活用して以下を実行する。**

✅ ネットワークパケットの監視（C2サーバー接続の検出）

✅ マルウェアプロセスの実行検知（ランサムウェア実行の追跡）

✅ カーネルモジュールのロードモニタリング（ルートキットの検出）

✅ ファイル改ざんの検知（データ漏洩の監視）

**つまり、SysmonはLinuxカーネルと直接連携して、より精密で効率的なセキュリティロギングを実現する。**

### **2-3. Sysmon for Linuxの主要機能（TIDマッピング）**

SysmonはMITRE ATT&CKフレームワークとマッピングされる **重要なイベントロギング機能** を提供する。

| Sysmonイベント | 説明 | 関連MITRE ATT&CK TID |
| --- | --- | --- |
| **ProcessCreate** | 新しいプロセスの実行を記録 | T1059 (Command and Scripting Interpreter) |
| **FileCreate** | ファイル作成イベントを監視 | T1203 (Exploitation for Client Execution) |
| **NetworkConnect** | ネットワーク接続発生時のログ記録 | T1071 (Application Layer Protocol) |
| **ModuleLoad** | カーネルモジュールのロードを検出 | T1543.003 (Create or Modify System Process: Windows Service) |
| **ProcessTerminate** | 特定プロセスの終了を検出 | T1489 (Service Stop) |

**これによりSysmonを活用すれば、Linuxでもセキュリティイベントを精密に分析し、脅威検知の精度を高めることができる。**

---

## **3. Sysmon for Linuxを活用した実践的な脅威検知シナリオ**

### **3-1. Linuxサーバーでの権限昇格（Sudo Exploit）の検出**

**攻撃シナリオ**

- 攻撃者が`wget`を使ってマルウェアをダウンロードして実行しようとする。
- `auditd`は`execve`呼び出しを追跡するが、設定が複雑で **ファイル実行時にどのようなネットワーク接続が行われたかを把握しづらい。**
- Sysmonは **プロセス実行（`ProcessCreate`）とネットワーク接続（`NetworkConnect`）を一括でログ記録**し、悪質なプロセスを簡単に検出可能。

**Sysmon検出ルール例（YAML構成）**

![sample01](https://github.com/user-attachments/assets/63908c7d-822c-409f-b314-b537e7b5f36b)

### **3-2. Linuxにおける悪質なネットワーク接続の検出**

**攻撃シナリオ**

- 攻撃者が **C2（Command & Control）サーバー**に接続して遠隔操作を行う。
- `auditd`にはネットワークトラフィック監視機能がなく、これを検知するのが困難。
- Sysmonは`NetworkConnect`イベントを通じて **外部C2サーバーとの接続をリアルタイムに監視**可能。

**Sysmon検出ルール例（YAML構成）**

![sample02](https://github.com/user-attachments/assets/d8d79e81-3854-4530-aabb-b5776c658ad9)

### **3-3. Sysmon for Linux vs Auditd 比較表**

| 機能 | Auditd | Sysmon for Linux |
| --- | --- | --- |
| インストールの必要性 | 🚫 標準搭載（`auditd`サービス有効化） | ✅ 別途インストールが必要（`sysmon`バイナリ） |
| プロセス実行監視（`execve`） | ✅ 可能 | ✅ 可能 |
| 親子関係の追跡 | ❌ 不可（個別イベントのみ記録） | ✅ 可能（`ProcessCreate`イベント） |
| ネットワークアクティビティの監視 | ❌ 制限あり（`syscall`ベース） | ✅ 可能（`NetworkConnect`イベント） |
| ファイルレス攻撃の検出 | ❌ 不可 | ✅ 可能（メモリ実行の検出） |
| C2（Command & Control）検出 | ❌ 不可 | ✅ 可能（ネットワーク接続とプロセス関連分析） |
| ファイルハッシュ出力 | ❌ 不可 | ✅ 可能（`FileCreate`など） |
| リソース使用量 | ✅ 低い（カーネルレベル監視） | 🔶 やや高め（ユーザー空間で動作） |

---

## **4. 結論：Linuxセキュリティ強化の必須ツール、Sysmon！**

**1. セキュリティ検出と脅威ハンティングの観点から**

- SysmonはMITRE ATT&CKフレームワークと緊密に連携しており、**権限昇格（T1548）、リモートコード実行（T1059）、マルウェア実行（T1203）などの攻撃技法をより直感的に検出**可能。

**2. イベントフィルタリングによるセキュリティ運用最適化**

- `auditd`は **不要なイベントまで記録してノイズが多い。**
- Sysmonは **フィルタリング機能（Event Filtering）を提供し、実際の脅威検出性能を最大化**。

**3. SIEMおよびクラウド環境との統合**

- SysmonはJSONベースのログを生成し、**Windows Sysmon、SIEM、XDRとの連携が容易**。
- クラウドベースのサーバー保護、コンテナ環境のセキュリティに最適化されたソリューション。

---

### **最終選択：Sysmonが適している環境**

✅ **SIEMと連携してログを分析する環境**

✅ **ネットワークベースの攻撃およびクラウド環境まで拡張された脅威ハンティングが必要な環境**

✅ **運用の単純化および効率的なログ管理が求められる環境**

✅ **Windows、Linux統合セキュリティモニタリングが必要な環境**

**つまり、リアルタイムの脅威検知とセキュリティ可視性を高めるためには、Sysmonが適したソリューションとなり得る。**
