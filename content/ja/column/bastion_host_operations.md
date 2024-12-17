---
date: 2020-12-30T00:00:00
description: 
featured_image: "cdn/column/bastion_hosts-1.png"
tags: ["Bastion Host", "AWS", "VPC", "EC2", "セキュリティ", "プライベートサブネット"]
title: "Bastion Host 運用"
---

## Bastion Hostとは？

Bastion Hostは、PublicネットワークからPrivateネットワークへのアクセスを提供する目的のサーバーです。  
通常、**Amazon VPC (Virtual Private Cloud)**のPublicサブネットに配置されたAmazon EC2インスタンスで実行されます。

- Linuxインスタンスは、Publicサブネットに接続されたBastion Hostを通じてPrivateサブネット内のリソースにアクセスできます。  
- Bastion HostはSSHトラフィックを許可し、セキュリティグループによって制御されます。

![bastion_host](https://blog.plura.io/cdn/column/bastion_hosts-1.png)
<!--more-->
---

以下の図は、Bastion Hostを介した接続を説明しています：

![NM_diagram_061316_a](https://github.com/user-attachments/assets/0972fe30-7d5e-4e92-a1a5-81d603a1e4e0)

---

## Bastion Host運用

### A. EC2の設定

#### 1. インスタンス
1) **Bastion Host**
   - **IP:** Public IPを割り当てる
   - **サブネット:** Publicサブネット1に配置

2) **WebServer Instance1**
   - **IP:** Public IPは割り当てない
   - **サブネット:** Privateサブネット1に配置

![00](https://github.com/user-attachments/assets/abec3ff3-5c70-461e-be3d-a6c6de9db1b8)

---

#### 2. セキュリティグループの設定
1) **Bastion Host**
   - **タイプ:** SSH  
   - **ソース:** My IP (Bastion Hostに接続するHost PCのグローバルIPを指定)

2) **WebServer Instance1**
   - **タイプ:** SSH  
   - **ソース:** Bastion HostのPublicサブネットに割り当てられたIPアドレスを指定

![11](https://github.com/user-attachments/assets/d8ebbe8a-1fcf-4256-8ede-49b746b4afa1)

---

### B. VPCの設定

#### 1. VPC
- **CIDR:** `172.31.0.0/16`

![55](https://github.com/user-attachments/assets/d27ef032-09be-41ca-8049-a8dc95e301b7)

---

#### 2. サブネット
- **プライベートサブネット:** `172.31.16.0/20`  
- **パブリックサブネット:** `172.31.0.0/20`

---

#### 3. ルートテーブル
1) **プライベートルートテーブル**  
   - ローカルネットワーク帯域のみをルーティング

2) **パブリックルートテーブル**  
   - ローカル帯域外のトラフィックはインターネットゲートウェイにルーティングし、外部通信を可能にする

---

#### 4. ネットワークACLの設定
1) **プライベートサブネットACL**  
   - Bastion HostからのSSH接続のみを許可

2) **パブリックサブネットACL**  
   - すべてのソースからSSHリクエストを許可（必要に応じてセキュリティグループで詳細制御）

---

### C. SSH接続

1) **Bastion Hostへの接続**  
   - Public IPを使用

2) **`pem`ファイルのアップロード**  
   - Bastion HostからPrivateサブネット内のインスタンスに接続するには.pemファイルが必要

3) **PrivateサブネットへのSSH接続**

```bash
$ ssh -i "plura.pem" ec2-user@172.31.20.117
```

![22](https://github.com/user-attachments/assets/c76591b9-caf7-474d-9445-3d7e8425ff34)

---

## Bastion Host運用の目的

![33-1](https://github.com/user-attachments/assets/c3f207b3-abf3-4abb-b44f-72d750646247)

Publicサーバー1台で1日に約11,000件のログイン失敗が検出された事例です。  
Publicサーバーは1日に数万〜数十万件のアカウント乗っ取り攻撃を受ける可能性があります。

- ファイアウォールで管理してもすべてのIPを制御することは難しく、セキュリティの脆弱性につながります。  
- **Bastion Host運用により、Privateインスタンスのアクセスログを一元的に収集して管理が容易になります。**

**重要: Bastion HostはLinuxインスタンスへの唯一のSSHトラフィックソースです。**

![44-1](https://github.com/user-attachments/assets/07a841a2-7b47-48c7-b254-d244842407ad)

PLURAでは、公開鍵ログイン成功時にPrivateインスタンスへのアクセスIPアドレスや作成日をフィルタリングして検出します。

---

## 参考
- [AWS Bastion Hostの使用ガイド](https://aws.amazon.com/ko/blogs/security/how-to-record-ssh-sessions-established-through-a-bastion-host/)  
- [Terraform Bastion Hostモジュール](https://registry.terraform.io/modules/Guimove/bastion/aws/latest)  
- [Bastion Host運用方法](https://galid1.tistory.com/365)
