---
date: 2017-08-18T00:01:00
description: 
featured_image: 
tags: 
title: "누군가 당신의 인터넷 사용을 훔쳐보고 있다? ARP Spoofing"
---

![ARP-Spoofing](https://github.com/user-attachments/assets/c1700da8-ddde-4a97-bc88-d16769939bbf)

ARP 스푸핑은 간단하지만 피해는 치명적인 공격입니다. 그럼 도대체 ARP 스푸핑이 뭘까요?

> 2016년 3월 26일 반디소프트 홈페이지가 ARP 스푸핑 공격을 받아, 이 기간 동안 반디소프트 홈페이지를 통해서 꿀뷰를 다운로드 받은 사용자들에게 꿀뷰 설치 파일 대신 악성코드가 다운로드 되는 문제가 발생하였습니다.<br>
>
> 2016년 4월 특정 호스팅사가 ARP 스푸핑 공격을 당해 쇼핑몰, P2P, 날씨배너, 커뮤니티 등 호스팅 서비스를 받는 다수의 웹사이트에서 파밍용 악성코드가 유포되었습니다.<br>
> 호스팅 업체를 노린 ARP 스푸핑 공격은 특정 패킷을 변조해 악성URL이나 스크립트를 추가함으로써 다운로드 링크를 변조시키는 공격 방식이었습니다.<br>
>
> 2015년 3월 국내 보안업계 최대 행사인 행정자치부 주최로 열리는 '전자정부 솔루션 페어' 와 '세계 보안 엑스포' 의 홈페이지가 ARP 스푸핑 공격에 당해 행사 전날 밤 동시에 마비됐습니다.<br>
> 해킹 사실을 확인한 행사 조직위원회 측은 악성코드가 퍼져나갈 것을 우려하여 서버 접속을 중단시켰습니다.

<br>ARP 스푸핑에 대해 알아보기전에 먼저 ARP가 뭔지 살펴보겠습니다.

## ARP (Address Resolution Protocol)
ARP는 네트워크 상에서 IP 주소를 물리적 주소(MAC 주소)로 대응 시켜 주는 프로토콜입니다.<br>
네트워크 상에서 특정 IP를 가지고 있는 호스트가 누군지 물어보면(Request) 해당 IP를 가진 호스트가 응답(Reply)하는 Request와 Reply 구조로 동작합니다.<br>

### ARP 동작과정<br>
![arp-request](https://github.com/user-attachments/assets/0e4b777d-2fa3-484d-b969-47d758796f2e)<br>

ⅰ. 송신자가 수신자에게 데이터를 보낼 때 먼저 ARP table을 확인합니다.
ARP table에 수신자에 대한 정보가 없다면 송신자는 ARP Request 메시지를 생성하여 네트워크 상에 브로드캐스트합니다.

ⅱ. 네트워크 상의 모든 호스트들은 ARP Request 패킷을 수신하고 해당 ip를 가진 호스트만 자신의 물리주소를 포함하는 ARP Reply 메시지를 생성하여 송신자에게 유니캐스트로 전송합니다.

ⅲ. 송신자는 ARP Reply 패킷을 받고 목적지 ip와 물리주소를 ARP table에 기록합니다.<br>
ARP table에 정보가 저장되면 다음부터는 이 과정 없이 ARP table을 참조하여 바로 데이터를 전달하여 효율적으로 통신을 할 수 있습니다.

![arp-reply](https://github.com/user-attachments/assets/e54c6989-c84d-4710-9fba-e69f35c2d120)

## ARP spoofing ?

그렇다면 ARP Spoofing이란 뭘까요?
ARP Spoofing은 victim에게 잘못된 MAC 주소가 담긴 ARP Reply를 보내 victim의 ARP 캐시를 조작하여 victim으로부터 정보를 빼내는 해킹 기법입니다.<br>
ARP에 Reply 패킷으로 받은 MAC주소가 진짜인지 아닌지 검증하는 인증 시스템이 없다는 취약점을 이용한 공격입니다.<br>
![Attack-MITM](https://github.com/user-attachments/assets/de2a1bdd-8a96-48ef-99ba-0c63b22336f1)

### 동작과정

i. 공격자가 victim에게 gateway의 ip 주소와 공격자의 Mac 주소가 담긴 패킷을 지속적으로 전송합니다.

ⅱ. 그럼 victim은 ARP table에 해당 내용을 그대로 저장합니다.
### Target’s ARP table

| Gateway’s IP      | Attacker’s MAC Address |
|--------------------|-------------------------|

ⅲ. victim은 공격자를 gateway로 생각하고 공격자의 mac 주소로 데이터를 전송합니다.<br>
* 공격자는 받은 데이터를 포워딩해주어야 합니다. (포워딩 해주지 않으면 Target은 정상적인 통신을 할 수 없어 공격을 의심할 수 있습니다)

### 공격 Tools
- Ettercap
- arpspoof
- Cain & Abel
- fake

### ARP Spoofing으로 가능한 공격
- 악성코드 유포
- 세션 하이재킹
- DNS Spoofing
- VoIP 도청
- 로그인 정보(아이디/패스워드) 수집

### 대응방법
- 패킷 감지 프로그램을 사용하여 ARP 신호를 보내는 패킷 확인
- ARP 테이블을 정적으로 관리
- ARP 스푸핑 감지 소프트웨어 사용
- 네트워크 장비에서 서로 다른 ip에 동일한 mac 주소가 매핑 되어있는지 확인


## 공격 테스트<br><br>
![re_cap](https://github.com/user-attachments/assets/6ca7e9de-b559-462e-9696-721857259700)

시나리오 1><br>
: target의 arp table에 gateway의 ip와 attacker의 mac주소가 저장되도록 하여 target이 주고 받는 패킷들을 스니핑 할 수 있습니다.

<공격 전 target’s arp table><br>
![arp_before_v2](https://github.com/user-attachments/assets/3996d878-82c9-4fbd-a855-8b61d12af1f3)

<공격 후 target’s arp table><br>
![arp_after_v2](https://github.com/user-attachments/assets/2f0075be-e96b-4333-a43b-0c0fc65a4a9e)

target이 로그인시 계정 정보 스니핑<br>
![계정정보](https://github.com/user-attachments/assets/e06da358-76a7-4467-bb84-df28884082f3)

시나리오 2><br>
: switch의 arp table에 gateway의 ip와 attacker의 mac주소가 저장되도록 하여 스위치에 연결된 모든 호스트들이 주고받는 패킷들을 attacker가 스니핑 할 수 있습니다.

<공격 전 switch의 arp table><br>
![SW_arp-table_before](https://github.com/user-attachments/assets/fe82acfd-6c65-4fd2-aeec-770671987b1a)

<공격 후 switch의 arp table><br>
![SW_arp-table_after](https://github.com/user-attachments/assets/23945841-c391-439a-9108-539bbb8d88d1)

시나리오 3><br>
: 라우터에 gateway의 ip와 attacker의 mac주소를 ARP Reply 패킷으로 보내면 라우터에서 서로 다른 ip에 같은 mac주소가 매핑된것을 확인하고 로그를 생성합니다.

> Router# show logging
>
> *Feb 28 15:19:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:20:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:20:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:21:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:21:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:22:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:22:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:23:18.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>
> *Feb 28 15:23:48.203: %IP-4-DUPADDR: Duplicate address 192.168.10.1 on FastEthernet0/0, sourced by 0800.27ef.e2a9<br>






