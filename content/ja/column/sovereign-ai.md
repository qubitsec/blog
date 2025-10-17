---
title: "ソバリンAIの始まりは「ソバリンデータ」だ"
date: 2025-09-28
draft: false
description: "AI防御にならない理由はデータがないため、防御用データは‘生成’できます。"
featured_image: "cdn/column/sovereign-cybersecurity-00.png"
tags: ["Sovereign AI", "Sovereign Data", "ウェブログ", "監査ログ", "Sysmon", "auditd", "PLURA-XDR", "MITRE ATT&CK"]
---

## まとめ 1行

> **AI防衛はデータゲーム**です。今失敗の本質は**データがなくて**と、正解は**防御用データを「生成」する運用転換**です。
> Webは**リクエスト・応答本文**、サーバーは**監査ポリシーを有効にする**で**新しいログを作成** AIが働く資料を供給してください。

<!--more-->

![Why PLURA-XDR](https://blog.plura.io/cdn/column/sovereign-cybersecurity-00.png)

---

## 1) なぜ「ソバリンデータ」が防御の出発点なのか

* **AIはデータがなければ無能です。
* **攻撃はAIで高度化**されますが、 **防御はデータ不在**で「異常兆候→ストーリーライン→分離」が続くことはありません。
* **ソバリンAI**の意味はモデル国産化だけではなく、**国内環境/規定/言語/業務の文脈に合った「国産防御データ」の自給**です。

---

## 2) 今システムが失敗する典型的なパターン(兆候)

* **ウェブ本文未収集**: URI・状態コードのみあり **POST/Response Bodyがない**
* **ホスト可視性ゼロ**: **Advanced Audit Policy 非アクティブ**、Sysmon/auditd 未構成
* **TLS 可視性欠乏**: WAF/プロキシ・ALB で **復号化ポイントの本文ロギング部材**
* **PII(Personally Identifiable Information, 個人識別情報) 懸念で全面非収集**: **マスキング/トークン化**なしで「全く残さない」を選択
* **スキーマ不在**: フィールド乱立・重複・非定型で**AI学習/規則化不可**

---

## 3) 防御用データは「生成」できる — 原理

1. **ウェブ**: **リクエスト(Request) + レスポンス(Response)本文**を**復号化境界**(WAF/リバースプロキシ/アプリGW)で**ポリシー的に生成**
2. **サーバー/ホスト**: **監査ポリシーを「オンにして」** プロセス・ファイル・アカウント・ネットワーク行為を**構造化イベント**に**生成**
3. **プライバシー-セーフパイプライン**: **PIIマスキング・ハッシュ・トークン化**後保存 → **AI/検出エンジンがすぐに食べるスキーマ**で積載

---

## 4) Web: 要求・応答本文ログ設計（運営チェックリスト）

**目標:** ウェブシェルアップロード・経会・RCE・データ流出の**証拠とコンテキスト**を本文で捕捉

### 4.1どこでキャプチャするか（推奨優先順位）

1. **WAF/プロキシ/リバースプロキシ**(TLS 終点)
2. **アプリケーションサーバーエージェント**（フレームワークミドルウェアフック）
3. **eBPF/PCAP系列**(例外・フォレン食用、基本は非推奨)

### 4.2 収集ポリシー

* **基本**: `POST/PUT/PATCH` リクエスト本文 **全量またはサンプル+ルールベース全量**
* **高リスクエンドポイント**（アップロード・認証・決済・管理者）：**無条件全量**
* **応答(Response)**: `Content-Type` が `text/*`, `application/json|xml` など **意味のある本文** は **要約+専門(条件付)**
* **大容量バイナリ**: **ハッシュ(SHA-256)+ヘッダ+前後Nバイト**(スライドウィンドウ)保存

### 4.3 プライバシー・セキュリティ

* **サーバー団トークン化・マスキング**: カード・住民番号・セッショントークン **正規表現ベースの動的マスキング**
* **不可逆ハッシュ**（pepperを含む）で**識別子依存検出**可能に
* **DLPルール**：「個人情報フィールド送信時の専門保管禁止+要約のみ」選択可能

### 4.4 推奨スキーマ(要旨)

```json
{
  "ts": "2025-09-28T08:15:30.123Z",
  "trace_id": "1f3a...e9",
  "src_ip": "203.0.113.10",
  "dst_host": "app.example.com",
  "method": "POST",
  "url": "/api/upload",
  "status": 200,
  "req_hdr": {"ct":"multipart/form-data", "ua":"..."},
  "req_body": {"len": 5432, "hash": "sha256:...", "snippet_b64": "..."},
  "resp_hdr": {"ct":"application/json"},
  "resp_body": {"len": 321, "hash": "sha256:...", "snippet_b64": "..."},
  "pii_flags": ["email_masked","card_redacted"],
  "waf": {"policy":"post-body-on","action":"allow","signals":["anomaly_upload_ext_dbl"] }
}
```

### 4.5 実務のヒント

* **ヘッダ・ボディ分離保存 + 共通 trace_id** で **分散処理/組換え** 容易
* **サンプリング→ルール昇格**(疑わしい信号時の専門切り替え) **動的制御**
* **圧縮(Zstd)** + **ライフサイクル(ホット7日/ワーム30日/コールド180日)**

---

## 5）サーバー/ホスト：監査ポリシーでログを生成する（Windows・Linux）

### 5.1 Windows (Advanced Audit Policy + Sysmon)

**目標：**実行/権限上昇/アカウント/持続性/ネットワーク/ファイル変調の**連鎖証拠**

**必須監査ポリシー（要旨）**

* **Account Logon/Logon**: 成功・失敗
* **Object Access**: ファイル/レジストリ（高価値パスのみ）
* **Policy Change/Privilege Use/System/DS Access**
* **Detailed Tracking**: **Process Creation** オン

**クイックアプリケーションの例**

```powershell
# Manager PowerShell
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"Process Creation" /success:enable
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1 /f
```

**Sysmonコアイベント**

* **1**(Process Create)、**3**(Network Connect)、**7**(Image Load)、**10**(Process Access)、
* **11**(File Create), **12/13**(Registry Add/Set), **15**(FileStream),
* **17/18**(Pipe Created/Connected), **22**(DNS), **23/24**(FileDelete/Detected)

> 推奨：**署名/CLM/WDACポリシーとともに**「合法実行システム」を指定して**ノイズ最小化+攻撃面の可視化**。

### 5.2 Linux(auditd+コアトレース)

**auditdルール（要旨）**

* **execve** 呼び出し追跡: `-a always,exit -F arch=b64 -S execve -k exec`
* **uid/gid 変更・setuid**: `-S setuid,setreuid,...`
* **アカウント/グループの変更**: `/etc/passwd`, `/etc/shadow`, `/etc/sudoers` **ウォッチ**
* **ウェブルートを書く**: `/var/www/**` **w 権限監視**
* **権限上昇/ネットワーク設定**関連syscalls

**journald + eBPF補強**

* **SSH認証イベント**、**サービス再起動**、**コアダンプ**、**疑わしいDNS/出力**など**検出ルールに直結**される項目のみ補強

---

## 6) 30・60・90日ロードマップ（現実配布プラン）

**D+30 (可視性開通)**

* [ ] **TLS 終了点**から **POST 本体** キャプチャ開始（高リスクURI全量）
* [ ] **Windows Process Creation** + **Sysmon(1/3/10/22)** 最小セット
* [ ] **Linux auditd execve + ウェブルート w** ルール適用
* [ ] **PIIマスキングプロファイル** 1次稼働(カード/住民/トークン)
* [ ] **スキーマ固定 + trace_id** 統一

**D+60（品質・検出切替）**

* [ ] **回答本文まとめ/専門保管ルール** 精巧化
* [ ] **MITRE ATT&CKマッピングルールパック**（ウェブシェル、権限上昇、C2、データ漏洩）適用
* [ ] **サンプリング→専門文化切り替えロジック**（動的）配布
* [ ] **性能ガードレール**(QPS上限/ボディサイズ制限/圧縮)

**D+90 (AI準備も達成)**

* [ ] **シナリオ型ストーリーライン再構成**（ウェブ→ホスト連携）
* [ ] **LLM 補助 triage** アクティブ（プレイブック：隔離/アカウントロック/チケット）
* [ ] **品質指標(QoD)** KPI 運用(下記参照)

---

## 7）品質指標（QoD）＆AI準備図指標

* **本文カバレッジ**: 高リスクエンドポイントの **全量本文収集率(%)**
* **エンティティ忠実度**: `user/session/file/hash/dns/url` **欠落率↓**
* **接続性**: **Web イベント ↔ ホストイベント** **trace_id 結合率**
* **検出性能**: **MTTD/MTTR**、ストーリーライン再構成 **完了率**
* **プライバシー適合性**: **非マスキング保存率0%**を維持

---

## 8) 法・倫理・プライバシー

* **最小収集** + **目的制限** + **保存サイクル**
* **機密情報前面マスキング** 基本、フォレンジック必要時 **封印型アクセス**
* **アクセス制御・暗号化・アクセスログ** 義務化

---

## 9）失敗を呼ぶアンチパターン

* "**PII危険だから全く本文を残さない**"→**検出・フォレンジック不能**
* "**スキーマなしで打ち込む**"→**AI不可・性能地獄**
* "**TLS終端不明確**"→**本文キャプチャ不可**
* "**全量無圧縮・無寿命サイクル**"→**費用爆弾**

---

## 10）結論 - **データを作成するとAI防御が始まります**

* **ウェブ本文**と**監査ログ**は**今でも「生成」できる防御資産**です。
* **可視性(D+30)→品質(D+60)→AI連携(D+90)に段階的に切り替え**を踏んでください。
* ソバリンAIの本当の基盤は、**現場で育てたソバリンデータ**です。

---

## 付録 A. 運用チェックリスト（一枚まとめ）

* [ ] TLS 出口点の識別および **POST/Response ボディーロギング** 操作
* [ ] **PIIマスキング/トークン化**ポリシーの適用
* [ ] **スキーマ確定+ trace_id統一**
* [ ] Windows **Advanced Audit Policy + Sysmon(核心イベント)**
* [ ] Linux **auditd(execve, webroot w) + journald 強化**
* [ ] **ライフサイクル/圧縮**および**パフォーマンスガードレール**
* [ ] **MITREルールパック**連動および**ストーリーライン再構成**
* [ ] **QoD(Quality of Data) KPI** 運営 (カバレッジ・接続性・プライバシー)

---

## 付録B.（オプション）PLURA-XDRとの接続例

* **ウェブ**: WAF/プロキシ本体のキャプチャ → **Post-body 分析** + **MITRE マッピング**
* **ホスト**: Sysmon/auditd → **行為相関** → **AI SecOpsエージェント**が **分離/アカウントロック/チケット**を実行
* **TI**: 外部TI+内部検出フィードバックで**ソバリンインテリジェンス**を強化
