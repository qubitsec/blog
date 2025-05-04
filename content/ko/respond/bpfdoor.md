---
title: "SKT 해킹 악성코드 BPFDoor 분석 및 PLURA-XDR 대응 전략 (탐지 시연 영상 포함)"
date: 2025-05-02
draft: false
description: "2025년 4월 SKT 유심 해킹 사건에 활용된 BPFDoor 악성코드의 작동 원리와 탐지 방법을 실제 시연 영상으로 확인하고, PLURA-XDR의 효과적 대응 전략까지 한 번에 정리합니다."
featured_image: "cdn/respond/bpfdoor.png"
tags: ["SKT 해킹", "BPFDoor", "악성코드 분석", "공격 탐지 영상", "PLURA-XDR", "SKT 유심 유출", "SIM 스와핑", "백도어 탐지", "eBPF", "APT 공격"]
---



> **BPFDoor**는 eBPF 필터·매직 바이트·다중 프로토콜을 이용해 “패킷 흔적이 0”에 가까운 **포트리스(backdoor)** 상태를 구현합니다. 기존 접근 방식으로는 탐지되지 않습니다. 이러한 탐지 우회를 깨뜨리려면 **메모리 실행·AF_PACKET 소켓·iptables 변조** 같은 *행위 시그널*을 교차 분석해야 합니다.  

<!--more-->
![BPFdoor](https://blog.plura.io/cdn/respond/bpfdoor.png)

---

## 1️⃣ BPFDoor 개요

| 항목 | 내용 |
|------|------|
| 최초 공개 | PwC 위협 인텔리전스 보고서(2021) |
| 주요 사용 조직 | 중국발 APT(스피어피싱·통신망 침투) |
| 핵심 기술 | eBPF 필터링 · 매직 바이트 인증 · RC4 암호화 |
| 탐지 난이도 | **매우 높음** – 패턴/포트 기반 IPS · NDR 무력화 |

---

## 2️⃣ 동작 메커니즘 정리

### ① 매직 바이트 & 다중 프로토콜
* **트리거** → `0x7255` (TCP/UDP) · `0x5293` (ICMP) 매직 바이트 수신 시만 활성화  
* **지원 프로토콜** → TCP · UDP · ICMP 모두 수락  
* **허용 포트** → 22/80/443 등 일반 서비스 포트를 재사용 → *포트 스캔 회피*

![BPFdoor01](https://blog.plura.io/cdn/respond/bpfdoor01.png)

### ② RC4 암호화∙패스워드 인증
```c
struct magic_packet {
    unsigned int flag;
    in_addr_t    ip;
    unsigned short port;
    char pass[14];   // "justforfun" 등 하드코딩
};
````

* `pass` 값이 내부 키와 일치해야 세션 수립
* RC4 스트림으로 입·출력을 실시간 암복호화
* SKT 해킹 사고에 사용된 것으로 추측되는 BPFDoor의 패스워드 부분

![BPFdoor02](https://blog.plura.io/cdn/respond/bpfdoor02.png)

### ③ 은폐·지속화 기법

| 기법              | 설명                                                       |
| --------------- | -------------------------------------------------------- |
| **프로세스 위장**     | `/sbin/udevd -d`, `avahi-daemon: chroot helper` 등 정상 데몬명 |
| **메모리 실행**      | `/dev/shm` 으로 복사 후 원본 삭제                                 |
| **iptables 변조** | 공격자 IP 허용 + NAT PREROUTING 리다이렉션                         |
| **PTY 쉘**       | `/dev/ptmx` 연결 → 기록 방지 환경변수 설정                           |

#### 📊 Sequence Diagram — 전체 흐름

```mermaid
sequenceDiagram
    %% Participants
    participant Attacker
    participant HSS
    participant Kernel/eBPF as eBPF
    participant BPFDoor
    participant Host OS as OS

    %% ① 매직 바이트 & 다중 프로토콜
    Attacker->>HSS: 일반 스캔·패킷<br/>(매직 바이트 없음)
    HSS-->>Attacker: (무응답) 포트리스 상태
    Attacker->>HSS: Magic Packet 0x7255 (TCP/UDP, 22/80/443)
    Attacker->>HSS: Magic Packet 0x5293 (ICMP)
    HSS->>eBPF: 패킷 전달
    eBPF-->>BPFDoor: 매직 바이트 일치 → 활성화

    %% ② RC4 암호화·패스워드 인증
    BPFDoor->>BPFDoor: magic_packet 구조체 파싱<br/>pass 필드 검증
    alt 패스워드 일치
        BPFDoor-->>Attacker: 세션 수립 (RC4 암복호화 스트림)
    else 불일치
        BPFDoor-->>Attacker: 무응답·세션 거부
    end

    %% ③ 은폐·지속화 단계
    BPFDoor->>OS: /dev/shm 경로로 자가 복사 → 원본 삭제
    BPFDoor->>OS: 프로세스 이름 위장<br/>("/sbin/udevd -d" 등)
    BPFDoor->>OS: iptables -I INPUT <attacker IP>
    BPFDoor->>OS: iptables -t nat PREROUTING DNAT
    BPFDoor->>OS: open /dev/ptmx → /bin/sh 생성
    Attacker-->>BPFDoor: PTY 쉘 조작 (명령 실행)
```

---

![Sequence Diagram](https://blog.plura.io/cdn/respond/bpfdoor-sequence-diagram.png)

---

## 3️⃣ 왜 탐지가 어려운가?

| 탐지 우회 포인트      | 상세                         |
| -------------- | -------------------------- |
| **패턴 부재**      | 매직 바이트 수신 전까지 패킷·포트·로그 ‘0’ |
| **파일 흔적 최소화**  | 실행 직후 자기 삭제, 메모리만 상주       |
| **정상 프로세스 위장** | SOC 육안·기본 모니터링으로는 구별 난항    |
| **RC4 암호화**    | 시그니처 기반 IDS/정적 분석 무력화      |

---

## 4️⃣ MITRE ATT\&CK 매핑 (Enterprise v17)

| 전술(Tactic)        | 기법 · 서브기법                                          | TID           | 설명                      |
| ----------------- | -------------------------------------------------- | ------------- | ----------------------- |
| Execution         | Command & Scripting Interpreter: Unix Shell        | **T1059.004** | RC4 인증 후 로컬/리버스 셸 실행    |
|                   | Execution Guardrails: Mutual Exclusion             | **T1480.002** | PID 파일로 중복 실행 방지        |
| Defense-Evasion   | Hide Artifacts: Ignore Process Interrupts          | **T1564.011** | 백도어 프로세스에 시그널 무시        |
|                   | Impair Defenses: Impair Command History Logging    | **T1562.003** | `HISTFILE=/dev/null` 설정 |
|                   | Impair Defenses: Disable or Modify System Firewall | **T1562.004** | `iptables` 규칙 조작        |
|                   | Indicator Removal: File Deletion                   | **T1070.004** | 원본 실행 파일 삭제             |
|                   | Indicator Removal: Timestomp                       | **T1070.006** | 실행 파일 타임스탬프 조작          |
|                   | Masquerading: Break Process Trees                  | **T1036.009** | `--init` 플래그로 PPID 끊기   |
|                   | Masquerading: Overwrite Process Arguments          | **T1036.011** | `argv[0]`을 정상 데몬명으로 변경  |
|                   | Obfuscated/Encrypted File or Information           | **T1027**     | RC4 트래픽 난독화             |
| Command & Control | Traffic Signaling: Socket Filters                  | **T1205.002** | eBPF 필터로 매직 바이트 감지      |

> **참조:** MITRE ATT\&CK 소프트웨어 항목 **S1161 (BPFDoor)**

---

## 5️⃣ 실전 PLURA-XDR 탐지: Sysmon for Linux

| Sysmon 이벤트           | 탐지 포인트                         |
| -------------------- | ------------------------------ |
| `ProcessCreate`      | `/dev/shm/*` 경로 실행 · 의심 데몬명    |
| `FileDeleteDetected` | 실행 직후 원본 삭제 이력                 |
| `NetworkConnect`     | PID = 1(daemonized) + 외부 C2 연결 |
| `RawAccessRead`(\*)  | `AF_PACKET` 소켓 생성 시도           |

> *\* `RawAccessRead` 이벤트는 Linux Sysmon 5.8+ 빌드 기준*
> **TIP** : `rule_id=BPFDoor_RawSocket` 같은 커스텀 태그를 달아 PLURA-XDR에 전송하면 후속 상관 분석이 용이합니다.

### 1. 파일이름 위장과 자가 삭제 탐지

![BPFdoor03](https://blog.plura.io/cdn/respond/bpfdoor03.png)

- `/dev/shm/kdmtmpflush` 파일 생성 및 삭제, 권한 부여 등 발생

### 2. 프로세스 초기화 탐지

![BPFdoor04](https://blog.plura.io/cdn/respond/bpfdoor04.png)

- 메모리 기반으로 초기화하기 위한 `—init` 플래그 발생

### 3. iptables 명령어를 통한 방화벽 설정 변경 탐지

![BPFdoor05](https://blog.plura.io/cdn/respond/bpfdoor05.png)

- 백도어로부터 발생한 리버스 쉘 연결을 위한 포트 오픈

### 4. 리버스 쉘 연결 행위 탐지

![BPFdoor06](https://blog.plura.io/cdn/respond/bpfdoor06.png)

- 네트워크 연결을 의미하는 Sysmon의 EventID 3번 로그의 발생, iptables로 열린 포트로 부터 패킷 전송 탐지

### 5. 리버스 쉘 연결 성공 탐지

![BPFdoor07](https://blog.plura.io/cdn/respond/bpfdoor07.png)

- 해당 명령어 및 프로세스가 로그에 발생 시 리버스 쉘 연결이 성공하였다는 것을 의미

---

## 6️⃣ PLURA-XDR 탐지 전략

| 카테고리              | 룰 예시                                              |
| ----------------- | ------------------------------------------------- |
| **메모리 실행**        | 경로 `/dev/shm` · `/tmp` + `ELF` 실행                 |
| **AF\_PACKET 사용** | `socket(PF_PACKET, SOCK_RAW, …)` 호출               |
| **iptables 변조**   | `iptables -I` · `-t nat -A PREROUTING` 행위         |
| **리버스 셸**         | `bash -i`, `nc -e`, `socat TCP4:`, `/bin/sh` 실행 등 |
| **해시·IOC**        | BPFDoor 샘플 SHA-256, C2 도메인 블록                     |

---

## 🔚 결론 & 대응 체크리스트

1. **메모리 경로 실행 감시** – `/dev/shm`, `/tmp` 실시간 모니터링
2. **Raw Socket 룰 적용** – `AF_PACKET` 생성 이벤트 즉시 알림
3. **iptables 변경 알림** – 정책·NAT 테이블 무결성 주기 검사
4. **다계층 상관 분석** – 네트워크·호스트·로그 그래프 연계
5. **주기적 IOC 업데이트** – 샘플 해시·C2 주소 블록

> **BPFDoor는 ‘보이지 않는’ 백도어를 지향합니다.**
> **PLURA-XDR**는 호스트·네트워크·로그 전 계층 관측을 통해 그 *보이지 않는 순간*을 잡아냅니다.

---

### 📺 함께 시청하기
* [BPFDoor 공격, 어떻게 침투하는가? | PLURA 실시간 탐지 시연](https://www.youtube.com/watch?v=bzGv1AwHy9k)

### 📖 함께 읽기
* [SKT 해킹 악성코드 BPFDoor 분석 및 탐지 시연 영상 (PLURA-XDR 대응 전략 포함)](https://blog.plura.io/ko/respond/bpfdoor/)  
* [SKT 유심 해킹 사건 총정리: 유출 원인, 피해 규모, 대응 방법까지](https://blog.plura.io/ko/column/leak_of_skt_usim/)  
* [리눅스에서도 Sysmon을 사용해야 하는 이유!](https://youtu.be/bzGv1AwHy9k)
