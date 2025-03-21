---
date: 2023-02-14T01:10:00
draft: false
title: "디렉토리 리스팅 공격 대응"
description: ""
featured_image: "cdn/respond/directory_listing_attack-1.png"
tags: ["디렉토리 리스팅", "사이버 보안", "웹 서버", "WAF", "접근 제어"]
---

## 🏗️개요

디렉토리 목록 공격은 기본 페이지(예: "index.html")가 없는 경우에도 웹 서버가 디렉토리의 내용을 표시하도록 구성된 경우 발생하는 일종의 취약점입니다. 공격자는 이 취약점을 악용하여 중요한 파일이나 디렉터리 구조와 같은 중요한 정보에 대한 무단 액세스 권한을 얻을 수 있습니다.

<!--more-->

디렉터리 목록 공격 중에 공격자는 디렉터리의 내용을 검색하여 파일 및 디렉터리 이름, 파일 크기, 타임스탬프와 같은 중요한 정보를 잠재적으로 노출할 수 있습니다. 그런 다음 이 정보를 사용하여 악성 파일 업로드 또는 민감한 데이터 액세스와 같은 추가 공격을 시작할 수 있습니다.

디렉터리 목록 공격을 방지하려면 웹 서버를 안전하게 구성하고 무단 액세스를 방지하기 위한 액세스 제어 및 기타 보안 조치를 구현하는 것이 중요합니다.

<br>

![directory_listing_attack](https://blog.plura.io/cdn/respond/directory_listing_attack-1.png)

## 🛠️대응방법

### 1. 디렉토리 목록 비활성화:

- 대부분의 웹 서버에는 구성 파일이나 관리 패널을 통해 수행할 수 있는 디렉토리 목록을 비활성화하는 옵션이 있습니다.

### 2. 기본 페이지 사용:

- 기본 페이지(예: "index.html")를 생성하면 디렉토리 목록이 활성화된 경우에도 디렉토리의 내용이 표시되지 않도록 할 수 있습니다.

### 3. 액세스 제어 구현:

- Apache의 경우 .htaccess 파일 또는 인증과 같은 액세스 제어 메커니즘을 사용하여 민감한 디렉토리에 대한 액세스를 제한하십시오.

### 4. WAF(웹 응용 프로그램 방화벽) 사용:

- WAF는 악의적인 요청을 탐지하고 차단하여 디렉터리 목록 공격으로부터 보호할 수 있습니다.

### 5. 소프트웨어를 최신 상태로 유지:

- 웹 서버 소프트웨어와 설치된 응용 프로그램을 정기적으로 업데이트하면 알려진 취약점을 수정하고 악용을 방지할 수 있습니다.

### 6. 구성 및 액세스 로그를 정기적으로 모니터링:

- 웹 서버 구성 및 액세스 로그를 정기적으로 검토하고 모니터링하여 안전한지 확인하고 디렉터리 목록 공격을 방지하는 것이 중요합니다.
- 또한 웹 서버 구성 및 보안 조치에 익숙하지 않은 경우 전문가의 도움을 받거나 보안 전문가와 상담하는 것이 좋습니다.

<br>

📖 함께 읽기
- [cwiki_DirectoryListings](https://cwiki.apache.org/confluence/display/httpd/DirectoryListings)
- [ngx_http_autoindex_module](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html)
- [microsoft_directorybrowse](https://learn.microsoft.com/en-us/iis/configuration/system.webserver/directorybrowse)
