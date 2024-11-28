---
date: 2021-07-14T11:58:08-04:00
title: "MACアドレスを確認する方法"
description: "PCサーバーの固有情報を確認するためのMACアドレスの使用方法を紹介します。"
featured_image: 
tags: ["MACアドレス", "ネットワーク", "PC情報"]
---

![blog_banner_20210714_1](https://github.com/user-attachments/assets/1b1c156c-814b-4bd2-90a0-8dcc99516e79)

PCサーバーの固有情報を確認して活用するために、**MACアドレス**を確認する方法を紹介します。

---

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
