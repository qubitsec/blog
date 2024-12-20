---
date: 2023-05-13
draft: false
title: "ゼロトラストアーキテクチャ(ZTA)の論理構成要素"
description: 
featured_image: "cdn/column/zero_trust_architecture-1.png"
tags: ["Zero Trust", "ZTA", "セキュリティ", "NIST"]
---

### 1. ポリシーエンジン (PE, Policy Engine)
- **役割:** 主体に対してリソースアクセス権を付与するかを決定します。  
- **機能:** 
  - 外部ソース（例: CDMシステム、脅威インテリジェンス）や企業ポリシーを基にアクセスを許可、拒否、または取り消します。
  - ポリシーアドミニストレータ(PA)と連携して動作し、決定内容を記録および伝達します。

![zero_trust_architecture](https://blog.plura.io/cdn/column/zero_trust_architecture-1.png)
<!--more-->
> **Zero Trust Architecture, NIST Special Publication 800-207**  
> Google翻訳による翻訳

---

### 2. ポリシーアドミニストレータ (PA, Policy Administrator)
- **役割:** 主体とリソース間の通信経路を設定または終了します。  
- **機能:** 
  - 認証トークンや資格情報を生成します。
  - PEの決定に基づき、セッションを承認または終了するためにPEPに指示を送ります。

---

### 3. ポリシー実行ポイント (PEP, Policy Enforcement Point)
- **役割:** 主体とリソース間の接続を有効化、監視、終了します。  
- **機能:** 
  - PAと通信し、リクエストを転送したり、ポリシーの更新を受信します。
  - クライアント側（例: ノートパソコンエージェント）とリソース側（例: ゲートウェイ）に分類されます。

---

### 4. 継続的診断と緩和 (CDM, Continuous Diagnostics and Mitigation)
- **役割:** 企業資産の現在の状態情報を収集し、ソフトウェアの更新を適用します。  
- **機能:** 
  - ポリシーエンジンに資産情報（OS状態、整合性など）を提供します。

---

### 5. 業界規制遵守 (Industry Compliance)
- **役割:** 企業が規制要件を遵守できるように保証します。  
- **機能:** 
  - FISMA、金融および医療情報セキュリティ要件への対応を支援します。

---

### 6. 脅威インテリジェンスフィード (Threat Intelligence Feed)
- **役割:** ポリシーエンジンの決定に活用される情報を提供します。  
- **機能:** 
  - 新しい脆弱性、マルウェア、攻撃に関する最新情報を提供します。

---

### 7. ネットワークおよびシステム活動ログ (Network and System Activity Logs)
- **役割:** 資産ログ、ネットワークトラフィック、リソースアクセス操作などのリアルタイムデータを集約します。  
- **機能:** 
  - 企業情報システムのセキュリティ状態を監視します。

---

### 8. データアクセスポリシー (Data Access Policies)
- **役割:** リソースに関する属性、ルール、ポリシーを定義します。  
- **機能:** 
  - アカウントやアプリケーション/サービスに対する基本アクセス権を提供します。

---

### 9. 公開鍵基盤 (PKI, Public Key Infrastructure)
- **役割:** 証明書を生成し、記録します。  
- **機能:** 
  - リソース、主体、サービス、アプリケーションに対して証明書を発行します。

---

### 10. ID管理 (IDM, Identity Management)
- **役割:** 企業ユーザーアカウントとID情報を生成、保存、管理します。  
- **機能:** 
  - 主体の役割、アクセス属性、資産割り当て情報を含みます。

---

### 11. セキュリティ情報およびイベント管理 (SIEM, Security Information and Event Management)
- **役割:** セキュリティ情報を収集し、ポリシー改善に活用します。  
- **機能:** 
  - 潜在的な攻撃の可能性を警告し、分析のためにデータを保存します。

---

### 参考資料

1. NIST SP 800-207: [Zero Trust Architecture](https://csrc.nist.gov/publications/detail/sp/800-207/final)  
2. KISA翻訳: "常時診断および対応"  
3. Google翻訳: "セキュリティ情報およびイベント管理"
