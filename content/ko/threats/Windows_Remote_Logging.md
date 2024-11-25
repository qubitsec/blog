---
date: 2019-06-24T00:01:00
description: 
featured_image: 
tags: 
title: "Windows Remote Logging"
---

![2020-07-29_1](https://github.com/user-attachments/assets/a159a391-3a43-400c-9ddc-57d230ff8457)

Active Directory 환경에서 Windows Event Collector 를 구성하면 Remote Logging 을 할 수 있습니다.

### 1. 이벤트 전달 및 수집을 위한 컴퓨터 구성

- 다음의 고려사항이 있습니다.
  - 단방향 구독만 사용할 수 있습니다.
  - 각 시스템에서 원격 이벤트 로그 관리에 대한 방화벽 예외를 추가해야 합니다.
  - 각 시스템의 로그 판독기 그룹에 관리자 권한이 있는 계정을 추가해야 합니다.
  - HTTPS 프로토콜을 사용하도록 구독을 구성하는 경우 이에 대한 방화벽 예외를 설정해야 합니다.
  - Microsoft 에서 권장하는 서비스팩과 핫픽스가 미설치된 경우 오류가 발생할 수 있습니다.

- 그 외의 상세 고려사항들은 아래 공식 URL에서 확인 할 수 있습니다.<br>
https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc748890(v=ws.11)

### 2. Windows 이벤트 수집기 사용 방법

- 위의 구성이 모두 완료되면 아래 공식 URL의 방법으로 이벤트 수집기를 사용할  수 있습니다.<br>
https://docs.microsoft.com/ko-kr/windows/desktop/WEC/using-windows-event-collector
