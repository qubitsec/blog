---
date: 2020-06-04T00:00:00
draft: false
title: "홈페이지 변조 해킹 기술 똑똑해져…보안 강화 필요"
description: 
featured_image: "cdn/column/homepage_hack-1.png"
tags: ["홈페이지 변조", "보안", "악성코드", "웹쉘", "PLURA"]
---

해커가 웹사이트를 공격한 후 필요한 정보를 탈취한 후, 이차적인 피해를 위해 홈페이지에 악성코드를 심는다.

혹은 웹 쉘을 이용하여 공격 성공된 사이트에 대하여 지속적인 연결을 유지하려고 한다.

이러한 공격은 홈페이지 위변조를 통해 이루어지는데.

인터넷 기사에 따르면 한국인터넷진흥원(KISA) 에서 2015년부터 연간 1,000회 이상씩 꾸준히 홈페이지 위변조 공격이 발생하고 있다.

하지만 기존 SIEM 이나 보안장비들은 이러한 공격에 대하여 효과적으로 방어 할 수 있는 기능이 구현되지 않았다.

PLURA 제품을 사용하면 클릭 몇 번을 통해 간단하게 홈페이지 위변조 해킹을 탐지하고 관리할 수 있다.

![homepage_hack](https://blog.plura.io/cdn/column/homepage_hack-1.png)
<!--more-->
---

# 홈페이지 위변조 해킹 탐지 방법

## 1. [PLURA 메뉴] → [필터] → [보안] → [홈페이지 위변조]<br>
![image](https://github.com/user-attachments/assets/bae4d0a1-6674-4f44-8aa4-7dffd0b823fa)

## 탐지하고 싶은 파일경로를 적어주면 해당 파일이 위변조 될 때 필터 탐지가 됩니다.<br><br>
![2020-06-04-13-07-01](https://github.com/user-attachments/assets/91ca78d3-41d8-49d2-a0b9-37b57ee799ab)

> * 예시)  해커가 index.php 에 iframe 태그를 이용하여 악성코드 유포지를 삽입함.<br><br>
> ![2020-06-04-13-33-43](https://github.com/user-attachments/assets/eacdbe97-5444-4022-9948-115581b6c7b2)
>
> * 실제 삽입된 악성 html 코드<br><br>
> ![2020-06-04-13-31-28](https://github.com/user-attachments/assets/1d49c727-ea2a-4b35-bc36-8e79161a89a1)
>
> * 해당 사이트 방문자는 악성코드 유포지에 연결되었음. [테스트 환경이기 때문에 가상의 도메인으로 설정]<br><br>
> ![2020-06-04-13-31-56](https://github.com/user-attachments/assets/68d5cf4d-fbba-4f87-9765-2c29448c4103)
>
> * PLURA에서 해당 페이지 변조가 탐지되었습니다.<br><br>
> ![2020-06-04-14-07-17](https://github.com/user-attachments/assets/d56e98ae-5be7-4a75-91c2-41afeff5490d)


**변조된 파일 경로와 이름을 확인할 수 있어 관리자는 해당 파일을 점검하여 홈페이지 위변조 공격을 대처 할 수 있습니다.**
