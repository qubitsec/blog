---
date: 2024-03-04
title: "PLURAでMicrosoft Defender Antivirusログを確認する"
description:
featured_image: ""
tags: ["Microsoft Defender", "セキュリティログ", "PLURA", "アンチウイルス"]
---

![column_20240304](https://github.com/user-attachments/assets/a254870f-a26f-4a89-997c-c93368c40408)

### Microsoft Defender Antivirusとは？

**Microsoft Defender Antivirus**は、Microsoft Windowsに組み込まれたウイルス対策ソフトウェアコンポーネントです。[1]  
Defenderは検出結果をログに記録し、PLURAはこれらのログを収集して管理者が悪性感染や検出イベントを効果的に把握できるようサポートします。

---

### PLURAで確認されたMicrosoft Defenderのログ事例

#### 1つ目のログ: ISOイメージファイルの検出

![01-1024x360](https://github.com/user-attachments/assets/6e6a1467-054f-4e7a-b915-0d738a858f09)

- **検出内容:** Microsoft Office関連のISOイメージ内の`setup.exe`ファイルがトロイの木馬として検出されました。  
- **Defenderの対処:** 保護アクションが実行され、脅威が削除されました。

> 攻撃者がマルウェアを含むISOファイルを配布する場合があるため、ダウンロード時の注意が必要です。

---

#### 2つ目のログ: PUAと悪性IPの検出

![02-1-1536x416](https://github.com/user-attachments/assets/30c97fe7-419e-4670-96a8-405a23db965d)

- **検出内容:** `uTorrent.exe`ファイルがPUA（望ましくないファイル）として検出されました。  
- **追加ログ:** 悪性IPへのアクセス試行が検出されました（`port 80`への接続試行）。  

> トレントを利用したファイルダウンロードはマルウェア感染に弱く、管理者による制御を強化する必要があります。

---

#### 3つ目のログ: バックドア疑いファイルの検出

![02-1024x357](https://github.com/user-attachments/assets/a2b94cff-95a9-42e2-b27b-f85b6d5551f5)

- **検出内容:** 特定のzipファイル内に、`admin`や`root`パスに配置された悪性の`asp`および`php`ファイルが発見されました。  
- **危険度:** ファイル拡張子を偽装してマルウェアを隠す意図が明確です。  

> これらのログを通じて、重大な悪性ファイルおよび流入経路を早期に検出し、対処することが可能です。

---

### Microsoft Defender Antivirusのライセンス案内

- **Microsoft Defender Antivirusは無料で提供されます。**
- Windows 10およびWindows 11のオペレーティングシステムに標準で含まれており、追加のライセンス購入なしでリアルタイム保護およびマルウェア削除機能を提供します。
- Windows Serverでも特定バージョンにMicrosoft Defender Antivirusが含まれており、正規ライセンスを通じて追加費用なしで利用可能です。
- 高度なセキュリティが必要な企業環境では、**Microsoft Defender for Endpoint**などの追加セキュリティソリューションが必要な場合があります。

---

### 外部参考資料

[1] [Microsoft Defender Antivirus (Wikipedia)](https://en.wikipedia.org/wiki/Microsoft_Defender_Antivirus)  
[2] [Microsoft Defender Antivirus トラブルシューティング](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide)
