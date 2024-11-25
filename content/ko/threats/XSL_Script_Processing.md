---
date: 2021-01-25T00:02:00
description: 
featured_image: 
tags: 
title: "탈륨 (Thallium) 조직, XSL Script Processing 공격 수행 [T1220]"
---

![shutterstock_298555268_0](https://github.com/user-attachments/assets/95568d22-9a84-45f4-901e-854210c30030)

### XSL Script Processing?
공격자는 XSL 파일에 스크립트를 포함하여 애플리케이션 제어를 우회하고 코드 실행을 모호하게 할 수 있습니다.<br>
**마이터에서 T1220**로 관리하고 있는 공격입니다.

### XSL?
XSL (Extensible Stylesheet Language: 확장 가능한 스타일시트 언어) 파일은 일반적으로 XML 파일 내의 데이터 처리 및 렌더링을 설명하는 데 사용됩니다. 
복잡한 작업을 지원하기 위해 XSL 표준에는 다양한 언어로 포함된 스크립팅 지원이 포함되어 있습니다.

공격자는 이 기능을 남용하여 잠재적으로 애플리케이션 제어를 우회하면서 임의의 파일을 실행할 수 있습니다.
최근 탈륨, Dridex 등 악성코드에서도 사용된 기법으로, 정상 윈도우 유틸리티(wmic.exe)를 활용하여 악성 XSL 문서 스크립트 파일을 가져옵니다.
*탈륨: 북한 정부를 배후로 둔 것으로 추정되는 해킹 조직으로, 최근 사설 주식 투자 메신저 프로그램을 변조해 공급망 공격을 수행
![qubit_tt](https://github.com/user-attachments/assets/f5653c30-9007-484b-88bf-3f1e3f55a87b)

### 실행 동영상(XSL Script Processing)
https://youtu.be/1RoD8f8GYcw?si=u_gAMtyKrTqw-WP4
<br><br>

### PLURA에서는 해당 공격에 대해 'XSL 스크립트 처리 [T1220]' 필터 탐지하고 있습니다.
![qubit_t](https://github.com/user-attachments/assets/950a7355-2735-4c39-97ec-8754075e39a4)
<br><br>

### 참조
- https://attack.mitre.org/techniques/T1220/
- https://asec.ahnlab.com/ko/1344/
- https://blog.alyac.co.kr/3489[/fusion_builder_column][/fusion_builder_row][/fusion_builder_container]
