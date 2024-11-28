---
date: 2017-08-18T00:01:00
description: 
featured_image: 
tags: ["ARP Spoofing", "ネットワークセキュリティ", "ハッキング手法", "サイバーセキュリティ", "情報保護"]
title: "誰かがあなたのインターネット使用を盗み見ている？ARP Spoofing"
---

![ARP-Spoofing](https://github.com/user-attachments/assets/c1700da8-ddde-4a97-bc88-d16769939bbf)

ARPスプーフィングはシンプルながら被害が致命的な攻撃です。  
では、一体ARPスプーフィングとは何でしょうか？

> **2016年3月26日** BandisoftのホームページがARPスプーフィング攻撃を受け、この期間中にBandisoftのホームページからHoneyviewをダウンロードしたユーザーに、Honeyviewインストールファイルの代わりにマルウェアがダウンロードされる問題が発生しました。
>
> **2016年4月** あるホスティング会社がARPスプーフィング攻撃を受け、ショッピングモール、P2P、天気ウィジェット、コミュニティなど、ホスティングサービスを利用している多くのウェブサイトでフィッシング用マルウェアが配布されました。  
> ホスティング業者を狙ったARPスプーフィング攻撃は、特定のパケットを改ざんし、悪意のあるURLやスクリプトを追加することでダウンロードリンクを改ざんする攻撃方式でした。
>
> **2015年3月** 国内セキュリティ業界の最大イベントである行政自治部主催「電子政府ソリューションフェア」と「世界セキュリティエキスポ」のホームページがARPスプーフィング攻撃を受け、イベント前夜に同時に麻痺しました。  
> ハッキングが確認された後、イベント組織委員会はマルウェア拡散を懸念し、サーバーの接続を停止しました。

## ARP (Address Resolution Protocol)

ARPは、ネットワーク上でIPアドレスを物理アドレス（MACアドレス）に対応させるためのプロトコルです。  
ネットワーク上で特定のIPを持つホストが誰なのか問い合わせ（Request）を行い、そのIPを持つホストが応答（Reply）するRequestとReply構造で動作します。

### ARPの動作過程
![arp-request](https://github.com/user-attachments/assets/0e4b777d-2fa3-484d-b969-47d758796f2e)

1. 送信者が受信者にデータを送信する際、まずARPテーブルを確認します。  
   ARPテーブルに受信者の情報がない場合、送信者はARPリクエストメッセージを生成し、ネットワーク上にブロードキャストします。
2. ネットワーク上のすべてのホストがARPリクエストパケットを受信し、そのIPを持つホストだけが自分の物理アドレスを含むARPリプライメッセージを送信者にユニキャストで送信します。
3. 送信者はARPリプライパケットを受け取り、宛先IPと物理アドレスをARPテーブルに記録します。  
   これにより、以降はARPテーブルを参照して効率的にデータを転送できます。

![arp-reply](https://github.com/user-attachments/assets/e54c6989-c84d-4710-9fba-e69f35c2d120)

---

## ARP Spoofingとは？

ARPスプーフィングは、被害者（victim）に偽のMACアドレスが含まれたARPリプライを送り、被害者のARPキャッシュを操作して情報を盗むハッキング手法です。  
ARPリプライパケットで受け取ったMACアドレスの真偽を検証する認証システムがない脆弱性を悪用した攻撃です。

![Attack-MITM](https://github.com/user-attachments/assets/de2a1bdd-8a96-48ef-99ba-0c63b22336f1)

### 動作過程

1. 攻撃者が被害者に対してゲートウェイのIPアドレスと攻撃者のMACアドレスを含むパケットを継続的に送信します。
2. 被害者はARPテーブルにその内容をそのまま保存します。

**被害者のARPテーブル**:

| ゲートウェイのIP      | 攻撃者のMACアドレス |
|--------------------|-------------------------|

3. 被害者は攻撃者をゲートウェイと認識し、攻撃者のMACアドレスにデータを送信します。  
   攻撃者は受信したデータをフォワーディングする必要があります。（フォワーディングしない場合、被害者が正常な通信を行えなくなり、攻撃が疑われる可能性があります。）

---

## ARP Spoofingで可能な攻撃

- マルウェア配布
- セッションハイジャック
- DNSスプーフィング
- VoIP盗聴
- ログイン情報（ID/パスワード）の収集

---

## 対応方法

- パケット検出プログラムを使用してARP信号を送るパケットを確認
- ARPテーブルを静的に管理
- ARPスプーフィング検出ソフトウェアを使用
- ネットワーク機器で同一IPに同一MACアドレスがマッピングされているか確認

---

## 攻撃テスト

![re_cap](https://github.com/user-attachments/assets/6ca7e9de-b559-462e-9696-721857259700)

### シナリオ 1

**被害者のARPテーブルにゲートウェイのIPと攻撃者のMACアドレスを保存させ、被害者が送受信するパケットをスニッフィング。**

<攻撃前の被害者のARPテーブル>  
![arp_before_v2](https://github.com/user-attachments/assets/3996d878-82c9-4fbd-a855-8b61d12af1f3)

<攻撃後の被害者のARPテーブル>  
![arp_after_v2](https://github.com/user-attachments/assets/2f0075be-e96b-4333-a43b-0c0fc65a4a9e)

**被害者がログイン時、アカウント情報をスニッフィング**  
![계정정보](https://github.com/user-attachments/assets/e06da358-76a7-4467-bb84-df28884082f3)

---

### シナリオ 2

**スイッチのARPテーブルにゲートウェイのIPと攻撃者のMACアドレスを保存させ、スイッチに接続されたすべてのホストのパケットをスニッフィング。**

<攻撃前のスイッチのARPテーブル>  
![SW_arp-table_before](https://github.com/user-attachments/assets/fe82acfd-6c65-4fd2-aeec-770671987b1a)

<攻撃後のスイッチのARPテーブル>  
![SW_arp-table_after](https://github.com/user-attachments/assets/23945841-c391-439a-9108-539bbb8d88d1)

---

### シナリオ 3

**ルーターにゲートウェイのIPと攻撃者のMACアドレスを送信し、ルーターのARPテーブルに同一IPに重複MACアドレスをマッピング。**

```log
Router# show logging

*Feb 28 15:19:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:20:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:20:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:21:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:21:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:22:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:22:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:23:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
*Feb 28 15:23:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9
```
