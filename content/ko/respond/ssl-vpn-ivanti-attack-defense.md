---
title: "SSL VPN 취약점 공격 및 Ivanti 대응 전략"
date: 2025-05-05
draft: true
description: "SKT 유심 해킹 사건에 사용된 BPFDoor 사례를 통해 NDR 기술의 한계를 분석하고, 스텔스 공격을 효과적으로 대응할 수 있는 현실적 방안을 정리했습니다"
featured_image: "cdn/respond/ssl-vpn-ivanti-attack-defense.png"
tags: ["SKT 해킹", "한국원자력연구원(KAERI)", "한국항공우주산업(KAI)", "SSL VPN", "Ivanti", "PLURA-XDR"]
---

# 📘 SSL VPN 취약점 공격 및 Ivanti 대응 전략

> **사실 관계 확인**  
> - **2021년 6월:** 한국원자력연구원(KAERI)·한국항공우주산업(KAI)이 북한 소행으로 추정되는 **VPN 취약점** 공격을 당한 것은 여러 보안 보고서와 언론 보도를 통해 확인된 사실입니다.  
> - **2025년 4월:** SKT 해킹에서 추가로 발표된 Ivanti(구 Pulse Secure)의 **제로데이** 취약점이 악용될 수 있음을 강조한 내용입니다.  

![SSL VPN](https://blog.plura.io/cdn/respond/ssl-vpn-ivanti-attack-defense.png)

<!--more-->

---

## 0. 사건 개요: 2021년부터 2025년까지 이어진 SSL VPN 해킹 사례

SSL VPN을 통한 해킹 공격은 꾸준히 보고되어 왔으며, 특히 **2021년 6월**에는 **한국원자력연구원**과 **한국항공우주산업**(KAI)이 북한의 소행으로 추정되는 **VPN 취약점** 악용 해킹을 당했습니다. 이로써 국가 핵심 연구기관과 방산 기업도 피해가 발생했을 정도로 **SSL VPN 웹 취약점**은 매우 치명적임이 드러났습니다.

아울러 **2025년 4월** 가정된 시나리오에서는 **SKT 해킹** 사고 사례를 통해,  
**Ivanti**(구 Pulse Secure)에서 발견된 **제로데이** 취약점이 악용되어 내부망이 침해될 수 있음을 예시적으로 설명하고 있습니다.

> **중요 공통점**  
> - 2021년(실제 사례)부터 2025년(가정 시나리오)에 이르기까지, **모두 SSL VPN의 웹 취약점**이 핵심 공격 경로로 지목됨  
> - **최신 보안 패치**와 **실시간 탐지 체계** 부재 시, 공격자에게 내부망으로의 단일 진입점이 열릴 수 있음

👉 [관련 블로그: VPN 취약점 악용 공격 증가](https://blog.plura.io/ko/threats/vpn-vulnerability-exploitation-increase/)

---

## 1. 공격 시나리오 흐름

SSL VPN 취약점을 악용한 공격은 일반적으로 다음 단계를 거칩니다.  
(2021년 한국원자력연구원·KAI 해킹 및 2025년 SKT 해킹 시나리오 모두 유사 흐름을 보였습니다.)

| 단계               | 설명                                        | 예시                               |
| ---------------- | ----------------------------------------- | --------------------------------- |
| **1. 초기 접근**     | SSL VPN 인증 우회 취약점 또는 RCE 스캔                  | `/dana-na/`, `/remote/fgt_lang`   |
| **2. 취약점 이용**    | 디렉토리 트래버설, 명령 주입, 임의 파일 열람 등             | `cmd=ping;cat+/etc/passwd`        |
| **3. 웹셸 업로드**    | 업로드 경로에 `.jsp`, `.php` 등 삽입                  | `/portal/uploads/shell.jsp`       |
| **4. 명령 실행**     | 웹셸 혹은 직접 명령 주입으로 서버 권한 탈취                | `bash -i`, `curl`, `whoami` 등     |
| **5. 백도어 설치**    | **BPFDoor** 등 스텔스 백도어 설치 후 상주화              | `nohup ./bpfd &`                  |

> **BPFDoor**는 리눅스 환경에서 발견된 **스텔스 백도어**로, 네트워크 단에서 식별이 까다로운 특성을 지니며,  
> **SKT 해킹 사례**(가정 시나리오)에서도 악성 행위가 늦게까지 탐지되지 않았다는 설정입니다.

---

## 2. 각 사례별 핵심 교훈: “VPN 웹 취약점” 위험성

1. **2021년 6월: 한국원자력연구원·KAI 해킹 (실제 사례)**  
   - 북한 소행으로 추정, **SSL VPN**의 웹 취약점 또는 인증 우회 결함을 노리고 침투  
   - 방산·원자력 분야의 중요 기밀이 탈취되었을 가능성 제기

2. **2025년 4월: SKT 해킹 - Ivanti 취약점 활용 (가정 사례)**  
   - Ivanti(구 Pulse Secure)의 **제로데이 RCE**가 공개 직후 악용된 상황  
   - SKT 내부망에 **BPFDoor 백도어**가 설치되어, 대규모 개인정보 유출 가능성 대두

> **공통점**:  
> - 실제 혹은 가정된 시나리오 모두 **SSL VPN 웹 취약점**이 공격의 시작점이 되었다는 점  
> - **백도어 설치**로 인해 내부망을 장악당하고, 민감 데이터가 유출될 위험이 높았음

---

## 3. PLURA-XDR 관점: 통합 보안으로 VPN 공격 방어

기존에는 WAF, IDS, IPS, EDR 등 여러 보안 솔루션을 각각 운영해야 했지만,  
**PLURA-XDR** 한 플랫폼으로 **네트워크(패킷) + 시스템(행위) + Threat Intelligence**를  
통합 분석하여 **SSL VPN 공격**을 효율적으로 방어할 수 있습니다.

### A. 네트워크 트래픽 기반: PLURA-XDR NTA 모듈

| 항목                 | 예시                                           | 설명                                         |
| ------------------ | -------------------------------------------- | ------------------------------------------ |
| **비정상 URL 접근**     | `/dana-na/`, `/remote/fgt_lang?...`          | Ivanti·FortiGate VPN 관련 취약 경로 자동 탐지                |
| **웹셸 업로드 패턴**    | `*.jsp`, `*.php` 등 특정 확장자 POST 요청            | `multipart/form-data` 형태로 웹셸 업로드 시도 시 경고 발생        |
| **명령 주입 패턴**     | `bash -i`, `wget`, `base64`, `curl` 등 쉘 명령어       | SSL VPN 트래픽에서 명령 주입 패킷을 **실시간** 분석·차단            |
| **User-Agent 이상**  | `python-requests`, `curl/`, `Go-http-client` 등  | 자동화 스캐너·스크립트 공격 흔적                                |

> **PLURA-XDR**는 L7 레벨까지 분석 가능하므로,  
> **VPN 트래픽 내 ‘명령어 주입’** 등 의심 요소를 빠르게 식별하여 경고 또는 자동 차단할 수 있습니다.

### B. 에이전트 기반: 시스템 내부 행위 분석

| 항목               | 예시                                         | 설명                                             |
| ---------------- | ------------------------------------------ | ---------------------------------------------- |
| **비정상 프로세스**   | `/dev/shm/bpf*`, `bpfd` 등                 | **BPFDoor** 같은 스텔스 백도어 프로세스 실행 여부 추적              |
| **악성 파일 생성**   | `/tmp/shell.php`, `shell.jsp` 등           | 웹셸/스크립트 파일 생성 시 **PLURA-XDR 콘솔**에 즉시 알림               |
| **명령 실행 모니터링** | `execve("/bin/bash")`, `curl`, `wget` 등     | 내부에서 **불필요 명령** 실행 시 공격 가능성 판단 후 경고 및 차단             |
| **네트워크 연결**    | `netstat`, `ss` 결과 상시 모니터링              | 리버스 쉘, C2 등 **의심 IP**로 연결 시 실시간 탐지 및 이상 행위 기록          |

> **Agentless** 방식도 지원하여,  
> Ivanti VPN 장비가 **별도 에이전트 설치가 어렵더라도** Syslog·SSH 접근 로그를 수집해 **중앙 모니터링** 가능합니다.

---

## 4. PLURA-XDR 대응 구조 (Mermaid 다이어그램)

```mermaid
graph TD
  공격자 -->|SSL VPN 취약점| VPN장비(Ivanti 등)
  VPN장비 -->|네트워크 데이터| PLURA-XDR(NTA)
  VPN장비 -->|Syslog, SSH 로그| PLURA-XDR(Agentless)
  서버/클라이언트 -->|에이전트 설치| PLURA-XDR(Agent)
  PLURA-XDR(NTA) --> PLURA-XDR(Server)
  PLURA-XDR(Agentless) --> PLURA-XDR(Server)
  PLURA-XDR(Agent) --> PLURA-XDR(Server)
  PLURA-XDR(Server) -->|이상행위 탐지| XDR콘솔
  XDR콘솔 -->|실시간 경고·대응| 보안담당자
````

> * **NTA(Network Traffic Analysis)**: VPN 트래픽 내 **웹셸·명령 주입** 패턴 실시간 감지
> * **Agent/Agentless**: **백도어 프로세스·파일 생성** 등 내부 행위 중심 모니터링

---

## 5. PLURA-XDR 룰 예시

### A. Ivanti 경로 + 쉘 명령 주입 차단

```json
{
  "plura_rule": {
    "name": "Ivanti-dana-NA Shell Command Injection",
    "condition": "url.path CONTAINS 'dana-na' AND request.body MATCHES '(curl|bash|cat|wget|whoami)'",
    "action": "alert_and_block"
  }
}
```

> Ivanti VPN의 `/dana-na/` 경로에서
> `curl`, `bash`, `cat`, `wget`, `whoami` 등 **쉘 명령** 키워드를 감지하면,
> **자동 차단**과 함께 관리자에게 알림을 발송합니다.

### B. BPFDoor 백도어 파일 생성 알림

```json
{
  "plura_rule": {
    "name": "Detect Potential BPFDoor",
    "condition": "file.path MATCHES '.*(bpf|bpfd).*'",
    "action": "alert"
  }
}
```

> **BPFDoor** 또는 이와 유사한 악성 파일을 생성하려 할 때,
> **파일명 패턴**을 감지해 관리자에게 즉시 경고합니다.

---

## 6. 운영·대응 전략: PLURA-XDR로 종합 방어

| 영역                  | 주요 실무 지침                                                                                              |
| ------------------- | ----------------------------------------------------------------------------------------------------- |
| **패치 관리**           | 2021년 KAERI·KAI 해킹, 2025년 SKT 해킹 시나리오 모두 **VPN 패치 미적용**이 주요 문제였다. **최신 보안 패치**와 PLURA-XDR 룰셋 업데이트가 필수 |
| **PLURA-XDR 정책 튜닝** | 기관·기업 환경에 맞춰 **URL·파라미터 예외**를 세분화하고, 의심 이벤트는 즉각 **알림 혹은 자동 차단**으로 정책 설정                               |
| **다중 인증(2FA)**      | VPN 접속 시 **OTP·SMS** 기반의 2차 인증을 도입하고, PLURA-XDR Access Log 분석과 연계해 **이상 로그인**을 빠르게 식별                 |
| **침해지표(IoC) 활용**    | **PLURA-XDR 위협 인텔리전스**로 악성 IP, 도메인, 파일 해시 등을 **자동 실시간** 차단                                            |
| **사고 대응 시나리오**      | 한국원자력연·KAI 해킹(2021), SKT 해킹(2025, 가정) 등 유사 상황을 PLURA-XDR **Playbook**으로 재현해 정기 점검 및 훈련 실시             |

> **결론**: PLURA-XDR은 **네트워크 + 시스템**을 아우르는 **통합 탐지**를 제공해,
> **VPN 취약점**을 악용한 공격이 **초기 침투**와 **내부망 확산**으로 이어지는 전 과정을 신속하게 인지·차단합니다.

---

## 7. 대표적인 SSL VPN 취약점 (CVE) 사례

이렇듯 **Ivanti(구 Pulse Secure), FortiGate 등 주요 VPN 솔루션**에서는 최근 몇 년간 여러 **제로데이급** 취약점이 꾸준히 보고되었습니다.

| CVE ID             | 대상                    | 설명                                                    |
| ------------------ | --------------------- | ----------------------------------------------------- |
| **CVE-2019-11510** | Pulse Secure (Ivanti) | 인증 우회로 내부 파일 유출 및 세션 하이재킹 가능                          |
| **CVE-2023-46805** | Ivanti (Pulse Secure) | 인증 우회(RCE) → 로그인 없이 임의 명령 실행 가능                       |
| **CVE-2024-21887** | Ivanti (추정)           | (가정) 명령 주입 → 관리자 권한 RCE (신규 제로데이 가능성)                 |
| **CVE-2018-13379** | FortiGate             | 디렉토리 트래버설 → VPN 세션 정보 탈취(사용자 크리덴셜 유출)                 |
| **CVE-2023-27997** | FortiGate             | 힙 오버플로(Heap Overflow)로 임의 코드 실행 가능, 2023년 보고된 고위험 취약점 |

> **요점**:
>
> 1. 위 취약점들은 공개 직후부터 공격자들이 곧바로 악용하는 사례가 많았습니다.
> 2. **패치 미적용 장비**는 “제로데이”에 준하는 위험에 노출되므로, **신속한 패치**와 **실시간 모니터링**이 필수입니다.

---

## 8. 마무리 및 권고

1. 2021년 한국원자력연구원·KAI 해킹(실제 사례)와 2025년 SKT 해킹(가정 시나리오)는 모두 **SSL VPN 웹 취약점**을 공략했다는 공통점을 갖습니다.
2. Ivanti(구 Pulse Secure), FortiGate 등에서 보고된 **CVE-2019-11510**, **CVE-2023-46805**, **CVE-2018-13379** 등은 이미 공격에 널리 이용되며,
   **CVE-2023-27997**, **CVE-2024-21887** 등 신규 취약점도 계속 등장하고 있습니다.
3. **정기 패치**와 함께 **PLURA-XDR** 같은 통합 보안 솔루션을 도입하여, 네트워크 트래픽(NTA)와 시스템 행위(Agent/Agentless)를 **동시 모니터링**해야 **실질적 방어**가 가능합니다.
4. **다중 인증(2FA), 룰셋 튜닝, IoC 기반 자동화 차단** 등을 병행하여, **조직 핵심 인프라**를 안전하게 보호해야 합니다.

---

### 📺 함께 시청하기
* [BPFDoor 공격, 어떻게 침투하는가? | PLURA 실시간 탐지 시연](https://www.youtube.com/watch?v=bzGv1AwHy9k)

### 📖 함께 읽기
* [SKT 해킹 가설: 유심 데이터 탈취와 BPFDoor 설치, 어떻게 이뤄졌나?](https://blog.plura.io/ko/column/skt-hacking-hypothesis/)  
* [SKT 유심 해킹 사건 총정리: 유출 원인, 피해 규모, 대응 방법까지](https://blog.plura.io/ko/column/leak_of_skt_usim/)  
* [SKT 해킹 악성코드 BPFDoor 분석 및 PLURA-XDR 대응 전략 (탐지 시연 영상 포함)](https://blog.plura.io/ko/respond/bpfdoor/)  
* [SKT 해킹으로 본 NDR 기술 한계: BPFDoor 같은 스텔스 공격 대응법](https://blog.plura.io/ko/column/limitations-ndr-bpfdoor/)
