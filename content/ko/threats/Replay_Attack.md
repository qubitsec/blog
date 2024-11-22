---
date: 2020-11-13T00:07:00
description: 
featured_image: 
tags: 
title: "[재전송 공격] Replay attack 이란"
---

![20201113_1](https://github.com/user-attachments/assets/ade0a051-eadd-4c5c-8c5f-1b95e4acbe4f)

재전송 공격(리플레이 공격)은 중간자 공격의 하위 계층 버전 중의 하나입니다.

프루라에서는 탐지된 공격 로그를 이용하여 재생(Replay)하는 기술, **재전송 공격**을 제공합니다.

공격이 실제 데이터 유출로 이어졌는지 확인하기란 대단히 어렵습니다.

특히, 일반적으로 access log 만 남겨진 환경에서는 POST 메소드의 Post-body 가 남아 있지 않아서 공격 자체를 확인하기가 불가능합니다.


다음과 같은 환경을 가정해 보겠습니다.
> 1) access log는 남아 있지만, POST 메소드의 Post-body 가 없다.
> 2) POST 메소드의 Post-body를 가지고 있지만, 재전송하는 방법을 모르겠다.
> 3) POST 메소드의 Post-body를 가지고 있으며 재전송 방법도 알지만 망분리로 네트워크가 분리되어 실행하기 어렵다.



프루라의 "재전송 공격"은 이럴 경우 매우 유용하게 사용됩니다.
> **1) POST 메소드의 Post-body가 없는 경우,** 남아 있는 GET 메소드를 이용하여 실제 공격 형태를 확인할 수 있습니다.<br>
>
> **2) POST 메소드의 Post-body가 있는 경우,** 간단히 재전송 공격을 클릭하는 것으로 모의 해킹을 진행할 수 있으며, 결과적으로 해당 공격이 우리 서버에서 어떻게 동작하는지 이해할 수 있습니다.<br>
>
> **3) POST 메소드의 Post-body가 있고 망분리가 되어 있는 경우,** 터미널을 열고 curl 복사 후 해당 터미널에서 실행하는 것으로 모의 해킹을 진행합니다.<br>

해킹 공격에 대하여 **성공**과 **실패**를 이해하기란 대단히 어렵습니다.

프루라의 **재전송 공격** 기능을 이용하여 파악하면 업무의 많은 부담을 경감시켜 줄 것입니다.


## 참고 자료
- 1) 내 서버에는 누가 들어오는 걸까, NAVER D2 블로그, 권태관, https://bit.ly/36zNkrM
- 2) curl 설치 및 사용법, lesstif, https://bit.ly/3knV3yl
- 3) 위키백과, Replay attack, https://bit.ly/38yH1HQ[/fusion_builder_column][/fusion_builder_row][/fusion_builder_container]
