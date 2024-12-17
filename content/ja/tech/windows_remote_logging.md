---
date: 2019-06-24T00:01:00
draft: false
title: "Windowsリモートロギング"
description: 
featured_image: "cdn/tech/windows_remote_logging-1.png"
tags: ["Windows", "リモートロギング", "Windows Event Collector", "Active Directory", "ログ管理", "セキュリティ"]
---

Active Directory環境で**Windows Event Collector(WEC)**を構成すると、リモートイベントログを中央で収集・管理することができます。  
この機能により、集中型ログ管理とモニタリングが可能となり、組織のセキュリティと運用効率が向上します。
<!--more-->
---

## 1. イベント転送と収集のためのコンピュータ構成

### 主な考慮事項

- **一方向の購読のみ利用可能**
  - ログはイベントソースから収集サーバへ一方向にのみ転送されます。

- **ファイアウォール例外設定の必要性**
  - 各システムでリモートイベントログ管理の機能に対するファイアウォール例外を追加する必要があります。
  - HTTPSプロトコルを使用する場合、該当ポートもファイアウォールで開放する必要があります。

- **アカウント権限設定**
  - 各システムの**Event Log Readersグループ**に管理者権限を持つアカウントを追加する必要があります。

- **サービスパックとホットフィックス**
  - Microsoft推奨の最新サービスパックとホットフィックスをインストールして、エラーを防ぐ必要があります。

### 構成手順
1. **Windows Remote Management(WINRM)の有効化**
   ```bash
   winrm quickconfig
   ```

2. **収集サーバでロググループを設定**
   - 収集サーバでイベントログを保存し、分析するためのロググループを設定します。

3. **ファイアウォール規則の有効化**
   - `Windowsファイアウォールの高度なセキュリティ`で**リモートイベントログ管理**と**HTTPS**規則を有効にします。

4. **購読の設定**
   - イベントビューア(Event Viewer)で購読(Subscription)を作成します。
   - ソースコンピュータから送信されるイベントを収集サーバで受信するように設定します。

**参考資料:**  
- [Microsoft公式ドキュメント - コンピュータ構成](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc748890(v=ws.11))

---

## 2. Windows Event Collectorの使用方法

Windows Event Collectorを使用してイベントを収集するには、以下の手順に従います。

### 手順ガイド

1. **収集サーバで収集サービスを実行**
   ```bash
   wecutil qc
   ```

2. **イベント購読を設定**
   - イベントビューア(Event Viewer)を開き、**購読(Subscription)**セクションで新しい購読を作成します。
   - ソースコンピュータと収集サーバ間の接続を設定します。

3. **フィルタリングと購読条件の定義**
   - 特定のイベントID、ソース、またはレベル(Level)に基づいてフィルタを設定し、ログデータを選別します。

4. **HTTPS接続の設定(オプション)**
   - HTTPS接続を使用する場合、証明書をインストールし、収集サーバがHTTPSでイベントを受信するよう構成します。
   - 例:
     ```bash
     winrm create https
     ```

**参考資料:**  
- [Microsoft公式ドキュメント - イベントコレクタの使用方法](https://docs.microsoft.com/ja-jp/windows/desktop/WEC/using-windows-event-collector)

---

## 3. リモートロギングの利点

- **集中管理**
  - 分散した複数のシステムのログを1つの場所で管理でき、効率的です。

- **セキュリティ強化**
  - リモートで発生したセキュリティイベントをリアルタイムで収集し、迅速に対応可能。

- **分析とモニタリングの容易化**
  - 中央でイベントデータを分析し、セキュリティ脅威や運用上の問題をモニタリング可能。

---

## 4. 活用事例

1. **セキュリティ脅威の検出**
   - 攻撃者がシステムへのログインを試みるイベントをリアルタイムで検出。

2. **コンプライアンス遵守**
   - GDPRやISO 27001などの規定に基づくログデータの管理と保管。

3. **運用最適化**
   - 障害発生時にイベントログを活用して根本原因を迅速に特定。

---

## 5. 追加参考資料

- [Microsoft公式ドキュメント - Windows Event Forwarding](https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection)  
- [Windows Remote Managementガイド](https://docs.microsoft.com/en-us/windows/win32/winrm/portal)
