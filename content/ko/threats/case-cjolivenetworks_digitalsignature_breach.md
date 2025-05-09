---
title: "CJ올리브네트웍스 인증서 유출 사건 분석 및 후속 대응 방안"
date: 2025-05-07
draft: true
description: "CJ올리브네트웍스 디지털 인증서 유출 사건의 영향과 북한 해킹 그룹의 공격 전략 분석 및 긴급 대응 방안을 정리했습니다."
featured\_image: "cdn/threats/case-cjolivenetworks_digitalsignature_breach.png"
tags: ["CJ올리브네트웍스", "인증서 탈취", "김수키", "북한 해킹", "APT", "디지털 서명 위협", "보안 사고 대응"]
---

# CJ올리브네트웍스 디지털 인증서 유출 사건 분석 (2025년 5월)

## 사건 요약 및 공격 개요

2025년 5월 초, CJ그룹 IT 서비스 계열사 **CJ올리브네트웍스**의 소프트웨어 서명용 **디지털 인증서가 유출**되어 북한 연계 해커들에게 악용된 정황이 확인되었다. 지난 4월 말 발견된 북한발 악성 파일에 CJ올리브네트웍스의 **디지털 서명**이 포함되어 있었으며, 이를 통해 **해당 인증서가 공격자에게 탈취**당해 악성코드 서명에 사용되었을 가능성이 제기되었다. 보안업계는 북한 정찰총국 산하 APT 그룹인 \*\*‘김수키(Kimsuky)’\*\*를 배후로 지목하고 있는데, 실제로 중국 보안기업 레드드립팀(RedDrip)은 SNS를 통해 김수키 조직이 탈취한 CJ올리브네트웍스 인증서를 활용해 **국책 연구기관인 한국기계연구원(KIMM)을 공격**하려 한 정황을 공개했다. CJ올리브네트웍스 측은 5월 6일 밤 내부 해킹 징후를 인지한 즉시 한국인터넷진흥원(KISA)에 신고하고, 다음 날 오전 문제의 인증서를 \*\*즉시 폐기(폐지)\*\*하여 더 이상 사용할 수 없도록 조치했다고 밝혔다. 회사 측 설명에 따르면 해당 인증서는 **소프트웨어 개발·배포용 코드서명 인증서**로서, 현재까지 **고객 개인정보 유출 등의 2차 피해는 확인되지 않았다**. 이번 사건은 앞서 발생한 SK텔레콤 USIM 해킹 사고에 이어 국내 대기업 대상 사이버 공격이 연쇄적으로 드러난 사례로, 대기업 전반에 **공급망 보안 및 신뢰 기반 인증 시스템**에 대한 위협 경보를 울리고 있다.

## 디지털 인증서 탈취 수법 및 유사 사례

공격자들은 정상 소프트웨어로 신뢰받는 **코드서명 인증서**를 탈취함으로써, 훔친 인증서로 악성코드에 서명하여 보안 검증을 회피하는 수법을 사용한다. 코드서명된 파일은 운영체제 및 보안 프로그램에 의해 출처가 확인되고 위변조되지 않은 것으로 인식되므로, **탈취된 인증서로 서명된 악성코드**는 사용자와 보안 시스템을 속이기 쉽다. 공격자는 이러한 인증서를 얻기 위해 **스피어피싱, 웹 서버 취약점 악용 등으로 기업 내부망에 침투**한 뒤 중요한 인증서 파일을 찾는 것으로 추정된다. 예를 들어 2013년 보안기업 Bit9 해킹 사례에서는, **인터넷에 노출된 웹 서버의 SQL 인젝션 취약점**을 통해 공격자가 내부 코드서명 서버에 접근한 뒤 인증서 키를 탈취하고 이를 이용해 악성코드를 서명한 바 있다. 이처럼 침해된 코드서명 개인키를 확보한 공격자는 시스템을 수색하여 `.p12` `.pfx` 등의 **인증서 키 파일**을 찾아내거나 덤프해낼 수 있으며, 경우에 따라 인증서 보호 비밀번호를 알아내기 위해 **키로깅 등 추가 기법**을 동원하기도 한다.

국내외에서는 **인증서 탈취를 통한 공격 사례**가 다수 보고되어 왔다. **Stuxnet** 공격(2010년경)에서는 **Realtek Semiconductor** 등의 **정상 코드서명 인증서가 탈취되어 악성 드라이버 서명**에 사용되었고, 이로써 산업제어 시스템 공격에 신뢰도가 부여되었다. 중국계 APT인 **Winnti/APT41** 그룹은 2010년대부터 지속적으로 소프트웨어 기업을 해킹해 **코드서명 인증서**를 빼돌리고 이를 다른 공격에 활용해왔으며, 실제 2012년에는 한국 게임회사 \*\*엠게임(Mgame)\*\*의 코드서명 인증서를 탈취해 게임업계 경쟁사를 대상으로 공격에 사용하기도 했다. 2018년 **플리드(PLEAD)** 공격キャン페ーン에서는 **대만 D-Link社의 코드서명 인증서**가 유출되어 동일 인증서로 서명된 악성코드가 발견되었고, D-Link는 즉시 해당 인증서를 폐기한 바 있다. 북한 또한 과거 여러 차례 이와 유사한 수법을 사용했는데, **2020년 김수키 그룹**이 남측 공공기관 직원의 인증서 정보를 이용해 악성 이메일을 발송하려 한 정황이 보고되었으며, 2024년 초에는 \*\*국내 보안업체 SGA솔루션즈의 자회사 인증서(D2innovation)\*\*를 탈취해 **Troll Stealer**라는 정보탈취 악성코드를 서명·유포한 사례가 있었다. 이처럼 **공격자에게 탈취당한 인증서**는 신뢰도 우회와 **공급망 공격**에 악용될 수 있는 만큼, 코드서명 인증서 자체가 중요한 공격 표적이 되고 있다.

## 공격자 침투 및 악성코드 배포 시나리오 (가설 기반)

&#x20;*가설적 공격 흐름도: 공격자가 CJ올리브네트웍스 인증서를 탈취하여 최종 표적을 공격하기까지의 단계를 나타낸 그림.* 공격자는 먼저 표적 기업 및 관련 협력사들을 사전에 정밀 조사하여 침투 경로를 모색한다. 이후 사회공학 기법 등을 활용해 초기 침입에 성공하면, 내부에서 권한을 확대하며 인증서 키와 같은 중요 자산을 탈취한다. 확보한 인증서로 악성코드에 서명하여 신뢰를 가장한 뒤 최종 목표 대상에게 배포하고 실행시킴으로써 추가 침투에 나선다. 아래는 이번 사건에 대한 가능한 **공격 단계별 시나리오**를 정리한 것이다:

1. **초기 침투** – 공격자는 CJ올리브네트웍스 또는 그 협력업체 직원을 노린 **스피어피싱 이메일** 등으로 초기 접근을 시도했을 것으로 보인다. 실제 김수키 조직은 **한글 문서 아이콘으로 위장한 LNK 파일** 등을 첨부한 표적 공격형 이메일을 과거부터 활용해왔으며, 이러한 수법으로 대상자의 PC에 **원격 액세스 악성코드**를 심었을 가능성이 있다. 웹 서버 등의 공개된 시스템 취약점을 통한 **원격 침입**도 배제할 수 없다. 초기 단계에서 공격자는 일반 직원 계정 하나를 탈취하거나 멀웨어 설치에 성공함으로써 기업 내부망에 발을 디딘다.

2. **내부 정찰 및 인증서 접근** – 내부 침투 후 공격자는 CJ올리브네트웍스의 **개발/빌드 서버**나 **코드서명 관리 시스템**을 탐색하며 높은 권한을 획득하는 데 주력한다. 관리자 권한을 확보한 공격자는 시스템 내에 저장된 **코드서명 인증서의 개인 키 파일**을 찾았을 것으로 추정된다. 일반적으로 코드서명 인증서는 개발자 PC나 빌드 서버에 **PFX/P12 형태**로 저장되며, 공격자는 이를 찾기 위해 파일시스템을 검색하거나 레지스트리 등을 뒤졌을 수 있다. 만약 키가 암호로 보호되어 있었다면 **키로거 설치** 등을 통해 입력되는 패스프레이즈를 탈취하거나, 암호를 크래킹하여 \*\*인증서 개인키를 외부로 유출(Exfiltration)\*\*했을 것으로 보인다.

3. **악성 실행파일 제작 및 서명** – 공격자가 획득한 인증서 키로 **악성코드에 디지털 서명**을 함으로써, 겉보기에는 CJ올리브네트웍스에서 배포한 정상 프로그램처럼 위장한 \*\*악성 실행파일(dropper)\*\*을 만들었다. 이 드로퍼(dropper)는 내부에 실제 공격 페이로드(예: 백도어 DLL)를 포함하거나, 실행 시 외부에서 추가 악성코드를 내려받는 역할을 한다. 중요한 점은 이 실행파일의 서명이 CJ올리브네트웍스 명의로 되어 있으므로, **Windows 보안 경고나 백신의 무결성 검사**를 통과하여 사용자에게 신뢰된 소프트웨어로 인식된다는 것이다. 실제로 이번에 발견된 악성 드로퍼는 “CJ Olivenetworks Co., Ltd.” 명의의 서명을 가지고 있었고, 실행 시 **`C:\Users\Public\config.dat`** 경로에 악성 DLL을 떨어뜨린 정황이 있었다고 한다 (레드드립팀 공개 정보).

4. **악성코드 배포 및 침투 확산** – 공격자는 이렇게 준비된 **서명된 악성코드**를 실제 표적에게 전달함으로써 2차 침투를 시도했다. 이때 **신뢰 관계를 이용한 공급망 공격** 기법을 활용했을 것으로 추정되는데, 즉 CJ올리브네트웍스와 연관된 \*\*협력사인 ‘플랜아이’\*\*를 경유지로 삼아 최종 목표인 한국기계연구원(KIMM)에 접근했을 가능성이 제기된다. 가령 공격자가 플랜아이 직원에게 CJ올리브네트웍스에서 보낸 것처럼 보이는 **서명된 실행파일**(업데이트 파일 등을 가장)이나 이메일을 보내면, 이를 **CJ올리브네트웍스의 정규 배포파일로 신뢰한 플랜아이 직원**이 실행하게 되고 시스템이 감염된다. 공격자는 감염된 플랜아이 시스템을 **거점으로 삼아 KIMM 연구원들을 상대로 추가 공격**을 전개하거나, 플랜아이와 KIMM 간의 **네트워크 연결 및 신뢰**를 이용해 KIMM 내부망으로 침투를 확대했을 것으로 보인다. 이러한 **멀티홉 침투 전략**은 중간 단계에 있는 협력업체를 악용하여 최종 표적에 다가가는 전형적인 APT 수법이다.

5. **악성코드 실행 및 내부 활동** – 최종 표적 환경(KIMM 등)에 서명된 악성코드가 전달되면, 피해 조직 내 사용자나 시스템은 해당 파일을 **의심 없이 실행**했을 수 있다. 실행된 드로퍼는 내부에 포함된 페이로드를 설치하거나 추가 악성 파일을 내려받아 \*\*실행(Execution)\*\*한다. 김수키가 과거 사용했던 **PebbleDash 백도어** 또는 **맞춤형 원격제어 도구**가 이 단계에서 설치되었을 가능성이 있다. 공격자는 윈도우 **시작 프로그램 등록, 레지스트리 자동실행 키 설정** 등으로 \*\*지속성(Persistence)\*\*을 확보하고, **권한 상승**을 통해 시스템 제어권을 강화했을 수 있다. 또한 **PowerShell 기반 키로거**를 실행해 키보드 입력을 수집함으로써 추가 계정 비밀번호나 중요한 입력 정보를 탈취하고, 내부망에서 **추가 횡적 이동**을 준비했을 것으로 추정된다.

6. **횡적 이동 및 목표 달성** – 공격자는 초기 침투한 시스템 외에 \*\*내부망의 다른 시스템으로 이동(Lateral Movement)\*\*하여 공격 범위를 넓혔다. 예를 들어 김수키 조직은 이번 공격에서 **RDP Wrapper**를 활용한 **원격 데스크톱 접속 백도어**를 설치한 것으로 알려져 있는데, 이를 통해 내부망에서 **지속적으로 접근 가능한 거점**을 마련하고 추가 공격 대상 시스템에 접속했을 가능성이 높다. 횡적 이동을 거쳐 최종적으로 연구원들의 PC나 서버 등 **목표 시스템에 접근**한 공격자는, 그들의 본목적인 **정보 탈취 및 정찰** 행위를 수행했을 것으로 보인다. 이메일 계정 탈취, 연구 자료 수집, 시스템 내 민감정보 검색 등의 과정을 거쳐 빼낸 데이터를 \*\*외부 C2 서버로 유출(Exfiltration)\*\*하거나, 향후 활용을 위해 내부에 **백도어를 잠복**시켰을 수 있다. 결국 공격자는 탈취한 인증서를 **신뢰 기반 위협 요소**로 활용하여 여러 단계의 침투 과정을 은밀하게 진행, 최종 표적에 대한 사이버 스파이 활동을 수행했을 것으로 추정된다.

## MITRE ATT\&CK 전술·기법 매핑

이번 사건 및 가설 시나리오를 **MITRE ATT\&CK 프레임워크** 관점에서 살펴보면, 공격자는 여러 단계에서 다양한 전술·기법을 활용한 것으로 보인다. 주요 전술/기술을 매핑하면 다음과 같다:

* **초기 침투 – Spearphishing Attachment (T1566.001)**: 김수키 그룹은 표적에게 **악성 LNK 파일**이 포함된 스피어피싱 이메일을 보내 **초기 접근권을 획득**한 것으로 보인다. 이러한 **스피어피싱 첨부파일** 수법은 대상이 악성 첨부를 실행하도록 유도하여 원격 제어 악성코드를 심는 **Initial Access** 기법이다.

* **자격 증명 탈취 – Unsecured Private Keys (T1552.004)**: 내부 침투 후 \*\*인증서 키 파일(.p12/.pfx 등)\*\*을 시스템에서 검색하여 탈취한 행위는 **안전하지 않은 자격증명: 개인 키 획득** 기법에 해당한다. 공격자는 취약하게 보관된 인증서 키를 찾아내거나 추출함으로써 **코드서명 인증서의 비밀키**를 손에 넣었다. 일부 개인 키는 암호로 보호되므로, 공격자는 이를 풀기 위해 **키로깅 등 입력 가로채기** 기법(T1056.001)을 동원해 암호를 알아냈을 가능성도 있다.

* **방어 회피 – Code Signing (T1553.002)**: 탈취한 인증서로 악성코드에 **디지털 서명**을 한 것은 **신뢰 기반을 교란**하여 보안 탐지를 우회하는 대표적인 **Defense Evasion** 기술이다. 정상 소프트웨어처럼 서명된 악성 실행파일은 운영체제와 일부 보안제품의 신뢰 정책을 통과할 수 있기 때문에, 공격자는 **도용한 코드서명 인증서**를 통해 악성코드의 정체를 숨겼다. 이 기법으로 공격자는 \*\*소프트웨어 신뢰 체계(Subvert Trust Controls)\*\*를 악용하였다.

* **실행 & 지속성 – Remote Services: RDP (T1021.001)**: 김수키는 내부 침투 후 **원격접속 뒷문** 설치를 위해 **RDP Wrapper**와 같은 도구를 활용했는데, 이는 \*\*원격 데스크톱 프로토콜(RDP)\*\*을 이용한 **원격 서비스 후속 활동**에 해당한다. 해당 기법을 통해 공격자는 **지속적인 백도어 세션**을 확보하고 내부망에서 **횡적 이동** 및 추가 정찰을 수행할 수 있었다. RDP를 비롯한 원격 서비스 남용은 **Lateral Movement**와 **Persistence** 전술 모두에 활용된다.

* **수집 – Keylogging (T1056.001)**: 공격자는 **PowerShell 기반 키로거**를 구동시켜 피해 시스템의 키입력을 몰래 기록했는데, 이를 통해 사용자의 로그인 정보나 (만약 존재하면) 인증서 키 보호 암호 등 **중요한 입력 데이터**를 탈취했을 가능성이 있다. 키로깅은 **Credential Access** 및 **Collection** 단계에서 유용하게 쓰이는 기술로, 공격자는 수집한 키입력 데이터를 바탕으로 추가 권한 획득이나 정보 탈취를 진행했을 것이다.

* **명령 및 제어 – HTTP 통신 (T1071)**: 최종적으로 설치된 악성코드는 **외부 C2 서버와 통신**하며 명령을 수신하거나 탈취 데이터를 전송했을 것으로 보인다. 공개된 IOC에 따르면 해당 악성코드는 `login.php` 페이지를 경유해 특정 IP로 접속을 시도했는데, 이는 **HTTP 프로토콜**을 이용한 C2 통신 기법으로 추정된다. 이러한 **애플리케이션 레이어 프로토콜** 이용은 일반 웹 트래픽에 은폐되어 탐지를 어렵게 만드는 **Command and Control** 전술의 일부다.

이외에도 공격 진행 과정에서 **권한 상승(Privilege Escalation)**, **자산 발견(System Discovery)**, **데이터 압축(Archive Collected Data)** 등의 ATT\&CK 기술들이 부가적으로 사용됐을 가능성이 있다. 전체적으로 볼 때 본 사건은 **초기 침입**부터 **신뢰도 악용을 통한 은밀한 침투**, 그리고 **원격 제어 및 정보 탈취**에 이르는 복합적인 APT 공격 기법들의 연계를 보여준다.

## 보안 대응 전략 및 사전 탐지 포인트

CJ올리브네트웍스 인증서 유출 사고에 대응하여, 기업들은 **공격 전후 단계에 걸친 다층적인 보안 대책**을 재점검할 필요가 있다. 우선 **유출된 인증서에 대한 긴급 조치**로서, CJ올리브네트웍스가 취한 것처럼 해당 인증서를 \*\*즉시 폐기(revocation)\*\*하고 관련 인증서로 서명된 기존 파일의 신뢰를 차단해야 한다. 인증서 폐기가 이루어지면 Windows 운영체제나 브라우저 등은 더 이상 해당 인증서를 신뢰하지 않으므로, 공격자가 동일 인증서를 활용해 추가로 공격을 전개하는 것을 어렵게 만든다. 아울러 이번 사건 관련 IoC(지표들) – 예컨대 **악성 파일 해시나 C2 도메인 정보** – 를 KISA 등과 공유하여 보안업계 전반에 전파함으로써, 유사 공격 시도를 **사전 탐지**할 수 있도록 하는 것도 중요하다. 실제 레드드립팀이 공개한 해시값과 C2 주소 등의 정보는 향후 해당 **악성코드 변종 탐지**에 활용될 수 있으므로, 이를 토대로 한 **위협 헌팅**과 모니터링을 수행해야 한다.

**사전 예방 측면**에서는 무엇보다 **코드서명 인증서 및 키 관리 보안**을 한층 강화해야 한다. 기업은 자체 서명용 인증서를 \*\*HSM(하드웨어 보안 모듈)\*\*이나 물리적으로 분리된 안전한 저장소에 보관하고, 인증서 접근에 다단계 인증 및 엄격한 권한 통제를 적용해야 한다. 또한 **정기적인 키 교체 및 폐기 계획**을 수립하고, 사용하지 않는 오래된 인증서는 폐기하여 악용 가능성을 줄여야 한다. 코드서명 작업이 이루어지는 빌드/배포 환경에 대해서는 **네트워크 분리**와 **필수 포트 제한** 등을 통해 외부 침입 통로를 최소화하고, 해당 서버에 대한 **포렌식 로깅/모니터링**을 강화함으로써 비정상적 접근이나 서명 시도를 실시간 탐지하도록 한다. 예를 들어 **서명 서버에서 평소와 다른 IP나 계정이 인증서에 접근**하거나 **이상 시간대에 서명 작업**이 발생하면 경고를 발생시키는 규칙을 마련할 수 있다.

**탐지 및 대응 측면**에서는 **엔드포인트 보안**과 **네트워크 보안** 레이어에서 모두 이번 사건과 유사한 공격 징후를 포착할 수 있는 전략이 필요하다. 엔드포인트 단에서는 다음과 같은 **탐지 포인트**를 고려할 수 있다:

* **이상 실행파일 탐지**: 일반 사용자 PC에서 **평소 사용되지 않던 인증서로 서명된 실행파일**이 갑자기 등장하거나 실행되는 경우 경고를 준다. 예컨대 CJ올리브네트웍스 인증서로 서명된 파일이 내부망에서 발견된다면, 설령 그 인증서가 유효하더라도 이를 의심 이벤트로 간주해야 한다. 실제 ESET 연구진은 D-Link 인증서로 서명되었지만 행위가 수상한 파일들을 포착해 악성코드 유포 사실을 밝혀낸 바 있으며, 이처럼 **행위 기반 분석과 서명 무결성 검증**을 병행하는 보안 기능이 요구된다.

* **행위 기반 탐지**: 코드서명 여부와 무관하게 **수상한 프로세스 행위**를 모니터링한다. 예를 들면, 사용자 환경에서 **mshta.exe나 PowerShell이 이메일 첨부 실행 직후 구동되어 스크립트를 실행**하거나, **정상 프로세스(예: explorer.exe)가 자식 프로세스로 이상 프로세스를 실행**하는 행위 등은 스피어피싱 공격의 전형적인 징후일 수 있다. 또, **새롭게 생성된 `C:\Users\Public\` 경로의 DLL/데이터 파일**이나 **운영체제 시스템 디렉토리에 자기 복제하는 실행파일** 등은 공격 진행을 나타내는 단서가 될 수 있다.

* **원격접속 도구 탐지**: 김수키 조직의 TTP에 비추어 보면, **RDP Wrapper 설치**나 **정상 프로세스에 내부에서 몰래 원격 접속을 수신 대기**하는 행위, 그리고 **이상 접속 계정 생성** 등을 탐지 포인트로 삼을 수 있다. 예를 들어 일반 사용 PC에서 갑자기 RDP 서비스가 활성화되거나 방화벽 규칙이 변경되는 것은 의심스러운 징후다. Endpoint EDR 솔루션 등으로 이러한 **행위 이상 징후에 대한 규칙**을 설정해 두면 공격자의 내부 거점 확보 시도를 조기에 발견할 수 있다.

네트워크 보안 측면에서는 **C2 통신 및 데이터 유출 시그니처**를 탐지하는 것이 중요하다. 김수키를 비롯한 APT 공격에 공통적으로 나타나는 **비정상 트래픽 패턴** – 예컨대 평소 접속하지 않던 해외 IP나 도메인과의 통신, `login.php` 등의 페이지 요청, TLS가 아닌 평문 프로토콜로 장기간 지속되는 통신 등 – 을 식별하여 차단해야 한다. 또한 **DNS 요청 모니터링**을 통해 알려진 악성 도메인에 대한 질의가 발생하는지 살피고, **SSL/TLS 트래픽 가시성**을 확보하여 악성 페이로드가 암호화 통신으로 빠져나가는 것을 탐지/차단하도록 한다.

만일 침해가 의심될 경우를 대비해 **Incident Response 체계**를 갖추고 로그를 신속히 수집/분석하는 것도 대응 전략의 일환이다. 이번 사건의 경우 CJ올리브네트웍스는 KISA와 협조하여 내부 침해 조사 및 추가 대응 조치를 진행 중인데, 평시에 이런 **사이버 위기 대응 프로세스**를 마련해 두는 것이 피해 확산을 막고 원인을 규명하는 데 필수적이다.

## 기술적 시사점 및 통합 보안 플랫폼 대응 방안

CJ올리브네트웍스 인증서 유출 사건은 \*\*공급망 보안(supply chain security)\*\*과 **신뢰 기반 인증 체계의 취약점**을 다시 한 번 드러낸 사례다. 기업의 개발/배포 인프라가 뚫려 **인증서와 같은 신뢰의 근간이 탈취**될 경우, 공격자는 이를 지렛대로 삼아 **기존 보안 솔루션을 우회**하고도 침투를 감행할 수 있다. 특히 **정상 소프트웨어로 가장한 악성코드**는 겉보기에 합법적인 서명이 있으므로 사용자와 보안 담당자의 의심을 피하기 쉽고, 이로 인해 **“신뢰할 수 있는 것”에 대한 맹신**이 위험함을 보여준다. 앞으로도 코드서명 인증서를 노린 공격은 계속 발생할 가능성이 높다. 이에 대한 **기술적 시사점**은 다음과 같다.

첫째, **코드서명만으로 소프트웨어 무결성을 보장할 수 없는 시대**가 되었으므로, **행위 기반 탐지 및 평판 기반 검증**을 결합한 **다계층 보안**이 요구된다. 예를 들어 EDR/XDR과 같은 솔루션은 파일의 서명 여부와 무관하게 행위 패턴을 분석하여 이상 징후를 탐지할 수 있어야 한다. 이미 **악성코드가 합법 인증서로 서명되어도 여전히 탐지 가능**함을 입증한 연구들이 있으며, 실제 이번 사건에서도 결국 행위 이상을 통해 악성파일이 식별되었다. 엔드포인트 보안 솔루션은 파일 서명을 신뢰하더라도 그 파일의 \*\*동적 행위(예: 프로세스 호출, 메모리 변조, 네트워크 접속)\*\*에 지속적인 감시를 놓음으로써, 서명된 악성코드가 활동을 시작하는 순간 차단할 수 있어야 한다.

둘째, **통합 위협 인텔리전스 활용**이 중요하다. 이번 사례에서 레드드립팀이 SNS로 공개한 IoC와 정보들은 공격 흐름 파악과 대응 조치에 큰 도움이 되었는데, 이러한 **위협 인텔리전스 정보**를 신속히 수집하고 자사 보안 시스템에 적용하는 체계를 마련해야 한다. 예를 들어 **통합 보안 플랫폼**이나 SIEM에 글로벌 위협 인텔리전스 피드를 연계하여 \*\*탈취된 인증서 지문(해시)\*\*이나 **악성 C2 인프라 정보**를 실시간으로 모니터링하면, 유사 사건 발생 시 조기에 경보를 받을 수 있다. 또한 기업 내부의 **로그/이벤트를 중앙집중적으로 수집/분석**하는 플랫폼을 통해 이메일 보안, 엔드포인트, 네트워크 장비 등의 탐지 정보를 상호 연관 지으면, 단일 벡터로는 탐지하지 못한 **공격의 전체 흐름**을 파악할 수 있다. 예컨대 이메일 게이트웨이에서 탐지된 피싱 시도를 EDR의 실행파일 로그와 대조하고, 이어 방화벽의 트래픽 로그와 결합하여 보면 **공격 타임라인과 경로**를 훨씬 선명하게 그려낼 수 있다.

셋째, **공급망 보안 관리**를 강화해야 한다. 대기업의 보안 수준이 높아지면서 공격자들은 그 **약한 고리로 협력사나 외주 업체를 노리는 경향**이 강해지고 있다. 이에 대응하려면 본사 뿐 아니라 협력업체에 대한 **보안 요구사항**을 높이고, **주요 협력사와의 네트워크 연결에 대한 제어**를 강화해야 한다. 예를 들어 협력사 시스템에서 본사로 접속할 수 있는 경로를 최소화하고, 불가피한 경우 **제로 트러스트 접근 통제**를 적용하여 협력사라도 인증된 단말/계정만 제한적으로 접근하게 한다. 또한 협력사 측 보안 사고가 발생했을 때 신속히 공유받을 수 있는 **공동 대응 프로세스**를 마련하고 정기적으로 모의훈련을 실시하면, 실제 공격 시 피해를 국소화하고 확산을 막는 데 도움이 된다.

넷째, **조직적 차원의 보안 투자와 관리체계 강화**가 필수적이다. **염흥열 순천향대 명예교수**는 “최근 기업에서 인증 정보 등 민감정보 유출이 빈번하며, 보안사고는 2차 피해는 물론 기업 비즈니스에 치명적인 영향을 준다”며 “사고를 막기 위해 \*\*보안 투자를 획기적으로 늘리고, 기술·관리·조직적 준비태세인 \*\*정보보호 관리체계(ISMS)\*\*를 강화할 필요가 있다”고 강조한다. 경영진은 이번 사건을 교훈 삼아 **보안 거버넌스**를 재점검하고, 침해사고 대응 시나리오에 따른 역할/책임을 명확히 해야 한다. 나아가 개발, IT운영, 보안팀 간의 **협업체계**를 공고히 하여, 코드서명 인증서와 같은 **크라운 주얼(crown jewel)** 자산을 보호하고 이상 발생 시 신속 대응할 수 있는 조직 문화를 구축해야 할 것이다.

마지막으로, \*\*신뢰하지만 검증하라(Trust but Verify)\*\*는 원칙을 기억해야 한다. 디지털 서명 자체는 분명 소프트웨어 신뢰성 검증에 유용한 수단이지만, 이제는 **서명에 대한 추가 검증 절차**가 요구된다. 기업은 자체 개발 소프트웨어라 할지라도 **배포 전 샌드박스 동적 분석** 등을 통해 악성코드 삽입 여부를 점검하고, 사용자에게는 최신 위협 정보와 함께 “설령 소프트웨어가 서명되어 있어도 출처를 재확인하라”는 **보안 인식교육**을 진행해야 한다. 또한 **운영체제 및 보안 솔루션의 인증서 취소 목록(CRL) 업데이트**를 상시 확인하여, 이미 폐기된 인증서로 서명된 파일이 실행되지 않도록 환경을 유지해야 한다. 이러한 기술적·관리적 대응 방안을 통합적으로 시행함으로써, 조직은 **신뢰 기반 공격**에 대한 선제적 방어력을 높이고 앞으로 유사한 **공급망 APT 공격**으로부터 자산을 지켜낼 수 있을 것이다.

**참고자료:** CJ올리브네트웍스 인증서 유출 관련 보도, 보안 업계 기술 블로그 및 보고서 (ESET, S2W 분석 등), MITRE ATT\&CK 데이터베이스, 전자신문 등 언론 기사.
