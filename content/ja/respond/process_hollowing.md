---
date: 2025-02-10T16:00:00
draft: false
description: 
featured_image: "cdn/respond/process_hollowing.png"
tags: ["process_hollowing", "CyberSecurity", "MalwareAnalysis", "ThreatDetection", "EDR_Security"]
title: "Process Hollowing: 攻撃技術と検出戦略"
---

# 🤔1. Process Hollowingとは？

**Process Hollowing**は、T1055.012として分類される**Process Injection**のサブテクニックであり、  
**正規のプロセスのメモリアドレス空間を破損させ、マルウェアを実行する手法**を指します。<br>
<br>
🕵️‍♂️ 主に**権限昇格や検知回避**を目的として使用され、代表的な例として**Meterpreter**や**Cobalt Strike**などの攻撃ツールで活用されます。<br>
攻撃者は、正規の実行ファイルをロードした後、そのメモリ内のコードを**悪意のあるペイロードに上書き**することで動作します。

この手法は、セキュリティソリューションによって検知されにくいです。<br>
🚨 なぜなら、実行中のプロセスが**正規のファイルと同じパスを持ち、署名された合法的なプログラムに見える**ためです。  

<!--more-->

![process_hollowing1](https://github.com/user-attachments/assets/524b4574-0aa7-4878-abc2-60694b47cf9e)

[写真 1] Process Hollowing

# 🛠️2. Process Hollowingの主要な手順

Process Hollowingは、一般的に以下の手順で実行されます。

## 2-1) プロセスを一時停止状態で作成する

![process_hollowing2](https://github.com/user-attachments/assets/011a705f-b35a-4612-8c46-d9a2e70025d5)

[写真 2] Process Hollowing Step 1

![code1-1-1](https://github.com/user-attachments/assets/2cf8151c-6d40-40ac-aaca-e8ba105eb9ba)

[写真 3] Process Hollowing Step 1 (code)

正常なプロセスである**explorer.exe**を実行する。

## 2-2) プロセスのImageBaseアドレスを取得する。

![process_hollowing3](https://github.com/user-attachments/assets/2d2c9524-e112-4798-91ce-b5e1bd2779d0)

[写真 4] Process Hollowing Step 2

![code1-2-1](https://github.com/user-attachments/assets/33b8e5cb-e8b8-4e48-ae71-3e418adbf250)

[写真 5] Process Hollowing Step 2 (code)

新しく作成されたプロセスのイメージベースアドレスを取得する。

## 2-3) プロセスのImageBaseアドレスをUnmappingする。

![process_hollowing4](https://github.com/user-attachments/assets/2d798777-6958-451d-a874-ab5422780f4a)

[写真 6] Process Hollowing Step 3

![image](https://github.com/user-attachments/assets/87cf1b03-cd7f-4e1e-aad7-3861171d7fb5)

[写真 7] Process Hollowing Step 3 (code)

元々実行されていた**explorer.exe**のメモリをアンマップし、空の状態にする。

## 2-4) プロセスのImageBaseアドレスに新しいイメージをマッピングする。

![process_hollowing5](https://github.com/user-attachments/assets/8c892aca-1789-44c7-ac72-d04f3c4d4e9c)

[사진 8] Process Hollowing Step 4

![code2-1](https://github.com/user-attachments/assets/01677cfb-bee8-41ec-96ad-a13198237a8d)

[写真 9] Process Hollowing Step 4 (code1)

![code2-2](https://github.com/user-attachments/assets/9b99ed92-af05-498c-8e82-bddc06e1adad)

[写真 10] Process Hollowing Step 4 (code2)

- **injector**オブジェクトを使用して、**マルウェアコード（malwareTarget）**を正規プロセスに注入する準備を行う。  
- **malwareTarget**（サイズ: 2,203,648バイトのPEバイナリ）を**peクラス**を使用してロードする。  
- `injector.alloc(malwr_size, imagebase, false);`  
  - 元のプロセスが使用していた領域（**imagebase**）に、マルウェアコードのサイズ分のメモリを割り当てる。

## 2-5) 一時的なメモリ領域を確保する。

![process_hollowing6](https://github.com/user-attachments/assets/1f85d2b0-c132-4098-8c2d-569a877a5ac1)

[写真 11] Process Hollowing Step 5

![code2-3](https://github.com/user-attachments/assets/2c1dff38-7497-458f-b1c1-bcbfd166ea83)

[写真 12] Process Hollowing Step 5 (code)

- **PEファイルをロードするための新しいメモリ領域**を確保する。  
- `getRelativeOffset` を使用して、**再配置情報（Relocation Offset）**を計算する。  
- **新しいベースアドレスをマルウェアコードに設定する**。

## 2-6) 一時的に確保したメモリ領域にマルウェアPEファイルのヘッダーを書き込む。

![process_hollowing7](https://github.com/user-attachments/assets/b490090d-752f-4bd6-9742-b1f111e42910)

[写真 13] Process Hollowing Step 6

![code2-4](https://github.com/user-attachments/assets/af1bb32e-2db0-480a-9223-5e14c6fa2c0a)

[写真 14] Process Hollowing Step 6 (code)

プロセスが正常に実行できるように、**PEファイルのヘッダー（Header）情報**を最初に書き込む。

## 2-7) 一時的に確保したメモリ領域にマルウェアPEファイルのセクションを書き込む。

![process_hollowing8](https://github.com/user-attachments/assets/ed71f701-290c-4acb-a2de-f0ab19c7c7a9)

[写真 15] Process Hollowing Step 7

![code2-5](https://github.com/user-attachments/assets/b7823331-c03f-4ba6-a327-efb282ea4811)

[写真 16] Process Hollowing Step 7 (code)

- **PEファイルは、ヘッダー（Header）+ セクション（Section）構造**で構成されている。  
- `getFirstSection()` を使用して最初のセクションを取得し、`writeSection()` を用いて各セクションをコピーする。  
- `getNextSection(currentSection)` を使用して、すべてのセクションを順番に書き込む。

## 2-8) ImageBaseを基準にマルウェアPEファイルのコードとデータを再配置する。

![process_hollowing9](https://github.com/user-attachments/assets/27a5e07d-3a2c-49fb-b459-263691682c05)

[写真 17] Process Hollowing Step 8

![code2-6](https://github.com/user-attachments/assets/9d78b686-3c61-42a4-b477-50abbe3929c4)

[写真 18] Process Hollowing Step 8 (code)

- **PEファイルが新しいメモリアドレスにロードされたため、元々想定されていたベースアドレスと異なる可能性がある**。  
- `relocate()` 関数を使用し、相対オフセットを適用することで、正しく実行できるように修正する。

## 2-9) 再配置が完了したマルウェアPEファイルを正規PEファイルのメモリ領域に書き込む。

![process_hollowing10](https://github.com/user-attachments/assets/e1b11d53-6e2d-4c9b-8324-5c49c7646981)

[写真 19] Process Hollowing Step 9

![code2-7](https://github.com/user-attachments/assets/68a188f1-ea00-40ff-8421-40d72b52e7ba)

[写真 20] Process Hollowing Step 9 (code1)

![code3-1](https://github.com/user-attachments/assets/d45f46f2-bdf1-4f66-891a-7fa2f7c5d3fe)

[写真 21] Process Hollowing Step 9 (code2)

- `injector.write()` を使用して、**PEファイル全体を正規プロセスのメモリに書き込む**。  
- `patchEntryPoint()` を使用して、**元のプロセスのエントリーポイントをマルウェアコードのエントリーポイント（Entry Point）に変更する**。

## 2-10) コードの開始アドレスをImageBaseを基準に修正した後、プロセスを再開する。

![process_hollowing11](https://github.com/user-attachments/assets/d2695498-3cab-4993-8754-bf19d1310143)

[写真 22] Process Hollowing Step 10

![code3-2](https://github.com/user-attachments/assets/843278b8-1037-477a-bac9-a2f18285d4b9)

[写真 23] Process Hollowing Step 10 (code)

- `resume()` を呼び出し、停止状態だったプロセスを再実行する。  
- しかし、この時点から実行されるコードは、**元のexplorer.exeではなく、マルウェアコード**となる。

## Process Hollowingの手順まとめ

1. **正規プロセス（explorer.exe）を実行**
2. **既存のPEイメージをアンマップして削除**
3. **マルウェアコード注入のためのメモリ割り当て**
4. **PEファイルをロードし、ヘッダー＆セクションデータをコピー**
5. **再配置（Relocation）を適用**
6. **エントリーポイント（Entry Point）を変更**
7. **プロセスを再開 → 正規プロセスに偽装して実行**

![hollow_test_virustotal](https://github.com/user-attachments/assets/d0eaebf5-9319-4066-8612-48101f02d7dd)

[写真 24] 使用された**hollow_test.exe**をVirusTotalにアップロードした結果、**23/71のエンジンでマルウェアとして検出**。

## **使用されたProcess Hollowingコード**

```cpp
#include <Windows.h>

#include "process_.h"
#include "injector.h"

#include "pe.h"

WCHAR wszProcessPath[] = L"explorer.exe";

unsigned char malwareTarget[2203648] = { // explorer.exeのバイナリ値 }
int WINAPI WinMain(
	HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	PSTR lpCmdLine,
	INT nCmdShow
)
{
	process normalProcess;

	if (normalProcess.create(wszProcessPath, true, false))
	{
		ULONG_PTR imagebase = normalProcess.imagebase();

		if (normalProcess.unmap(imagebase, false)) // Step3
		{
			injector injector(normalProcess.handle());

			pe malwr(malwareTarget, 2203648);
			ULONG malwr_size = malwr.imageSize();

			LONG_PTR relativeOffset = 0;

			ULONG_PTR malwrAddr = injector.alloc(malwr_size, imagebase, false); // Step4: target process メモリ割り当て

			if (malwrAddr != 0)
			{
				ULONG_PTR buildAddr = malwr.memAlloc(malwr_size); // Step5

				relativeOffset = malwr.getRelativeOffset(malwrAddr);
				malwr.setImagebase(malwrAddr);

				injector.writeHeader(buildAddr, (ULONG_PTR)malwr.peHeader(), malwr.peHeaderSize()); // Step6: ### ヘッダーの記録

				// Step 7
				ULONG_PTR currentSection = malwr.getFirstSection();

				for (int nSection = 0; nSection < malwr.numberOfSection(); ++nSection)
				{
					injector.writeSection(buildAddr, (ULONG_PTR)malwr.peHeader(), currentSection);
					currentSection = malwr.getNextSection(currentSection);
				}

				// Step 8: relocate
				malwr.relocate(buildAddr, relativeOffset);

				// Step 9, 10
				injector.write(malwrAddr, buildAddr, malwr_size, false);
				normalProcess.patchEntryPoint(malwrAddr, malwr.addressOfEntryPoint());
				normalProcess.resume();
			}
		}
	}

	return 0;
}

```

---

---

# 3. 作成したProcess Hollowingプログラムの実行画面

![program](https://github.com/user-attachments/assets/57fff65a-d408-4b87-8c31-391668b18810)

[写真 25] **hollow_test.exe** 実行画面

![process_list](https://github.com/user-attachments/assets/79ba792b-8559-4b0b-80c7-b22789f208d2)

[写真 26] **プロセス一覧**

Process Hackerを使用してプロセスの一覧を確認した結果、`hollow_test.exe` プロセスの下に  
`explorer.exe（ファイルエクスプローラー）` および `conhost.exe` が存在していることを確認できた。

## 🔍 プロセス分析

### a. **`hollow_test.exe` 内部で別の `explorer.exe` が実行**
- 本来、`explorer.exe` はシステムによって自動的に実行されるプロセスだが、  
  特定の実行ファイル（`hollow_test.exe`）が親プロセスとして `explorer.exe` を実行したことは非常に疑わしい動作である。
- これは通常の実行方式ではなく、マルウェアが**Hollowing手法を利用して正規プロセスを偽装した可能性**を示唆している。

### b. **`conhost.exe` の存在**
- `conhost.exe` はコンソールプログラムをサポートする**正規のWindowsプロセス**だが、  
  `hollow_test.exe` の配下で実行されている点が特異である。
- マルウェアが `conhost.exe` を利用してシェルコマンドを実行するケースもあるため、注意が必要。

### c. **CPUおよびメモリ使用量の分析**
- `hollow_test.exe` の**CPU使用率が高くない場合、マルウェアがバックグラウンドで静かに動作している可能性**がある。
- `WriteProcessMemory`、`SetThreadContext`、`ResumeThread` などのAPI呼び出しを監視し、  
  **追加のHollowingが発生していないか**を確認する必要がある。

![two_explorer](https://github.com/user-attachments/assets/fc3de4a3-034e-47b3-af0b-f2a8c488f52d)

[写真 27] **`explorer.exe` プロセスが2つ存在することを確認**

## 1️⃣ 分析ポイント

### 1) `explorer.exe` プロセスが2つ存在

- Windowsでは通常、**1つの `explorer.exe`** が実行される。
- `explorer.exe` が複数存在する場合、**マルウェアがHollowing手法を使用した可能性**がある。

### 2) Parent-Child関係およびプロセス生成の確認

- 上記の画像では、**PID 9728** の `explorer.exe` が **PID 2296** の `explorer.exe` の **子プロセス** として実行されている。
- `explorer.exe` が別の `explorer.exe` の**子プロセスとして生成されるのは通常の動作ではない**。
- これは、攻撃者が正規の `explorer.exe` を Hollowing して実行した可能性が高い。

### 3) メモリ使用量と実行サイズの差異

- **PID 2296 (`explorer.exe`)**: 86.25MB メモリ使用
- **PID 9728 (`explorer.exe`)**: 5.05MB メモリ使用
- 通常、`explorer.exe` は多くのメモリを消費するが、**5.05MBしか使用していない** `explorer.exe` は、  
  **Hollowingによって正規のPEがロードされていない可能性**が高い。

![explorer_analysis](https://github.com/user-attachments/assets/877a4d15-49de-44f9-9204-7bedb1c5762d)

[写真 28] **2つの `explorer.exe` プロセス分析**

## **1️⃣ 分析ポイント**

### **✅ (1) 正常な `explorer.exe` (PID 2296)**

- **パス:** `C:\Windows\Explorer.EXE`（正規のシステムファイルのパス）
- **実行場所:** `C:\Windows\system32\`
- **実行開始:** **3か月前 (2024-10-30)**  
  → 正常な `explorer.exe` は通常 Windows 起動時に実行されるため、**長時間実行されているのが正常**。
- **親プロセス:** `Non-existent process (PID 4088)`  
  → `explorer.exe` は通常 `winlogon.exe` によって起動されるため、**親プロセスが存在しないのは正常な場合が多い**。

### **🚨 (2) 疑わしい `explorer.exe` (PID 9728)**

- **パス:** `C:\Windows\explorer.exe`（正規のファイルのように見えるが、実行方法が異なる）
- **実行場所:** `C:\Users\user\Desktop\hollow_test\x64\Debug\`  
  → ❗ **正規の `explorer.exe` は `system32` で実行されるべきだが、デスクトップ上の `hollow_test.exe` によって実行された。**
- **実行開始:** **3日20時間前 (2025-02-05)**  
  → システム起動とは無関係なタイミングで新しく `explorer.exe` が実行されている。
- **親プロセス:** `hollow_test.exe (PID 2196)`  
  → ❗ `explorer.exe` は通常 `winlogon.exe` によって起動されるが、**別のプロセス (`hollow_test.exe`) が親プロセスとして設定されている。**  
  → **Process Hollowing** 攻撃手法でよく見られるパターンである。
  
---

## **2️⃣ Process Hollowing の疑わしい証拠**

📌 **Hollowing の可能性が高い理由:**

- **`hollow_test.exe` が Parent Process に設定されている**  
  → これは通常の `explorer.exe` の実行方式とは異なる。

- **`explorer.exe` が異常なパス（デスクトップの Debug フォルダ）から実行されている**  
  → 通常の `explorer.exe` は `C:\Windows\system32\` から実行されるべきだが、  
    **別のディレクトリから起動されている点が不審**。

- **`explorer.exe` の実行時間が3日前で、手動で実行された可能性**  
  → **Windows の起動プロセスとは無関係な実行履歴**があり、不正なプロセス注入の疑いが強い。

![analsys](https://github.com/user-attachments/assets/2e9ee03c-fe88-4dde-bb0b-7ffa345042b5)

[写真 29] **2つの `explorer.exe` プロセス分析**

## **1️⃣ スレッド（Thread）分析ポイント**

### **✅ (1) 正常な `explorer.exe` (PID 2296)**

- **TID（スレッドID）の数:** 13個以上のスレッドが実行中。
- **Start Address（開始アドレス）:**
    - `SHCore.dll!Ordinal172+0x100`（Windows Shell 関連ライブラリ）
    - `ntdll.dll!TpReleaseCleanupGroupMembers`（スレッドプール関連）
    - `combase.dll!RoGetServerActivatableClassRegistration`（COM ベースサービス関連）
    - `WorkFoldersShell.dll!DllUnregisterServer`（WorkFolders 関連プロセス）
    - その他、`GdiPlus.dll`、`SHCore.dll` などのシステム DLL から開始される**正常な動作**が確認される。
- **スレッド優先度:** `Above normal` を含む、さまざまな優先度のスレッドが存在。
- **解析結果:**
    - 正常な `explorer.exe` は **Windows のさまざまなシステム機能を利用し、多数のスレッドを生成**して動作する。
    - これは **Windows Shell およびエクスプローラーの正常なプロセス動作**である。

---

### **🚨 (2) 疑わしい `explorer.exe` (PID 9728)**

- **TID（スレッドID）の数:** **4個のみで非常に少ない**
- **Start Address（開始アドレス）:**
    - `explorer.exe+0xa3a10` → ❗ **バイナリコードから直接実行されたスレッド**（疑わしい）
    - `ntdll.dll!TpReleaseCleanupGroupMembers`（一般的なWindows API）
- **スレッド優先度:** すべてのスレッドが `Normal` に設定されている。
- **解析結果:**
    - **正常な `explorer.exe` と比較すると、DLL ベースのスレッドがほとんど存在しない。**
    - `ntdll.dll` の `TpReleaseCleanupGroupMembers` は通常の動作である可能性はあるが、  
      **単一のAPI呼び出しのみでエクスプローラーが動作するのは不自然**。
    - **最も疑わしい点は `explorer.exe+0xa3a10` のアドレスから直接実行されたスレッドが存在すること。**
        - これは **Process Hollowing によってマルウェアのペイロードがインジェクションされた際によく見られるパターン**。

---

## **2️⃣ Process Hollowing の可能性および追加分析の必要性**

📌 **Hollowing の可能性が高い理由:**

### a. **TID（スレッドID）数の違い**
   - **正常な `explorer.exe`（PID 2296）** は **13個以上のさまざまなシステムスレッド** を含む。
   - **疑わしい `explorer.exe`（PID 9728）** は **4個のみで、大部分が `ntdll.dll` から実行されている**。

### b. **異常な実行場所**
   - `explorer.exe+0xa3a10` は、明確な DLL ベースのスレッドではなく、  
     **メモリ内部コードの実行形態** に見えるため、**Hollowingの痕跡** として疑わしい。

### c. **親プロセス (`hollow_test.exe`) の存在**
   - **本来 `explorer.exe` は `winlogon.exe` によって生成されるはず** だが、  
     **異常なプロセス (`hollow_test.exe`) から実行されている** ことが確認された。

---

このように、**Process Hollowing** 手法は表面的には正規プロセスと区別が難しく、単純な識別方法だけでは検出が困難です。  
そのため、実行フローの詳細な分析やメモリ検査、スレッドパターンの比較など、**高度なフォレンジック技術**が必要となります。

# 🔎4. Process Hollowing の検出手法

Process Hollowing は高度な攻撃手法ですが、セキュリティソリューションではさまざまな方法で検出できます。

## 📡4-1) API呼び出しのモニタリング

`CreateProcess`、`NtUnmapViewOfSection`、`VirtualAllocEx`、`WriteProcessMemory`、  
`SetThreadContext`、`ResumeThread` などのAPI呼び出しが連続して発生する場合、疑わしい動作と見なすべきです。

- **EDRやSIEMログ**を分析し、これらのAPIの呼び出しパターンを監視することで、不審な挙動を検出できます。

## 🏴‍☠️4-2) 実行ファイルとメモリマッピングの比較

正規の実行ファイルとメモリ上でロードされている実行ファイルが異なる場合、Process Hollowing が発生している可能性が高いです。

- **`SigCheck` を使用して、実行ファイルの署名と整合性を検証**
- **`Volatility` を活用し、メモリ内の実行中プロセスを分析し、実行ファイルとの不一致を検出**

## 🧩4-3) Parent-Child プロセス関係の分析

攻撃者が元のプロセスを停止し、新たな Hollowing されたプロセスを実行すると、Parent-Child 関係が異常に変化することがあります。

- 例：`explorer.exe` から `cmd.exe` を実行するのは正常ですが、`winlogon.exe` から `powershell.exe` が実行される場合は疑わしい。
- **`Sysmon` を使用して Parent-Child 関係を追跡** することで、不審なプロセスの動作を検出できます。

## 📊4-4) コードインジェクションの検出

Process Hollowing の本質は、**正規プロセス内にマルウェアコードを注入すること** です。  
これを検出するためには、**プロセスのコード領域を定期的にスキャンし、実行可能なメモリページが変更されていないか確認** する必要があります。

- **`Mimikatz` や `PE-Sieve` を使用して、メモリ上の不審なコード挿入を検出** できます。

# 🛡️5. Process Hollowing の対策

Process Hollowing 攻撃を効果的に防ぐには、以下のセキュリティ対策を適用することが重要です。

## 5-1) **EDRおよびSIEMソリューションの活用**

- **API呼び出しのパターン分析**
- **実行ファイルの整合性チェック**
- **Parent-Child関係のモニタリング** などを自動化し、攻撃をリアルタイムで検出

## 5-2) **攻撃対象領域の最小化**

- `AppLocker` や `Windows Defender Application Control (WDAC)` を活用し、疑わしい実行ファイルの実行を制限。
- **ASLR、DEP、CFG** などのメモリ保護技術を有効にし、コードインジェクションを困難にする。

## 5-3) **システムログ分析および検出フィルタの適用**

- **`Sysmon` や `Windows Event Logging` を活用し、疑わしいAPI呼び出しを監視・フィルタリング**

## 5-4) **定期的なフォレンジック分析の実施**

- **`Volatility`、`Procmon`、`PE-Sieve` を使用してシステムを定期的にスキャンし、不審な動作を分析**

# 🏆6. 結論

Process Hollowing は攻撃者が頻繁に使用する強力なコードインジェクション技術ですが、  
適切な検出手法を活用すれば、十分に対策することが可能です。  
特に **API呼び出しのモニタリング、実行ファイルとメモリの比較、Parent-Child関係の分析** を活用することで、攻撃を効果的に検出できます。

🔒 セキュリティ担当者は常に **MITRE ATT&CK フレームワークの T1055（Process Injection）技術を分析し、検出フィルタを最新の状態に維持** する必要があります。  
また、定期的なセキュリティレビューとフォレンジック分析を通じて、組織のセキュリティレベルを強化することが求められます。
