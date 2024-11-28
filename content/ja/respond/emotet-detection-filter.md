---
date: 2023-02-06T00:00:00
description: 
featured_image: 
tags: ["Emotet", "マルウェア", "トロイの木馬", "PLURA", "フィルター"]
title: "EMOTET検知フィルター"
---

![excel](https://github.com/user-attachments/assets/29f395fe-2696-452c-baea-303f6e6f835f)

> Emotet（エモテット）は、クレジットカード情報などを個人から盗むバンキング型トロイの木馬ウイルスです。 <br>
> 2014年から活動を開始し、数年間で大きく進化し、企業ネットワークに侵入し他のマルウェアタイプを拡散させる重大な脅威となっています。
>
> 米国国土安全保障省（DHS）は2018年7月にEmotetに関する警告を発し、「主に他のバンキング型トロイの木馬ウイルスのダウンローダーまたはドロッパー（Dropper）として機能する進化したモジュール型バンキングトロイの木馬ウイルス」と説明し、除去が非常に困難で一般的なシグネチャベースの検出を回避し、自ら拡散すると警告しました。  <br>
> この警告では「Emotet感染により、州政府や地方自治体は1件あたり最大100万ドルの解決費用が発生した」と説明されています。

## EMOTET検知フィルター

### 1. EMOTETファイル収集

> * Excel添付ファイルを通じて拡散されることが一般的です。
> * 収集されたExcelファイルを確認（Virustotal）<br><br>
> ![emotet00](https://github.com/user-attachments/assets/6603c3a9-8d9b-4060-af74-4d5255e0f76c)
> [図1] 分析対象のExcelファイルに関するVirustotalの結果

<br>

### 2. EMOTETファイルの実行

> * 感染したExcelファイルを実行後、「コンテンツを有効にする」ボタンをクリックするよう誘導するメッセージを確認できます。<br><br>
>   ![emotet01](https://github.com/user-attachments/assets/73648c89-f963-43cf-b425-af5c8c024aa5)
>   [図2] マクロ許可誘導メッセージ

<br>

### 2-1. PLURA検知フィルター

> * フィルター名：コンテンツ使用<br><br>
> ![emotet11](https://github.com/user-attachments/assets/964ca044-b6af-41d1-8b62-65078cc11eb3)
> [図3] フィルター名：コンテンツ使用検知ログ

> * フィルター名：Excelショートカット作成<br><br>
> ![emotet12](https://github.com/user-attachments/assets/2c7fc921-1bd5-4db6-b0ae-8d2ae42c5a90)
> [図4] フィルター名：Excelショートカット検知ログ

<br>

### 3. 隠しシート解除

> * 隠しシートをすべて「非表示解除」処理します。
> * 6つのシートすべてを「シート保護解除」処理します。<br><br>
> ![emotet03](https://github.com/user-attachments/assets/c70dd491-998e-4f16-b976-f52ed3619503)
> [図5] シート非表示解除およびシート保護解除

<br>

### 4. マクロ項目適用

> * マクロボックスで「Auto_Open0.」を選択します。
> * 「Sheet6」の「G列」を非表示解除します。<br><br>
> ![emotet06](https://github.com/user-attachments/assets/abc39208-5eef-42fb-b68b-a725b3f5aa68)
> [図6] マクロ許可

<br>

### 5. セル数式

> * 非表示解除後、「G列」のセル数式です。<br><br>
> ![emotet08](https://github.com/user-attachments/assets/fe4b6143-eeae-4642-8363-513ea76dc4b5)
> [図7] G列の隠されていたセル数式

<br>

### 6. 「コンテンツを有効にする」ボタンのクリック（感染進行）

> * 「コンテンツを有効にする」ボタンをクリックすると、順次コマンドが実行されます。
> * C:\Windows\System32にDLL形式でEmotetファイルをダウンロードします。
> * ダウンロードされたファイルはregsrv32.exeを使用してDLLファイルを実行します。
> * 実行されたEmotetファイルはC&Cサーバーを通じて追加コマンドを受け取り、情報盗取などの悪意ある行為を実行します。<br><br>
> ![emotet09](https://github.com/user-attachments/assets/eedb5939-e34c-405b-ad3b-f6eb147b7cfa)
> [図8] G列の攻撃コマンド群

<br>

### 6-1. PLURA検知フィルター

> * フィルター名：Emotet DLLマルウェア実行 (1)<br><br>
> ![emotet13](https://github.com/user-attachments/assets/eef93658-fba7-4209-9967-c7120c5f43b2)
> 
> * フィルター名：Emotet DLLマルウェア実行 (2)<br><br>
> ![emotet14](https://github.com/user-attachments/assets/2c8de873-1f5a-476d-bf79-d1adf9f43d54)
>
> * フィルター名：Emotet DLLマルウェア実行 (3)<br><br>
> ![emotet15](https://github.com/user-attachments/assets/d5d1095f-be88-4f31-b771-5a6bd3936734)
>
> * フィルター名：Emotet DLLマルウェア実行 (4)<br><br>
> ![emotet16](https://github.com/user-attachments/assets/ddb34d98-cc0d-4fea-9018-3320b6bdf6fe)
> [図9] フィルター名：Emotet DLLマルウェア実行 (1~4)

<br>

### 6-2. PLURA相関分析検知フィルター

> * 相関分析検知フィルターを通じて「正検出率」を向上させることができます。<br><br>
> ![emotet18](https://github.com/user-attachments/assets/202e826c-4413-4710-b8e1-14eb78cda9d7)
> [図10] 相関分析フィルター名：Emotet

<br>

### 7. C&C

> * aldina[.]jp/wp-admin/YvD46yh/
> * alliance-habitat[.]com/cache/lE8/
> * anguklaw[.]com/microsoft-clearscript/oVgMlzJ61/
> * andorsat[.]com/css/5xdvDtgW0H4SrZokxM/

<br>

### 8. IOC

> * SHA256 : 76323e3a53815b76193d22984da10a9d492d934d49a611fd541e7a78a88cf3c9

<br>

### 出典

* https://www.itworld.co.kr/tags/81617/Emotet/122207#csidxb0960f83251f39d83ca06e0918e9890
* https://www.virustotal.com/gui/file/76323e3a53815b76193d22984da10a9d492d934d49a611fd541e7a78a88cf3c9
* https://asec.ahnlab.com/ko/41365/
