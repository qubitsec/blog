---
date: 2021-01-25T00:02:00
description: 
featured_image: 
tags: ["タリウム", "Thallium", "XSL Script Processing", "T1220", "セキュリティ", "攻撃手法", "WMIC", "MITRE ATT&CK"]
title: "タリウム (Thallium) 組織、XSL Script Processing 攻撃を実行 [T1220]"
---

![shutterstock_298555268_0](https://github.com/user-attachments/assets/95568d22-9a84-45f4-901e-854210c30030)

## XSL Script Processingとは？

攻撃者はXSLファイルにスクリプトを埋め込むことで、アプリケーション制御を回避し、コード実行を隠蔽することができます。  
この攻撃手法は、**MITRE ATT&CK**で[T1220]として管理されています。

---

## XSLとは？

XSL (Extensible Stylesheet Language: 拡張可能なスタイルシート言語) ファイルは、一般的にXMLファイルのデータを処理し、レンダリングするために使用されます。  
XSLの標準には、複雑な処理をサポートするために、さまざまな言語でスクリプトを埋め込む機能が含まれています。

### 悪用の事例
攻撃者はこの機能を悪用し、アプリケーション制御を回避し、任意のファイルを実行します。  
特に**タリウム**や**Dridex**のようなマルウェアで利用されており、正規のWindowsユーティリティ(wmic.exe)を使用して悪意のあるXSLスクリプトファイルを取得します。

**タリウム(Thallium):**  
北朝鮮政府の支援を受けていると推定されるハッカー集団で、最近では私設株式投資メッセンジャープログラムを改ざんし、サプライチェーン攻撃を実行しました。

![qubit_tt](https://github.com/user-attachments/assets/f5653c30-9007-484b-88bf-3f1e3f55a87b)

---

## 実行動画 (XSL Script Processing)

[XSL Script Processing 実行例](https://docs.plura.io/ko/video/demo/web/xsl)

---

## PLURAによる検知および対応

PLURAは**「XSLスクリプト処理 [T1220]」**フィルターを使用して、この攻撃を検知できます。  
![qubit_t](https://github.com/user-attachments/assets/950a7355-2735-4c39-97ec-8754075e39a4)

---

## 参考資料

- [MITRE ATT&CK - T1220](https://attack.mitre.org/techniques/T1220/)
- [AhnLab ASEC ブログ](https://asec.ahnlab.com/ko/1344/)
- [アルヤクブログ](https://blog.alyac.co.kr/3489/)
