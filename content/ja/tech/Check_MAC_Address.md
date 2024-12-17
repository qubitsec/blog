---
date: 2021-07-14T11:58:08-04:00
draft: false
title: "MACアドレスを確認する方法"
description: 
featured_image: "cdn/tech/check_mac_address-1.png"
tags: ["MACアドレス", "ネットワーク", "PC情報"]
---

PCサーバーの固有情報を確認して活用するために、**MACアドレス**を確認する方法を紹介します。

<!--more-->
---
![check_mac_address](https://blog.plura.io/cdn/tech/check_mac_address-1.png)

## コマンドプロンプトを起動

まず、`コマンドプロンプト(cmd)`を起動します。

![cmd](https://github.com/user-attachments/assets/904a77ef-fe8d-4590-a336-1ca42daa2135)

---

## `ipconfig /all` コマンドを実行

コマンドプロンプトで次のコマンドを実行します:

```bash
ipconfig /all
```

![ipconfig](https://github.com/user-attachments/assets/80ce24e4-b4d8-45f1-9f1b-e41af052c497)

---

## MACアドレスの確認

`ipconfig /all` コマンドの実行結果から、各アダプターの `物理アドレス(Physical Address)` の項目が、そのアダプターのMACアドレスです。
