---
date: 2021-01-25T00:02:00
description: 
featured_image: 
tags: ["탈륨", "Thallium", "XSL Script Processing", "T1220", "보안", "공격 기법", "WMIC", "마이터 ATT&CK"]
title: "탈륨 (Thallium) 조직, XSL Script Processing 공격 수행 [T1220]"
---

![shutterstock_298555268_0](https://github.com/user-attachments/assets/95568d22-9a84-45f4-901e-854210c30030)

## XSL Script Processing란?

공격자는 XSL 파일에 스크립트를 포함하여 애플리케이션 제어를 우회하고, 코드 실행을 모호하게 할 수 있습니다.  
이 공격 기법은 **MITRE ATT&CK의 T1220**으로 분류되어 관리되고 있습니다.

---

## XSL이란?

XSL (Extensible Stylesheet Language: 확장 가능한 스타일시트 언어) 파일은 일반적으로 XML 파일의 데이터를 처리하고 렌더링하는 데 사용됩니다.  
XSL 표준에는 복잡한 작업을 지원하기 위해 다양한 언어로 스크립트를 포함할 수 있는 기능이 포함되어 있습니다.

### 악용 사례
공격자는 이 기능을 악용하여 애플리케이션 제어를 우회하고, 임의의 파일을 실행합니다.  
특히 **탈륨** 및 **Dridex**와 같은 악성코드에서 활용되었으며, 정상 윈도우 유틸리티(wmic.exe)를 사용하여 악성 XSL 문서 스크립트 파일을 가져옵니다.

**탈륨(Thallium):**  
북한 정부의 지원을 받는 것으로 추정되는 해킹 조직으로, 최근 사설 주식 투자 메신저 프로그램을 변조하여 공급망 공격을 수행했습니다.  

![qubit_tt](https://github.com/user-attachments/assets/f5653c30-9007-484b-88bf-3f1e3f55a87b)

---

## 실행 동영상 (XSL Script Processing)

[XSL Script Processing 실행 예시](https://youtu.be/1RoD8f8GYcw?si=u_gAMtyKrTqw-WP4)

---

## PLURA의 탐지 및 대응

PLURA는 **'XSL 스크립트 처리 [T1220]'** 필터를 통해 해당 공격을 탐지할 수 있습니다.  
![qubit_t](https://github.com/user-attachments/assets/950a7355-2735-4c39-97ec-8754075e39a4)

---

## 참조 자료

- [MITRE ATT&CK - T1220](https://attack.mitre.org/techniques/T1220/)
- [AhnLab ASEC 블로그](https://asec.ahnlab.com/ko/1344/)
- [알약 블로그](https://blog.alyac.co.kr/3489/)
