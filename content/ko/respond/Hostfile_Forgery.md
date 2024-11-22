---
date: 2020-10-20T00:07:01
description: 
featured_image: 
tags: 
title: "hosts 파일 변조"
---

![blog_banner_20201102_2](https://github.com/user-attachments/assets/c9bdaad4-162a-4db0-b987-b900e380dfdb)

우리는 구글 사이트에 접속하고 싶을 때, 주소 창에 '172.217.163.228'과 같이 구글의 IP주소를 입력하기 보다는

'www.google.com'과 같이 해당 IP주소가 할당되어 있는 특정 도메인을 입력하여 접속합니다.

이 과정은 DNS(Domain Name System)가 있기에 작동하게 됩니다.

DNS는 사용자가 입력한 도메인을 할당 IP주소로 변환하는 시스템으로 마치 전화번호부와 같은 역할을 합니다. 

그런데 우리의 PC는 DNS에서 주소 정보를 제공받는 과정이 진행되기 전에 우선 순위가 더 높은 hosts 파일을 읽는 과정을 먼저 거치게 됩니다.

<br><br>

hosts 파일은 hostname과 이에 해당하는 IP주소를 직접 작성하여 설정할 수 있는 파일입니다.

특정 도메인의 IP주소를 127.0.0.1로 설정한다면 해당 도메인으로 브라우저에 접속하려 해도 자기 자신에게 향하기 때문에 접속 되지 않습니다. 

이런 식으로 특정 사이트 및 광고를 차단하는 방식으로 이용할 수도 있고,

개발자들이 개발 과정에서 개인 IP주소를 등록하거나 테스트하는 등의 경우 주로 사용됩니다. [1]

그러나 대부분의 일반 사용자들은 hosts파일이 무슨 역할을 하는지, 파일이 존재하는지 조차 모르는 경우가 많기 때문에 hosts 파일의 내용이 수정되어 있다면 해킹으로 인한 변조일 가능성이 큽니다. 

 

hosts 파일은 해커들에게 악용되어 호스트 변조를 통한 해킹에 이용할 수 있다는 문제점이 존재합니다.

이를 이용한 대표적인 해킹 수법인 "파밍"을 통해 예시를 들어 보겠습니다.

해커는 이메일이나 광고 배너, 링크 등으로 악성 코드를 퍼뜨립니다.

클릭한 사용자의 컴퓨터에는 악성 코드가 깔리고 악성 코드는 hosts 파일을 변조하여 특정 은행 사이트 도메인을 해커가 만든 위조 사이트의 IP로 연결되도록 만듭니다.

사용자는 주소 창에 은행 사이트의 도메인을 입력하여 접속하였지만 그것은 해커의 위조 사이트로 연결되게 되고 이를 인지하지 못한 사용자가 개인정보를 입력하게 되면 이것은 모두 해커의 손으로 넘어가게 됩니다.  [2]

<br><br>

hosts 파일이 변조되었음을 파악하지 못하는 이상,

사용자는 늘 이용하던 정확한 도메인을 입력하여 접속하였기에 그것이 해커의 사이트인지 전혀 의심하지 못하고 개인정보를 넘겨주게 된다는 점에서 위험한 해킹 수법입니다.

<br><br>

이런 문제를 방지하기 위해서는 우선 사용자의 행동이 중요합니다.

OS 및 백신 프로그램을 최신 버전으로 유지하고

알 수 없는 링크와 광고 배너 및 이메일은 클릭하지 않는 것이 좋습니다.

정상 접속되던 도메인이 접속되지 않는 오류가 발생해도 hosts 파일 변조를 의심해 볼 수 있습니다. [3]

그리고 hosts 파일에 대한 권한을 읽기 전용으로 설정해 놓는 것이 좋습니다.

윈도우의 경우에는 관리자 권한의 파일 속성을 통해, 리눅스의 경우에는

**ls -al /etc/hosts**

명령어를 통해 hosts파일의 권한을 확인할 수 있습니다. 

![lsal](https://github.com/user-attachments/assets/1a8a073b-5901-4084-ba47-cae20624b9cb)

현재 -rw-r--r--로 **644** 권한이 설정되어 있습니다. 통상적으로 600이 안전하다고 여겨지므로

chmod **600** /etc/hosts

통해 권한 설정을 바꾸고 경우에 따라 644 권한을 설정하는 것이 좋습니다.

<br><br>

그리고 hosts 파일 변조가 의심된다면 확인해 보도록 합니다.

윈도우의 경우 C:\Windows\System32\drivers\etc 경로의 파일을 관리자 권한으로 메모장을 통해 실행합니다.

만약 hosts.ics 파일이 존재한다면 이는 hosts 파일보다 우선순위가 높은 파일로 해킹이 의심되므로 삭제해야 합니다. [4]

리눅스의 경우 sudo vi /etc/hosts 명령을 통해 관리자 권한으로 파일을 엽니다.

일반적으로 hosts 파일에는 127.0.0.1 localhost의 내용만 존재하므로 그 외의 알 수 없는 내용이 있다면 삭제 후 저장 합니다.

<br><br>

다음은 PLURA V5에서 hosts 파일 변조가 탐지되는 과정입니다.

ping 명령어를 통해 www.google.com의 ip주소를 확인해 본 결과 172.217.163.228이 출력됩니다.

![pinggoogle11](https://github.com/user-attachments/assets/d64bd956-ff8f-4c56-b49b-decb7657dbc7)

<br><br>

sudo vi /etc/hosts 명령어를 통해 관리자 권한으로 hosts 파일을 vi editor을 통해 확인합니다.

![sudovi-1](https://github.com/user-attachments/assets/c13dc459-72c6-4c0e-a535-0b2033a62ab5)

<br><br>

다음 www.google.com의 IP주소를 임의로 설정 후 저장합니다.

![google127](https://github.com/user-attachments/assets/96366bf2-22b0-41e7-b007-3e720284055b)

<br><br>

다시 ping 명령어를 통해 확인한 결과 hosts파일에서 설정한 IP주소가 출력되며 www.google.com로 접속 시도시 정상적으로 접근되지 않음을 확인할 수 있습니다.

![ping-google-1](https://github.com/user-attachments/assets/a2b6a210-be92-49f4-aa1a-d1d1c37dc8f6)

![googlesite](https://github.com/user-attachments/assets/6a33aa86-2a09-4e9c-9929-74202ab6c67b)

<br><br>

그리고 PLURA V5에는 hosts 파일 변조에 대한 탐지가 발생합니다.

![hostslog-1](https://github.com/user-attachments/assets/449e7c2b-cd1a-42fa-8050-ad9cb82a2b3e)

<br>

**PLURA V5는 예방하지 못한 다양한 취약점으로 발생한 hosts파일 변조를 포함하여 다양한 파일 변조에 대한 해킹을 탐지하여 대응할 수 있도록 합니다.**


## 참고 사이트
- [1] [hosts] 호스트를 설정해서 쓰는 이유??, https://bit.ly/3jOAniL
- [2] 파밍 공격방법 중 하나인 HOSTS 파일 변조, https://bit.ly/35SZdJk
- [3] 연말연시 파밍 주의보 , 파밍 대처법은?, https://bit.ly/2JvEzYh
- [4] hosts.ics 이용한 파밍 사이트 접속 유도 주의!,  https://bit.ly/2JtfxsH
