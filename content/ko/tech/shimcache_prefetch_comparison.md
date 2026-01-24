---
date: 2026-01-24T09:00:00
draft: false
description: "윈도우 포렌식 핵심 아티팩트인 ShimCache와 Prefetch를 비교하고, Prefetch 단독 조회를 넘어 악성코드와 연계된 ‘실행 체인(Execution Chain)’을 복원하는 실무 확장 전략을 정리합니다."
featured_image: "cdn/tech/shimcache_prefetch_comparison.png"
tags: ["Digital Forensics", "ShimCache", "Prefetch", "Amcache", "Sysmon", "침해 사고 분석", "Windows", "Execution Chain", "지속성(Persistence)"]
title: "ShimCache와 Prefetch: 실행 흔적 입증에서 실행 체인 복원까지"
---

📖 **ShimCache와 Prefetch, 왜 ‘둘 다’ 봐야 할까? 그리고 어떻게 ‘연계 실행 체인’까지 복원할까**

> 목표: 침해 사고 분석(Incident Response)에서 가장 중요한 질문은 결국 이것입니다.  
> **“악성 파일이 실제로 실행되었는가?”**  
> 하지만 실무에서 더 중요한 질문은 한 단계 더 나아갑니다.  
> ✅ **“이 악성 파일을 실행·지원·은폐·전달한 프로그램 체인은 무엇인가?”**  
>
> 이 글은 기존 **ShimCache vs Prefetch 비교**를 기반으로, Prefetch/ShimCache를 시작점으로 **실행 체인(Execution Chain)을 복원**하는 확장 분석 흐름까지 정리합니다. :contentReference[oaicite:0]{index=0}

---

## 1. ShimCache (AppCompatCache): “존재”의 증명

ShimCache(Application Compatibility Cache)는 프로그램의 **호환성 유지**를 위해 설계된 기능입니다.  
포렌식 관점에서는 파일이 시스템에 ‘**존재했음**’을 증명하는 강력한 증거가 됩니다.

### ❌ 분석 시 주의할 점 (오해와 진실)

- **실행 시간이 아니다**: ShimCache의 타임스탬프는 보통 **실행 시각이 아니라 파일의 마지막 수정 시간(Last Modified Time)** 성격으로 해석해야 합니다. 이를 실행 시간으로 단정하면 타임라인이 크게 틀어질 수 있습니다.
- **실행 여부의 모호성**: Windows 버전/조건에 따라 “캐싱됨 = 실행됨”이 항상 성립하지 않습니다.
- **휘발성 특성**: 일반적으로 **정상 종료/재부팅 시점에 기록**되는 성격이 있어, 강제 종료/크래시 상황에서는 최신 흔적이 누락될 수 있습니다.

### ✅ ShimCache의 핵심 가치

- **파일 존재 입증**: 원본이 self-delete 되었어도 경로 흔적이 남을 수 있습니다.
- **이동 경로 추적**: 악성 파일이 어느 경로에 있었는지 전체 경로 기반 추적이 가능합니다.

---

## 2. Prefetch: “실행”의 확증

Prefetch는 윈도우의 **부팅 및 실행 속도 향상**을 위한 메커니즘이며, 분석가에게는 “**실행되었다**”를 가장 강하게 뒷받침합니다.

### 📌 Prefetch가 제공하는 결정적 증거

- **확실한 실행 보장**: Prefetch 파일(`.pf`)이 생성되었다면 해당 실행 파일은 **실제로 실행**되었을 가능성이 매우 높습니다.
- **정확한 실행 시각**: 마지막 실행 시각뿐 아니라(Win 8 이상 기준) **최근 여러 회(일반적으로 8회)의 실행 시각**을 기록하는 구조가 일반적입니다.
- **실행 횟수(Run Count)**: 실행 빈도 추정에 유리합니다.

### ❌ 한계점

- **개수 제한/덮어쓰기**: 시스템에 따라 Prefetch 저장 개수 제한으로 오래된 기록이 덮일 수 있습니다.
- **환경에 따라 비활성/부재 가능**: 일부 서버/정책/저장장치 환경에서는 Prefetch가 기대대로 남지 않을 수 있어 “없다 = 실행 안 했다”로 단정하면 위험합니다.
- **단독으로는 ‘연계’가 약함**: Prefetch는 “실행”을 잘 말해주지만, **누가 실행했는지(부모 프로세스), 어떤 체인인지**는 Prefetch만으로 완전 복원이 어렵습니다.

---

## 3. 한눈에 보는 비교: ShimCache vs Prefetch

두 아티팩트는 상호 보완적입니다. 하나만으로는 전체 그림을 그리기 어렵습니다.

| 비교 항목 | 🔹 ShimCache (AppCompatCache) | 🔹 Prefetch |
| --- | --- | --- |
| 원래 목적 | 애플리케이션 호환성 유지 | 프로그램 실행 속도 향상 |
| 저장 위치 | 레지스트리 (`SYSTEM` Hive) | 파일 시스템 (`C:\Windows\Prefetch`) |
| 기록 시점 | 시스템 종료/재부팅 시 반영되는 성격 | 프로그램 실행 시 생성되는 성격 |
| 시간 정보 | 실행 시각이 아닌 값으로 오해 위험 | 실행 시간(Last Run Time) 중심 |
| 포렌식 의미 | 파일이 시스템에 **존재했음**을 입증 | 파일이 **실행되었음**을 뒷받침 |
| 삭제 시 | 원본 파일 삭제돼도 흔적이 남을 수 있음 | 원본 파일 삭제돼도 `.pf`가 남을 수 있음 |

---

## 4. 현실적인 분석 시나리오: “실행 후 삭제” 대응

### 📌 시나리오: 공격자가 `malware.exe` 실행 후 삭제하고 도망감

#### 1) ShimCache에서 흔적 포착

- **발견**: `C:\Temp\malware.exe`
- **의미**: “이 시스템에 해당 파일이 존재했었다.”

#### 2) Prefetch로 행위 확증/강화

- **발견**: `MALWARE.EXE-12A3B456.pf`
- **의미**: “정확히 언제, 몇 번 실행되었는지”에 대한 강한 단서 확보  
- **추가 단서**: 로드 DLL/참조 파일 목록에서 네트워크/암호화/스크립트 흔적 등 정황 확보 가능

---

## 5. 추천 기본 흐름도 (존재 → 실행 입증)

```mermaid
flowchart TD
  Start[사고 발생 및 분석 시작] --> CheckFile[파일 존재 여부 확인]

  CheckFile -->|파일 삭제됨| CheckShim[ShimCache 분석]
  CheckShim -->|기록 없음| DeepScan[MFT/저널링 분석]
  CheckShim -->|기록 있음| CheckPrefetch[Prefetch 폴더 확인]

  CheckPrefetch -->|pf 파일 존재| ConfirmExec["실행 확정 & 시간/횟수 분석"]
  CheckPrefetch -->|pf 파일 없음| InferredExec["실행 여부 불투명 (단순 존재 가능성)"]

  ConfirmExec --> Report[보고서 작성: 실행 입증]
  InferredExec --> Report
```

---

## 6. 관점 전환: Prefetch는 ‘결론’이 아니라 ‘시작점’

Prefetch는 “**이 실행 파일이 실행된 적이 있다**”를 말해주는 도구입니다.
하지만 실무에서 우리가 복원해야 하는 것은 보통 이것입니다.

> ❌ “이 악성 파일이 실행됐나?”
> ✅ **“이 악성 파일을 실행·지원·은폐·전달한 프로그램은 무엇인가?”**

즉, 중심을 **‘연계 흔적’**(Correlation)으로 옮기면 분석이 확장됩니다.

---

## 7. Prefetch 내부에서 바로 뽑을 수 있는 “연계 단서”

### 7.1 DLL 로드/참조 흔적: 인젝션·사이드로딩 정황

Prefetch에는 실행 시점에 **참조된 파일 경로**(특히 DLL 포함)가 남는 경우가 많습니다.
아래 패턴은 실무에서 자주 “연계 단서”가 됩니다.

* 정상 앱에선 보기 힘든 DLL 로드
* `Temp`, `AppData`, `ProgramData` 하위에서 로드되는 DLL
* 파일명 위장 DLL (`version.dll`, `wininet.dll` 등 “정상 DLL처럼 보이게”)

➡️ **의미**

* **인젝션/사이드로딩** 가능성 판단
* “드로퍼(배포)” vs “로더/실행(호출)”의 역할 구분에 도움

> 팁: Prefetch를 파싱할 때는 “실행 파일 자체”보다 **의심 경로/의심 DLL/의심 확장자**에 하이라이트를 주는 방식이 빠릅니다.

---

## 8. ShimCache와 Prefetch를 “시간 축”으로 결합하기

둘을 교차하면 단순히 “있다/없다”를 넘어 **상황을 분기**할 수 있습니다.

| 상황                         | 해석(현장 관점)                                   |
| -------------------------- | ------------------------------------------- |
| ShimCache만 있음              | 드롭/유입만 됐을 가능성, 또는 실행 증거가 다른 곳에 존재           |
| Prefetch + ShimCache       | 실행 + 반복 가능성(타임라인 강화)                        |
| Prefetch 없음 + ShimCache 있음 | 1회성/특수 환경/Prefetch 비활성/덮어쓰기 등 가능성(추가 증거 필요) |

➡️ **연계 포인트(실무 체크)**

* 동일 디렉터리에 존재했던 **다른 실행 파일/스크립트**(드로퍼/다운로더/로더)
* 시간 흐름상 “먼저 등장한 파일”과 “뒤이어 실행된 파일”의 관계

> 주의: ShimCache의 시간은 “실행 시간”으로 단정하지 말고, Prefetch/이벤트로그/파일시스템(MFT·USN)과 교차 검증하세요.

---

## 9. Amcache.hve: “설치형 악성코드/유입 경로” 추적의 핵심

ShimCache/Prefetch가 “존재/실행”을 다룬다면, Amcache는 경우에 따라 **유입(설치) 관점**에서 훨씬 강력해집니다.

확인 포인트(대표):

* File ID / SHA1(또는 식별 해시)
* Program Name
* First Install Time (환경/버전에 따라 다르게 기록될 수 있음)
* Parent Path / Source 경로 단서

➡️ **의미**

* 드로퍼 → 페이로드 구조 파악(“누가 무엇을 떨어뜨렸나”)
* 정상 프로그램 위장 여부 판단
* 실행이 불확실해도 **시스템 유입 사실**을 입증

---

## 10. (로그가 있다면 최강) Sysmon/보안 로그로 “프로세스 트리” 복원

Prefetch로는 절대 완전하게 보기 어려운 것이 **부모-자식 프로세스 관계**입니다.
Sysmon(또는 EDR/XDR/보안로그)이 있다면, 실행 체인 복원이 급격히 쉬워집니다.

### ✔ Sysmon Event ID 1 (Process Create)에서 보는 핵심 필드

* `ParentImage`
* `CommandLine`
* `CurrentDirectory`
* `Hashes`

예시(전형적인 체인 형태):

```text
powershell.exe
 └── rundll32.exe
      └── evil.dll
```

➡️ **핵심**

* Prefetch는 “rundll32가 실행됐다”를 말해줄 수 있어도
  “**누가 rundll32를 불렀는지, 어떤 커맨드라인이었는지**”는 로그가 훨씬 강합니다.

---

## 11. “누가 다시 살렸는가”: 지속성(Persistence) 트리거 추적

최초 실행 파일과 **재실행(지속성) 트리거**는 다른 경우가 많습니다.
따라서 실행 체인의 마지막 퍼즐은 보통 **지속성 메커니즘**입니다.

대표 확인 대상:

* Scheduled Tasks

  * 예: `schtasks /query /v`
* Services

  * 예: `HKLM\SYSTEM\CurrentControlSet\Services`
* WMI Event Subscription

  * Event Filter / Consumer / Binding 조합 확인

➡️ **의미**

* “최초 실행 프로그램 ≠ 지속성 트리거”를 분리해서 봐야 함
* 정상 프로그램 이름을 쓴 악성 서비스/작업이 숨어 있을 수 있음

---

## 12. Prefetch가 없거나 약할 때: MFT/USN Journal로 “드롭 묶음” 찾기

Prefetch가 비활성/덮어쓰기/삭제 등으로 비어 있으면, 파일시스템 레벨이 특히 중요해집니다.

확인 포인트:

* 악성 파일 생성 직후 생성된 `.exe`, `.dll`, `.ps1`, `.vbs`, `.bat`
* 동일 초 단위/근접 시간대에 생성된 파일 군집(“드롭 묶음”)

➡️ **의미**

* 드롭 행위 입증(“누가 무엇을 언제 떨어뜨렸는가”)
* 실행 파일 간 관계성 도출(로더/페이로드/설정 파일 등)

---

## 13. 실무용 “연계 실행 분석(Execution Correlation)” 요약 흐름

```text
[악성 파일 발견]
      ↓
[Prefetch 존재 여부]
      ↓
[Prefetch에서 실행 시간/횟수 + 로드 DLL/참조 파일 추출]
      ↓
[ShimCache로 존재/경로/동일 디렉터리 연계 파일 확보]
      ↓
[Amcache로 유입/설치/식별(해시) 강화]
      ↓
[Sysmon/이벤트로그로 Parent-Child + CommandLine 복원]
      ↓
[지속성(작업/서비스/WMI)로 재실행 트리거 확인]
      ↓
[MFT/USN으로 파일 생성 군집 묶어 최종 체인 재구성]
```

---

## 14. PLURA-Forensic 관점 제안: “Execution Correlation Analysis”로 격상

Prefetch를 **단일 결과 항목**으로 두는 순간, 분석은 “점”에서 멈춥니다.
현장 대응은 **선**(체인)을 복원해야 합니다.

### ▶ 카테고리 제안: “연계 실행 분석(Execution Correlation Analysis)”

포함 요소(권장 묶음):

* Prefetch
* ShimCache
* Amcache
* Process Tree(로그 기반)
* Persistence Artifacts(작업/서비스/WMI 등)

➡️ 이 방식의 최종 목표는
**“악성 파일 단독 입증” → “공격 시나리오 복원”** 입니다.

---

## 15. 현장에서 바로 쓰는 체크리스트 (10문 10답)

1. **이 파일은 실행됐나?** → Prefetch로 확인
2. **몇 번 실행됐나?** → Run Count/최근 실행 기록
3. **실행 시각은 언제였나?** → Prefetch 시간 기반 타임라인
4. **실행 시 무엇을 로드/참조했나?** → Prefetch의 DLL/참조 파일
5. **같은 폴더에 연계 파일(드로퍼/스크립트)이 있나?** → ShimCache/파일시스템
6. **유입(설치) 흔적은 더 없나?** → Amcache로 강화
7. **누가 실행시켰나(부모 프로세스)?** → Sysmon/보안로그
8. **커맨드라인은 무엇이었나?** → PowerShell/rundll32/mshta 등 식별
9. **다시 실행되게 만든 트리거는?** → 작업/서비스/WMI
10. **Prefetch가 비어 있다면?** → MFT/USN으로 생성 군집 재구성

---

## 📌 결론

* **ShimCache는 “존재”의 강한 단서**입니다.
* **Prefetch는 “실행”을 뒷받침하는 강력한 증거**입니다.
* 하지만 실제 침해사고 분석의 핵심은 다음 한 문장으로 정리됩니다.

> **Prefetch는 시작점이지 결론이 아니다.**
> 악성코드 분석의 핵심은
> “**누가 실행했는가, 무엇을 불렀는가, 어떻게 다시 살아났는가**”다.

---

## 💡 분석가 팁 (Pro Tip)

* **도구 활용**: `Eric Zimmerman's Tools`(예: AppCompatCacheParser, PECmd 등)로 파싱 자동화하면 속도가 크게 올라갑니다.
* **시간 오해 방지**: ShimCache는 시간 해석을 특히 조심(단독 해석 금지), Prefetch/로그/파일시스템과 교차 검증을 기본값으로 두세요.
* **통합 관점**: EDR/XDR 로그가 있다면 최우선으로 활용하되, 로그 유실·지연 탐지 상황에서는 위 아티팩트들이 “블랙박스” 역할을 합니다.

---

### 📖 함께 읽기

* [침해 사고 분석 절차 가이드](/ko/tech/ir_guide/)
* [윈도우 레지스트리 포렌식 기초](/ko/tech/registry_forensics/)

---
