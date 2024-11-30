---
date: 2023-02-20T00:00:00
description: 
featured_image: 
tags: ["ANONYMOUS LOGON", "NTLM V1", "セキュリティポリシー", "Microsoft", "KISA", "LAN Manager", "認証セキュリティ"]
title: "ANONYMOUS LOGON、NTLM V1 使用ポリシーの無効化"
---

![column-20230220-4](https://github.com/user-attachments/assets/2611df5b-5c37-4cf1-8ee8-56ee3c8cc0db)

## ANONYMOUS LOGONとは？

匿名ユーザーアカウントを通じて**認証なしでファイルおよびフォルダにアクセス**できる機能を指します。  
この設定が有効になっている場合、**セキュリティリスク**が高まる可能性があります。

---

## NTLM V1とは？

**NT (New Technology) LAN Manager**は、ユーザー認証、データ完全性、機密性を提供する**Microsoftのセキュリティプロトコル**です。  
しかし、NTLM V1は**セキュリティレベルが低いため**、現在では無効化が推奨されています。  
- **セキュリティの脆弱性**: 8文字のパスワードハッシュを6時間以内に解読可能。  
- [関連記事を読む](https://arstechnica.com/information-technology/2012/12/25-gpu-cluster-cracks-every-standard-windows-password-in-6-hours/)

---

## ANONYMOUS LOGONを無効化する方法

**参考**: [KISA 主要情報通信基盤施設 W-42](https://github.com/QubitSecurity/VAS/tree/main/v.2021.03/windows)

### 設定方法

| 項目           | 内容                                                                                      |
|----------------|------------------------------------------------------------------------------------------|
| **点検内容**   | `SAM アカウントと共有の匿名列挙を許可しない`ポリシーの設定状況を確認                             |
| **点検目的**   | 匿名ユーザーによる悪意あるアカウント情報の窃取を防止するため                                      |
| **良好基準**   | セキュリティオプションの値が設定されている場合                                                |
| **脆弱基準**   | セキュリティオプションの値が設定されていない場合                                              |
| **措置方法**   | Windows 2003, 2008, 2012, 2016, 2019<br> 1. **スタート** > **実行** > `SECPOL.MSC`<br> 2. **ローカルポリシー** > **セキュリティオプション**<br> 3. `ネットワークアクセス: SAM アカウントと共有の匿名列挙を許可しない`と`ネットワークアクセス: SAM アカウントの匿名列挙を許可しない`を**有効**に設定 |

---

## NTLM V1を無効化する方法

**参考**: [KISA 主要情報通信基盤施設 W-77](https://github.com/QubitSecurity/VAS/tree/main/v.2021.03/windows)

### 設定方法

| 項目           | 内容                                                                                      |
|----------------|------------------------------------------------------------------------------------------|
| **点検内容**   | LAN Manager 認証レベルの適切性を確認                                                       |
| **点検目的**   | LAN Manager 認証レベルを設定し、ネットワークログオン認証プロトコルを決定、安全な認証手続きを適用するため             |
| **良好基準**   | `LAN Manager 認証レベル`ポリシーが`NTLMv2 応答のみを送信`に設定されている場合                         |
| **脆弱基準**   | `LAN Manager 認証レベル`ポリシーが`LM`および`NTLM`認証に設定されている場合                            |
| **措置方法**   | Windows 2003, 2008, 2012, 2016, 2019<br> 1. **スタート** > **実行** > `SECPOL.MSC`<br> 2. **ローカルポリシー** > **セキュリティオプション**<br> 3. `ネットワークセキュリティ: LAN Manager 認証レベル`ポリシーを`NTLMv2 応答のみを送信`に設定 |

---

## 参考資料

- [6時間以内にすべての標準Windowsパスワードを解読可能](https://arstechnica.com/information-technology/2012/12/25-gpu-cluster-cracks-every-standard-windows-password-in-6-hours/)
- [KISA 主要情報通信基盤施設セキュリティガイド](https://www.kisa.or.kr/)
