---
date: 2025-02-10T16:32:00
draft: false
description: 
featured_image: "cdn/column/masquerading.png"
tags: ["Masquerading", "CyberThreats", "EndpointSecurity", "ThreatHunting", "EDR_Security"]
title: "コピーされたシステムファイル、セキュリティソリューションは同じように見えるか?"
---

### 🕵️‍♂️ マスカレーディング（Masquerading）、セキュリティソリューションは正規ファイルとマルウェアをどのように識別するのか？

サイバー攻撃はますます高度化しており、その中でも**マスカレーディング（Masquerading）**手法は  
**セキュリティソリューションを回避するための非常に効果的な方法**です。<br>
この技術は、正規のシステムファイルを悪用し、セキュリティ検出を逃れながらマルウェアを実行するために使用されます。  
では、セキュリティソリューションはコピーされたシステムファイルをどのように処理するのでしょうか？

<!--more-->

---

### 1. マスカレーディング（Masquerading）とは？

マスカレーディングとは、攻撃者が自身の正体を隠したり、他のユーザーの権限を偽装する手法であり、  
**セキュリティシステムを回避**したり、**機密情報を窃取**するために使用されます。<br>
この際、主に偽装されるファイルは**OSの標準実行ファイル**や**信頼できるプログラム**です。

🕵️‍♂️ **よく偽装されるファイルの種類**

マスカレーディングで**最も頻繁に使用されるファイル**は以下の通りです。

✅ **1) Windows システムファイル（Windows Native Executables）**

Windows に標準搭載されている実行ファイル（EXE）は、セキュリティソリューションの信頼性を回避するために頻繁に悪用されます。

- `cmd.exe`：コマンドプロンプトの実行ファイル
- `powershell.exe`：PowerShell スクリプト実行ツール
- `wscript.exe`：Windows Script Host の実行ファイル

✅ **2) 一般的なソフトウェアファイル**

攻撃者は、ユーザーが頻繁に使用するソフトウェアを偽装し、疑いを回避しようとします。

- `chrome.exe`
- `notepad.exe`
- `excel.exe`

---

### 2. マスカレーディングのために使用される回避技術

攻撃者は単にファイル名を変更するだけでなく、**さまざまな技術を駆使して検出を回避**します。

✅ **1) 異常なパスからの実行**

`cmd.exe`、`powershell.exe`、`explorer.exe` などの Windows システムファイルを、  
本来のパスではなく **異常なパス**（例: `C:\ProgramData\cmd.exe`）から実行することで、  
セキュリティソリューションの検出を回避できます。

✅ **2) 拡張子の変更または隠蔽**

- `malware.exe` → `explorer.exe`
- `ransomware.exe` → `winword.exe`
- `.exe` 拡張子を `.scr`、`.com`、`.bat` に変更することで検出を回避。

✅ **3) コード署名の偽装**

攻撃者は、**Microsoft、Google、Adobe** などの正規のコード署名を偽装し、  
信頼できるプログラムであるかのように見せかけることが可能です。

---

### 3. マスカレーディングによるシステムファイルのコピーとマルウェアの実行

![powershell](https://github.com/user-attachments/assets/a51f5d37-80d4-4bdf-b098-221b45e6a167)

[写真 1] PowerShell を使用して `cmd.exe` を異常なパスにコピー

まず、PowerShell を使用して以下のコマンドを実行し、`cmd.exe` を異常なパスにコピーします。

```powershell
copy-item "$env:windir\System32\cmd.exe" -destination "$env:allusersprofile\cmd.exe"
start-process "$env:allusersprofile\cmd.exe"
sleep -s 5 
stop-process -name "cmd" | out-null
```

![error](https://github.com/user-attachments/assets/1125b7bd-935b-4078-93a7-fe26963a0ec8)

[写真 2] コピー後のエラーメッセージ

コピーした cmd.exe を実行すると、[写真 2] のようにエラーが発生しました。

> cmd.exe は Windows のコマンドプロンプト実行ファイルであり、
> 多くのリソースファイルと連携して動作 します。
> これらのリソースファイルの中には、多言語ユーザーインターフェース（MUI）ファイルが含まれています。
> 通常、cmd.exe に関連する .mui ファイルは以下のパスに存在します：

> パス: C:\Windows\System32\ko-KR\cmd.exe.mui
> ここで、ko-KR は韓国語（Korean）を示し、システムの言語設定によって異なる言語フォルダが存在します。
> 例えば、英語（米国）のシステムでは en-US フォルダに .mui ファイルが保存されています。
> .mui ファイルは cmd.exe の UI（ユーザーインターフェース）要素を特定の言語で表示するために使用されます。
> そのため、cmd.exe を別のディレクトリにコピーして実行すると、これらのリソースファイルが見つからずエラーが発生する 可能性があります。
> この問題を防ぐには、cmd.exe を元の場所で実行するか、必要な .mui ファイルを一緒にコピーする必要があります。
> ただし、システムファイルをコピー・移動することは推奨されていないため、可能な限り元のパスで実行することが望ましい です。

解決策: .mui ファイルを cmd.exe がある異常なパスにコピーすると、問題が解決します。

![copy](https://github.com/user-attachments/assets/ed15570e-974c-4235-84bb-2652550927a7)

[写真 3] C:\Windows\System32 にある ko-KR フォルダをコピー

.mui ファイルが含まれている C:\Windows\System32\ko-KR フォルダをコピーします。

![paste](https://github.com/user-attachments/assets/c2cf32bf-be54-4aba-bdc8-28af5860edb2)

[写真 4] コピーした ko-KR フォルダを cmd.exe の異常なパスに貼り付け

コピーした ko-KR フォルダを、異常なパスにある cmd.exe と同じ場所に配置します。

![cmd](https://github.com/user-attachments/assets/3cfe7cd0-e794-46fb-b898-444b658a072e)

[写真 5] エラーメッセージなしで正常に cmd.exe が実行

cmd.exe が正常に実行されることを確認できます。

---

### 4. セキュリティソリューションによる検出デモ

デモに使用されたマルウェアは、以前のブログで説明した **Process Hollowing（プロセス ハロウイング）** 手法を  
使用して作成されたものです。

- [**Process Hollowing（プロセス ハロウイング）について詳しく知る**](https://blog.plura.io/ko/threats/process_hollowing/)

![a](https://github.com/user-attachments/assets/7479837c-3cd8-460c-a868-fa3fb65d2c8e)

[写真 6] **A社のアンチウイルスによる検出**

`hollow_test.exe` が **A社のアンチウイルスで検出** されました。

![a_log](https://github.com/user-attachments/assets/bea524f9-3f8e-4ce4-9fe5-fb7aef02b01d)

[写真 7] **A社のアンチウイルス保護記録（Trojan:Win32/Bearfoos.A!ml 検出）**

A社のアンチウイルスによって `Trojan:Win32/Bearfoos.A!ml` に分類され、隔離されたことを確認。

---

![b](https://github.com/user-attachments/assets/527b6e6b-1e52-4c7b-a581-8590c84a9cc1)

[写真 8] **B社のアンチウイルス、リアルタイム監視で検出できず**

![b_fail01](https://github.com/user-attachments/assets/fa954303-9385-487f-89be-8c41507fdf39)

[写真 9] **B社のアンチウイルス、クイックスキャンでも検出されず**

![b_detect](https://github.com/user-attachments/assets/3dc8b5f6-82df-473e-b315-f816f899d921)

[写真 10] **B社のアンチウイルス、精密スキャンで検出を確認**

---

無料のセキュリティソリューションの中で最も性能が低い（つまり検出力が弱い）ものを特定するのは簡単ではありませんが、  
複数のテスト結果やユーザーフィードバックを総合すると、いくつかの候補を整理することができます。

### 1. 無料セキュリティソリューションの性能が低い場合の特徴
✅ **シグネチャ（Signature）ベースの検出のみ提供** → 最新の攻撃手法の検出が困難<br>
✅ **行動ベース（Behavioral）検出がない** → マルウェアの実行後の動作を分析できない<br>
✅ **リアルタイム監視が弱い** → リアルタイム保護機能が制限されている、または存在しない<br>
✅ **EDR機能がない** → プロセスチェーン分析や脅威ハンティングをサポートしない<br>
✅ **更新が遅い、またはサポートが不足** → 最新のマルウェアを検出するのが難しい

他のセキュリティソリューションでも検出されるか確認するために、ChatGPTに**性能の低い無料セキュリティソリューション**を推薦してもらいました。

### 2. C社のアンチウイルス
- リアルタイム保護機能はあるが、**検出性能が良くない**
- **誤検知（False Positive）が多い** → 正常なファイルもブロックされることが多い
- クラウドベースの検出性能が低く、データベースの更新が遅い
- **行動ベースの検出が不足しており、マスカレーディングの検出可能性が低い**

### 🛑結論: **基本的な保護は可能だが、EDRやSIEMがない環境では容易に回避可能。**

![c_fail](https://github.com/user-attachments/assets/a46b3e4f-ee73-4425-9e6f-da1a81d0bbe0)

[写真 11] **C社のアンチウイルス、リアルタイム監視で検出できず**

![c_fail_2](https://github.com/user-attachments/assets/c8d97477-7256-4b85-9bdb-90c713c42464)

[写真 12] **C社のアンチウイルス、クイックスキャンでも検出されず**

![c_fail_3](https://github.com/user-attachments/assets/760ebe77-6d12-49f0-8c55-cfa6c0239c2b)

[写真 13] **C社のアンチウイルス、指定フォルダー検査でも検出されず**

---

### 3. D社のアンチウイルス（無料版）
- 基本的な検出機能はあるが、**行動ベースの検出が不足**
- 過去に**ユーザーデータ収集やプライバシー問題**で論争があった
- **リアルタイム保護機能はあるが、検出力が低いため回避が容易**
- **広告が多く、不必要な機能が含まれている**

### 🛑結論: **無料ではあるが、中国製のアンチウイルスの特性上、信頼性が低くセキュリティ性能も不十分。**

![D_success](https://github.com/user-attachments/assets/a9ebc215-ba8a-43a3-8849-98708ca10f8e)

[写真 14] **D社のアンチウイルス、リアルタイム監視で検出を確認**

---

### 4. マスカレーディングはセキュリティソリューションの“脆弱性”を狙う手法

マスカレーディングを使用する理由は以下の通りです。

1. **静的分析を回避するため** → シグネチャベースの検出を回避できる可能性がある。
2. **セキュリティソリューションのポリシーを回避するため** → 一部の環境では `cmd.exe` の実行パスを検知しない。
3. **イベントログや分析を回避するため** → SIEMが正常なプロセスと誤認する可能性がある。
4. **行動ベースの検出を難しくするため** → 一部の環境では異常な `cmd.exe` の動作を許可する可能性がある。

しかし、**EDRが有効化された環境では、マスカレーディングを使用しても検出を回避するのは難しい** です。

そのため、攻撃者は **`PowerShell`、`rundll32.exe`、`mshta.exe`、`wmic.exe`** などの  
**LOLBins（Living Off the Land Binaries）** を活用し、さらなる回避技術を組み合わせることもあります。

### 💡**防御戦略**:

✅ **EDR（Endpoint Detection & Response）ソリューションの活用** → 異常なプロセスの実行を検出

✅ **SIEM（Security Information & Event Management）ログ分析** → 正規の実行ファイルが異常なパスで実行されていないか監視

✅ **アプリケーションホワイトリストの適用** → 実行可能なプログラムを制限し、攻撃を防止

💀 **攻撃者は常に新しい偽装技術を研究しているため、セキュリティソリューションも継続的に更新する必要があります。**

---

### 📖 **関連リンク**

- [マスカレーディング（Masquerading）](https://attack.mitre.org/techniques/T1036/)
- [プロセス ハロウイング（Process Hollowing）](https://attack.mitre.org/techniques/T1055/012/)
