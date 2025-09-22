매불

| 타임코드        | 영상 주장(요지)                                        | 팩트/정정                                                                                                                                                                                                                                                                      | 근거(출처) |
| ----------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| (전반·반복)     | “망분리가 안 돼서 ‘무균실’ 논리도 어불성설”                       | 망분리는 **절대 방패가 아니며**, 한국 정부·금융권도 2024\~2025년 **망분리 일변도 → 제로트러스트·계층형 보안(N²SF)** 전환을 공식화. 즉 ‘무균실’처럼 과장된 표현은 부정확. **망분리는 여러 수단 중 하나**이며, 인증·접근·모니터링과 결합돼야 함. ([조선비즈][1])                                                                                                       |        |
| (전반·맥락) | 코로나로 원격 접속이 늘었고, 외부망 접속이 늘어 종료하지 않는 세션도 있다 → 이것이 이번 문제의 ‘원인’이다 | **논리 비약.** 팬데믹 기간 원격근무·VPN 사용이 급증한 건 사실이지만, **원격접속 자체가 침해의 직접 원인이라는 인과는 입증되지 않음.** 다수 기관·기업은 원격접속을 허용하되 **VPN·IP 허용목록(Allowlist)·접근권한 최소화·MFA·모니터링·제로트러스트(ZTA)** 등으로 보안을 **체계적으로 강화**해 왔다. 즉 **상관관계 ≠ 인과관계**, 본 사건의 원인 규명은 **취약 서비스·프로토콜 경로·운영 설정** 등 기술적 사실에 근거해 이루어져야 함. ([CISA][5]) |        |
| **22:50~** | “로그가 생성되니 민감결제정보도 남는다”는 일반화                      | **오해.** 로그는 자동으로 ‘무조건’ 남지 않음. **PLURA가 강조하는 요청/응답 본문 로그와 OS 감사정책 로그는 관리자 설정 시에만 수집**되고, 기본값으로는 남지 않음. 또한 **민감 인증데이터**(CVV/CVC·PIN·트랙데이터)는 **승인 후 저장 금지**, **PAN** 취급 시에도 **비가독화**(마스킹/토큰화)가 원칙. “자동으로 로그에 다 남는다”는 주장은 사실 아님. ([PCI Security Standards Council][2]) |        |
| (전반·반복)     | “**2017년부터 8년간** 해킹됐다”                           | **사실 아님.** 보도된 핵심 취약점은 **Oracle WebLogic CVE-2017-10271**(2017년 공개·패치 제공)으로, **취약점 공개 연도 = 침해 지속 기간**이 아님. WebLogic의 **HTTP/T3 경로 악용 가능**이 문서화되어 있으나, **8년 지속 침해**를 입증하는 공식 근거는 없음. ([NVD][3])                                                                             |        |
| (검증 필요 핵심)  | “웹셸 패치 문제가 아니라, **언제부터 WAF가 차단하지 못했는지** 검증돼야 한다” | **정확한 문제 제기.** 미차단 원인 점검 체크포인트: ① **TLS 종단 위치**(WAF 앞단 복호화로 L7 가시성 확보), ② **프로토콜 경로**(WebLogic **T3** 등 **비HTTP 우회** 차단), ③ **예외/룰 운영**(우회 예외·서명 미적용·완화 정책). WebLogic의 **T3/직렬화 기반 RCE**는 공신 자료로 확인됨—구성에 따라 WAF 우회 가능. ([NVD][3])                                          |        |

### 부연: 롯데카드 사건의 확인된 수치(참고)

* **피해 규모:** 약 **2.97백만 명**. 이 중 \*\*약 28만 명(≈9.5%)\*\*은 카드번호·유효기간·CVC·비밀번호(2자리) 등 **부정 사용 가능 데이터** 포함으로 발표. ([Reuters][4])
* **회사/당국 조치:** 사건 공지 및 소비자 보호조치(재발급·보상 등) 발표. ([Reuters][4])

원하시면 \*\*추가 타임코드(예: 23:01, 29:10)\*\*를 주제로 행을 더 늘려 드릴게요. 각 행에 “직접 인용·팩트·근거”를 붙여 **팩트체크 표**를 완성해 드리겠습니다.

[1]: https://biz.chosun.com/en/en-it/2025/09/10/B7VVFIDGLZG5BDBNJWBGGXYSIM/?utm_source=chatgpt.com "South Korea overhauls network security with tiered N2SF ..."
[2]: https://www.pcisecuritystandards.org/faq/articles/Frequently_Asked_Question/for-pci-dss-why-is-storage-of-sensitive-authentication-data-sad-after-authorization-not-permitted-even-when-there-are-no-primary-account-numbers-pans-in-an-environment/?utm_source=chatgpt.com "Sensitive authentication data (SAD) is used ..."
[3]: https://nvd.nist.gov/vuln/detail/cve-2017-10271?utm_source=chatgpt.com "CVE-2017-10271 Detail - NVD"
[4]: https://www.reuters.com/sustainability/boards-policy-regulation/mbk-controlled-lotte-card-says-personal-data-nearly-3-million-customers-leaked-2025-09-18/?utm_source=chatgpt.com "MBK-controlled Lotte Card says personal data of nearly 3 ..."
[5]: https://www.cisa.gov/topics/risk-management/coronavirus/telework-guidance-and-resources?utm_source=chatgpt.com "Telework Guidance and Resources"
