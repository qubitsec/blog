---
date: 2022-06-21T00:00:00
title: "sqlmap"
description: "SQL Injectionの検出および悪用のためのオープンソース侵入テストツール"
featured_image: ""
tags: ["sqlmap", "SQL Injection", "セキュリティ", "侵入テスト", "データベース"]
---

![sqlmap](https://github.com/user-attachments/assets/58985214-005b-412f-8f6c-3fb6719e5925)

## sqlmapとは？

**sqlmap**は、SQL Injectionの脆弱性を検出し悪用できるPythonで作成されたオープンソースの侵入テストツールです。

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

![データベース名の抽出](https://github.com/user-attachments/assets/41dd7117-117d-43bb-aaca-9a06df5581de)

---

### テーブル名の抽出

![テーブル名の抽出](https://github.com/user-attachments/assets/7eeefc89-e858-4104-ae44-31085132ecb0)

---

### カラム名の抽出

![カラム名の抽出](https://github.com/user-attachments/assets/4b601d3f-09e6-4e39-bb3d-578625689dec)

---

### データ情報の抽出

![データ情報の抽出](https://github.com/user-attachments/assets/c8d1ac2d-2c3e-49be-bba0-39e939f65160)

---

## 参考資料

- [University of Toronto - SQLMap](http://www.cs.toronto.edu/~arnold/427/15s/csc427/tools/sqlmap/index.html)
- [sqlmap GitHub Wiki](https://github.com/sqlmapproject/sqlmap/wiki/Usage)
- [BinaryTides - SQLMap Hacking Tutorial](https://www.binarytides.com/sqlmap-hacking-tutorial)
