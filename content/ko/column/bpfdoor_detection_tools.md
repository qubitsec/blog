---
title: "BPFDoor 악성코드 탐지 도구 비교 분석"
date: 2025-05-19T00:02:00
draft: false
description: "BPFDoor는 은밀하게 리눅스 시스템을 침투하는 백도어입니다. KISA에서 제공한 공식 점검 가이드를 기반으로 각 도구의 탐지 범위를 체크리스트 기준 10개 항목으로 비교하고, 추천 조합을 제안합니다."
featured_image: "cdn/column/bpfdoor_detection_tools.png"
tags: ["BPFDoor", "리눅스백도어", "포렌식", "Audit로그", "PLURA", "침해사고대응", "소켓탐지"]
---

## 🔍 개요

2025년 4월 이후 국내 주요 리눅스 서버 환경을 타깃으로 한 **BPFDoor 백도어 악성코드** 감염 사례가 다수 보고되었습니다.

해당 악성코드는 포트를 열지 않고도 외부 명령을 수신하며, BPF 필터를 통해 **패킷 필터 우회**, **메모리 상주형 리버스 셸**, **위장 프로세스 실행** 등의 고도화된 행위를 수행합니다.

이에 따라 **KISA(한국인터넷진흥원)**, **PLURA-XDR**, **A사, B사** 등 다양한 기관 및 기업에서 대응 도구를 배포하고 있습니다.

본 글에서는 **KISA에서 제공한 공식 점검 가이드**를 기반으로 각 도구의 탐지 범위를 **체크리스트 기준 10개 항목**으로 비교하고, 추천 조합을 제안합니다.

<!--more-->
![bpfdoor_detection_tools](https://blog.plura.io/cdn/column/bpfdoor_detection_tools.png)

---

## 🛠️ BPFDoor 탐지 체크리스트

### 1. 뮤텍스 / 락 파일 확인

`/var/run/` 경로 내 `.pid`, `.lock` 파일 중 **크기 0바이트 & 권한 644**인 파일이 있는지 확인합니다.

```bash
sudo stat -c "%a %s %n" /var/run/*.pid /var/run/*.lock 2>/dev/null | awk '$1=="644" && $2==0 {print $3}'
```

---

### 2. 자동 실행 스크립트 확인

`/etc/sysconfig/` 경로에 `[-f <파일>] && <파일>` 형식의 자동 실행 구문이 삽입되어 있는지 점검합니다.

```bash
sudo grep -Er '\[\s*-f\s+/[^]]+\]\s*&&\s*/' /etc/sysconfig/

```

---

### 3. BPF 필터 존재 여부 확인

BPFDoor는 BPF 필터를 등록해 패킷을 직접 처리합니다. 필터에 **매직 넘버**가 존재하면 감염 가능성이 높습니다.

```bash
sudo ss -0pb | grep -E "21139|29269|960051513|36204|40783"

```

---

### 4. RAW 소켓 사용 프로세스 확인

`SOCK_RAW` 또는 `SOCK_DGRAM` 타입의 소켓을 사용하는 프로세스를 확인합니다.

```bash
sudo lsof 2>/dev/null | grep -E "IP type=SOCK_RAW|IP type=SOCK_DGRAM" | awk '{print $2}' | sort -u | xargs -r ps -fp

```

---

### 5. 환경 변수 이상 여부

BPFDoor는 종종 셸 환경 변수를 조작하여 이력을 남기지 않으려 합니다. 다음과 같은 값이 동시에 설정된 프로세스는 주의가 필요합니다:

- `HOME=/tmp`
- `HISTFILE=/dev/null`
- `MYSQL_HISTFILE=/dev/null`

```bash
sudo tr '\0' '\n' < /proc/[PID]/environ

```

---

### 6. 의심 포트 사용 상태 점검

특정 포트(8000, 42391~43390) 리스닝 여부를 점검합니다. 해당 포트는 BPFDoor의 기본 통신 포트로 사용된 바 있습니다.

```bash
sudo netstat -tulpn | grep -E ":8000|:4239[1-9]|:43[0-3][0-9][0-9]"

```

---

### 7. 위장 프로세스명 존재 여부

BPFDoor는 `abrtd`, `udevd`, `pickup` 등 정상 프로세스로 위장합니다. 실행 중인 프로세스 중 이들 이름을 가진 항목이 실제로 해당 바이너리에서 실행된 것인지 확인이 필요합니다.

```bash
sudo ps -ef | grep -E 'abrtd|udevd|cmathreshd|sgaSolAgent|atd|pickup'

```

---

### 8. 문자열 기반 의심 바이너리 탐지

의심 파일에 다음과 같은 문자열이 포함되어 있는지 `strings` 명령으로 확인합니다.

- `MYSQL_HISTFILE=/dev/null`
- `ttcompat`
- `:f:wiunomc`

```bash
sudo strings -a -n 5 <의심파일> | grep -E 'MYSQL_HISTFILE=/dev/null|ttcompat|:f:wiunomc'

```

---

### 9. SHA256 해시 기반 탐지

BPFDoor 관련 샘플 해시를 기반으로 파일을 탐지할 수 있습니다.

```bash
sudo find / -type f -size +15k -size -4M -exec sha256sum {} 2>/dev/null \; | \
grep -Ei 'c7f693f7f85b01a8c0e561bd369845f40bff423b0743c7aa0f4c323d9133b5d4|\
3f6f108db37d18519f47c5e4182e5e33cc795564f286ae770aa03372133d15c4|\
95fd8a70c4b18a9a669fec6eb82dac0ba6a9236ac42a5ecde270330b66f51595'

```

---

### 10. `/dev/shm`, `/tmp` 경로 내 의심 파일 점검

BPFDoor는 흔히 해당 임시 디렉토리에 자취를 남깁니다. 실행 중이거나 삭제된 상태에서도 메모리에 남아있는 경우가 있어 점검이 중요합니다.

```bash
# 실행 파일 탐지
sudo find /dev/shm /tmp -type f -executable -ls

# 프로세스가 이 경로에서 실행 중인지 확인
ps -eo pid,cmd | while read pid cmd; do ls -l /proc/$pid/exe 2>/dev/null | grep -E "/dev/shm|/tmp" && echo "→ $cmd"; done

# 삭제되었으나 메모리에 존재하는 경우
ls -l /proc/*/exe 2>/dev/null | grep '(deleted)' | grep -E '/dev/shm|/tmp'

```

---

## 🧪 탐지 도구별 항목 충족 비교

| 항목 | 🛡 **KISA** (공식 가이드 스크립트) | **PLURA-XDR** | **B사 탐지 프로그램** | **A사 탐지 프로그램** |
| --- | --- | --- | --- | --- |
| 1. 락파일 확인 | ✅ | ✅ | ❌ | ❌ |
| 2. 자동 실행 확인 | ✅ | ❌ | ❌ | ❌ |
| 3. BPF 필터 감지 | ✅ | ✅ | ❌ | ✅ |
| 4. RAW 소켓 탐지 | ✅ | ✅ | ❌ | ✅ |
| 5. 환경 변수 탐지 | ✅ | ✅ | ❌ | ❌ |
| 6. 의심 포트 확인 | ✅ | ✅ | ❌ | ✅ |
| 7. 위장 프로세스 확인 | ✅ | ✅ | ✅ | ✅ |
| 8. 문자열 기반 탐지 | ✅ | 🟨 | ✅ | ✅  |
| 9. 해시 기반 탐지 | ✅ | ✅ | ✅ | ✅ |
| 10. /dev/shm 실행파일 탐지 | ✅ | ✅ | ✅ | ✅ |

---

## 📊 종합 점수 비교 (10점 만점)

| 도구 | 점수 | 평가 |
| --- | --- | --- |
| **KISA** | 10 / 10 | ✅ 최고 정확도 (공식 가이드 + 스크립트) |
| **PLURA-XDR** | 8.5 / 10 | ✅ 실시간 탐지 및 대응 가능 |
| **B사** | 4 / 10 | ⛔ 자동 실행/환경 변수 탐지 미흡 |
| **A사** | 7/ 10 | ✅ 폭넓은 탐지, 커스터마이징 용이 |

---

## 🔍 상세 평가 요약

### 🛡 KISA

- `bpfdoor_bpf.sh`, `bpfdoor_env.sh` 등 **쉘 기반 점검 스크립트 포함**
- **YARA 룰**, **magic sequence 필터**, **환경 변수**, **삭제된 파일 추적**까지 포함된  가이드 스크립트

### 🔐 PLURA-XDR

- 실시간 행위탐지 기반 XDR 플랫폼
- 메모리 에서 활동하는 이벤트를 audit, Linux for Sysmon을 통해 탐지
- 실시간 로그 분석 및 포렌식 기능을 통한 추가 대응 가능

---

## 도구 실행 시 시스템 부하 비교

### 📈 실시간 실행 중 CPU 점유율 비교 (Ubuntu 22.04 기준)

![실행 시 부하 그래프](https://blog.plura.io/cdn/column/bpfdoor_detection_tools_01.png)

> 📌 *[좌: KISA /중: A사 / 우: B사 실행 시 부하 그래프]*
> 
> 
> **A사 도구**는 분석 시작 직후 수 분간 CPU 점유율이 100%에 근접한 상태로 유지되며, 이는 프로세스 트리 탐색과 파일 해시 계산 등 광범위한 커버리지로 인해 발생하는 **과부하**로 해석됩니다.
> 
> 반면 **B사** 스크립트는 일시적인 피크 이후 빠르게 안정되며, **서버 운영 중 병행 사용이 더 용이**합니다.
> 

| 도구 | 부하율 | 비고 |
| --- | --- | --- |
| 🛡️ **KISA** | **64%로 단기 상승 후 안정화** | 초기 peak 이후 빠르게 하락, 가벼운 운영 적합 |
| 🧰 **A사** | **100% 지속 점유** | 정적 분석 과정에서 높은 리소스 사용 지속 |
| 🧪 **B사** | **17~64% 범위로 단기 상승 후 안정화** | 초기 peak 이후 빠르게 하락, 가벼운 운영 적합 |

<aside>
💡 PLURA 에이전트를 활용하면 낮은 리소스로 실시간 탐지가 가능해 운영 환경에 부담을 최소화할 수 있습니다.
</aside>

---

## 📊 주요 솔루션별 장단점

| 솔루션 | 장점 | 단점 |
| --- | --- | --- |
| **KISA 가이드** | ✅ 공신력 있는 공식 자료 <br> ✅ 다양한 탐지 항목 제공 | ❌ 실시간 탐지 불가 <br> ❌ 수동 점검 필요 |
| **PLURA-XDR** | ✅ 실시간 탐지 및 자동 대응 <br> ✅ eBPF 악용 공격도 탐지 가능 |  |
| **A사** | ✅ 많은 해시 값으로 다양한 파일 탐지 <br> ✅ 악성파일 자동 삭제 가능 | ❌ 탐지 항목 제한 <br> ❌ 변종 탐지 한계 |
| **B사** | ✅ 다양한 탐지 항목 제공 <br> ✅ 포렌식 자료 수집에 유용 | ❌ 전문가의 점검 필요 <br> ❌ 광범위한 탐지로 부하 발생 |

> 🔚 **PLURA-XDR을 설치하면 낮은 리소스로 고도화된 BPFDoor 탐지와 대응을 제공합니다.**

---

## ✅ 결론 및 추천 조합

| 목적 | 추천 도구 조합 |
| --- | --- |
| **초기 보안 점검** | KISA 가이드 스크립트 + I사 |
| **보안 운영 자동화** | PLURA-XDR |
| **포렌식/침해대응** | PLURA-XDR |

---

## 📖 함께 읽기

- [**SKT 유심 해킹 사건 총정리: 유출 원인, 피해 규모, 대응 방법까지**](https://blog.plura.io/ko/column/leak_of_skt_usim/)
- [**SKT 해킹 악성코드 BPFDoor 분석 및 PLURA-XDR 대응 전략 (탐지 시연 영상 포함)**](https://blog.plura.io/ko/respond/bpfdoor/)
- [**SKT 해킹으로 본 NDR 기술 한계: BPFDoor 같은 스텔스 공격 대응법**](https://blog.plura.io/ko/column/limitations-ndr-bpfdoor/)
- [**SIEM, 도입하면 뭐하나요? 로그 수집도 분석도 안 된다**](https://blog.plura.io/ko/column/why_siem_always_fails/)

### 🌟 PLURA-XDR의 서비스

- [PLURA-XDR 소개](https://www.plura.io/platform/xdr)
- [PLURA-DOCS : Credential Stuffing](https://docs.plura.io/ko/fn/comm/sfilter/takeover)
