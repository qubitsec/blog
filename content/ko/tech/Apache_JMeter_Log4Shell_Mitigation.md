---
date: 2021-12-14T00:00:00
title: "Apache JMeter Log4Shell 대응 방법"
description: "Apache JMeter와 관련된 Log4j 취약점(Log4Shell) 대응 방법"
featured_image: ""
tags: ["Apache JMeter", "Log4j", "Log4Shell", "보안", "취약점"]
---

![blog_banner_20211214](https://github.com/user-attachments/assets/e8398d21-669a-4c03-93bc-63bb2bde8b1a)

Apache 소프트웨어 재단은 Log4j 2에서 발생한 취약점을 해결하기 위한 보안 업데이트를 권고하고 있습니다.  
Apache JMeter는 주로 사용자 PC에서 사용되기 때문에 각별한 주의가 필요합니다.  
이 취약점은 서버뿐만 아니라 클라이언트 환경에서도 영향을 미칠 수 있습니다.

> 공격자는 이 취약점을 이용하여 악성코드 감염 등의 피해를 발생시킬 수 있으므로,  
> **최신 버전으로 업데이트를 진행해야 합니다.**

---

## 대응 방법

Log4j에서 JNDI 파싱은 원격 코드 실행에 대한 취약점을 유발하므로, 해당 기능을 **패치**하거나 **비활성화**해야 합니다.  
다음 중 하나의 방법을 선택하여 진행합니다.

### 1. Log4j 버전 업그레이드
- **Log4j Version 2.15.0 이상**으로 업그레이드 (Java 8 지원 필요)

---

### 2. Log4j V2.10.0 이상인 경우, 아래 방법 중 하나를 사용
- **ⓐ Java 실행 인자(Arguments)에 시스템 속성 추가**  
  ```bash
  -Dlog4j2.formatMsgNoLookups=true
  ```

- **ⓑ Java 실행 계정의 환경 변수 혹은 시스템 변수 설정**  
  ```bash
  LOG4J_FORMAT_MSG_NO_LOOKUPS=true
  ```

---

### 3. Log4j V2.7.0 이상인 경우
- **Log4j 설정 파일 수정**  
  - `log4j.xml` 등 설정 파일에서 `PatternLayout` 속성의 `%m` 부분을 아래와 같이 변경합니다:  
    ```xml
    %m{nolookups}
    ```

---

### 4. Log4j 버전이 위 기준 미만인 경우
- **JndiLookup 클래스와 JndiManager 클래스가 로드되지 않도록 조치**해야 합니다.  
- Log4j Core를 직접 빌드하거나, 프로젝트 내에서 패키지명까지 맞춰 dummy 클래스를 작성하여 비활성화합니다.

---

## 참고 자료

- [Windows ForFiles 명령어 사용](https://docs.microsoft.com/ko-kr/windows-server/administration/windows-commands/forfiles)
