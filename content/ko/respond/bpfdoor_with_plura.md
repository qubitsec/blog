---
title: "PLURA를 활용한 BPFDoor 탐지: Audit 로그와 포렌식 기반 대응"
date: 2025-05-20
draft: false
description: "BPFDoor는 은밀하게 리눅스 시스템을 침투하는 백도어입니다. PLURA는 audit 로그와 포렌식 분석을 통해 그 행위를 단계별로 식별하고 탐지합니다."
featured_image: "cdn/respond/bpfdoor_with_plura.png"
tags: ["BPFDoor", "리눅스백도어", "포렌식", "Audit로그", "PLURA", "침해사고대응", "소켓탐지", "시연", "데모", "demo"]
---

## 🔍 PLURA로 BPFDoor 공격 탐지하기

최근 리눅스 기반 시스템을 노리는 고급 위협 중 하나로 BPFDoor가 주목받고 있습니다. BPFDoor는 BPF(Berkeley Packet Filter)를 악용하여 백도어 통신을 가능하게 하는 APT형 리눅스 백도어로, 보안 솔루션 우회를 시도하고 메모리 기반으로 동작하기 때문에 탐지와 대응이 매우 어렵습니다.

하지만 PLURA는 BPFDoor의 주요 행위 기반을 실시간으로 탐지하고 분석할 수 있습니다. PLURA를 통해 BPFDoor를 어떻게 탐지할 수 있는지, 구체적인 탐지 항목과 방법을 소개합니다.

<!--more-->
![bpfdoor_with_plura](https://blog.plura.io/cdn/respond/bpfdoor_with_plura.png)


❗**BPFDoor 공격은 기본적으로 일반 로그에 거의 남지 않습니다.** **이를 추적하기 위해서는 Audit 로그 설정이 필수입니다.**

---

### 1. BPFDoor 파일 삭제 탐지

- 탐지 개요

  - BPFDoor는 실행 후 흔적을 감추기 위해 자신의 실행 파일을 삭제합니다. 이 행위는 메모리 기반 실행(backdoor in memory)을 위한 사전 작업입니다.

- 탐지 로그

![BPFDoor 파일 삭제 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_01.png)

  - 명령어: "`/bin/rm -f /dev/shm/kdmtmpflush`"

  - 분석: 임시 파일 시스템에 위치한 악성 실행 파일이 실행 후 곧바로 삭제됨

  - 보안 의미: 디스크에 흔적을 남기지 않기 위한 자가 삭제 행위로, 메모리 상 백도어 존재 가능성 높음

---

### 2. BPFDoor 파일 권한 변경 탐지

- 탐지 개요

  - BPFDoor는 실행 가능하도록 chmod 명령을 통해 파일에 실행 권한을 부여합니다.

- 탐지 로그

![BPFDoor 파일 권한 변경 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_02.png)

  - 명령어: "`chmod 755 /dev/shm/kdmtmpflush`"

  - 분석: 파일 실행을 위한 권한 변경으로, 공격 준비 단계에 해당

  - 보안 의미: 공격자가 시스템에 업로드한 악성 파일을 실행하기 전 단계

---

### 3. BPFDoor 파일 복제 탐지

- 탐지 개요

  - BPFDoor는 시스템 내에 복제되어 실행되며, 경로 또는 이름을 위장할 수 있습니다.

- 탐지 로그

![BPFDoor 파일 복제 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_03.png)

  - 명령어: "`cp ./bpfdoor /dev/shm/kdmtmpflush`"

  - 분석: 실제 악성 실행 파일이 /dev/shm 경로로 복제됨

  - 보안 의미: 탐지를 피하기 위한 위치 이동 및 이름 변경

---

### 4. BPFDoor 파일 실행 탐지

- 탐지 개요

  - 파일이 실행되면서 실제로 백도어 기능이 활성화됩니다. execve 시스템 호출이 발생하며 실행 파일 경로가 확인됩니다.

- 탐지 로그

![BPFDoor 파일 실행 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_04.png)

  - 실행된 파일: "`/dev/shm/kdmtmpflush`"

  - 분석: 파일이 루트 권한으로 실행됨. `execve` 시스템 호출로 프로세스 생성

  - 보안 의미: 백도어가 실행된 지점, 이후 통신·소켓 생성이 이어짐

---

### 5. BPFDoor 초기화 실행 탐지 (--init 사용)

- 탐지 개요

  - BPFDoor는 --init 플래그를 통해 메모리 기반으로 초기화 실행됩니다. 이는 파일 삭제 후에도 동작을 유지하게 해주는 핵심 기능입니다.

- 탐지 로그

![BPFDoor 초기화 실행 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_05.png)

  - 실행 명령: "`/dev/shm/kdmtmpflush --init`"

  - 분석: 파일 삭제와 동시에 메모리 상 실행 유지를 위한 초기화

  - 보안 의미: 탐지를 회피하고 장기간 은닉 실행을 위한 전략

---

### 6. BPFDoor 소켓 생성 탐지

- 탐지 개요

  - 실행된 BPFDoor는 외부 명령 수신을 위해 socket() 시스템 호출을 사용하여 통신용 소켓을 생성합니다.

- 탐지 로그

![BPFDoor 소켓 생성 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_06.png)

  - 위장 comm 필드: Hex → /sbin/udevd -d

  - 분석: 악성 프로세스가 정상 서비스처럼 위장한 채 소켓 생성

  - 보안 의미: 백도어 통신 시작점, 위장 실행 감지 필요

- 🔥BPFDoor 소켓이 탐지됐을 경우

  - 🔌 포렌식 기반 심층 분석

    - PLURA는 이상 행위가 탐지된 이후, 포렌식 기능을 통해 다음을 심층 분석합니다:

    - 매직바이트 분석: BPFDoor와 연관된 고유 시그니처 검색(21139, 29269, 960051513, 36204, 40783)

      ![포렌식_매직바이트](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_10.png)

    - 환경변수 분석: 은닉된 악성 환경변수 노출 여부 파악

      ![환경변수 분석](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_07.png)
  
    - 의심 세션 및 포트 사용 분석: 비표준 포트 사용(예: 42391~43390, 8000)

      ![의심 세션 및 포트 사용 분석](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_08.png)

---

### 7. iptables 명령어를 통한 방화벽 설정 변경 탐지

- 탐지 개요

  - BPFDoor는 공격자의 트래픽을 정상적으로 수신하기 위해 시스템 방화벽 규칙을 우회하거나 제거합니다.

- 탐지 로그

![iptables 명령어를 통한 방화벽 설정 변경 탐지](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_09.png)

  - 행위: NAT 테이블의 규칙 제거 (nft_unregister_rule)

  - 분석: iptables 명령을 통해 PREROUTING/NAT 규칙 우회

  - 보안 의미: 기존 방화벽 규칙을 제거해 외부 연결을 허용하려는 공격자 의도

---

### 🛡️PLURA EDR 대응 필터

PLURA는 탐지에 그치지 않고, EDR 대응 필터를 통해 BPFDoor 프로세스를 실시간으로 차단하고 강제 종료할 수 있습니다.

- EDR 필터 적용 전

  ![EDR 필터 적용 전](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_11.png)

- EDR 필터 적용 후

  ![EDR 필터 적용 후](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_12.png)

BPFDoor 프로세스가 실행되면, PLURA는 이를 즉시 탐지하고 해당 프로세스를 자동으로 차단 및 종료합니다.
이로 인해 리버스 쉘 연결 시도는 실패하며, 백도어는 정상적으로 작동하지 못합니다.
결과적으로 공격자는 후속 명령이나 통신을 전혀 수행할 수 없게 됩니다.

![BPFDoor 소켓 차단 필터](https://blog.plura.io/cdn/respond/bpfdoor_with_plura_13.png)

---

### ✅ 결론

BPFDoor는 고도로 은밀하고 정교한 리눅스 백도어이지만, PLURA는 다양한 행위 기반 탐지 및 포렌식 분석을 통해 그 위협을 실시간으로 식별하고 대응할 수 있습니다.

리눅스 서버의 보안성을 강화하고, APT 공격에 대비하기 위해 PLURA를 통한 지속적인 모니터링과 탐지가 필요합니다.

### 📺 함께 시청하기
* [BPFDoor, 이렇게 걸린다! | PLURA의 Audit 로그 기반 실시간 탐지 시연](https://youtu.be/Rkz7vNAM0ZY)

### 📖 함께 읽기
* [리눅스에서도 Sysmon을 사용해야 하는 이유!](https://blog.plura.io/ko/respond/linux_sysmon/)
* [PLURA에서 Microsoft Defender Antivirus 로그 확인하기](https://blog.plura.io/ko/respond/plura-microsoft-defender-logs/)
* [Process Hollowing: 공격 기법과 탐지 전략](https://blog.plura.io/ko/respond/process_hollowing/)
* [마이터 어택 관점에서 Emotet (이모텟) 탐지하기](https://blog.plura.io/ko/respond/detecting-emotet-with-mitre-attck/)
* [RANSOMWARE 상관 분석 필터](https://blog.plura.io/ko/respond/ransomeware_correlation_filter/)
