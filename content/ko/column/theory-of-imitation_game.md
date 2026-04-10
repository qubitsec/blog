---
title: "생각지도 못한 일을 해내는 PLURA"
date: 2025-06-10
draft: false
description: "앨런 튜링의 말을 빌리면, PLURA 개발팀은 누구도 상상하지 못한 방식으로 해킹에 대응하는 로그 중심 보안 기술을 만들었습니다."
featured_image: "cdn/column/theory-of-imitation_game.png"
tags: ["앨런 튜링", "Alan Mathison Turing", "The Imitation Game", "사이버보안", "이미테이션게임", "로그기반보안", "큐비트시큐리티"]
---

## 🎬 영화 *이미테이션 게임* 속 명대사

> “**Sometimes it is the people no one imagines anything of who do the things that no one can imagine.**”  
> “생각지도 못한 누군가가, 누구도 상상하지 못한 일을 해내곤 합니다.”

이 구절은 천재 수학자 **앨런 튜링**의 이야기를 다룬 영화 *이미테이션 게임*에서 가장 인상적인 대사 중 하나입니다.  
그는 기존 방식으로는 풀 수 없다고 여겨졌던 **에니그마 암호를 해독**하며 전쟁의 흐름을 바꿨습니다.

![Imitation Game](https://blog.plura.io/cdn/column/theory-of-imitation_game.png)

<!--more-->

---

## ❌ 기존 보안 제품의 명확한 한계

수많은 보안 솔루션이 있지만, 대다수는 다음과 같은 한계를 갖고 있습니다.

- **이미 알려진 공격에만 반응**합니다.
- **분석할 충분한 로그가 없습니다.**
- 결국, **공격이 일어나도 무엇이 벌어졌는지 제대로 설명하지 못합니다.**

---

## ✅ PLURA는 다른 출발점에서 시작했습니다

**PLURA**는 사이버보안의 제1원칙(First Principle)인 **로그**에 집중합니다.

> **“로그만 있다면, 대응은 시작될 수 있습니다.”**

하지만 현실은 다릅니다.

- 운영체제(OS) 로그는 기본 설정만으로는 충분히 남지 않습니다.
- 대부분의 웹 서버 로그는 **요청·응답 본문**을 남기지 않습니다.
- 그래서 많은 조직은 공격을 당하고도 **무슨 일이 있었는지 근거를 확보하지 못합니다.**

PLURA는 이 지점을 바꿨습니다.

- **감사정책(Audit Policy)** 으로 OS에서 필요한 로그를 생성하고,
- **웹 요청과 응답의 본문까지 수집**해,
- 통합 저장소에서 **즉시 검색·분석**할 수 있게 만들었습니다.

기존 SIEM이나 일반 로그 수집 체계가 놓치기 쉬운  
**POST Body와 응답 흐름까지 실시간으로 본다**는 점이 바로 차이입니다.

---

## ⚡ 실시간 분석과 자동 대응의 실현

PLURA는 단순한 저장에 머무르지 않습니다.

- 로그 기반의 **실시간 공격 탐지**
- 상관분석을 통한 **위협 판단**
- 탐지 즉시 **EDR 및 WAF 연동 자동 대응**

이제는 더 이상  
‘공격당한 뒤 한참 후에 알게 되는’ 시대가 아닙니다.

**PLURA는 로그를 남기고, 이해하고, 대응까지 이어지게 합니다.**

---

## 🏁 결론

> “**생각지도 못한 누군가가, 누구도 상상하지 못한 일을 해낸다.**”

PLURA가 집중한 것은 화려한 구호가 아니라  
**보안의 본질인 로그**였습니다.

운영체제 로그를 만들고,  
웹 요청·응답 본문까지 수집하고,  
그 흐름을 실시간으로 분석해 대응으로 연결하는 것.

바로 그 점이  
**PLURA-XDR이 다른 보안 제품과 구분되는 이유**입니다.

---

### 📖 함께 읽기
- [앨런 튜링, 위키백과](https://ko.wikipedia.org/wiki/%EC%95%A8%EB%9F%B0_%ED%8A%9C%EB%A7%81)
- [앨런 튜링, 나무위키](https://namu.wiki/w/%EC%95%A8%EB%9F%B0%20%ED%8A%9C%EB%A7%81)
- [The Imitation Game, Wikipedia](https://en.wikipedia.org/wiki/The_Imitation_Game)

### 🚀 PLURA-XDR 소개
- [지금 해킹 공격이 진행 중인지 확인하려면?](https://blog.plura.io/ko/column/why-plura-xdr-merit/)
