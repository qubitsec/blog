---
date: 2021-12-14T00:00:00
draft: false
title: "Apache JMeter Log4Shell 대응 방법"
description: "Apache JMeter와 관련된 Log4j 취약점(Log4Shell) 대응 방법"
featured_image: "cdn/tech/apache_jmeter_log4shell-1.png"
tags: ["Apache JMeter", "Log4j", "Log4Shell", "보안", "취약점"]
---

Apache 소프트웨어 재단은 Log4j 2에서 발생한 취약점을 해결하기 위한 보안 업데이트를 권고하고 있습니다.  
Apache JMeter는 주로 사용자 PC에서 사용되기 때문에 각별한 주의가 필요합니다.  
이 취약점은 서버뿐만 아니라 클라이언트 환경에서도 영향을 미칠 수 있습니다.

> 공격자는 이 취약점을 이용하여 악성코드 감염 등의 피해를 발생시킬 수 있으므로,  
> **최신 버전으로 업데이트를 진행해야 합니다.**

<!--more-->
---

![apache_jmeter_log4shell](https://blog.plura.io/cdn/tech/apache_jmeter_log4shell-1.png)

## 대응 방법

Log4j에서 JNDI 관련 기능은 원격 코드 실행 등의 취약점을 유발할 수 있으므로, 해당 기능을 **패치**하거나 **비활성화**해야 합니다.  
가장 권장되는 방법은 **Apache JMeter 자체를 최신 버전으로 업데이트**하는 것입니다.  
Apache JMeter는 2021년 12월 대응 릴리스인 **5.4.2**에서 Log4j를 **2.16.0**으로 업데이트했습니다.

### 1. Apache JMeter 또는 Log4j 버전 업그레이드
- **Apache JMeter 5.4.2 이상**으로 업그레이드
- 또는 **Log4j Version 2.16.0 이상**으로 업그레이드

---

### 2. 즉시 업그레이드가 어려운 경우
- 가능한 한 빨리 **JMeter 또는 Log4j를 업데이트**해야 합니다.
- 임시 대응으로는 **JndiLookup 클래스가 로드되지 않도록 조치**하는 방법을 검토할 수 있습니다.

---

### 3. 주의 사항
- 기존에 안내되던 아래 방식은 초기 완화책으로 사용되었지만, 이후 추가 이슈가 확인되었습니다.
  ```bash
  -Dlog4j2.formatMsgNoLookups=true
```

```xml
%m{nolookups}
```

* 따라서 위 설정만으로 충분하다고 보기보다, **버전 업그레이드를 우선 적용**해야 합니다.

---

### 4. Log4j 버전이 낮아 즉시 교체가 어려운 경우

* **JndiLookup 클래스와 JndiManager 클래스가 로드되지 않도록 조치**해야 합니다.
* Log4j Core를 직접 빌드하거나, 프로젝트 내에서 패키지명까지 맞춰 dummy 클래스를 작성하여 비활성화합니다.

---

## 📖 함께 읽기

* Apache JMeter Changes History
* Apache Log4j Security Vulnerabilities

---
[1]: https://news.apache.org/foundation/entry/apache-log4j-cves?utm_source=chatgpt.com "Apache Log4j CVEs - The ASF Blog"
[2]: https://jmeter.apache.org/changes_history.html?utm_source=chatgpt.com "History of Previous Changes - Apache JMeter"
