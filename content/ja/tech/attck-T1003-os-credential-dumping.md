---  
title: "RAM にあるパスワードを狙う – T1003.001: LSASS メモリ ダンプ攻撃"  
date: 2025-06-20  
draft: false  
description: "T1003.001 技法（LSASS メモリ ダンプ）を利用した資格情報盗難方法と Event ID に基づく検出、LSASS PPL、Credential Guard などの対策戦略をまとめます。"  
featured_image: "cdn/respond/attck-T1003-os-credential-dumping.png"  
tags: ["MITRE ATT&CK", "T1003.001", "LSASS Memory", "Credential Dumping", "RAM 攻撃", "EDR", "PLURA‑XDR", "サイバーセキュリティ"]  
---

> **要約 3行**  
> 1️⃣ 攻撃者は `lsass.exe` のメモリをダンプしてパスワード ハッシュやトークンを盗み取ります。  
> 2️⃣ Event ID 4656/10 などのプロセス-ハンドルアクセスログで検出可能です。  
> 3️⃣ **LSASS PPL + Credential Guard + ASR ルール** によって事前に阻止してください。

![ATT&CK アイコンと LSASS メモリ ダンプ 概要](https://blog.plura.io/cdn/respond/attck-T1003-os-credential-dumping.png)

<!--more-->

## 🔎 関連 MITRE ATT&CK 技法

| ID            | 名前 | 主な内容 |
|--------------|------|----------|
| **T1003.001** | **OS Credential Dumping: LSASS Memory** | `lsass.exe` プロセスメモリをダンプしてパスワード ハッシュや Kerberos チケットなどを抽出 |
| **T1560.001** | Archive Collected Data: `.zip` | 盗んだハッシュを ZIP に圧縮•暗号化して外部に持ち出し |
| **T1078**     | Valid Accounts | ダンプしたハッシュを再利用し、ラテラル移動（水平移動） |

> 📌 **なぜ LSASS なのか？**  
> LSASS（Local Security Authority SubSystem）はログインや SSO の資格情報をメモリに平文またはハッシュ形式で保持します。SYSTEM 権限を得れば、コスト <= リターン の攻撃構造が成立します。

---

## 🧑‍💻 攻撃ワークフロー（例）

1. **権限昇格** – `CVE‑2022‑24521` などのカーネル脆弱性や DACL 誤設定を利用して SYSTEM 権限を取得  
2. **メモリ ダンプ**  
   ```powershell
   procdump.exe -accepteula -ma lsass.exe lsass.dmp   # Sysinternals 使用
   rundll32.exe C:\windows\system32\comsvcs.dll, MiniDump  # LOLBINS 技法
    ```
3. **クラック** – Mimikatz sekurlsa::minidump lsass.dmp  
4. **再利用** – psexec /hashes:<NTLM> で SMB セッションをハイジャック  

## 🛠 検出ポイント

| ログソース              | イベント ID                                | 意味                                              |
|----------------------|------------------------------------------|---------------------------------------------------|
| **Windows Security** | **4656**（特権プロセスハンドル要求）           | ProcessName: lsass.exe に対して GrantedAccess: 0x40 |
| **Sysmon**           | **10**                                    | lsass.exe に対する **PROCESS_ACCESS** の発生        |
| **ETW**              | Microsoft‑Windows‑Kernel‑Process/4674     | HANDLE_DUPLICATE → ハンドル複製の試行                  |

> 🎯 **ヒント** – 「TargetImage contains lsass.exe AND CallTrace not contains \Windows\System32\lsass.exe」の条件で誤検出を最小化

## 🛡 対応・遮断戦略

| 対策                                     | コマンド/パス                                                                 | 説明                                  |
|----------------------------------------|-----------------------------------------------------------------------------|--------------------------------------|
| **LSASS PPL**（Protected Process Light） | reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v RunAsPPL /t REG_DWORD /d 1 /f | 署名済みドライバがなければハンドルアクセスを遮断 |
| **Credential Guard**                  | Windows Features → Device Guard → Enable                                   | 仮想化ベースのセキュリティ（VBS）で認証トークンを分離 |
| **ASR ルール**                          | Block credential stealing from LSASS <br>GUID: 9E6B...                     | Microsoft Defender for Endpoint に適用 |
| **PLURA‑XDR**                         | リアルタイムのハンドルアクセスログ記録 + MITRE マッピング                                  | EVENT 10 → 自動遮断 & KQL 検索対応    |

```powershell
# LSASS PPL 有効化スクリプト（Windows 10 20H2+）
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d 1 /f
Write-Output "[+] LSASS が Protected Process Light モードに移行しました。"
```
> ☢ **注意** : Registry を変更する前に、テスト環境での互換性確認が必須です。

## 📚 実例と教訓

| 年       | キャンペーン           | LSASS 関連性・示唆                                       |
|--------|--------------------|--------------------------------------------------------|
| **2022** | **HermeticWiper** | ディスク破壊の前に LSASS メモリやリカバリセクタに痕跡を残し、復元を妨害 |
| **2017** | **NotPetya**      | WMI・PSExec での拡散時に盗まれたハッシュを再利用 → 広範なラテラルムーブメント発生 |
| **2019** | **LockerGoga**    | 高速暗号化と並行して LSASS にアクセスし、ローカル・ドメインのハッシュを盗んで感染範囲を拡大 |

## ⚖ 免責事項

本記事は教育・研究目的で提供されています。運用環境に設定を適用する前に **専門家に相談**し、バックアップおよびテスト手順を順守してください。攻撃グループやサンプルによって挙動が異なる場合があります。

## 🔚 結論

* **lsass.exe のメモリ**は「ゴールデンキー」です。管理者は *EVENT ID → LSASS PPL → Credential Guard* の3ステップを必ず実施してください。  
* **攻撃より先に検知が必要**です。EDR / SIEM に詳細なイベントを送信し、MITRE ATT&CK に基づくモニタリング体制を構築しましょう。  
* **PLURA‑XDR** は LSASS ハンドル要求をリアルタイムに可視化し、遮断ポリシーを自動化して被害範囲を最小化します。

> *Protect Process, Protect Credentials, Protect Enterprise.*


