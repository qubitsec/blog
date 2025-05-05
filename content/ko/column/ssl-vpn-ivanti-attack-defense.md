---
title: "SSL VPN 취약점 공격 및 Ivanti 대응 전략"
date: 2025-05-05
draft: false
description: "SKT 유심 해킹 사건에 사용된 BPFDoor 사례를 통해 NDR 기술의 한계를 분석하고, 스텔스 공격을 효과적으로 대응할 수 있는 현실적 방안을 정리했습니다"
featured_image: "cdn/column/limitations-ndr-bpfdoor.png"
tags: ["SKT 해킹", "BPFDoor", "NDR 한계", "스텔스 공격", "네트워크 보안", "IDS", "IPS", "Symbiote", "LummaC2", "PLURA-XDR"]
---

# 📘 SSL VPN 취약점 공격 및 Ivanti 대응 전략

## 0. 사건 개요: 2021년부터 2025년까지 이어진 SSL VPN 해킹 사례

SSL VPN을 통한 해킹 공격은 꾸준히 보고되어 왔으며, 특히 **2021년 6월**에는 **한국원자력연구원**과 **KAI(한국항공우주산업)**가 북한의 소행으로 추정되는 **VPN 취약점** 악용 해킹을 당했습니다. 이로써 국가 핵심 연구기관과 방산 기업도 피해가 발생했을 정도로 **SSL VPN 웹 취약점**은 매우 치명적입니다.

그 뒤 **2023년 5월 법원 해킹 사건**에서 다시 한 번 **VPN 인증 우회** 취약점이 도마 위에 올랐고,  
**2025년 4월**에는 **SKT 해킹** 사고에서 **Ivanti(구 Pulse Secure)**의 **제로데이** 취약점이 악용되어 내부망이 침해되었다고 알려져 있습니다.

> **중요 공통점**  
> - 2021년부터 2025년에 이르기까지, **모두 SSL VPN의 웹 취약점**을 통한 공격이었음  
> - 최신 보안 패치를 적용하지 않거나, **실시간 탐지 체계**가 부재할 경우 공격자에게 쉽게 문을 열어줄 수 있음

[관련 블로그 글 바로 가기](https://blog.plura.io/ko/threats/vpn-vulnerability-exploitation-increase/)

---

## 1. 공격 시나리오 흐름

SSL VPN 취약점을 악용한 공격은 일반적으로 다음과 같은 단계를 밟습니다.  
(2021년 한국원자력연구원·KAI 사건, 2023년 법원 해킹, 2025년 SKT 해킹 모두 유사 흐름을 보였습니다.)

| 단계               | 설명                                      | 예시                              |
| ---------------- | --------------------------------------- | -------------------------------- |
| **1. 초기 접근**     | SSL VPN 인증 우회 취약점 또는 RCE 스캔                | `/dana-na/`, `/remote/fgt_lang`  |
| **2. 취약점 이용**    | 디렉토리 트래버설, 명령 주입, 임의 파일 열람 등           | `cmd=ping;cat+/etc/passwd`       |
| **3. 웹셸 업로드**    | 업로드 경로에 `.jsp`, `.php` 등 삽입                | `/portal/uploads/shell.jsp`      |
| **4. 명령 실행**     | 웹셸 혹은 직접 명령 주입으로 서버 권한 탈취              | `bash -i`, `curl`, `whoami` 등    |
| **5. 백도어 설치**    | **BPFDoor** 등 스텔스 백도어 설치 후 상주화            | `nohup ./bpfd &`                 |

> **BPFDoor**는 **SKT 해킹 사건**에서도 발견된 **스텔스 백도어**로, 네트워크 단에서 식별하기 까다로운 악성 행위가 특징입니다.

---

## 2. 각 사례별 핵심 교훈: “VPN 웹 취약점” 위험성

1. **2021년 6월: 한국원자력연구원·KAI 해킹**  
   - 북한 소행으로 추정, **SSL VPN**의 웹 취약점 또는 인증 우회 결함을 노리고 침투  
   - 방산·원자력 분야의 중요 기밀이 탈취되었을 가능성 제기

2. **2023년 5월: 법원 해킹 사건**  
   - 내부 행정망에 접근 가능해져, 민감한 판결 자료·개인정보 등이 노출 우려  
   - 침입 경로가 **VPN 취약점**으로 파악되어 대대적인 취약점 점검 실시

3. **2025년 4월: SKT 해킹 - Ivanti 취약점 활용**  
   - Ivanti(구 Pulse Secure)의 **제로데이 RCE** 악용  
   - SKT 내부 망에 악성 백도어(BPFDoor) 설치, 대규모 개인정보 유출 우려

> **공통점**: 모두 **SSL VPN 웹 취약점**을 이용한 공격이며, **백도어 설치** 후 내부망을 장악했다는 점이 같습니다.

---

## 3. PLURA-XDR 관점: 통합 보안으로 VPN 공격 방어

기존에는 WAF, IDS, IPS, EDR 등 다양한 솔루션을 각각 운영해야 했지만,  
**PLURA-XDR** 한 플랫폼으로 **네트워크(패킷) + 시스템(행위) + Threat Intelligence**를  
통합 분석하여 **SSL VPN 공격**을 효율적으로 방어할 수 있습니다.

### A. 네트워크 트래픽 기반: PLURA-XDR NTA 모듈

| 항목                 | 예시                                           | 설명                                         |
| ------------------ | -------------------------------------------- | ------------------------------------------ |
| **비정상 URL 접근**     | `/dana-na/`, `/remote/fgt_lang?...`          | Ivanti·FortiGate VPN 관련 취약 경로 자동 탐지                |
| **웹셸 업로드 패턴**    | `*.jsp`, `*.php` 등 특정 확장자 POST 요청            | `multipart/form-data` 형태로 웹셸 업로드 시도 시 경고 발생        |
| **명령 주입 패턴**     | `bash -i`, `wget`, `base64`, `curl` 등 쉘 명령어       | SSL VPN 트래픽에서 명령 주입 패킷 실시간 분석·차단                   |
| **User-Agent 이상**  | `python-requests`, `curl/`, `Go-http-client` 등  | 자동화 스캐너·스크립트 공격 흔적                                |

> **PLURA-XDR**는 L7 레벨까지 분석 가능하므로, **VPN 트래픽 내 ‘명령어 주입’** 등 의심 요소를 빠르게 찾아낼 수 있습니다.

### B. 에이전트 기반: 시스템 내부 행위 분석

| 항목               | 예시                                         | 설명                                             |
| ---------------- | ------------------------------------------ | ---------------------------------------------- |
| **비정상 프로세스**   | `/dev/shm/bpf*`, `bpfd` 등                 | **BPFDoor** 같은 스텔스 백도어 프로세스 식별                   |
| **악성 파일 생성**   | `/tmp/shell.php`, `shell.jsp` 등           | 웹셸/스크립트 파일이 생성되면 즉시 PLURA-XDR 콘솔로 알림              |
| **명령 실행 모니터링** | `execve("/bin/bash")`, `curl`, `wget` 등     | 내부에서 불필요한 명령 실행 시, 공격 가능성 판단 후 경고 및 차단             |
| **네트워크 연결**    | `netstat`, `ss` 결과 상시 모니터링              | 리버스 쉘, C2 등 **의심 IP**로의 연결 발생 시 실시간 탐지/이상 행위 기록 |

> **Agentless** 방식도 지원하여, Ivanti VPN 장비가 별도 에이전트를 설치하기 어려운 환경이라도  
> **Syslog, SSH 접근 로그** 수집으로 **중앙 모니터링**이 가능합니다.

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

---

## 6. 운영·대응 전략: PLURA-XDR로 종합 방어

| 영역                  | 주요 실무 지침                                                                     |
| ------------------- | ---------------------------------------------------------------------------- |
| **패치 관리**           | 2021·2023·2025 공격 사례 모두 **VPN 패치 미적용** 상태였음. 최신 보안 패치 및 PLURA-XDR 룰셋 업데이트 필수 |
| **PLURA-XDR 정책 튜닝** | 기관·기업 환경에 맞춰 **URL·파라미터 예외**를 세분화하고, 의심 이벤트는 즉각 알림 또는 자동 차단                  |
| **다중 인증(2FA)**      | VPN 접속에 **OTP·SMS** 기반 2차 인증을 적용, PLURA-XDR에서 Access Log 분석 연계               |
| **침해지표(IoC) 활용**    | **PLURA-XDR 위협 인텔리전스**로 악성 IP, 도메인, 파일 해시 등을 **자동 실시간** 차단                   |
| **사고 대응 시나리오**      | **한국원자력연·KAI 해킹, 법원 해킹, SKT 해킹** 유사 상황을 PLURA-XDR **Playbook**으로 사전 점검·훈련 실행 |

> **결론**: PLURA-XDR은 네트워크와 시스템 행위를 동시 모니터링하여,
> **VPN 취약점**을 통한 공격이 **초기 침투**와 **내부 확산**으로 이어지는 전 과정을 신속하게 탐지·대응합니다.

---

## 7. 마무리 및 권고

1. **2021년 한국원자력연구원·KAI 해킹**, **2023년 법원 해킹**, **2025년 SKT 해킹**은 모두 **SSL VPN 웹 취약점**이라는 공통된 공격 경로를 사용했습니다.
2. Ivanti(구 Pulse Secure), FortiGate 등 **주요 VPN 솔루션**에서 **제로데이 취약점**이 계속 나오고 있으므로, **정기 패치**와 함께 **실시간 공격 탐지** 체계가 필수입니다.
3. **PLURA-XDR**를 도입하면, \*\*네트워크 트래픽(NTA)\*\*와 \*\*시스템 행위(Agent/Agentless)\*\*를 **원스톱**으로 분석하여, **웹셸 업로드·백도어 설치** 같은 실제 침해 행위를 조기에 차단할 수 있습니다.
4. **패치 + 다중 인증 + XDR 기반 모니터링**을 결합해, **조직의 핵심 인프라**를 안전하게 보호해야 합니다.

---

> **문의 / 추가정보**
>
> * PLURA-XDR 공식 사이트: [https://www.plura.io/](https://www.plura.io/)
> * 기술지원: [plura@qubitsec.com](mailto:plura@qubitsec.com)
> * 자료 요청: PDF / HTML / Markdown 버전 가능

