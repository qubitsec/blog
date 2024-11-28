---
date: 2024-06-03
title: "[WEB] Webシェル攻撃とcreate_function関数の脆弱性"
description: "Webシェル攻撃の仕組みとcreate_function関数のセキュリティ脆弱性を分析"
featured_image: ""
tags: ["Webシェル", "セキュリティ", "PHP", "create_function"]
---

![webshell-1](https://github.com/user-attachments/assets/65f2db3d-7538-427e-a804-38cc3201c812)

### Webシェル(Webshell)の概要

Webシェル(Webshell)とは、Webサーバーにアップロードされることで、攻撃者がリモートからサーバーを制御できるようにする悪意のあるスクリプトです。これにより、サーバーのファイルシステムにアクセスし、コマンドを実行することが可能になります。

#### 主な機能:
- **ファイル管理:** アップロード、ダウンロード、編集、削除
- **コマンド実行:** サーバー上でのシェルコマンド実行
- **ネットワーク活動:** 悪意のあるコードの拡散や他のシステムへの攻撃
- **データベースアクセス:** 機密情報の流出

---

### Webシェルの実行/分析情報

![1](https://github.com/user-attachments/assets/33d3c999-2bb6-44f8-9840-33769efdcf7c)

#### 分析情報:
- **MD5:** `3cd5c4352b1379bd789ab3de7b76a196`
- **SHA-1:** `3a728d71ac418a906f9db78ba3fa935736eb02c9`
- **SHA-256:** `ec04ce68129b58837f0b7b720f9dcb453d840f051ef9d1e2f7d197abf4167384`

[画像1] VirustotalによるWebシェル分析結果

---

### create_function関数の脆弱性

![3](https://github.com/user-attachments/assets/5459d2f5-e667-4887-b088-b551f51a35ab)

**create_function関数**は、PHPで匿名関数(Anonymous Function)を生成する機能を提供します。しかし、この関数はセキュリティ上の脆弱性が指摘されており、次第に使用が非推奨となりました。

#### PHPバージョン別の動作:

1. **PHP 4.0.1 ~ 7.1.x**  
   - 正常に使用可能。

2. **PHP 7.2.0 ~ 7.4.x**  
   - `create_function()`は非推奨(deprecated)となり、警告メッセージが表示されますが、関数は引き続き実行可能です。  
   - **出力例:**  
     ```plaintext
     Deprecated: Function create_function() is deprecated in /path/to/file.php on line 2
     ```

3. **PHP 8.0以降**  
   - 関数が完全に削除され、実行時にFatal Errorが発生します。  
   - **出力例:**  
     ```plaintext
     Fatal error: Uncaught Error: Call to undefined function create_function() in /path/to/file.php:2
     ```

---

### 対応方法

PHPのバージョンを最新にアップデートすることは、セキュリティとパフォーマンスを強化するために必須です。特に、create_function関数の脆弱性を回避するためには、最新バージョンの使用が推奨されます。

#### 最新バージョンアップデートのメリット:
1. **セキュリティ強化:** Webシェル攻撃や脆弱性の防止。
2. **パフォーマンス向上:** Webアプリケーションの応答速度を最適化。
3. **新機能の提供:** 最新の文法や機能を活用可能。

そのため、PHP 8.0以降にアップデートすることで、セキュリティとパフォーマンスを維持し、Webシェルのような攻撃からシステムを保護できます。

---

### 参考資料

- [PHP公式ドキュメント - create_function関数](https://www.php.net/manual/en/function.create-function.php)  
- [Virustotal Webシェル分析結果](https://www.virustotal.com/gui/file/ec04ce68129b58837f0b7b720f9dcb453d840f051ef9d1e2f7d197abf4167384/details)
