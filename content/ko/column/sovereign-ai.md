---
title: "소버린 AI의 시작은 ‘소버린 데이터’다"
date: 2025-09-28
draft: true
description: "AI 방어가 안 되는 이유는 데이터가 없기 때문, 방어용 데이터는 ‘생성’할 수 있습니다."
tags: ["Sovereign AI", "Sovereign Data", "웹 로그", "감사 로그", "Sysmon", "auditd", "PLURA-XDR", "MITRE ATT&CK"]
---

## 요약 한 줄

> **AI 방어는 데이터 게임**입니다. 지금 실패의 본질은 **데이터가 없어서**고, 정답은 **방어용 데이터를 ‘생성’하는 운영 전환**입니다.  
> 웹은 **요청·응답 본문**, 서버는 **감사 정책 활성화**로 **새 로그를 만들어** AI가 일할 자료를 공급하세요.

---

## 1) 왜 ‘소버린 데이터’가 방어의 출발점인가

* **AI는 데이터가 없으면 무능합니다.** 모델·플레이북·요정수준 프롬프트도 **원천 로그가 없으면 무용**입니다.
* **공격은 AI로 고도화**되지만, **방어는 데이터 부재**로 “이상징후→스토리라인→격리”가 이어지지 않습니다.
* **소버린 AI**의 의미는 모델 국산화만이 아니라, **국내 환경/규정/언어/업무 맥락에 맞는 ‘국산 방어 데이터’의 자급**입니다.

---

## 2) 지금 체계가 실패하는 전형적 패턴 (징후)

* **웹 본문 미수집**: URI·상태코드만 있고 **POST/Response Body가 없다**
* **호스트 가시성 제로**: **Advanced Audit Policy 비활성**, Sysmon/auditd 미구성
* **TLS 가시성 결핍**: WAF/프록시·ALB에서 **복호화 지점의 본문 로깅 부재**
* **PII 우려로 전면 비수집**: **마스킹/토큰화** 없이 “아예 안 남김”을 선택
* **스키마 부재**: 필드 난립·중복·비정형으로 **AI 학습/규칙화 불가**

---

## 3) 방어용 데이터는 ‘생성’할 수 있다 — 원리

1. **웹**: **요청(Request) + 응답(Response) 본문**을 **복호화 경계**(WAF/리버스 프록시/앱GW)에서 **정책적으로 생성**
2. **서버/호스트**: **감사 정책을 ‘켜서’** 프로세스·파일·계정·네트워크 행위를 **구조화 이벤트**로 **생성**
3. **프라이버시-세이프 파이프라인**: **PII 마스킹·해쉬·토큰화** 후 저장 → **AI/탐지 엔진이 바로 먹을 스키마**로 적재

---

## 4) 웹: 요청·응답 본문 로그 설계 (운영 체크리스트)

**목표:** 웹셸 업로드·경로우회·RCE·데이터 유출의 **증거와 컨텍스트**를 본문에서 포착

### 4.1 어디서 캡처할 것인가 (권장 우선순위)

1. **WAF/프록시/리버스 프록시**(TLS 종료 지점)
2. **애플리케이션 서버 에이전트**(프레임워크 미들웨어 훅)
3. **eBPF/PCAP 계열**(예외·포렌식용, 기본은 비권장)

### 4.2 수집 정책

* **기본**: `POST/PUT/PATCH` 요청 본문 **전량 또는 샘플+룰기반 전량**
* **고위험 엔드포인트**(업로드·인증·결제·관리자): **무조건 전량**
* **응답(Response)**: `Content-Type`이 `text/*`, `application/json|xml` 등 **의미 있는 본문**은 **요약+전문(조건부)**
* **대용량 바이너리**: **해시(SHA-256) + 헤더 + 앞뒤 N바이트**(슬라이딩 창) 보존

### 4.3 프라이버시·보안

* **서버단 토큰화·마스킹**: 카드·주민번호·세션 토큰 **정규식 기반 동적 마스킹**
* **비가역 해시(pepper 포함)**로 **식별자 의존 탐지** 가능하게
* **DLP 룰**: “개인정보 필드 전송 시 전문 보관 금지 + 요약만” 선택 가능

### 4.4 권장 스키마(요지)

```json
{
  "ts": "2025-09-28T08:15:30.123Z",
  "trace_id": "1f3a...e9",
  "src_ip": "203.0.113.10",
  "dst_host": "app.example.com",
  "method": "POST",
  "url": "/api/upload",
  "status": 200,
  "req_hdr": {"ct":"multipart/form-data", "ua":"..."},
  "req_body": {"len": 5432, "hash": "sha256:...", "snippet_b64": "..."},
  "resp_hdr": {"ct":"application/json"},
  "resp_body": {"len": 321, "hash": "sha256:...", "snippet_b64": "..."},
  "pii_flags": ["email_masked","card_redacted"],
  "waf": {"policy":"post-body-on","action":"allow","signals":["anomaly_upload_ext_dbl"] }
}
```

### 4.5 실무 팁

* **헤더·바디 분리 저장 + 공통 trace_id**로 **분산 처리/재조합** 용이
* **샘플링 → 룰승격**(의심 신호시 전문 전환) **동적 제어**
* **압축(Zstd)** + **수명주기(핫 7일/웜 30일/콜드 180일)**

---

## 5) 서버/호스트: 감사 정책으로 로그 생성 (Windows·Linux)

### 5.1 Windows (Advanced Audit Policy + Sysmon)

**목표:** 실행/권한상승/계정/지속성/네트워크/파일 변조의 **연쇄 증거화**

**필수 감사 정책(요지)**

* **Account Logon/Logon**: 성공·실패
* **Object Access**: 파일/레지스트리(고가치 경로만)
* **Policy Change / Privilege Use / System / DS Access**
* **Detailed Tracking**: **Process Creation** 켜기

**빠른 적용 예시**

```powershell
# 관리자 PowerShell
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"Process Creation" /success:enable
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1 /f
```

**Sysmon 핵심 이벤트**

* **1**(Process Create), **3**(Network Connect), **7**(Image Load), **10**(Process Access),
* **11**(File Create), **12/13**(Registry Add/Set), **15**(FileStream),
* **17/18**(Pipe Created/Connected), **22**(DNS), **23/24**(FileDelete/Detected)

> 권장: **서명/CLM/WDAC 정책과 함께** “합법 실행체계”를 명시해 **잡음 최소화 + 공격면 가시화**.

### 5.2 Linux (auditd + 핵심 추적)

**auditd 규칙(요지)**

* **execve** 호출 추적: `-a always,exit -F arch=b64 -S execve -k exec`
* **uid/gid 변경·setuid**: `-S setuid,setreuid,...`
* **계정/그룹 변경**: `/etc/passwd`, `/etc/shadow`, `/etc/sudoers` **워치**
* **웹루트 쓰기**: `/var/www/**` **w 권한 감시**
* **권한상승/네트워크 설정** 관련 syscalls

**journald + eBPF 보강**

* **SSH 인증 이벤트**, **서비스 재시작**, **코어 덤프**, **의심 DNS/출력** 등 **탐지 룰과 직결**되는 항목만 보강

---

## 6) 30·60·90일 로드맵 (현실 배포 플랜)

**D+30 (가시성 개통)**

* [ ] **TLS 종료 지점**에서 **POST 본문** 캡처 시작(고위험 URI 전량)
* [ ] **Windows Process Creation** + **Sysmon(1/3/10/22)** 최소 집합
* [ ] **Linux auditd execve + 웹루트 w** 룰 적용
* [ ] **PII 마스킹 프로파일** 1차 가동(카드/주민/토큰)
* [ ] **스키마 고정 + trace_id** 통일

**D+60 (품질·탐지 전환)**

* [ ] **응답 본문 요약/전문 보관 룰** 정교화
* [ ] **MITRE ATT&CK 맵핑 룰팩**(웹셸, 권한상승, C2, 데이터 유출) 적용
* [ ] **샘플링→전문화 전환 로직**(동적) 배포
* [ ] **성능 가드레일**(QPS 상한/바디 크기 제한/압축)

**D+90 (AI 준비도 달성)**

* [ ] **시나리오형 스토리라인 재구성**(웹→호스트 연계)
* [ ] **LLM 보조 triage** 활성(플레이북: 격리/계정잠금/티켓)
* [ ] **품질지표(QoD)** KPI 운영(아래 참조)

---

## 7) 품질지표(QoD) & AI 준비도 지표

* **본문 커버리지**: 고위험 엔드포인트의 **전량 본문 수집율(%)**
* **엔티티 충실도**: `user/session/file/hash/dns/url` **누락율↓**
* **연결성**: **웹 이벤트 ↔ 호스트 이벤트** **trace_id 조인율**
* **탐지 성능**: **MTTD/MTTR**, 스토리라인 재구성 **완결률**
* **프라이버시 적합성**: **비마스킹 저장률 0%** 유지

---

## 8) 법·윤리·프라이버시

* **최소수집** + **목적 제한** + **보존주기** 명시
* **민감정보 전면 마스킹** 기본, 포렌식 필요시 **봉인형 접근**
* **접근 통제·암호화·접근 로그** 의무화

---

## 9) 실패를 부르는 안티패턴

* “**PII 위험하니 아예 본문을 안 남긴다**” → **탐지·포렌식 불능**
* “**스키마 없이 때려 넣기**” → **AI 불가·성능 지옥**
* “**TLS 종단 불명확**” → **본문 캡처 불가**
* “**전량 무압축·무수명주기**” → **비용 폭탄**

---

## 10) 결론 — **데이터를 만들면 AI 방어가 시작됩니다**

* **웹 본문**과 **감사 로그**는 **지금도 ‘생성’할 수 있는 방어 자산**입니다.
* **가시성(D+30) → 품질(D+60) → AI연계(D+90)**로 **단계적 전환**을 밟으세요.
* 소버린 AI의 진짜 기반은 **현장에서 길러낸 소버린 데이터**입니다.

---

## 부록 A. 운영 체크리스트 (한 장 요약)

* [ ] TLS 종료 지점 식별 및 **POST/Response 본문 로깅** 가동
* [ ] **PII 마스킹/토큰화** 정책 적용
* [ ] **스키마 확정 + trace_id 통일**
* [ ] Windows **Advanced Audit Policy + Sysmon(핵심 이벤트)**
* [ ] Linux **auditd(execve, 웹루트 w) + journald 보강**
* [ ] **수명주기/압축** 및 **성능 가드레일**
* [ ] **MITRE 룰팩** 연동 및 **스토리라인 재구성**
* [ ] **QoD KPI** 운영 (커버리지·연결성·프라이버시)

---

## 부록 B. (선택) PLURA-XDR와의 연결 예

* **웹**: WAF/프록시 본문 캡처 → **Post-body 분석** + **MITRE 맵핑**
* **호스트**: Sysmon/auditd → **행위 상관** → **AI SecOps 에이전트**가 **격리/계정잠금/티켓** 실행
* **TI**: 외부 TI + 내부 탐지 피드백으로 **소버린 인텔리전스** 강화

