---
title: "SKT 유심 해킹 사건 총정리: 유출 원인, 피해 규모, 대응 방법까지"
date: 2025-05-02
draft: false
description: "2025년 4월 발생한 SKT 유심 정보 대규모 유출 사건의 원인과 피해 규모, 그리고 현실적인 대응 방법까지 쉽게 정리했습니다"
featured_image: "cdn/column/skt_usim.png"
tags: ["SKT 해킹", "SKT 유심 유출", "유심 해킹", "SIM 스와핑", "BPFDoor", "APT 공격", "PLURA-XDR", "개인정보 유출"]
---


> **핵심 한 줄 요약**  
> 2025년 4월 18일 확인된 SK텔레콤 **HSS** 해킹은 최대 **2,300만** 가입자의 USIM 인증 정보를 노출시켰으며, SKT는 4월 28일 전 고객 무료 USIM 교체를 발표했습니다.   

<!--more-->
![SKT 유심 유출](https://blog.plura.io/cdn/column/skt_usim.png)

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

👉 [BPFDoor 백도어 동작원리](https://blog.plura.io/ko/respond/bpfdoor/)  

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

### ✅ 행위 기반 탐지 고도화

* **메모리 실행 탐지:** `/dev/shm` 등 비정상적인 경로에서의 메모리 로딩과 실행 행위를 실시간으로 탐지하고, 프로세스 추적을 통해 백도어 설치 초기 단계에서 차단합니다.
* **Portless(포트리스) 통신 탐지:** eBPF 필터 기반의 비표준 통신 방식을 이상 행위 탐지 모델로 분석하여, 패턴 기반 NDR/IDS가 놓친 악성 통신도 탐지 가능합니다.
* **리버스 셸 탐지:** 기존 방화벽과 NDR 시스템이 놓치는 리버스 셸 연결 시도(예: `udp/53`, `tcp/443` 비정상 트래픽)를 실시간 행위 분석을 통해 조기 탐지하고 즉각 경고합니다.

### ✅ 심층 로그 상관 분석

* **종합 로그 통합 분석:** 네트워크 로그, 시스템 로그, 애플리케이션 로그를 통합하여 지능형 상관 분석을 수행합니다.
* **공격 그래프 분석:** 공격자의 침투·측면 이동(Lateral Movement)·데이터 유출 등 여러 단계의 로그 데이터를 시간순으로 연결해, 공격 경로와 침해 영향 범위를 정확히 시각화합니다.
* **이상 징후 조기 경보:** 이상 징후를 선제적으로 탐지하여, 사고 발생 전 관리자가 즉시 대응 조치를 취할 수 있도록 조기 경고를 제공합니다.

### ✅ 실시간 대응 자동화

* **대응 자동화:** PLURA-XDR이 공격 패턴과 이상 행위를 탐지하면 자동으로 공격 연결을 차단하거나 격리 조치를 수행하여 추가 피해를 방지합니다.
* **자동 포렌식 리포팅:** 공격 탐지 즉시 공격에 관련된 상세 포렌식 데이터를 자동 생성하여, 관리자가 신속하게 사고 대응과 보고가 가능하도록 지원합니다.

> **결론:** BPFDoor와 같은 스텔스형 APT 공격은 전통적 패턴 탐지로는 대응이 어렵습니다. PLURA-XDR의 고급 탐지 및 대응 기술은 이러한 공격의 초기 침투 단계부터 사후 분석 단계까지 모든 과정에서 확실한 가시성과 대응력을 제공합니다.

---

### 📖 함께 읽기
* [SKT 해킹 악성코드 BPFDoor 분석 및 PLURA-XDR 대응 전략 (탐지 시연 영상 포함)](https://blog.plura.io/ko/respond/bpfdoor/)  
* [SKT 해킹으로 본 NDR 기술 한계: BPFDoor 같은 스텔스 공격 대응법](https://blog.plura.io/ko/column/limitations-ndr-bpfdoor/)  

### 📑 참고 자료
* [Reuters - “SK Telecom shares plunge after data breach due to cyberattack” (2025-04-28)](https://www.reuters.com/sustainability/boards-policy-regulation/sk-telecom-shares-plunge-after-data-breach-due-cyberattack-2025-04-28)  
* [연합뉴스 - “최근 해킹 수법 경고…KISA, SKT 연계 악성코드 정보 공개” (2025-04-25)](https://www.yna.co.kr/view/AKR20250425168300017)  
* [Business Korea - “BPFDoor malware confirmed in SKT hack” (2025-04-29)](https://www.businesskorea.co.kr/news/articleView.html?idxno=241318)  

