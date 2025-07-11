--- 
title: "DragonForceランサムウェア実戦検知：PLURA-XDRで防いだ脅威"
date: 2025-07-11
draft: false
description: "ChaCha8ベースの新型ランサムウェア「DragonForce」をPLURA-XDRで検知・分析した実際の対応事例"
featured_image: "cdn/respond/dragonforce.png"
tags: ["ランサムウェア", "DragonForce", "攻撃検知", "hacking", "ransomware", "RansomHub", "PLURA-XDR"]
---

### 🧩 DragonForceランサムウェア概要

| 項目 | 内容 |
| --- | --- |
| 初公開 | 2024年10月、ダークウェブの流出情報をもとに分析 |
| 主な活動グループ | RansomHub解体後、複数の提携者を吸収し影響力を拡大 |
| 使用技術 | ChaCha8対称暗号 + RSA-4096キー暗号化構造 |
| 被害インジケーター | `readme.txt`のランサムノート生成、`.dragonforce_encrypted`拡張子の付加 |
| 検知難易度 | 中〜高：単一の静的シグネチャ回避および高速な暗号化速度 |

<!--more-->

![dragonforce](https://blog.plura.io/cdn/respond/dragonforce.png)

---

### 💡 DragonForceブログ

- 被害者リストの公開
    
    ![dragonforce_01](https://blog.plura.io/cdn/respond/dragonforce_01.png)
    
    > ランサムウェア運営グループは、被害を受けた企業や機関のリストをブログ上で公開し、脅迫手段として使用します。
    > 
    
- 被害者ファイルの投稿
    
    ![dragonforce_02](https://blog.plura.io/cdn/respond/dragonforce_02.png)
    
    > 交渉が遅延または拒否された場合、窃取した内部文書や機密ファイルをアップロードし、さらなる圧力を加えます。
    > 

---

### ⚙️ 動作メカニズム

### ① 復号不可能なファイル暗号化

- ChaCha8を使用した高速なファイル暗号化  
- セッションキーはRSA-4096で暗号化  

### ② バックアップおよび復元機能の無効化

- `vss`呼び出し  
- `cmd.exe /c C:\Windows\System32\wbem\WMIC.exe shadowcopy where "ID='{***}'" delete`を実行  

### ③ 検知回避および自動実行の登録

- `RunOnce`レジストリに永続化を登録  
- `readme.txt`のランサムノートを生成し、ユーザーデスクトップに配置  

---

### ❗検出が難しい理由

| 検出回避要素 | 説明 |
| --- | --- |
| 高速暗号化 | 数千個のファイルを数秒で暗号化し、検出と対応の時間を与えない |
| システム復元の削除 | 復元ポイントを無効化し、ファイル復元を不可能にする |
| 標準LOLBinの使用 | PowerShell、rundll32など、正規のWindows構成要素のみを使用 |

---

### 🛡️ MITRE ATT&CKマッピング

| 戦術（Tactic） | 技法（TID） | 説明 |
| --- | --- | --- |
| Impact | T1486 データの暗号化 | ChaCha8 + RSA-4096によるファイル暗号化 |
| Defense Evasion | T1070.004 ファイルの削除 | 元ファイル削除、ログ回避 |
| Defense Evasion | T1055.001 プロセスインジェクション | 正常なプロセス内で実行（状況により疑わしい） |
| Execution | T1059.001 PowerShellの使用 | LOLBinで暗号化を開始 |
| Persistence | T1547.001 Runキーの登録 | RunOnceに悪意あるコマンドを登録 |

---

### 🔍 PLURA-XDR検出戦略に基づくルール要約

| カテゴリ | フィルター内容の要約 | 重要度 |
| --- | --- | --- |
| バックアップ妨害 | VSSファイル削除（`vssadmin delete`） | 高 |
| 権限昇格 | `Administrators`権限取得後プロセス終了 | 高 |
| 復元妨害 | `bcdedit`、`wbadmin`、`wmic`による復元無効化（T1490） | 高 |
| ファイル操作 | ファイル名の変更および`readme.txt`生成検出（T1222, T1486） | 中 |
| UI改ざん | デスクトップ背景の変更、背景画像やユーザー設定レジストリの改変 | 低 |

---

## 主な現象

- 変更された背景画像
    
    ![dragonforce_03](https://blog.plura.io/cdn/respond/dragonforce_03.png)
    
    > 感染後、デスクトップの背景が脅迫メッセージを含む画像に変更され、ユーザーにランサムウェア感染を認識させ、心理的圧力を与えます。
    > 
    
- 生成されたランサムノート
    
    ![dragonforce_04](https://blog.plura.io/cdn/respond/dragonforce_04.png)
    
    > 各ディレクトリに`readme.txt`形式のランサムノートを生成し、復号手順を提供します。
    > 
    
- ファイルアイコンの変更
    
    ![dragonforce_05](https://blog.plura.io/cdn/respond/dragonforce_05.png)
    
    > 暗号化されたファイルは`.dragonforce_encrypted`拡張子に変更され、既定プログラムとの関連付けが解除されてアイコンが異常に表示されます。
    > 

- DragonForceメッセンジャーサポート
    
    ![dragonforce_06](https://blog.plura.io/cdn/respond/dragonforce_06.png)
    
    ![dragonforce_07](https://blog.plura.io/cdn/respond/dragonforce_07.png)
    
    > 被害者が直接攻撃者と連絡を取れるように、Torベースのメッセンジャーページを運営し、交渉や復号テストを促します。
    > 
    
    ![dragonforce_08](https://blog.plura.io/cdn/respond/dragonforce_08.png)
    
    > 最大3ファイル、4MBサイズまでのファイル復旧を提供し、信頼性を示す機能も備えています。
    > 

---

## 実戦におけるPLURA-XDR検出

> この分析は、PLURA-XDRにより検出されたDragonForceランサムウェアの特徴をもとに作成されました。
> 
- 相関分析による検出
    
    ![dragonforce_09](https://blog.plura.io/cdn/respond/dragonforce_09.png)
    
    > PLURA-XDRでは、イベントベースの検出だけでなく、さまざまな攻撃段階を相関的に分析することで、DragonForceのような多段階ランサムウェアの挙動を精密に検出できます。
    > 
### PLURA 検出詳細

1. ボリュームシャドウの削除検出
    
    ```xml
    <EventData>
    	<Data Name="SubjectUserSid">SID</Data>
    	<Data Name="SubjectUserName">qubit</Data>
    	<Data Name="SubjectDomainName">DESKTOP-Qubit</Data>
    	<Data Name="SubjectLogonId">0x1dedd</Data>
    	<Data Name="NewProcessId">0x16d8</Data>
    	<Data Name="NewProcessName">C:\Windows\System32\wbem\WMIC.exe</Data>
    	<Data Name="TokenElevationType">%%1937</Data>
    	<Data Name="ProcessId">0x538</Data><Data Name="CommandLine">C:\Windows\System32\wbem\WMIC.exe  shadowcopy where "ID='{ID}'" delete</Data>
    	<Data Name="TargetUserSid">S-1-0-0</Data>
    	<Data Name="TargetUserName">-</Data>
    	<Data Name="TargetDomainName">-</Data>
    	<Data Name="TargetLogonId">0x0</Data>
    	<Data Name="ParentProcessName">C:\Windows\System32\cmd.exe</Data>
    	<Data Name="MandatoryLabel">S-1-16-12288</Data>
    </EventData>
    ```
    
2. プロセス終了の検出
    
    ```xml
    <EventData>
    	<Data Name="RuleName">-</Data>
    	<Data Name="UtcTime">2025-07-02 07:28:52.533</Data>
    	<Data Name="ProcessGuid">{abcde123-abc9-1234-a100-000000000300}</Data>
    	<Data Name="ProcessId">7652</Data>
    	<Data Name="Image">C:\Users\qubit\AppData\Local\Microsoft\OneDrive\OneDrive.exe</Data>
    	<Data Name="User">DESKTOP-QUBIT\qubit</Data>
    </EventData>
    ```
    
3. ファイルおよびディレクトリの権限変更検出
    
    ```xml
    <EventData>
    	<Data Name="SubjectUserSid">SID</Data>
    	<Data Name="SubjectUserName">qubit</Data>
    	<Data Name="SubjectDomainName">DESKTOP-QUBIT</Data>
    	<Data Name="SubjectLogonId">0x1dedd</Data>
    	<Data Name="ObjectServer">Security</Data>
    	<Data Name="ObjectType">File</Data>
    	<Data Name="ObjectName">C:\ProgramData\Microsoft\User Account Pictures\user-40.png</Data><Data Name="HandleId">0x864</Data>
    	<Data Name="TransactionId">{00000000-0000-0000-0000-000000000000}</Data>
    	<Data Name="AccessList">%%1538\r\n\t\t\t\t%%1541\r\n\t\t\t\t%%4416\r\n\t\t\t\t%%4417\r\n\t\t\t\t%%4418\r\n\t\t\t\t%%4419\r\n\t\t\t\t%%4420\r\n\t\t\t\t%%4423\r\n\t\t\t\t%%4424\r\n\t\t\t\t</Data>
    	<Data Name="AccessReason">%%1538:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%1541:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4416:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4417:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4418:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4419:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4420:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4423:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t%%4424:\t%%1801\tD:(A;;FA;;;BA)\r\n\t\t\t\t</Data>
    	<Data Name="AccessMask">0x12019f</Data>
    	<Data Name="PrivilegeList">-</Data>
    	<Data Name="RestrictedSidCount">0</Data>
    	<Data Name="ProcessId">0x17f0</Data>
    	<Data Name="ProcessName">C:\Users\qubit\Desktop\70afd8efb34382badead93ae104d958256de6be8054227ccc85fe95d5c5f9db0\70afd8efb34382badead93ae104d958256de6be8054227ccc85fe95d5c5f9db0.exe</Data><Data Name="ResourceAttributes">-</Data>
    </EventData>
    ```
    
4. ランサムファイル変更の検出
    
    ```xml
     <EventData>
    	 <Data Name="RuleName">-</Data>
    	 <Data Name="UtcTime">2025-07-02 07:29:00.063</Data>
    	 <Data Name="ProcessGuid">{abcde123-abc9-1234-a100-000000000300}</Data>
    	 <Data Name="ProcessId">6128</Data>
    	 <Data Name="Image">C:\Users\qubit\Desktop\DragonForce.exe</Data>
    	 <Data Name="TargetFilename">C:\Users\Default\Documents\readme.txt</Data>
    	 <Data Name="CreationUtcTime">2025-07-02 07:29:00.063</Data>
    	 <Data Name="User">DESKTOP-QUBIT\qubit</Data>
    </EventData>
    ```
---

### 対応およびセキュリティ推奨事項

- Defender の「制御されたフォルダーアクセス（CFA）」機能を有効化
- VSS サービスの状態を定期的にモニタリングし、変更イベントを通知

---

## 📚 PLURA-Blog

- [今ランサムウェアが進行中であるか確認できますか？](https://blog.plura.io/ja/column/why-plura-xdr-merit-ransomware/)
- [高度なランサムウェア対応戦略：ノートパソコンの電源遮断がなぜ重要か](https://blog.plura.io/ja/respond/ransomware-shutdown-awareness/)
- [脅迫型DDoS攻撃、ランサムDDoS（RansomDDoS）](https://blog.plura.io/ja/threats/ransomddos/)
- [PCとサーバーのウイルス対策はWindows Defenderだけで十分か](https://blog.plura.io/ja/column/why-edr-is-necessary/)
