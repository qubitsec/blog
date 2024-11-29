---
date: 2023-10-05
title: "[Apache Tomcat] 버전 정보 노출 대응"
description: "Apache Tomcat 서버의 버전 정보 노출을 방지하기 위한 설정 방법"
featured_image: ""
tags: ["Apache Tomcat", "보안", "버전 정보", "서버 설정", "취약점 대응"]
---

![Apache Tomcat Logo](https://github.com/user-attachments/assets/f4838905-a0e0-4893-916e-6438a23edd86)

## 개요

Apache Tomcat은 기본 설정 상태에서 **오류 발생 시 서버 버전 정보가 노출**될 가능성이 있습니다.  
이는 공격자가 서버의 취약점을 악용할 가능성을 높이므로, **버전 정보를 숨기는 설정**이 반드시 필요합니다.

---

## 대응 방법

### 1. Tomcat 서버 설정 파일로 이동
Tomcat 설치 디렉토리의 **`conf`** 폴더로 이동하여 **`server.xml`** 파일을 엽니다.

![server.xml Example](https://github.com/user-attachments/assets/816c1b1f-2eaf-410a-be35-9300677ba210)

---

### 2. HTTP 커넥터 설정 찾기
`server.xml` 파일에서 HTTP 커넥터 설정 부분을 찾습니다.  
해당 설정은 기본적으로 HTTP 요청과 관련된 정보를 처리합니다.

![HTTP Connector Example](https://github.com/user-attachments/assets/76dd05ab-dbed-46de-ab0d-d791c8d6a6f6)

---

### 3. server.xml 파일 편집
HTTP 커넥터 설정에서 버전 정보 노출을 방지하기 위해 아래와 같이 `server` 속성을 추가하거나 수정합니다.

```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           server="Apache"/>
```

![server.xml Edited](https://github.com/user-attachments/assets/49e0a350-d94c-4c68-b437-04cf49233c1c)

이 설정은 Tomcat의 응답 헤더에서 **버전 정보가 노출되지 않도록** 조정합니다.

---

### 4. 변경 사항 저장
수정한 내용을 저장한 후 편집기를 닫습니다.

---

### 5. Tomcat 서버 재시작
수정 사항을 적용하기 위해 Tomcat 서버를 재시작합니다.  
Tomcat 설치 디렉토리의 **`bin`** 폴더에서 아래 명령어를 실행합니다:

```bash
./shutdown.sh
./startup.sh
```

![Restart Tomcat](https://github.com/user-attachments/assets/d9a368f0-7e01-45e7-899e-d25d7079fe50)

---

## 결과

이 단계를 완료하면 Apache Tomcat의 **버전 정보가 더 이상 노출되지 않습니다.**  
이를 통해 서버의 보안성을 강화하고, 공격자가 취약점을 악용할 가능성을 줄일 수 있습니다.

---

## 추가 권장 사항

- **정기적인 보안 업데이트**  
  Tomcat 및 서버 운영 체제를 최신 상태로 유지하세요. 최신 패치가 적용되지 않은 서버는 여전히 공격에 노출될 수 있습니다.

- **서버 보안 점검 수행**  
  서버 로그를 정기적으로 확인하고, 보안 취약점 점검 도구를 활용하여 추가적인 위험 요소를 탐지하세요.

- **전문가의 도움 활용**  
  서버 설정에 익숙하지 않거나 추가 보안 조치를 원할 경우, 보안 전문가의 상담을 받는 것을 권장합니다.
