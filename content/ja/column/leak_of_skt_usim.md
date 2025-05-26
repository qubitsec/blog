---
title: "SKTのUSIMハッキング事件総まとめ：流出原因、被害規模、対応方法まで"
date: 2025-05-02
draft: false
description: "2025年4月に発生したSKTのUSIM情報大規模流出事件の原因と被害規模、そして現実的な対応策までを簡単に整理しました。"
featured_image: "cdn/column/skt_usim.png"
tags: ["SKTハッキング", "SKT USIM流出", "USIMハッキング", "SIMスワッピング", "BPFDoor", "APT攻撃", "PLURA-XDR", "個人情報流出"]
---

> **要点の一行まとめ**  
> 2025年4月18日に確認されたSKテレコムの**HSS**ハッキングは、最大**2,300万人**のUSIM認証情報が漏洩し、SKTは4月28日に全顧客を対象とした無料USIM交換を発表しました。

<!--more-->
![SKT USIM流出](https://blog.plura.io/cdn/column/skt_usim.png)

---

## 🗓️ タイムライン
| 日付 | 内容 |
|------|------|
| **4月18日** | 侵害の内部認知・HSSサーバー隔離 |
| **4月19日** | KISA「BPFDoor系マルウェアの疑い」警報発令 |
| **4月28日** | SKTが公式発表 → 全顧客無料USIM交換発表、株価-8.5%急落 |
| **5月5日(予定)** | 全国2,600の代理店で新規加入を停止し、交換に集中 |

---

## 🔍 侵害手法：BPFDoor APTシナリオ（推定）
* **BPFDoor**はLinuxカーネルのBPFフックを利用して**パケット痕跡が残らない**ポートレスニング（backdoor）手法を実現します。  
* 初動の内部フォレンジック分析で、`udp/53`・`tcp/443`のリバースシェルの流れが識別されたとの通報がKISAに寄せられました（最終報告前）。

👉 [BPFDoorバックドアの動作原理](https://blog.plura.io/ja/respond/bpfdoor/)

> **NDRの限界と教訓**  
> ポートレス・TLS暗号化によるステルス型バックドアは、**パターンベースのNDR/IDSでは検出不可能**です。

---

## ⚠️ 二次被害のリスク：SIMスワッピング
漏洩した**IMSI・Ki・IMEI**の組み合わせは、SIMスワップ（名義盗用）攻撃に悪用される可能性があるため、金融・公共認証書の再発行とアカウント2FAの再設定が安全です。

---

## 🛡️ SKT・利用者・業界の対応
1. **SKTの対応**  
   * 全顧客無料USIM交換、USIM保護サービスの無償提供  
   * 新規加入1週間中断後、HSS再点検  
2. **利用者の必須対策**  
   ① USIM交換予約 → ② 主要アカウントの2FA再設定 → ③ 不審なSMSリンクの遮断  
3. **業界への示唆**  
   * **多層的検出体制**（PLURA-XDR）の導入が必須  
   * HSS・HLRなどのコアネットワーク機器に対する**ルートキット検出**の強化

---

## 🔐 PLURA-XDRで実現できる強化策

### ✅ 行動ベース検出の高度化

* **メモリ実行検出：** `/dev/shm`などの異常なパスでのメモリロードと実行動作をリアルタイムで検出し、プロセスの追跡を通じてバックドアの初期設置段階で遮断します。
* **ポートレス通信検出：** eBPFフィルターに基づく非標準通信方式を異常行動検出モデルで分析し、パターンベースのNDR/IDSが見逃す悪性通信も検出可能です。
* **リバースシェル検出：** 既存のファイアウォールやNDRシステムが見逃すリバースシェル接続の試み（例：`udp/53`、`tcp/443`の異常トラフィック）をリアルタイムで検出し、即時警告します。

### ✅ 深層ログ相関分析

* **統合ログ分析：** ネットワークログ、システムログ、アプリケーションログを統合し、インテリジェントな相関分析を実施。
* **攻撃グラフ分析：** 攻撃者の侵入・ラテラルムーブメント・データ流出などの各段階のログを時系列で接続し、攻撃経路と影響範囲を正確に可視化。
* **異常兆候の早期警報：** 異常兆候を事前に検出し、事故発生前に管理者が迅速に対応できるよう早期警報を提供。

### ✅ リアルタイム対応の自動化

* **自動対応：** PLURA-XDRが攻撃パターンや異常行動を検出した際、接続を自動で遮断または隔離し、二次被害を防止。
* **自動フォレンジックレポート：** 攻撃検出後すぐに関連フォレンジックデータを自動生成し、管理者が迅速にインシデント対応・報告を実行可能にします。

> **結論：** BPFDoorのようなステルス型APT攻撃は、従来のパターン検出では対応困難です。PLURA-XDRの高度な検出・対応技術は、初期侵入から事後分析までのすべての段階において確実な可視性と対応力を提供します。

---

### 📺 関連動画
* [BPFDoor攻撃、どうやって侵入するのか？｜PLURAリアルタイム検出デモ](https://www.youtube.com/watch?v=bzGv1AwHy9k)

### 📖 関連記事
* [SKTハッキングマルウェアBPFDoor分析とPLURA-XDR対応戦略（検出デモ動画付き）](https://blog.plura.io/ja/respond/bpfdoor/)  
* [SKTハッキング仮説：USIMデータの奪取とBPFDoorの設置はどう行われたか？](https://blog.plura.io/ja/column/skt-hacking-hypothesis/)

* [SKTハッキングから見るNDR技術の限界：BPFDoorのようなステルス攻撃への対応法](https://blog.plura.io/ja/column/limitations-ndr-bpfdoor/)  
* [多層・階層型セキュリティ、本当に必要か？](https://blog.plura.io/ja/column/overkill-multi-layer-security/)

### 📑 参考資料
* [Reuters - “SK Telecom shares plunge after data breach due to cyberattack” (2025-04-28)](https://www.reuters.com/sustainability/boards-policy-regulation/sk-telecom-shares-plunge-after-data-breach-due-cyberattack-2025-04-28)  
* [聯合ニュース - “最近のハッキング手法に警告…KISAがSKT関連マルウェア情報を公開” (2025-04-25)](https://www.yna.co.kr/view/AKR20250425168300017)  
* [Business Korea - “BPFDoor malware confirmed in SKT hack” (2025-04-29)](https://www.businesskorea.co.kr/news/articleView.html?idxno=241318)

### 🆙 PLURAアップデート案内
* [PLURAアップデート](https://github.com/qubitsec/plura/blob/main/update/v5.5/ja/2025.md)
