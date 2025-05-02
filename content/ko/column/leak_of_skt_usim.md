---
title: "SKT 유심 정보 유출 사건: 원인·영향·대응 총정리"
date: 2025-05-02
draft: false
description: "2025년 4월, SK텔레콤에서 발생한 대규모 USIM 정보 유출 사건의 경과와 실질적 대응 방안을 한눈에 정리합니다."
featured_image: "cdn/column/skt_usim.png"
tags: ["SKT", "SK텔레콤", "USIM", "BPFDoor", "APT", "SIM-Swapping", "PLURA-XDR"]
---

![SKT 유심 유출](https://blog.plura.io/cdn/column/skt_usim.png)

> **핵심 한 줄 요약**  
> 2025년 4월 18일 확인된 SK텔레콤 **HSS** 해킹은 최대 **2,300만** 가입자의 USIM 인증 정보를 노출시켰으며, SKT는 4월 28일 전 고객 무료 USIM 교체를 발표했습니다.   

---

## 🗓️ 타임라인
| 날짜 | 내용 |
|------|------|
| **4월 18 일** | 침해 사실 내부 인지·HSS 서버 격리 |
| **4월 19 일** | KISA “BPFDoor 계열 악성코드 의심” 경보 발령 |
| **4월 28 일** | SKT 공시 → 전 고객 무료 USIM 교체 발표, 주가 –8.5 % 급락 |
| **5월 5 일(예정)** | 전국 2,600개 대리점 신규가입 중단 후 교체 집중 시행 |

---

## 🔍 침해 방식: BPFDoor APT 시나리오(추정)
* **BPFDoor**는 리눅스 커널 BPF 훅을 활용해 **패킷 흔적이 남지 않는** 포트리스닝(backdoor) 기법을 구현합니다.  
* 내부 포렌식 초동 분석에서 `udp/53`·`tcp/443` 리버스 셸 흐름이 식별됐다는 제보가 KISA에 접수됐습니다(최종 보고 전). 

> **NDR 한계와 교훈**  
> 포트리스·TLS 암호화로 가시성이 ‘0’에 수렴하는 스텔스형 백도어는 **패턴 기반 NDR/IDS만으로는 탐지 불가**합니다.

---

## ⚠️ 2차 피해 위험: SIM-Swapping
노출된 **IMSI‧Ki‧IMEI** 조합은 SIM-Swap(명의 도용) 공격에 악용될 수 있으므로, 금융·공공 인증서를 재발급하고 계정 2FA를 재설정하는 것이 안전합니다.

---

## 🛡️ SKT ∙ 이용자 ∙ 업계 대응
1. **SKT 조치**  
   * 전 고객 무료 USIM 교체, USIM Protection Service 무상 제공  
   * 신규가입 1주일 중단 후 HSS 재점검  
2. **이용자 필수 수칙**  
   ① USIM 교체 예약 → ② 주요 계정 2FA 재설정 → ③ 의심 문자 링크 차단  
3. **업계 시사점**  
   * **다층 탐지 체계**(PLURA-XDR) 도입 필수  
   * HSS·HLR 등 핵심 망 장비의 **루트킷 탐지** 강화

---

## 🔐 PLURA-XDR로 가능한 보강
* **행위 기반 탐지** – `/dev/shm` 메모리-로드, portless 통신, 리버스 셸 패턴 식별  
* **로그 상관 분석** – 네트워크·호스트·애플리케이션 이벤트를 GPT 기반 그래프로 묶어 이상 징후 조기 경보  
* **PoC 제공** – HSS 로그·TLS 세션 가시성 리포트 무료 지원

> **결론:** 이번 사건은 “패턴 의존 보안”의 한계를 드러냈습니다. **PLURA-XDR** 같은 통합 AI 기반 플랫폼으로 **가시성 공백**을 메우는 것이 재발 방지의 현실적 해법입니다.

---

### 📖 함께 읽기
* [BPFDoor 백도어 실전 분석 및 대응: 매직 바이트·방화벽 우회](https://blog.plura.io/ko/respond/bpfdoor/)  
* [NDR의 한계: BPFDoor 스텔스형 공격 대응의 현실적 문제](https://blog.plura.io/ko/column/limitations-ndr-bpfdoor/)  


### 📑 참고 자료
* [Reuters - “SK Telecom shares plunge after data breach due to cyberattack” (2025-04-28)](https://www.reuters.com/sustainability/boards-policy-regulation/sk-telecom-shares-plunge-after-data-breach-due-cyberattack-2025-04-28)  
* [연합뉴스 - “최근 해킹 수법 경고…KISA, SKT 연계 악성코드 정보 공개” (2025-04-25)](https://www.yna.co.kr/view/AKR20250425168300017)  
* [Business Korea - “BPFDoor malware confirmed in SKT hack” (2025-04-29)](https://www.businesskorea.co.kr/news/articleView.html?idxno=241318)  

