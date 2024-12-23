---
date: 2023-01-11T02:00:00
draft: false
title: "MITRE ATT&CK視点でEmotet（エモテット）を検出する"
description: ""
featured_image: "cdn/respond/detecting-emotet-with-mitre-attck-1.png"
tags: ["emotet", "MITRE ATT&CK"]
---

**Emotet（エモテット）マルウェアは2022年下半期に日本で流行し、大きな被害をもたらしました。**

韓国でも2022年11月に、Alyacから注意が必要だと発表されています。

主にスパムメールを通じて拡散されています。
<!--more-->
![detecting-emotet-with-mitre-attck](https://blog.plura.io/cdn/respond/detecting-emotet-with-mitre-attck-1.png)

<br>

このような警告や注意喚起があるにもかかわらず、既存のAlyacなどのアンチウイルス製品が検出ルール（Rule）を提供しているにも関わらず、依然として被害が発生しています。

<br>

基本的にマクロベースのマルウェアは変更が非常に容易です。

マルウェア制作者は非常に迅速にコードを変更してアンチウイルスの検出を回避できます。

<br>

**MITRE ATT&CKの観点から回避攻撃を含めた迅速な検出方法を提案します。**
<br>
<br>

## 1. Emotet（エモテット）マルウェアの基本的な動作原理

**1) 実行されたWord（Excel、HWP、PDFなど）のファイルは、バックグラウンドでC&Cサーバーに接続し、マルウェアをダウンロードします。**

**2) マルウェアは複数のステップを経てトロイの木馬をインストールし、リモートアクセスを可能にするためにハッカーと通信します。**

<br>

## 2. MITRE ATT&CKの観点からEmotetを検出する

**1) Emotetマルウェアが実行されると、バックグラウンドで外部C&Cサーバーに接続し、ファイルをダウンロードします。**
<br>

**2) マルウェアはPowerShellを呼び出して実行します。この際、コードはBase64エンコードされており、内容を確認するためにデコードが必要です。**

このマルウェアが接続するC&Cサーバーのアドレスは、WordPressを利用したサイトが攻撃を受け、そこにマルウェアが隠されています。

見た目は通常のサイトに見える場合、ハッカーはC&Cサーバーとして長期間利用することができます。

> **- PowerShell[1059.001]** <br>
![m-2-800x372](https://github.com/user-attachments/assets/bf898135-6d43-4288-b0e5-4ebfe7995f40)<br><br>
> 攻撃者は実行のためにPowerShellコマンドやスクリプトを悪用する可能性があります。<br>
> PowerShellはWindowsオペレーティングシステムに含まれる強力な対話型コマンドラインインターフェースおよびスクリプティング環境です。<br>
> 攻撃者はPowerShellを使用して情報収集やコード実行を含むさまざまな作業を行うことができます。<br>
> 例えば、実行可能ファイルを実行するために使用できる`Start-Process`コマンドレットや、ローカルまたはリモートのコンピューターでコマンドを実行する`Invoke-Command`コマンドレットがあります。<br>
> （PowerShellを使用してリモートシステムに接続するには管理者権限が必要です）
<br>

**3) PowerShellを利用してダウンロードされたファイルは一時フォルダ（Temp）に保存され、実行後に削除されるプロセスが進行します。**

> - 一時フォルダ Temp\ __PSScriptPolicyTest_krutadkh.taj.ps1
![m-6](https://github.com/user-attachments/assets/9644c444-42b0-4853-b9b6-b6dfbcce83d8)
![m-7](https://github.com/user-attachments/assets/6b163ed0-3015-4502-9a29-4762398b14da)

<br>

**4) 外部C&Cサーバーに接続するために生成されたPowerShell用スクリプトを検出します。**

このスクリプトには明確にC&CサーバーがWordPressサイトであることが記されています。

> - MITRE ATT&CK検出フィルターID: PowerShell [T1059.001]
![m-5-1024x295](https://github.com/user-attachments/assets/4324b75e-3366-4838-8d1a-aaff3a81c0d0)

<br>

**5) 今回、マルウェアがスケジューラーに登録されます。**

![m-9-300x86](https://github.com/user-attachments/assets/1ef730eb-89ea-4982-9803-b8d67fba420b)<br>

> - イベントログの詳細<br><br>
![m-10-273x300](https://github.com/user-attachments/assets/453004ac-dd54-4a6a-a316-c389770fb370)<br><br>
> - XMLビューアで確認<br><br>
![m-11-225x300](https://github.com/user-attachments/assets/899ec693-cb58-4743-bc32-5b37356c99a4)

<br>

**6) 最終的に、マルウェアは対象システムにトロイの木馬をインストールし、リモートで接続可能な状態にします。**<br>
> - システム検出フィルター: exeファイル生成 by PowerShell <br>
> **PowerShellプロセスによって生成されたexeファイルがログに記録されます。**
![m-3](https://github.com/user-attachments/assets/0b9e940d-b66a-4370-a362-e2bd40283e34)

<br>

**7) マトリックスを使用して、攻撃がどの段階で進行しているかを一目で確認できます。**

![m-4-800x450](https://github.com/user-attachments/assets/6e9624b2-869e-484c-b0af-d17bafdb84e5)

<br>

MITRE ATT&CKフレームワークの利点は、従来のマルウェア検出方式を一歩進化させ、マルウェアの動作をモニタリングすることで、回避攻撃を含む広範囲の検出が可能である点です。

📖 一緒に読む

1. [wikipedia_emotet](https://en.wikipedia.org/wiki/Emotet)
2. [イモテット（Emotet）マルウェア、スパムメールによる国内流布の再開](https://blog.alyac.co.kr/4971)
