---
date: 2017-08-18T00:03:00
description: 
featured_image: 
tags: 
title: "협박성 디도스 공격, 랜섬디도스(RansomDDoS)"
---

![RansomDDoS](https://github.com/user-attachments/assets/530eb5ac-21e9-4443-8cf0-7daa6fe52e3a)


랜섬웨어(Ransomware)에 이어 랜섬디도스(Ransom DDoS)까지 기승을 부리고 있습니다.

> 비트코인 등 금전을 지불하지 않을 경우, 디도스 공격으로 기업의 IT 전산 인프라를 마비시켜 서비스 운영에 장애를 일으키겠다고 협박하는 것입니다. <br>
> 카스퍼스키랩은 최근 '2017년 2분기 디도스 리포트'를 통해 올해 2분기 트렌드로 이 같은 랜섬디도스를 꼽았다.<br>
> 시스코 또한 '2017 중기 사이버보안 보고서'를 통해 협박성 디도스 공격이 전 세계적으로 두드러지게 발생하고 있다고 발표했습니다.

Dos, DDoS 공격은 해커의 공격 명령 몇 줄이면 대상 서버에 엄청난 피해를 줄 수 있는 공격입니다.
디도스 공격에 대해서 많이 들어는 봤어도 자세한 내용은 잘 모르는 사람이 많습니다.

Dos와 DDos의 개념과 공격의 종류, 대응 방법에 대해 알아보겠습니다.

> **DoS(Denial of Service)**<br>
> ‘서비스 거부 공격’이라고도 하며 정상적인 서비스를 지연 시키거나 마비시키는 해킹 공격으로 한 PC가 다른 한 서버를 공격하는 1:1 공격 구조를 가지고 있습니다.
>
> **DDoS(Distributed Denial of Service)**<br>
> ‘분산 서비스 거부 공격’ 이라고도 하며 DoS의 발전된 형태로 다수의 PC가 하나의 서버를 공격하는 N : 1 공격 구조입니다.
> 좀 더 자세히 말하면 공격자가 악성코드를 유포하여 감염시킨 좀비PC들이 있고, 원격지에서도 좀비 PC들을 제어할 수 있도록 해주는 C&C서버가 있어서 공격자는 C&C서버를 통해 좀비 PC들이 특정 시스템으로 동시 다발적인 트래픽을 발생 시키도록 명령하는 구조를 가지고 있습니다.
> ![DDos_Attack](https://github.com/user-attachments/assets/7e3b5e3a-f8ef-49cc-aca9-4a94da692c59)


## 공격 종류

### 1. TCP Syn Flood

TCP Syn Flood는 두 호스트 사이에서 데이터를 주고 받기 전에 3-way handshake 과정을 통해 연결을 맺는 TCP의 특성을 이용한 공격입니다.
그렇기 때문에 TCP Syn Flood를 알기 전에 우선 TCP의 3-way-handshake에 대해 알아야 합니다.

**TCP 3-way-handshake**
3-way handshake는 신뢰성 있는 전송을 위해 데이터를 주고 받기 전에 두 호스트간의 연결을 맺는 과정입니다.<br><br>
![Tcp-handshake](https://github.com/user-attachments/assets/956c8906-c2a3-4475-8bf8-d74f6c143015)<br>

<동작과정>
1. Client에서 Server에 연결을 요청하기 위해 SYN 패킷을 보냅니다. 이 때 seq값을 임의의 값 x로 설정하여 보냅니다.<br>
2. 그러면 Server는 Client에게 ‘요청 잘 받았어~’ 라는 대답의 ACK 패킷과 ‘너도 포트좀 열어줘!’라는 SYN 패킷을 같이 보냅니다.<br>
이때 ack값에는 받은 SYN 패킷의 seq값에 1을 더한 값인 x+1을 넣고 seq에는 다른 임의의값 y를 넣습니다.<br>
3. Client는 SYN-ACK 패킷을 받고 서버에 요청을 잘 받았다는 ACK 패킷을 전송합니다. 물론 이때도 ack값을 y+1로 보냅니다.<br>

이 과정이 끝나면 Client와 Server는 연결을 맺고 데이터를 주고 받게됩니다.
그런데 이때, Client가 Server로 부터 SYN-ACK 패킷을 받고 ACK패킷를 보내지 않는다면 어떻게 될까요?

Server는 Half Open 상태로 일정 시간동안 Client의 ACK 패킷을 기다리고 이 연결은 Backlog Queue에 쌓아둡니다. 그러다가 Client로부터 ACK패킷이 오면 연결을 맺지만 일정 시간이 지나도록 ACK패킷이 오지 않으면 이 연결은 Backlog Queue에서 삭제됩니다.

tcp syn flood는 이 원리를 이용한 공격입니다.<br>
만약 Backlog Queue의 크기보다 많은 연결 요청이 발생한다면 어떻게 될까요? Backlog Queue의 연결이 삭제되기 전에 또 다른 연결 요청이 계속해서 들어온다면 어떻게 될까요?

공격자가 서버에 다수의 SYN 패킷을 보내면 서버는 이에 대한 응답으로 SYN-ACK 패킷을 보내겠죠, 하지만 공격자는 ACK 패킷을 보내지 않습니다.<br>
그렇게 되면 서버는 이 연결들을 Half Open 상태로 Backlog Queue에 계속 쌓아두게 되고 결국 Backlog Queue가 꽉 차서 다른 일반 사용자가 연결을 요청하면 연결을 받아들이지 못하는 서비스 거부상태가 됩니다.

### 2. UDP Flood

UDP의 비연결성, 비신뢰성 특성을 이용한 공격으로 UDP에서는 ip와 port를 스푸핑하기 쉽다는 점을 이용한 공격입니다.<br>
공격자가 잘못된 ip와 port로 UDP 패킷을 보내면, 패킷을 받은 쪽에서는 패킷을 잘못보냈다는 ICMP destination Unreachable 패킷을 보내는데 공격자가 잘못된 UDP 패킷을 대량으로 보낸다면 타겟은 UDP와 ICMP 패킷을 처리하는데 시스템 자원을 소비하게 됩니다.

### 3. TearDrop
네트워크를 통과할 수 있는 최대 패킷의 크기를 MTU (Maximum Transmission Unit)라고 하는데, 패킷의 크기가 MTU보다 크면 패킷을 쪼개는 Fragmentation(단편화) 과정을 거치게 됩니다.<br>
수신측에서는 쪼개진 패킷들을 순서 없이 받게 되는데 송신측에서 설정한 offset값을 통해 패킷을 재조합합니다.<br>
TearDrop은 이 Offset값을 조작하여 서버가 받은 패킷들을 재조합하지 못하도록 하여 장애를 발생시키는 공격입니다.

### 4. ICMP Flood
ICMP Flood의 대표적인 공격으로는 Smurf 공격이 있습니다.<br>
Smurf 공격은 공격자가 어떤 네트워크에 source IP를 victim의 IP로 한 ICMP request 패킷을 브로드캐스트하면 네트워크 안의 호스트들은 ICMP request 패킷을 victim이 보냈다고 생각하고 ICMP reply응답을 victim으로 보냅니다.<br> 
그럼 victim은 갑자기 대량의 ICMP reply 패킷을 받게 됩니다.<br>
* ICMP : 다른 호스트 or 게이트웨이 사이에 네트워크 에러가 있는지 확인하는 프로토콜

### 5. Ping of Death
Ping 명령을 통해 ICMP 패킷을 정상적인 크기보다 크게 만들어서 victim에 보내는 공격입니다.<br>
앞에서도 말했듯이 패킷의 크기가 MTU보다 크면 패킷을 쪼개서 보내는 fragmentation 과정을 거치는데, ICMP 패킷의 크기가 엄청 크다면 많을 양으로 쪼개질 것이고 victim은 그 패킷들을 처리하는데 시스템 자원을 소모하게 됩니다.

### 6. HTTP Flood
웹페이지를 대량으로 요청하여 공격 대상 웹 서버가 해당 요청을 처리하기 위해 서버 자원을 과도하게 사용하도록 하여 정상적인 요청을 처리하지 못하도록 하는 공격입니다.

### 7. Cache Control Attack
HTTP 헤더의 캐시 옵션값을 조작하여 웹서버에 부하를 주는 공격입니다.<br>
일반적으로 사용자가 웹페이지를 요청하면 응답 결과를 캐시에 저장하여 같은 페이지에 다시 접속했을 때 웹서버에 다시 요청하지 않고 캐시에 저장된 내용을 출력하여 불필요한 요청을 줄이고 처리속도를 향상시킵니다.<br>
캐시 옵션값을 ‘no-store’로 설정하면 캐시에 응답 결과를 저장하지 않고 매번 웹서버에 요청을 하여 서버에 부하가 생기게됩니다.<br>
또 캐시에 저장된 내용이 아직도 유효한지 웹서버에 확인하는 것을 ‘검증’한다고 하는데 캐시 옵션값을 ‘must-revalidate’로 설정하면 캐시에 저장된 내용을 매번 재검증하여 서버에 부하가 생깁니다.

## 대응방법
### Syn flooding
> - 백로그 큐의 크기 늘리기
> sysctl -a | grep syn_backlog : 백로그 사이즈 확인
> sysctl -w net.ipv4.tcp_max_syn_backlog=1024 : 백로그 사이즈 수정<br>
> - Syncookie 설정<br><br>
> ![tcp_syn_cookie](https://github.com/user-attachments/assets/2702a667-07a8-49ed-bc0d-bddfc556dc7a)<br>
> : Syncookie는 두 호스트간의 연결에 대한 정보를 암호화 한것인데 syncookie를 설정한다는 것은 3-way-handshake 과정에서 서버가 client로부터 SYN 패킷을 받고 SYN-ACK 패킷을 보낼 때 SYN 패킷의 seq값으로 syncookie값을 넣는 것을 말합니다.<br>
> 이렇게 하면 client로부터 ACK 패킷이 오지 않아도 server는 기다리지 않고 나중에 client가 ack값에 syncookie+1을 넣어 보내면 자신이 가지고 있는 syncookie값과 비교하여 같다면 연결을 맺고 통신하게됩니다.
>
> - syncookie 설정하는 법
> sysctl -a | grep syncookie : syncookie 설정 확인
> sysctl -w net.ipv4.tcp_syncookies=1 : syncookie 기능 활성화
> - 방화벽에 IP 당 SYN 요청에 대한 PPS 임계치 설정, 첫번째 SYN 패킷을 Drop 하여 재요청 패킷 도달 확인
> * PPS : 대역폭 별로 사용할 수 있는 최대 패킷 수
> - 레지스트리 값 수정 (EnableICMPRedirect, SynAttackProtect, KeepAliveTime 항목)

### UDP/ICMP flooding
- 웹서버나 운영 장비에서 UDP/ICMP 트래픽 DROP 설정
- Null 라우팅을 통해 공격 트래픽을 가상 인터페이스로 라우팅
- 운영 장비에서 Inbound 패킷 임계치 설정

### Teardrop
- 시스템의 운영체제가 취약점을 갖지 않도록 패치 해야 함
* 원인은 윈도우 및 Linux 시스템의 IP 패킷 재조합 코드의 버그에 있었으나 현재 대부분의 시스템에서는 이러한 teardrop 공격에 대해서 방어하고 있음

### Smurf
- 각 네트워크 라우터에서 IP 브로드캐스트 주소를 사용할 수 없게 미리 설정

###  Ping Of Death
- 패킷의 재조합 과정에서, 들어오는 패킷의 offset값의 합을 검사

### HTTP flooding
- 콘텐츠마다 요청할 수 있는 횟수에 임계치 설정하여 일정 규모 이상의 요청 차단
- 임의의 시간 안에 설정한 임계치 이상의 요청이 들어온 경우 해당 IP를 탐지하여 방화벽의 차단 목록으로 등록

### CC Attack
- L7 스위치를 이용하여 HTTP Header 의 CacheControl 에 특정 문자열을 포함하는 경우 해당 IP 접속 차단 설정

## 공격 결과

### tcp syn flooding
- netstat 명령
: 서버가 SYN-RECV 상태로 ACK패킷을 기다리는 것을 확인 할 수 있습니다.
> root@modtest:~# netstat -antop<br>
> Active Internet connections (servers and established)<br>
> Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name Timer<br>
> tcp 0 0 127.0.0.1:3306 0.0.0.0:* LISTEN 1454/mysqld off (0.00/0/0)<br>
> tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN 1129/sshd off (0.00/0/0)<br>
> tcp 0 304 10.10.2.85:22 10.10.2.122:55176 SYN-RECV 8527/sshd: plura [fusion_builder_container hundred_percent="yes" overflow="visible"][fusion_builder_row][fusion_builder_column type="1_1" background_position="left top" background_color="" border_size="" border_color="" border_style="solid" spacing="yes" background_image="" background_repeat="no-repeat" padding="" margin_top="0px" margin_bottom="0px" class="" id="" animation_type="" animation_speed="0.3" animation_direction="left" hide_on_mobile="no" center_content="no" min_height="none"][p on (0.01/0/0)<br>
> tcp 0 0 10.10.2.85:22 10.10.2.100:11936 SYN-RECV 30924/sshd: plura [ keepalive (4194.07/0/0)<br>
> tcp 0 0 10.10.2.85:22 10.10.2.122:55174 SYN-RECV 8357/sshd: plura [p keepalive (6913.81/0/0)<br>
> tcp6 0 0 :::80 :::* LISTEN 7018/apache2 off (0.00/0/0)<br>
> tcp6 0 0 :::22 :::* LISTEN 1129/sshd off (0.00/0/0)<br>
> tcp6 0 0 10.10.2.85:80 10.10.2.122:38486 FIN_WAIT2 - keepalive (210.71/0/0)<br>
> tcp6 0 0 10.10.2.85:80 10.10.2.122:39600 SYN-RECV 8353/apache2 keepalive (7175.96/0/0)<br>
> tcp6 0 0 10.10.2.85:80 10.10.2.122:39596 SYN-RECV 8350/apache2 keepalive (7175.96/0/0)<br>
> tcp6 0 0 10.10.2.85:80 10.10.2.122:39598 SYN-RECV 7021/apache2 keepalive (7175.96/0/0)<br>
> tcp6 0 0 10.10.2.85:80 10.10.2.122:39602 SYN-RECV 7022/apache2 keepalive (7175.96/0/0)<br>
> tcp6 0 0 10.10.2.85:80 10.10.2.122:39594 SYN-RECV 8585/apache2 keepalive (7175.96/0/0)<br>

### udp flooding
- ping 명령
: 공격 후 서버가 ICMP 패킷을 처리하느라 ping명령을 보냈을 때 응답시간이 점점 길어지는 것을 확인 할 수 있습니다.
> [root@localhost ~]# ping 192.168.10.10<br>
> PING 192.168.10.10 (192.168.10.10) 56(84) bytes of data.<br>
> 64 bytes from 192.168.10.10: icmp_seq=13 ttl=63 time=13.4 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=14 ttl=63 time=18.6 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=15 ttl=63 time=12.9 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=16 ttl=63 time=16.3 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=17 ttl=63 time=12.0 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=31 ttl=63 time=137 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=72 ttl=63 time=149 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=221 ttl=63 time=144 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=251 ttl=63 time=146 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=283 ttl=63 time=150 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=390 ttl=63 time=167 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=395 ttl=63 time=140 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=478 ttl=63 time=155 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=526 ttl=63 time=134 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=581 ttl=63 time=143 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=745 ttl=63 time=141 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=794 ttl=63 time=148 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=879 ttl=63 time=142 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=881 ttl=63 time=140 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=1088 ttl=63 time=148 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=1256 ttl=63 time=160 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=1266 ttl=63 time=144 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=1328 ttl=63 time=144 ms<br>
> 64 bytes from 192.168.10.10: icmp_seq=1359 ttl=63 time=146 ms<br>

### http flooding
- apache의 access_log
: access_log 로그를 통해 같은 ip로 거의 동시간대에 계속해서 접속한 것을 확인 할 수 있습니다.
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?HJJFE=KCYKMVXK HTTP/1.1" 301 252 "http://www.usatoday.com/search/results?q=VMQTL" "Opera/9.80 (W192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?HJJFE=KCYKMVXK HTTP/1.1" 301 252 "http://www.usatoday.com/search/results?q=VMQTL" "Opera/9.80 (Windows NT 5.2; U; ru) Presto/2.5.22 Version/10.51"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?XPBAVQIQE=UILLDFXMV HTTP/1.1" 301 257 "http://www.usatoday.com/search/results?q=UXQHNESAVK" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; .NET CLR 2.0.50727; InfoPath.2)"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?MDEZZ=TYI HTTP/1.1" 301 247 "http://engadget.search.aol.com/search?q=MFGRZD" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; .NET CLR 2.0.50727; InfoPath.2)"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?IBRC=KWFJVJF HTTP/1.1" 301 250 "http://www.google.com/?q=MOFCA" "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress/?JJTRXLEVV=ZVVFXWEOWC HTTP/1.1" 500 251 "http://192.168.0.8/QDMKPLOHYM" "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.1) Gecko/20090718 Firefox/3.5.1"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?ENYWOHXTQR=DSOS HTTP/1.1" 301 253 "http://engadget.search.aol.com/search?q=HYZQLIY" "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.1 (KHTML, like Gecko) Chrome/4.0.219.6 Safari/532.1"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?RGXR=KOE HTTP/1.1" 301 246 "http://192.168.0.8/LNQYSU" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; InfoPath.2)"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?MQR=ZSQTJLFSBN HTTP/1.1" 301 252 "http://192.168.0.8/QQJQIPQ" "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?BMWRXJSGC=ASIZB HTTP/1.1" 301 253 "http://www.usatoday.com/search/results?q=EJUSQMGM" "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?XNPHAN=PFASYHMNPV HTTP/1.1" 301 255 "http://engadget.search.aol.com/search?q=DXRHLFCFYJ" "Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress?VJCH=WRP HTTP/1.1" 301 246 "http://www.google.com/?q=GYHRGQTDD" "Mozilla/5.0 (Windows; U; Windows NT 6.1; en; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress/?FDE=OEPTDTK HTTP/1.1" 500 251 "http://www.google.com/?q=YFDAHCAI" "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.1 (KHTML, like Gecko) Chrome/4.0.219.6 Safari/532.1"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress/?NBU=XNFYUYYUD HTTP/1.1" 500 251 "http://192.168.0.8/BVMFYZVOG" "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.1) Gecko/20090718 Firefox/3.5.1"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:59 +0900] "GET /wordpress/?UTKXMG=NAMO HTTP/1.1" 500 251 "http://www.usatoday.com/search/results?q=YMSGOFP" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; Win64; x64; Trident/4.0)"<br>
> 192.168.0.4 - - [18/Jul/2017:14:41:58 +0900] "GET /wordpress/?HYSS=XPRNNT HTTP/1.1" 500 251 "http://engadget.search.aol.com/search?q=WAKAZYH" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; SLCC1; .NET CLR 2.0.50727; .NET CLR 1.1.4322; .NET CLR 3.5.30729; .NET CLR 3.0.30729)"<br>

- mod_evasive
: 공격 유형과 공격한 ip, 시간을 알 수 있습니다.
> [root@localhost mod_evasive]# ls -l /var/log/mod_evasive<br>
> 합계 0<br>
> -rw-r--r--. 1 apache apache 0 7월 24 13:17 dos-192.168.0.4
