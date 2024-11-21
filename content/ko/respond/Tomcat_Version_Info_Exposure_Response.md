---
date: 2023-10-05
title: "[Apache Tomcat] 버전 정보 노출 대응"
description: "Apache Tomcat에서 버전 정보 노출 방지 설정 방법"
featured_image: ""
tags: ["Apache Tomcat", "보안", "버전 정보", "설정"]
---

![414144141](https://github.com/user-attachments/assets/f4838905-a0e0-4893-916e-6438a23edd86)

### 개요

Apache Tomcat은 기본 설정 상태에서 오류 발생 시 **버전 정보가 노출**될 수 있습니다.  
이는 공격자가 서버의 취약점을 악용할 가능성을 높이므로, **버전 정보를 숨기는 설정**이 필요합니다.

---

### 대응 방법

#### 1. Tomcat 서버 설정 파일로 이동
Tomcat이 설치된 디렉토리의 **`conf`** 폴더로 이동하여 **`server.xml`** 파일을 엽니다.

![1-300x89](https://github.com/user-attachments/assets/816c1b1f-2eaf-410a-be35-9300677ba210)

---

#### 2. HTTP 커넥터 설정 찾기
`server.xml` 파일에서 HTTP 커넥터 설정 부분을 찾습니다.  
해당 설정은 기본적으로 HTTP 요청과 관련된 정보를 포함합니다.

![변경전-300x128](https://github.com/user-attachments/assets/de0433a8-bbf8-466c-89fd-3ab58a94b4cd)

---

#### 3. server.xml 파일 편집
HTTP 커넥터 설정에서 `server.xml` 속성을 추가하거나 수정하여 버전 정보를 숨깁니다.  
예를 들어, "Apache"로 변경하여 노출을 방지합니다.

![변경후-300x134](https://github.com/user-attachments/assets/780fcdc8-d7b0-4e6b-98ff-e1d21bf7dd0a)
 
---

#### 4. 변경 사항 저장
수정한 내용을 저장한 후 편집기를 닫습니다.

---

#### 5. Tomcat 서버 재시작
수정 사항을 적용하기 위해 Tomcat 서버를 재시작합니다.  
Tomcat 설치 디렉토리의 **`bin`** 폴더에서 다음 명령을 실행합니다:

![12312-300x189](https://github.com/user-attachments/assets/d9a368f0-7e01-45e7-899e-d25d7079fe50)

```bash
./shutdown.sh
./startup.sh
```

---

### 결과
이 단계를 완료하면 Apache Tomcat의 **버전 정보가 더 이상 노출되지 않습니다.**  
이를 통해 서버의 보안성을 높이고, 공격 대상이 되는 위험을 줄일 수 있습니다.

---

### 추가 권장 사항
- **정기적인 보안 업데이트**  
  Tomcat 및 서버 운영 체제를 최신 상태로 유지하세요.

- **전문가의 도움 활용**  
  보안 설정 및 서버 운영에 익숙하지 않은 경우 보안 전문가의 상담을 받는 것이 좋습니다.
