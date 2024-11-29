---
date: 2021-04-28T00:03:00
description: 
featured_image: 
tags: ["사용자 정의 규칙", "웹 해킹", "웹 방화벽", "제로데이 취약점", "WPScan"]
title: "사용자 정의 규칙 필터 (웹 & 웹방화벽)"
---

![0 (1)](https://github.com/user-attachments/assets/6a921cb9-fe12-4ab3-845a-1a7de939da76)

웹 해킹은 웹 사이트 취약점을 공격하는 기술로, 웹 페이지를 통하여 권한이 없는 시스템에 접근하거나 데이터 유출 및 파괴와 같은 행위가 이루어집니다.  
특히 웹 애플리케이션을 통해 해킹이 주로 발생됩니다.

OWASP에서 10대 웹 애플리케이션 취약점을 발표하였고, PLURA는 이를 기준으로 웹 공격 유형 분석을 통해 탐지 패턴을 등록하여 관리하고 있습니다.

해커는 제로데이 취약점이라고 하는, 이전에 보고된 적 없는 새로운 결함을 찾아다니고 있습니다.  
이들이 발견한 직후, 보안 전문가들은 exploit 하나가 악용되고 있는 것을 추적 결과 목격할 수 있습니다.  
목격 즉시 PLURA 사용자는 해당 공격을 탐지 또는 차단하는 필터를 등록할 수 있습니다.  
**제로데이 취약점이 발표되고 패치되기까지 이를 기다릴 필요 없이 바로 자사의 서버를 보호할 수 있습니다.**

해커가 WPScan이라는 툴을 이용해서 WordPress 취약점을 탐색하고 있습니다.  
![01-4](https://github.com/user-attachments/assets/3b3d6986-6376-448f-a64f-f1fbaf821238)

PLURA는 이러한 다수의 보안 취약점을 스캐닝하는 무차별 공격을 탐지/차단을 기본적으로 제공하고 있지 않습니다.  
이유 중 하나는 이를 모두 탐지한다면 과도한 탐지(과탐)로 인해 업무 부하를 가중할 수 있는 부작용이 있기 때문입니다.

하지만, 만약 스캔 공격 역시 탐지/차단하고자 한다면, PLURA 전체 로그를 바탕으로 필터 등록하여 대응할 수 있습니다.  
![02-2](https://github.com/user-attachments/assets/997409b6-165c-4099-a090-72e4f1486720)

WPScan 결과 해당 서버에서 xmlrpc 취약점이 감지되었습니다.  
![03-1 (1)](https://github.com/user-attachments/assets/09477163-0655-4419-90a3-3ab90fd81c4b)

xmlrpc 취약점은 Brute Force 공격에 이용되고 있으며, PLURA에서 탐지하고 있습니다.  
![04-5](https://github.com/user-attachments/assets/948fd06e-b1bb-4468-96ef-74024ce58cba)

사용자가 WordPress 관리자 ID를 등록하여 사용자 필터링을 한다면, 공격 여부 탐지를 넘어 ID 유출 여부를 실시간 탐지할 수 있습니다.

WordPress는 자체 취약점도 존재하지만, 취약한 플러그인을 통한 공격이 대부분입니다.  
![05-1](https://github.com/user-attachments/assets/d8709496-c7f8-44f0-9a98-c931451bb003)

사용자가 등록한 또는 활성화한 Plugins이 아니라면 매우 큰 보안 위협이 될 수 있습니다.  
![06-2](https://github.com/user-attachments/assets/486904c3-18fb-41b0-8e9a-1b7111cf5da5)

사용자는 설치된 WordPress Plugins 목록을 취합하여 관리할 필요가 있습니다.  
이 목록을 포함 제외하여 활성화된 Plugins에 대한 로그를 실시간으로 탐지할 수 있습니다.

## 참조

- [위키백과 - 웹 해킹](https://ko.wikipedia.org/wiki/%EC%9B%B9_%ED%95%B4%ED%82%B9_)
