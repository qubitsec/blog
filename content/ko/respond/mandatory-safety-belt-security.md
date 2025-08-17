---

title: "안전벨트를 강제로 채우듯: SELinux·PowerShell CLM을 ‘끄지 못하게’ 만들자"
date: 2025-08-18
draft: false
description: "SELinux와 PowerShell Constrained Language Mode는 ‘중요한데 쉽게 꺼지는’ 보안 안전벨트다. OS 차원의 강제·차단·가시화 설계로 기본 모드 변경 자체를 원천 봉쇄하는 방법과 운영 체크리스트를 제안한다."
featured_image: "cdn/threats/mandatory-safety-belt-security.png"
tags: ["SELinux", "PowerShell", "CLM", "기본값보안", "제로트러스트", "운영체제", "하드닝"]
---
# TL;DR

* **핵심 문제**: SELinux(리눅스)와 PowerShell CLM(윈도우)은 필수 안전장치지만, **config 한 줄**로 꺼지거나 완화된다.
* **핵심 주장**: 안전벨트처럼 **안 채우면 차가 ‘출발하지 못하는’** 구조가 필요하다. 즉, **OS 차원의 강제(immutable) 설계**가 정답이다.
* **해결 전략**: (1) **강제**—끄면 핵심 서비스가 기동되지 않도록, (2) **차단**—꺼짐을 시도하는 행위를 정책으로 불가능하게, (3) **가시화**—예외는 **짧게·기록 남기게·2인 승인**으로만.
* **운영 이득**: LOTL(생활형 공격)과 권한 상승 체인의 **대부분을 초기에 무력화**한다. (MITRE ATT\&CK의 T1059, T1216, T1548 등 완화 효과↑)

---

## 왜 ‘강제’해야 하나?

보안 기본값은 “좋은 출발점”일 뿐, **현실의 운용은 예외와 편의**가 그것을 무력화한다.

1. **호환성과 레거시**
   벤더/레거시 앱은 종종 MAC(강제 접근 제어)이나 CLM을 전제로 설계되지 않았다. “일단 꺼보자”가 관성이다.
2. **지원 부담·책임 회피**
   ISV·SI는 재현/지원 편의로 **완화(permit/permissive) 전환**을 유도한다.
3. **장애 대응의 지름길**
   장애 시 **쉽고 즉각적인 우회**가 ‘보안보다 가용성’의 전형적 선택을 만든다.
4. **정책/역량 격차**
   조직별 성숙도 차이로 **일관된 강제**가 어렵다.
5. **책임 분산**
   “사용자가 껐으니…”라는 구조는 **보안 책임**을 흐린다.

> **교훈**: 안전벨트는 경고음이 아니라 **시동 연동 차단**이 가장 효과적이다. 운영체제 보안도 동일하다—**끄면 못 달리게** 해야 한다.

---

## 보안 설계 원칙 (Seatbelt-Grade Security)

* **Fail-Closed by Default**: 보호 기능이 꺼지면 **핵심 서비스/네트워크가 기동 불가**.
* **Immutable Policy Surface**: 설정 파일과 정책 경로는 **불변(immutable)** 으로 유지.
* **Two-Person, Time-Bound Exception**: 예외는 **2인 승인 + 시간 제한 + 자동 롤백**.
* **Provable State**: 상태 증명(부팅·런타임)과 **중앙 가시화/경고**를 제공.
* **No Silent Degradation**: 완화(permissive/FullLanguage)로의 하향은 **침해 사고와 동일 급**으로 취급·경보.

---

## 구현 전략 개요

### A. Linux: SELinux를 ‘끄면 네트워크가 안 올라오는’ 구조

**목표**: `getenforce != Enforcing` 인 경우, **네트워크/SSH/애플리케이션 타겟 불가**.

1. **부팅 강제**

   * 커널 파라미터: `selinux=1 enforcing=1`
   * 부팅 이미지에 정책 포함(드라큿/dracut) + **Secure Boot**으로 커널/Initrd 무결성 보장.
2. **정책 표면 불변화**

   * `/etc/selinux/config` 등 핵심 경로에 `chattr +i`(Immutable) 적용.
   * 구성 변경은 **오프라인 유지보수 모드**에서만(암호화된 빌드 파이프라인).
3. **systemd 게이트(예시)**

   ```ini
   # /etc/systemd/system/selinux-enforcing-gate.service
   [Unit]
   Description=Gate network until SELinux is Enforcing
   DefaultDependencies=no
   Before=network-pre.target ssh.service
   Wants=network-pre.target
   Conflicts=rescue.service

   [Service]
   Type=oneshot
   ExecStart=/bin/sh -c 'test "$(getenforce)" = "Enforcing"'
   RemainAfterExit=yes

   [Install]
   WantedBy=multi-user.target
   ```

   * **효과**: Enforcing이 아니면 **network-pre**가 멈춰 서비스가 올라오지 않는다.
4. **감사 & 경보**

   * `auditd`로 AVC 거부와 **상태 완화 시도**를 중앙 수집.
   * 예: `ausearch -m avc -ts today`를 기준으로 **탐지 룰** 구성.

### B. Windows: CLM을 ‘정책적으로 해제 불가’로

**목표**: PowerShell이 기본적으로 **ConstrainedLanguage**에서만 동작.
**원칙**: CLM은 **WDAC(Windows Defender Application Control, UMCI)** 로 강제하는 것이 표준적이며, 로컬 설정/스크립트로 **해제 불가**하게 한다.

1. **WDAC(UMCI)로 CLM 강제**

   * 신뢰된 서명(기업 서명·Microsoft)만 **FullLanguage** 허용, 나머지는 **CLM 강제**.
   * 스크립트/매크로/인터프리터는 **허용 목록(allowlist)** 위주.
2. **탬퍼 보호 & 정책 보호**

   * WDAC 정책은 **부팅 신뢰 루트**로 서명/배포, **로컬 관리자도 변경 불가**.
   * 레거시 실행 정책(ExecutionPolicy)만 믿지 말 것—**WDAC/UMCI**가 핵심.
3. **감사 & 경보**

   * **PowerShell Operational(4103/4104)** 에 기록되는 CLM 제한 메시지(예: “not allowed in ConstrainedLanguage”)를 수집/경보.
   * **Code Integrity/WDAC** 이벤트 채널에서 정책 위반·완화 시도 탐지.

> **핵심**: CLM의 신뢰 수준은 **WDAC 배포 품질**에 달린다. “정책을 로컬에서 손댈 수 없다”는 점이 결정적이다.

---

## 예외(변경) 관리는 이렇게: “브레이크 글래스(유리망치) 절차”

* **2인 승인**: 보안 책임자 + 서비스 책임자 **동시 승인**.
* **시간 제한 토큰**: 30\~120분 등 짧은 유효기간, 자동 만료/롤백.
* **최소 권한 스코프**: 특정 호스트·서비스·정책 항목만 일시 완화.
* **풀 감시/기록**: 사유, 승인자, 범위, 기간, 실제 변경 로그를 **변경관리 시스템과 연동**.
* **사후 검토**: 예외 빈도/원인 분석 → 아키텍처/정책 개선.

---

## 실제로 막는 공격면 (ATT\&CK 매핑)

* **Windows LOTL 차단**

  * *T1059.001 PowerShell*, *T1216 Signed Binary Proxy Execution* → **CLM+WDAC**로 함수/리플렉션/COM 접근 제한, 서명/경로 기반 차단.
* **Linux 권한 상승·측면 이동 지연/봉쇄**

  * *T1068 Exploitation for Privilege Escalation* 이후 도메인 격리로 **파일/소켓/프로세스 접근 거부**(AVC).
* **데이터 탈취/웹쉘 행위 제약**

  * 웹서버 RCE 후에도 SELinux 컨텍스트로 **/home, /root, /sshkey, /etc/shadow** 접근 거부.
* **운영 사고의 ‘무음 완화’ 방지**

  * 완화(permissive/FullLanguage) 전환을 **즉시 중대 경보**로 승격.

---

## 운영팀 도입 체크리스트 ✅

**정책·설계**

* [ ] 부팅 시 **SELinux Enforcing** 강제(`selinux=1 enforcing=1`)
* [ ] **WDAC(UMCI)** 기반 CLM 강제 정책 수립 및 서명 배포
* [ ] 정책 파일/경로 **immutable** 및 배포 파이프라인에서만 변경

**게이팅**

* [ ] `getenforce` ≠ Enforcing → **network/ssh/service 타겟 중지**
* [ ] WDAC/CLM 비준수 → **사용자 세션 차단 또는 제한 셸**

**가시성/경보**

* [ ] SELinux 상태 변동, AVC 급증, CLM 위반 문자열(4103/4104) **실시간 경보**
* [ ] WDAC/CodeIntegrity 위반 이벤트 **중앙 수집**

**예외관리**

* [ ] **2인 승인 + 시간 제한 토큰 + 자동 롤백**
* [ ] 예외 사유 카탈로그화(반복 시 설계 개선)

---

## 보안 경고 UX 가이드 (사용자 친화적이되 단호하게)

* **문구**: “**보안 안전벨트(SELinux/CLM)가 해제되어 서비스 기동이 차단**되었습니다.
  (사유·영향·복구 절차 링크·예외 신청 버튼)”
* **행동 유도**: 단순 비활성화 시나리오 대신 **발견→신청→승인→시간 제한 해제→자동 복구** 흐름 고정.
* **교육**: ‘왜 필요한가’를 짧은 카드 뉴스/툴팁으로 안내, **장애시 최초 대응 플레이북** 제공.

---

## 참고 구현 팁

### Linux

* **정책 컴파일/배포**: 커스텀 타입엔포싱 모듈(TE)을 CI에서 빌드·서명·배포.
* **IMA/EVM**: 실행·설정 파일에 **무결성 측정/집행**을 붙여 정책 위변조 감지.
* **SSH 게이트**: `ForceCommand`로 `getenforce` 검사 후 비정상 상태면 **읽기 전용 셸** 제공.

### Windows

* **WDAC 템플릿**: “**서명된 Microsoft/기업 바이너리 허용, 그 외 스크립트는 CLM**” 기본.
* **탐지 규칙**: PowerShell ScriptBlock(4104)에

  * `not allowed in ConstrainedLanguage`
  * `Add-Type`, `Reflection.Assembly::Load` 등 **CLM에서 금지된 패턴** 탐지.
* **ASR/Attack Surface Reduction** 규칙으로 Office/스크립트 악용면 추가 차단.

---

## 흔한 반론과 답변

* **“레거시 앱이 안 돌아간다”**
  → 레거시를 **예외**로 돌리지 말고, **마이그레이션 계획**을 강제하라. 예외는 **시간 제한 + 로드맵** 전제일 때만 허용.
* **“장애 때 빨리 꺼야 한다”**
  → 그래서 **브레이크 글래스**가 있다. 단, **로그/책임/자동 롤백**이 전제.
* **“관리자니까 끌 수 있어야”**
  → 현대 보안은 **사람 권한보다 정책 무결성**이 우선이다(제로 트러스트). 관리자도 **정책 밖 변경은 불가**해야 한다.

---

## 결론

안전벨트가 **경고음**만으로는 생명을 구하지 못하듯, **SELinux와 PowerShell CLM도 경고만으로는 조직을 지키지 못한다.**
우리는 “**끄면 출발 자체가 불가**”한 **Seatbelt-Grade** 보안으로 나아가야 한다.
운영체제가 스스로 **강제·차단·가시화**를 제공하고, 예외는 **짧고 투명**해야 한다.
그때 비로소 “중요한데 쉽게 꺼지는 보안”이라는 모순을 끝낼 수 있다.

---

### 부록: 감사 포인트(간단 체크)

* [ ] 지난 분기 **SELinux 상태 변동 이력 0건**
* [ ] 지난 분기 **CLM 완화(FullLanguage 전환) 0건**
* [ ] WDAC/UMCI 정책 **서명·버전 일관성** 검증
* [ ] 예외 평균 **120분 이하**, 자동 롤백 성공률 **100%**
* [ ] AVC/CLM 위반 이벤트 **실시간 경보의 MTTD < 5분**

> **메시지 하나로 요약하면**: *“안전벨트는 선택이 아니다. 보안도 마찬가지다.”*
