---
title: "KT 서버 해킹 사고 분석 – ‘전사 서버 침해 6건’ 보고"
date: 2025-09-22
draft: false
description: "2025년 9월 KT가 KISA에 신고한 서버 해킹 정황(침해 4건·의심 2건)을 타임라인과 기술 TTP로 분석하고, 왜 조기 탐지에 실패했는지와 즉시 이행할 보완책을 제시합니다."
featured_image: "cdn/threats/case-kt_server.png"
tags: ["KT", "해킹", "서버 침해", "Smominru", "Metasploit", "KISA", "침해사고", "보안운영"]
---

> **핵심 한 줄 요약**  
> KT는 **2025년 9월 18일 23:57** 한국인터넷진흥원(KISA)에 **서버 침해 흔적 4건 + 의심 정황 2건**을 신고했습니다. 공개 항목은 **Windows SMB 측면 이동, VBScript 기반 RCE, Smominru 봇 감염, Linux 계정·SSH 키 조작, 원격지원(알서포트) 서버 의심 계정/비밀키 유출** 등입니다. *(유출 여부는 미확정)* :contentReference[oaicite:0]{index=0}

> **패턴 요약 (롯데카드와 유사)**  
> 앞선 **롯데카드 WebLogic 사건**처럼, **원격 코드 실행(RCE) → 웹셸(또는 스크립트 기반 실행) → 내부 측면 이동(SMB/SSH)** 으로 이어지는 **전형적인 공격 체인**이 관찰됩니다. 차이는 **진입면(Entry point)**: 롯데카드는 취약한 미들웨어(WLS-WSAT), 이번 건은 **스크립트/RCE + 계정·키 조작 + 원격지원 경로** 정황이 부각됩니다. :contentReference[oaicite:1]{index=1}

<!--more-->

![KT 사건](https://blog.plura.io/cdn/threats/case-kt_server.png)

---

## 🕒 타임라인(사실 기반)

- **9/15(월)** 외부 보안업체 전수 점검 결과 수령 → 내부 검증 착수. :contentReference[oaicite:2]{index=2}  
- **9/18(목) 23:57** KISA에 **침해 4 + 의심 2** 신고. :contentReference[oaicite:3]{index=3}  
- **9/19(금)** 정부·KISA 합동 브리핑: **침해 서버·유출 여부 추가 분석 필요** 입장. :contentReference[oaicite:4]{index=4}  
- **9/22(월)** **폐기 서버 로그 백업 확인** 취지 보도 다수 → **디지털 증거 보전 가능성 확대**. :contentReference[oaicite:5]{index=5}

> *신고 지연 논란*: **9/15 인지 → 9/18 신고**로 24시간 내 신고 의무 위반 공방이 제기됨(최종 판단은 당국). :contentReference[oaicite:6]{index=6}

---

## 🧪 공개된 **침해 4건·의심 2건** 기술 분석 (MITRE ATT&CK)

### 🔹 침해 흔적(Confirmed)

1) **Windows 서버 침투 후 측면 이동 시도**  
- **MITRE**: *Lateral Movement* — **T1021.002 (SMB/Windows Admin Shares)**, **TA0008**  
- **해석**: 초기 침투 확보 후 **SMB 기반 이동**. **C\$/ADMIN$** 접근·세션 재사용·로컬 관리자 남용 가능성. :contentReference[oaicite:7]{index=7}

2) **‘Smominru’ 봇 감염**  
- **MITRE**: *Resource Hijacking* — **T1496**, *Exploitation of Remote Services* — **T1210** *(일반적 전파)*  
- **해석**: 모네로 채굴 봇. 과거 **MS17-010(EternalBlue)** 악용과 결합 보고 다수(이번 건 동일성 미확정). :contentReference[oaicite:8]{index=8}

3) **VBScript 기반 RCE 및 민감정보 탈취 정황**  
- **MITRE**: *Execution* — **T1059.005 (Visual Basic)**, *Collection/Exfiltration* — **TA0009/TA0010**  
- **해석**: **wscript/cscript** 실행, **AMSI 우회/난독화** 가능. **4688/4104**, Sysmon(1/7/11) 추적 대상. :contentReference[oaicite:9]{index=9}

4) **Metasploit 통한 SMB 인증 시도 및 측면 이동 성공**  
- **MITRE**: *Lateral Movement* — **T1021.002**, *Credential Access* — **T1110/T1550**  
- **해석**: 툴 아티팩트(파이프/UA/서비스) 지표. **실패→성공 전환 패턴** 탐지 필요. :contentReference[oaicite:10]{index=10}

### 🔹 의심 정황(Suspected)

A) **Linux ‘sync’ 계정 조작 & `~/.ssh/authorized_keys` 생성**  
- **MITRE**: *Persistence* — **T1098**, **T1098.004 (SSH Authorized Keys)**  
- **해석**: **키 기반 영속성** 확보 시나리오. `PermitRootLogin no`, `PasswordAuthentication no` 등 점검. :contentReference[oaicite:11]{index=11}

B) **원격지원(알서포트) 서버 의심 계정 & 비밀키 유출**  
- **MITRE**: *Valid Accounts* — **T1078**, *Exfiltration* — **TA0010**  
- **해석**: **원격지원 게이트웨이** 장악 시 전사 원격접속 경로로 악용. **계정·키 전면 교체** 필요. :contentReference[oaicite:12]{index=12}

---

## 🔄 **사건 업데이트(9/22)** — “폐기 서버 **로그 백업** 확인”

여러 매체에 따르면, **폐기 처리된 서버의 로그 백업**이 남아있는 정황이 확인되었습니다. 이는 **증거보전(Chain of Custody)** 을 다시 진행할 수 있음을 의미합니다.  
- **의미**: 백업 볼륨/오브젝트/테이프 등에서 **동일 시점 로그** 복원이 가능할 개연성. **WORM/보존정책** 임시 강제 권고.  
- **조치**: 전사 범위 **증거 보전 명령(legal hold)**, 증거 파일별 **SHA-256 해시** 산출 및 타임스탬프 공유. :contentReference[oaicite:13]{index=13}

---

## 🧩 “기본 차단 룰”이 있는데 왜 뚫렸나 — **운영 가설 6가지**

1) **WAF 비경유 경로**: LB 헬스체크·직접 IP·대체 도메인 등 **우회 루트** 개방.  
2) **모니터링 모드/예외 과다**: SOAP/XML·스크립트 트래픽에 **탐지 전용/관대한 화이트리스트**.  
3) **정규화/디코딩 비활성**: GZIP/Chunked·인코딩 우회 **원본 통과**.  
4) **정책 불일치**: 블루/그린·DR 전환 시 **정책 미동기화**.  
5) **룰 갱신 지연**: 테스트 실패 후 **롤백**·방치.  
6) **알림 미연계**: 차단/탐지 이벤트가 **관제·EDR·티켓**으로 이어지지 않음.

> **즉시 점검 4항** — ① **모든 외부 경로 WAF 경유 보장**, ② **차단 모드 + 정규화 활성**, ③ **예외/화이트리스트 재점검**, ④ **블루/그린/DR 정책 동기화 & 룰 최신화**.

---

## 🧭 개념도 (정황 기반)

```mermaid
sequenceDiagram
    participant A as 공격자
    participant W as Windows 서버
    participant L as Linux 서버
    participant R as 원격지원 서버
    participant D as 데이터/내부자원

    Note over A,W: (진입면 불명·분석 중)
    A->>W: VBScript RCE (wscript/cscript)
    W-->>A: 세션 생성·명령 실행

    Note over W: Smominru 감염 이력
    W->>W: SMB 측면 이동 (Metasploit)
    W->>L: SSH 키 투입 / authorized_keys 조작(영속성)

    A->>R: 원격지원 서버 의심 계정 생성/키 유출(정황)
    W->>D: 민감 자원 접근 시도(유출 범위 미확정)
````

*(도식은 공개 정황 기반 개념도이며 실제 토폴로지와 다를 수 있음)* ([뉴시스][1])

---

## 🛠 **즉시 이행** 체크리스트

**A. Windows 내부 이동 차단**

* **SMB Sign/Encrypt** 강제, **C\$/ADMIN\$** 접근 관리, **LAPS/Entra LAPS** 로컬 관리자 랜덤화.
* **wscript/cscript 차단(앱제어)**, **AMSI 강제**, **PowerShell Constrained Language**, **WDAC/SR**.
* **이상 인증 룰**: *동시간대 실패→성공 전환*, *비업무시간 관리자 이동* 경보.

**B. Linux 영속성 제거**

* `~/.ssh/authorized_keys` 전수 검증·**서명키 회수**, `PermitRootLogin no`, `PasswordAuthentication no`, U2F/FIDO2.

**C. 원격지원/게이트웨이**

* **계정·키 전면 교체**, **MFA 필수**, **허용 IP/디바이스 등록**, **세션 레코딩/감사**.
* 관리자 콘솔은 **Bastion 프록시** 뒤로 집약, **비정상 계정·키 생성 실시간 알림**.

**D. 탐지·관측 강화**

* **4688/4104/Sysmon(1/7/11)** + **SMB/WinRM 텔레메트리**를 **세션 단위 상관**.
* **키/토큰 접근**과 **다운로드 이벤트**에 **UEBA 기준** 적용.
* **전사 취약 자산 스냅샷**: EoL/미패치 Windows, 외부 노출 RDP/SSH/VNC 즉시 차단.

**E. 거버넌스·신고**

* **인지 시점 증빙** 표준화, **24시간 내 보고** SLA/런북 재정의(기술·PR 라인 분리). ([뉴시스][1])

---

## ⚖️ 사실관계 주의(미확정)

* **초기 침투 기법·루트서버**: 당국·합동조사단 정밀 분석 대기.
* **Smominru 전파 취약점**: EternalBlue 결합 보고는 일반론, **KT 동일성은 미확정**. ([조선일보][2])

---

## 🌟 PLURA-XDR 관점 대응

* **스크립트·웹셸/봇 행위 실시간 차단**: VBScript/PowerShell/명령해석기 및 파일리스 지표 상관→**차단/격리**. *(MITRE: T1059.005, T1505/T1546)*
* **내부 이동 탐지**: **SMB/WinRM/LDAP** 인증·세션 메트릭 + EDR 이벤트 결합으로 **행위 기반 LM** 탐지. *(T1021, TA0008)*
* **키·계정 거버넌스**: **authorized\_keys 변경·신규 계정·권한상승** 실시간 탐지. *(T1098, T1078)*
* **오케스트레이션**: IOC 시 **계정 잠금·키 회수·네트워크 분리·원격지원 세션 종료** 자동화.

---

## 📑 참고·교차검증

* **KISA 신고(9/18 23:57, 4+2건)**: ZDNet, 뉴시스, 한겨레. ([지디넷코리아][3])
* **기술 항목 상세(Windows/Smominru/VBScript/Metasploit, Linux·원격지원)**: 뉴시스·동아일보. ([뉴시스][1])
* **폐기 서버 ‘로그 백업 존재’ 업데이트(9/22)**: 경향·서울신문·연합뉴스TV. ([경향신문][4])


[1]: https://www.newsis.com/view/NISX20250919_0003336185?utm_source=chatgpt.com "최수진 \"KT 해킹 침해 인지후 사흘 뒤 늑장 신고\""
[2]: https://www.chosun.com/economy/tech_it/2025/09/22/2BP43LXV2JBBNEEUKBPMEUNBEA/?utm_source=chatgpt.com "[단독] KT 해킹 사건은 “해킹의 교본 같은 사례”"
[3]: https://zdnet.co.kr/view/?no=20250919092915&utm_source=chatgpt.com "KT, 서버 해킹 4건 발견...KISA에 신고"
[4]: https://www.khan.co.kr/article/202509221705001?utm_source=chatgpt.com "KT, '해킹 의혹' 서버 폐기했다가 뒤늦게 “백업 자료 있다”"
