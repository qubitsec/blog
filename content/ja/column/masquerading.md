---
date: 2025-02-10T16:32:00
draft: false
description: 
featured_image: "cdn/column/masquerading.png"
tags: ["Masquerading", "CyberThreats", "EndpointSecurity", "ThreatHunting", "EDR_Security"]
title: "コピーされたシステムファイル、セキュリティソリューションは同じように見えますか？"
---

### 🕵️‍♂️ マスカレーディング(Masquerading)、セキュリティソリューションは正常なファイルとマルウェアをどのように識別するのか？

サイバー攻撃はますます高度化しており、その中でも**マスカレーディング(Masquerading)技術**はセキュリティソリューションを回避する非常に効果的な手法の一つです。
この技術は**正規のシステムファイルを悪用**し、セキュリティ検知を回避しながらマルウェアを実行するために使用されます。
それでは、セキュリティソリューションは**コピーされたシステムファイルをどのように処理**するのでしょうか？

<!--more-->

---

### 1. **マスカレーディング(Masquerading)とは？**

マスカレーディングは、攻撃者が**自身の正体を隠す**、または**他のユーザーの権限を偽装する手法**であり、**セキュリティシステムを回避**したり、**機密情報を盗み出す**ために使用されます。このとき、主に偽装に使われるファイルは**OSの標準実行ファイル**や**信頼できるプログラム**です。

🕵️‍♂️ **主に偽装されるファイルの種類**

マスカレーディングで**最も多く使用されるファイル**は以下の通りです。

✅ **1) Windowsシステムファイル (Windows Native Executables)**

Windowsに標準搭載されている実行ファイル(EXE)は、セキュリティソリューションの信頼を回避するために頻繁に利用されます。

- `cmd.exe`: コマンドプロンプト実行ファイル。
- `powershell.exe`: PowerShellスクリプト実行ツール。
- `wscript.exe`: Windows Script Hostの実行ファイル。

✅ **2) 一般的なソフトウェアの実行ファイル**

攻撃者は、ユーザーが頻繁に使用するソフトウェアに偽装し、疑われることを回避しようとします。

- `chrome.exe`
- `notepad.exe`
- `excel.exe`

---

### 2. **マスカレーディングに使用される回避技術**

攻撃者は単にファイル名を変更するだけでなく、**さまざまな技術を活用して検知を回避**します。

✅ **1) 異常なパスでの実行**

`cmd.exe`、`powershell.exe`、`explorer.exe`などのWindowsシステムファイルを、通常のパスではなく**異常なパス**（例: `C:\ProgramData\cmd.exe`）で実行することで、セキュリティソリューションの回避が可能となります。

✅ **2) 拡張子の変更または非表示化**

- `malware.exe` → `explorer.exe`
- `ransomware.exe` → `winword.exe`
- `.exe`拡張子を `.scr`, `.com`, `.bat` に変更することで検知を回避。

✅ **3) コード署名の偽造**

攻撃者は、**Microsoft, Google, Adobe** などの認証済みコード署名を偽造し、信頼できるプログラムのように見せかけることが可能です。

---

### 3. **マスカレーディングを利用したシステムファイルのコピーとマルウェア実行**

![powershell](https://github.com/user-attachments/assets/a51f5d37-80d4-4bdf-b098-221b45e6a167)

[写真 1] Powershellを介してcmd.exeを異常なパスにコピーする


まず、Powershellで以下のコマンドを使用してcmd.exeを異常なパスにコピーします。

```powershell
copy-item "$env:windir\System32\cmd.exe" -destination "$env:allusersprofile\cmd.exe"
start-process "$env:allusersprofile\cmd.exe"
sleep -s 5 
stop-process -name "cmd" | out-null
```

![error](https://github.com/user-attachments/assets/1125b7bd-935b-4078-93a7-fe26963a0ec8)

[写真 2] コピー後、エラーメッセージ


コピーしたcmd.exeを実行すると、上記の[写真2]のようにエラーが発生しました。

![path](https://github.com/user-attachments/assets/ceb66c65-75d5-4eda-b9df-05f1e3813143)

[写真 3] その他の解決策を提示


ChatGPTの別の解決策として、多言語ユーザーインターフェイスファイルである `.mui`ファイルをコピーしたcmd.exeがある異常なパスに入れてくれれば解決が可能だそうです。

![copy](https://github.com/user-attachments/assets/ed15570e-974c-4235-84bb-2652550927a7)

[写真 4]C:\Windows\System32 パス内の ja-JP フォルダーをコピー


`.mui` ファイルを含む C:\Windows\System32 パスにある `ja-JP` フォルダをコピーします。

![paste](https://github.com/user-attachments/assets/c2cf32bf-be54-4aba-bdc8-28af5860edb2)

[写真 5] コピーされたko-KRフォルダをコピーされたcmd.exeを持つ異常なパスに貼り付ける


コピーした `ko-KR` フォルダをコピーした cmd.exe が置かれた異常なパスに入れます。

![cmd](https://github.com/user-attachments/assets/3cfe7cd0-e794-46fb-b898-444b658a072e)

[写真 6] エラーメッセージなしで通常cmd.exeを実行する


cmd.exeが正常に実行されていることを確認できます。

### 4. セキュリティソリューションを検出するかどうかデモ

デモで使用されたマルウェアは、過去のブログで説明した**プロセスハロイング**技術を使用してマルウェアを作成した後、使用しました。

- [**プロセスハローイングを学ぶ**](https://www.notion.so/18f63ad52448802086fccc8ec082da38?pvs=21)

![defender](https://github.com/user-attachments/assets/7479837c-3cd8-460c-a868-fa3fb65d2c8e)

[写真 7] Microsoft Defenderの検出


hollow_test.exeがMicrosoft Defenderから検出されました。

![defender_log](https://github.com/user-attachments/assets/bea524f9-3f8e-4ce4-9fe5-fb7aef02b01d)

[写真 8] Microsoft Defender の保護履歴 (Trojan:Win32/Bearfoos.A!ml 検出)


Microsoft Defender で Trojan:Win32/Bearfoos.A!ml 分類に分離されていることを確認します。

![alyac](https://github.com/user-attachments/assets/527b6e6b-1e52-4c7b-a581-8590c84a9cc1)

[写真 9] ピルのリアルタイム監視で検出できない


![fail01](https://github.com/user-attachments/assets/fa954303-9385-487f-89be-8c41507fdf39)

[写真 10] クイックチェックでは検出されません。


![alyac_detect](https://github.com/user-attachments/assets/3dc8b5f6-82df-473e-b315-f816f899d921)

[写真 11] 精密検査で検出されることを確認


![answer](https://github.com/user-attachments/assets/fe785e6e-a3f3-4dcf-ac4e-15f991bd541a)

[写真 12] パフォーマンスの低いセキュリティソリューションの推奨に対する回答


他のセキュリティソリューションでも検出されていることを確認するために、ChatGPTはパフォーマンスの低い無料のセキュリティソリューションを推奨しました。

![comodo](https://github.com/user-attachments/assets/ec570264-2a0e-48bb-9501-1ae8bbf9f8bc)

[写真 13] Comodo Free Antivirus


![comodo_fail](https://github.com/user-attachments/assets/a46b3e4f-ee73-4425-9e6f-da1a81d0bbe0)

[写真 14] Comodoのリアルタイム監視で検出できない


![comodo_fail_2](https://github.com/user-attachments/assets/c8d97477-7256-4b85-9bdb-90c713c42464)

[写真 15] Comodoのクイックチェックで検出できない


![comodo_fail_3](https://github.com/user-attachments/assets/760ebe77-6d12-49f0-8c55-cfa6c0239c2b)

[写真 16] Comodoの指定フォルダチェックで検出できない


![360_total_security](https://github.com/user-attachments/assets/110e3dbd-303c-4ebe-ad7e-905553b2c50b)

[写真 17] 360 Total Security


![360_TotalSecurity_success](https://github.com/user-attachments/assets/a9ebc215-ba8a-43a3-8849-98708ca10f8e)

[写真 18] 360 Total Security → リアルタイムスキャンで検知。


### 4. マスカレーディングはセキュリティソリューションの“盲点”を狙う技術
マスカレーディングが使用される理由は以下の通りです。

静的解析を回避するため → シグネチャベースの検知を回避。
セキュリティポリシーの回避 → 一部の環境ではcmd.exeの実行パスを検知しない。
イベントロギングおよび分析を回避 → SIEMが正規プロセスと誤認する可能性がある。
振る舞い検知を困難にするため → 一部の環境では異常なcmd.exeの実行を許可する可能性がある。
しかし、EDR(Endpoint Detection & Response)が有効な環境ではマスカレーディングを使用しても検知を回避するのは難しくなります。

そのため、攻撃者は PowerShell、rundll32.exe、mshta.exe、wmic.exe などの LOLBins(Living Off the Land Binaries) を活用することで、さらなる回避技術を組み合わせることが一般的です。

💡 防御戦略:

✅ EDR(Endpoint Detection & Response)の活用 → 異常なプロセスの実行を検知
✅ SIEM(Security Information & Event Management)ログ分析 → 正規プロセスの異常な実行パスを監視
✅ アプリケーションホワイトリストの適用 → 許可されたプログラムのみ実行可能にすることで攻撃を防止

💀 攻撃者は常に新たな偽装技術を研究しているため、セキュリティソリューションも継続的なアップデートが必要です。

---

### 📖 **関連情報**

- [マスカレーディング(Masquerading)](https://attack.mitre.org/techniques/T1036/)
- [プロセスホロウィング(Process Hollowing)](https://attack.mitre.org/techniques/T1055/012/)
