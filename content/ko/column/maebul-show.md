**쇼/영상 메타**

* **쇼 이름(채널)**: \[팟빵] 매불쇼 ([YouTube][1])
* **영상 제목**: *충격적 사실! 외국 해커에게 완전히 뚫린 한국정부기관! \[코너별 다시보기]* ([YouTube][2])
* **원본 링크**: YouTube(동일 ID) ([YouTube][2])
* **업로드 시점(YouTube 표시)**: 2025-09-23 업로드 표기(검색 스니펫 기준) ([YouTube][2])
* **검토 반영 날짜**: 2025-09-23 (KST)

---

### 팩트체크 표 (오류·과장 지점)

| 타임코드        | 영상 주장(요지)                                    | 팩트/정정                                                                                                                                                                                                                                                |
| ----------- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| (전반·반복)     | “망분리가 안 돼서 ‘무균실’ 논리도 어불성설”                   | 망분리는 **절대 방패가 아님**. 한국의 2024\~2025 보안 방향은 **망분리 일변도 → 제로트러스트·계층형 보안(N2SF)** 전환. ‘무균실’처럼 과장된 일반화는 부정확. **망분리는 여러 수단 중 하나**로 인증·접근·모니터링과 결합돼야 함. ([조선비즈][3])                                                                                           |
| (전반·맥락)     | “코로나로 원격 접속이 늘고 종료 안 한 세션이 많아 이것이 이번 사태의 원인” | **논리 비약.** 원격근무·VPN 증가 사실과 **침해의 직접 인과는 별개**. 다수 조직은 **VPN·IP Allowlist·MFA·모니터링·ZTA**로 **보안을 강화**해 운영. 사건 원인 규명은 **취약 서비스·프로토콜 경로·운영 설정** 등 **기술적 사실**로 해야 함. ([CISA][4])                                                                           |
| **22:50\~** | “로그가 생성되니 민감결제정보도 남는다”는 일반화                  | **오해.** 로그는 자동으로 ‘무조건’ 남지 않음. **요청/응답 본문·OS 감사 로그는 관리자 설정 시에만 수집**(기본 Off). 또한 민감 인증데이터(SAD: CVC/CVV·PIN·트랙데이터)는 **승인 후 저장 금지**, **PAN(Primary Account Number)** 취급 시에도 **비가독화**가 원칙. “자동으로 다 남는다”는 주장은 사실 아님. ([PCI Security Standards Council][5]) |
| **23:01**   | (22:50 연장) “요청/응답 본문은 운영상 항상 남겨야 한다”         | **과장.** 본문 로깅은 **목적·범위·보존기간을 좁혀 선별 수집**하는 것이 표준. **민감필드 마스킹**과 **권한기반 열람** 필수. PCI-DSS의 **SAD 저장 금지**와 충돌하지 않도록 설계해야 함. ([PCI Security Standards Council][6])                                                                                        |
| (전반·반복)     | “**2017년부터 8년간** 해킹됐다”                       | **사실 아님.** 보고된 핵심 취약점은 **Oracle WebLogic CVE-2017-10271**(2017 공개·패치 제공). **취약점 공개 연도 = 침해 지속 기간**이 아님. WebLogic은 **HTTP/T3 경로 모두 악용 가능**이 문서화됐지만, ‘8년 지속 침해’를 입증하는 공식 근거는 없음. ([NVD][7])                                                            |

> **참고 수치(롯데카드):** 약 **2.97백만 명** 유출, 이 중 약 28만 명(≈9.5%)은 카드번호·유효기간·CVC·비밀번호(2자리) 등 **부정 사용 가능 데이터** 포함으로 발표. ([Reuters][8])

---

### 청중에게 유익한 포인트 표 (긍정/건설적 메시지)

| 포인트          | 요지                                                           | 근거(출처)                                |
| ------------ | ------------------------------------------------------------ | ------------------------------------- |
| 망분리 맹신 지양    | ‘망분리만으로 안전’이 아니라 제로트러스트·계층형 보안(N2SF)로 전환 필요성 환기              | ([조선비즈][3])                           |
| 원격접속 현대화     | 팬데믹 이후 원격접속은 **MFA·세분화된 접근·모니터링·ZTA**로 **안전하게 운영 가능**        | ([CISA][4])                           |
| 로깅의 설계 원칙    | 본문/감사 로그는 **기본 Off → 선별 On**, **민감필드 비가독화**, **권한기반 열람**이 표준 | ([PCI Security Standards Council][6]) |
| ‘오래된 취약점’ 경계 | **CVE-2017-10271**처럼 **구형 취약점 미패치**가 대형사고로 이어질 수 있음을 환기      | ([NVD][7])                            |

---

### 왜 요즘 공격이 부쩍 많아졌는가?

* **핵심 관점:** 최근 공격 증가는 **공격자도 AI/에이전트를 적극 활용**해 탐색·우회·코드 변종 생성·피싱 콘텐츠 생산을 **저비용·대량·고속**으로 수행하기 때문입니다.
* **현실 인식(공격–수비 비대칭):** **공격자의 AI 활용은 이미 일반화된 반면, 방어 측의 AI 기반 대응 체계는 많은 조직에서 아직 초기 단계이거나 부재합니다.** 즉 **수비자의 AI 대응 역량 공백**이 **피해 빈도와 규모 확대**로 이어지고 있습니다.
* **정량 근거(간접):** 글로벌 위협 리포트들은 AI·자동화 결합으로 **스캐닝/준비 단계가 폭증**했다고 보고합니다(예: 자동 스캔 **초당 3.6만 건** 수준). 또한 보안 책임자 다수가 “현 보안 체계가 AI 구동 위협에 미흡”하다고 응답했습니다. **“공격은 AI·자동화 결합으로 ‘폭발적(scale-out) 증가’ 양상을 보이고 있습니다.”** ([TechRadar][9])
* **메커니즘:**

  1. **우회/변종 자동화** — 서명 회피를 위한 페이로드 변형을 대량 생성
  2. **콘텐츠 대량 생산** — 스피어피싱·사회공학 메시지의 현지화·개인화 자동화
  3. **준비 단계 가속** — 열린 포트/취약 서비스 탐색, TTP(LOTL 등) 시뮬레이션 자동화
  4. **도구 체인 연계** — 스크립트·PoC 재활용, 에이전트로 연속 작업 실행
     (오펜시브 AI 연구 및 업계 리포트 다수에서 관찰) ([arXiv][10])

---

### 실무적 시사점 (축약본)

> *아래는 영상 비인용의 일반 보안 권고입니다.*

* **웹방화벽 대응의무 재점검:** 이번 유형은 **WAF가 가시성(TLS 종단), 비HTTP 경로(T3 등), 예외/룰 운영**을 포함해 **차단·탐지·알림**이 작동했어야 합니다. 현재 구성과 운영 이력을 즉시 점검하고, **가상패치·프로토콜 차단·룰 정비·재현 테스트**를 신속 적용하세요.
* **AI 보안 전환 가속:** 공격은 이미 **AI·자동화**로 규모가 커졌습니다. **요청/응답 본문 해석형 분석 + SecOps 에이전트** 기반으로 **탐지→격리→증거화**까지 자동화하는 **AI 보안 체계**로 전환을 **서둘러** 추진하세요.

---

[1]: https://www.youtube.com/%40maebulshow "팟빵 매불쇼"
[2]: https://www.youtube.com/watch?v=4XwhXsUVHN0 "충격적 사실! 외국 해커에게 완전히 뚫린 한국정부기관! [코너별 ...]"
[3]: https://biz.chosun.com/en/en-it/2025/09/10/B7VVFIDGLZG5BDBNJWBGGXYSIM/ "South Korea overhauls network security with tiered N2SF ..."
[4]: https://www.cisa.gov/sites/default/files/2023-12/CISA%20TIC%203.0%20Remote%20User%20Use%20Case_508c.pdf "Trusted Internet Connections 3.0 – Remote User Use Case (Dec 2023)"
[5]: https://www.pcisecuritystandards.org/faq/articles/Frequently_Asked_Question/for-pci-dss-why-is-storage-of-sensitive-authentication-data-sad-after-authorization-not-permitted-even-when-there-are-no-primary-account-numbers-pans-in-an-environment/ "Sensitive authentication data (SAD) – storage after authorization is not permitted"
[6]: https://www.pcisecuritystandards.org/document_library/ "PCI DSS Document Library (v4.x)"
[7]: https://nvd.nist.gov/vuln/detail/cve-2017-10271 "CVE-2017-10271 Detail – NVD"
[8]: https://www.reuters.com/sustainability/boards-policy-regulation/mbk-controlled-lotte-card-says-personal-data-nearly-3-million-customers-leaked-2025-09-18/ "MBK-controlled Lotte Card says personal data of nearly 3 ..."
[9]: https://www.techradar.com/pro/security/ai-powering-a-dramatic-surge-in-cyberthreats-as-automated-scans-hit-36-000-per-second "AI powering a 'dramatic surge' in cyberthreats as automated scans hit 36,000 per second"
[10]: https://arxiv.org/html/2410.03566v1 "A Survey on Offensive AI Within Cybersecurity"

