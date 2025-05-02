---
title: "SKT 유심 정보 유출 사건 정리: 무엇이 문제였고, 어떻게 대응해야 할까?"
date: 2025-05-02T00:00:01
draft: false
description: "BPFDoor 백도어 실전 분석을 통한 동작 방식 이해 및 PLURA에서의 탐지"
featured_image: "cdn/respond/bpfdoor.png"
tags: ["BPFDoor", "usim", "해커", "hacking", "skt telecom", "PLURA-XDR"]
---

# 🛡️ BPFDoor 백도어 실전 분석: 매직 바이트, 방화벽 우회, 그리고 Sysmon for Linux를 이용한 탐지

## 📌 들어가며

2021년 PwC(PricewaterhouseCoopers) 위협 인텔리전스 보고서를 통해 처음 공개된 **BPFDoor**는 주로 **중국 기반의 해킹 그룹이 사이버 스파이 활동에 사용하는 고급 백도어**입니다. 이 백도어는 eBPF(Extended Berkeley Packet Filter)를 활용해 리눅스 커널을 직접 수정하지 않고도 시스템을 은밀하게 제어할 수 있으며, 다양한 탐지 우회 기법을 갖추고 있어 고도화된 지속 위협(APT, Advanced Persistent Threat)에 속합니다.

<!--more-->

![BPFdoor](https://blog.plura.io/cdn/respond/bpfdoor.png)

---

## 🔗 1. 매직 바이트 기반 접속 방식과 통신 트리거

BPFDoor는 거의 공통된 구조의 클라이언트를 통해 백도어에 접속을 시도하며, 트래픽 분석을 회피하기 위해 **매직 바이트(Magic Bytes)** 기반의 인증 방식을 사용합니다.

### 주요 특징:

- **사전 정의된 매직 바이트**가 수신되기 전에는 포트가 열려 있지 않은 것처럼 행동하여 포트 스캔 및 방화벽 탐지에 반응하지 않음
- 매직 바이트가 수신되면 백도어는 활성화되어 연결 세션을 수립
- 이 과정에서 **하드코딩된 패스워드**로 인증이 진행되며, 비인가 접근은 무시

### 다중 프로토콜 지원

BPFDoor는 **TCP, UDP, ICMP 등 다양한 네트워크 프로토콜**을 지원합니다. 이는 **단순 포트 또는 특정 프로토콜만을 기준으로 한 탐지를 무력화**시킵니다.

또한, BPFDoor는 통신 포트로 **SSH(22), HTTP(80), HTTPS(443)**와 같은 **일반적으로 허용된 포트들을 사용**하기 때문에 **포트 기반 필터링만으로는 탐지가 어렵습니다**.

---

## 2. 매직 바이트 기반 트리거 및 다중 프로토콜 수신

백도어는 `socket(PF_PACKET, SOCK_RAW, htons(ETH_P_IP))` 으로 생성된 **raw socket**에 **BPF 필터**를 적용해 특정 바이트열을 포함한 패킷만 처리합니다.

이때 사용되는 필터는 매직 바이트로 알려진 `0x7255` (TCP/UDP), `0x5293` (ICMP 등)를 감지합니다.

### 수신 가능한 프로토콜

- **TCP** (`IPPROTO_TCP`)
- **UDP** (`IPPROTO_UDP`)
- **ICMP** (`IPPROTO_ICMP`)

### 패킷 구조

- 헤더 뒤에는 `struct magic_packet`이 위치
    
    ```c
    struct magic_packet {
        unsigned int flag;
        in_addr_t ip;
        unsigned short port;
        char pass[14];
    };
    ```
    

이러한 트리거 방식은 포트 기반 방화벽이나 IDS 탐지를 우회할 수 있으며, 인증 실패 시 아무 동작도 수행하지 않기 때문에 무작위 스캔에 반응하지 않습니다.

---

## 3. RC4 기반 암호화 통신

매직 패킷에 포함된 비밀번호(`pass`)는 **RC4 키**로 사용되며, 모든 입출력은 다음과 같이 암복호화 됩니다:

```c
rc4_init(mp->pass, strlen(mp->pass), &crypt_ctx);
rc4(tmp, count, &crypt_ctx); // 송신
rc4(buf, count, &decrypt_ctx); // 수

```

이는 분석 방해 및 IDS 회피에 유리하며, 일반적인 문자열 분석 기반 탐지에도 걸리지 않습니다.

---

## 4. 프로세스 이름 위장과 자가 삭제

공격자는 백도어 프로세스가 사용자의 의심을 피하도록 `argv[0]`과 커널 프로세스 이름(`prctl(PR_SET_NAME, ...)`)을 다음과 같이 위장합니다:

```c
char *self[] = {
    "/sbin/udevd -d", "/usr/sbin/console-kit-daemon", ...
};
strcpy(argv0, self[rand()%10]);
```

또한, 실행 후 자기 복제를 수행하고 원래 파일은 `/dev/shm/` 경로로 복사된 뒤 삭제되며, PID 파일(`/var/run/haldrund.pid`)로 중복 실행 여부를 감지합니다.

이는 Sysmon for Linux에서 `ProcessCreate`, `FileDeleteDetected`, `ProcessName` 로그로 추적이 가능합니다.

---

## 5. iptables 리다이렉션과 프록시 터널

`getshell()` 함수는 다음을 수행합니다:

- `iptables -I INPUT`으로 공격자의 IP를 허용
- `iptables -t nat -A PREROUTING`으로 공격 포트를 로컬 포트로 리다이렉션
- 수신된 포트를 `accept()`한 뒤, `fork()`로 `/bin/sh`를 실행

이는 방화벽을 뚫고 reverse shell 대신 **직접적인 로컬 port forwarding**으로 연결되는 구조로, 외부 포트와 내부 프로세스 간의 연동이 가능합니다.

---

## 6. 쉘 인터페이스 및 PTY 연결

공격자는 **psuedo-terminal** (`/dev/ptmx`, `ptsname()`)을 사용하여 실제 터미널처럼 쉘 세션을 생성합니다. 이 과정은 매우 은밀하게 이루어지며, 다음과 같은 명령어로 최종적으로 쉘이 실행됩니다:

```c
execve("/bin/sh", argv, envp);
```

환경 변수에는 `HISTFILE=/dev/null`, `PS1`, `PATH`, `MYSQL_HISTFILE` 등 **기록 방지 및 환경 위장용 설정**이 포함되어 있습니다.

![bpfdoor01](https://github.com/user-attachments/assets/eec8dff5-7ca4-434f-b37f-a140de85944e)

- attacker 서버에서 controller를 작동하여 victim 서버의 쉘 획득

---

## 🔒 BPFDoor가 탐지되기 어려운 구조적 이유

- 외부에서 특정 매직 바이트가 수신되기 전까지 아무런 활동을 하지 않아, 일반적인 행위 기반 탐지에 걸리지 않음
- 실행 후 자기 복제를 통해 디스크 상 흔적을 지우고, 메모리 상에서만 동작하여 파일 기반 탐지가 어려움
- 프로세스 이름과 경로를 정상 시스템 데몬처럼 위장해 관리자가 육안으로 식별하기 어려움
- 의심을 피할 수 있는 이름으로 프로세스를 생성하기 때문에, 시스템 운영자가 정상 프로세스로 오인할 가능성이 높음
    
    ![bpfdoor02](https://github.com/user-attachments/assets/89398f2a-e2a3-4bcd-bed9-6e3e4e9c4e6b)

    (/usr/sbin/smart으로 의심되지 않은 프로세스 이름 사용)
    
    → 사용된 위장 이름 예시:
    
    ```
    /sbin/udevd -d
    /sbin/mingetty /dev/tty7
    /usr/sbin/console-kit-daemon --no-daemon
    hald-addon-acpi: listening on acpi kernel interface /proc/acpi/event
    dbus-daemon --system
    hald-runner
    pickup -l -t fifo -u
    avahi-daemon: chroot helper
    /sbin/auditd -n
    /usr/lib/systemd/systemd-journald
    ```
    

![bpfdoor03](https://github.com/user-attachments/assets/56da76ce-f1ab-441b-8849-d942687ce4aa)


- `avahi-daemon: chroot helper` 위장 프로세스가 생성되어 작동 중임을 확인

---

## 🔐 패스워드 기반 접근 제한: 백도어임에도 쉽게 열리지 않는 이유

BPFDoor는 공개된 백도어 코드임에도 불구하고, 실제 공격 흐름을 재현하거나 통신을 성립시키는 것이 간단하지 않습니다. 그 이유는 다음과 같이 **패스워드 인증 기반의 접근 제한 구조**를 가지고 있기 때문입니다.

### ✅ 실행 조건에 대한 제약

- BPFDoor는 단순히 실행만으로 활성화되지 않습니다. 외부에서 전송되는 패킷에 **올바른 매직 바이트**가 포함되어야 하며, 이와 함께 **패스워드가 포함된 구조체(`magic_packet`)**가 전달되어야 합니다.
- 패스워드가 일치하지 않으면 어떠한 연결도 수립되지 않으며, **포트 오픈, 응답, 로그 출력 등의 반응이 전혀 발생하지 않습니다.** 이로 인해 무작위 연결 시도는 모두 실패하게 됩니다.

### 🔐 인증 원리: 구조체 기반의 사전 검증

BPFDoor는 매직 패킷을 수신했을 때 내부적으로 아래와 같은 구조체 데이터를 파싱합니다.

```c
struct magic_packet {
    unsigned int flag;
    in_addr_t ip;
    unsigned short port;
    char pass[14];
```

- 이 `pass` 필드에는 사전에 백도어 내부에 **하드코딩된 비밀번호**가 존재하며, 이는 `logon()` 함수에서 비교됩니다.
- 코드 상으로는 다음과 같이 두 개의 문자열이 비교됩니다:
    
    ```c
    char hash[]  = "justforfun";
    char hash2[] = "socket";
    ```
    
- 공격자는 이 중 하나라도 정확히 일치하는 문자열을 보내야만 백도어가 세션을 열고 쉘을 제공합니다.
    
    ![bpfdoor04](https://github.com/user-attachments/assets/d09b5512-2b2d-4df0-be6f-9160b852ab21)

    (→SKT 해킹 사고에 사용된 것으로 추측되는 BPFDoor의 패스워드 부분)
    

### 🚫 무작위 접근 불가

- 이 구조로 인해 **단순 포트 접근, 패킷 전송만으로는 실행 결과를 확인할 수 없습니다.**
- 실제 작동을 관찰하거나 분석하려면 패스워드까지 정확히 알고 있어야 하며, 그렇지 않으면 **완전히 무응답 상태로 보입니다.**

### 🔒 공격자 맞춤형 커스터마이징도 가능

- 코드 상에서는 `cfg.pass`와 `cfg.pass2` 값이 수정 가능하므로, 공격자가 백도어를 사용할 때 **자신만 아는 비밀번호를 설정하여 오용 가능성을 차단**할 수도 있습니다.

---

## 5️⃣ 탐지 방법

### 🔍 Sysmon for Linux

### 1. 파일이름 위장과 자가 삭제 탐지

![bpfdoor05](https://github.com/user-attachments/assets/f5184cc2-2ddd-4393-b545-ff82ab1750b5)

- `/dev/shm/kdmtmpflush` 파일 생성 및 삭제, 권한 부여 등 발생

### 2. 프로세스 초기화 탐지

![bpfdoor06](https://github.com/user-attachments/assets/48ad5a5b-35a5-4be8-8f49-1dbe97828ea3)

- 메모리 기반으로 초기화하기 위한 `—init` 플래그 발생

### 3. iptables 명령어를 통한 방화벽 설정 변경 탐지

![bpfdoor07](https://github.com/user-attachments/assets/5712b77f-51ce-4506-8995-87a2d59cdc6a)

- 백도어로부터 발생한 리버스 쉘 연결을 위한 포트 오픈

### 4. 리버스 쉘 연결 행위 탐지

![bpfdoor08](https://github.com/user-attachments/assets/f39a37cf-e75b-4efb-bb47-648ca6a879b3)

- 네트워크 연결을 의미하는 Sysmon의 EventID 3번 로그의 발생, iptables로 열린 포트로 부터 패킷 전송 탐지

### 🛡️ PLURA-XDR 탐지 전략

| 탐지 항목 | 조건 |
| --- | --- |
| 메모리 내 실행 감지 | `/dev/shm`, `/tmp` 등에서 실행된 프로세스 |
| 비정상 소켓 사용 | `AF_PACKET` 소켓 생성 시도 탐지 |
| 리버스셸 | `bash -i`, `nc`, `socat`, `/bin/sh` 실행 |
| 포트리스닝 없음 + Net 연결 | PPID = 1 + 네트워크 연결 존재 |
| 실행 시 해시 탐지 | Hash-based 탐지 및 Threat Intel 연계 |

---

## 결론 및 대응 방안

BPFdoor는 **기존 EDR·SIEM만으로 탐지하기 어려운** 고도화된 백도어입니다. 시스템 커널 수준에서 패킷을 감시하고, 흔적 없이 리버스쉘을 수립하기 때문에 다음과 같은 **탐지 전략이 병행**되어야 합니다.

### ✅ 대응 전략 요약

- 메모리 실행 및 `/dev/shm`, `/tmp` 모니터링 필수
- `AF_PACKET` 및 raw socket 생성 행위 탐지
- 리버스 쉘 트리거 패턴 기반 룰 생성
- XDR 기반 이벤트 상관 분석 적용
- IOC 기반의 정기 스캐닝 및 해시 차단

> PLURA-XDR은 /dev/shm 실행, 소켓 생성, 숨겨진 프로세스 탐지 등 행위 기반 탐지 체계를 갖추고 있으며, 리눅스 기반 시스템에서도 실시간 침해 지표 감지 및 대응이 가능합니다.

---

### 📖 함께 읽기
* [리눅스에서도 Sysmon을 사용해야 하는 이유!](https://blog.plura.io/ko/respond/linux_sysmon/)
