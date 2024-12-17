---
date: 2022-06-21T00:00:00
draft: false
title: "sqlmap"
description: "SQL Injectionの検出および悪用のためのオープンソース侵入テストツール"
featured_image: "cdn/tech/sqlmap-1.png"
tags: ["sqlmap", "SQL Injection", "セキュリティ", "侵入テスト", "データベース"]
---

## sqlmapとは？

**sqlmap**は、SQL Injectionの脆弱性を検出し悪用できるPythonで作成されたオープンソースの侵入テストツールです。

<!--more-->
![sqlmap](https://blog.plura.io/cdn/tech/sqlmap-1.png)

---

### 主な特徴
- **対応データベース**: MySQL、PostgreSQL、Oracle、Microsoft SQL Serverなどの最新データベースで動作
- **機能**:
  - データベースの脆弱性確認から、データベース、テーブル、カラム、データの抽出までSQL Injection攻撃技術を自動化
- **対応SQL Injection技術**:
  - Error Based
  - Time Delay
  - Stacked Queries
  - Boolean Based
  - Union Based

---

## sqlmapの使用方法と例

- [Kali Tools - sqlmap](https://www.kali.org/tools/sqlmap/)
- [sqlmap公式サイト](https://sqlmap.org/)

---

## PLURAのSQL Injectionとデータ漏洩検出

### データベース名の抽出

![d1](https://github.com/user-attachments/assets/fa668e3f-ab17-4e3b-be96-f947716257e5)

---

### テーブル名の抽出

![d2-1](https://github.com/user-attachments/assets/33426029-c1ed-4c33-bd41-04c5dc14c1d0)

---

### カラム名の抽出

![d3-1](https://github.com/user-attachments/assets/c42a4261-7532-4a58-9a88-fea6d1b8c518)

---

### データ情報の抽出

![d4-1](https://github.com/user-attachments/assets/67351212-0d91-4f29-aded-ccbde1061edc)

---

## 参考資料

- [University of Toronto - SQLMap](http://www.cs.toronto.edu/~arnold/427/15s/csc427/tools/sqlmap/index.html)
- [sqlmap GitHub Wiki](https://github.com/sqlmapproject/sqlmap/wiki/Usage)
- [BinaryTides - SQLMap Hacking Tutorial](https://www.binarytides.com/sqlmap-hacking-tutorial)
