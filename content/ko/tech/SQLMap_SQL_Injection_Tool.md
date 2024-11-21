---
date: 2022-06-21T00:00:00
title: "sqlmap"
description: "SQL Injection 탐지 및 악용을 위한 오픈 소스 침투 테스트 도구"
featured_image: ""
tags: ["sqlmap", "SQL Injection", "보안", "침투 테스트", "데이터베이스"]
---

![sqlmap](https://github.com/user-attachments/assets/58985214-005b-412f-8f6c-3fb6719e5925)

## sqlmap이란?

**sqlmap**은 SQL Injection 결함을 감지하고 악용할 수 있는 Python으로 작성된 오픈 소스 침투 테스트 도구입니다.

### 주요 특징
- **지원 데이터베이스**: MySQL, PostgreSQL, Oracle, Microsoft SQL Server 등 최신 데이터베이스에서 작동
- **기능**:
  - DB 취약 여부 확인부터 데이터베이스, 테이블, 컬럼, 데이터 탈취까지 SQL Injection 공격 기술을 자동화
- **지원 SQL Injection 기술**:
  - Error Based
  - Time Delay
  - Stacked Queries
  - Boolean Based
  - Union Based

---

## sqlmap 사용법 및 예제

- [Kali Tools - sqlmap](https://www.kali.org/tools/sqlmap/)
- [sqlmap 공식 사이트](https://sqlmap.org/)

---

## PLURA의 SQL Injection 및 데이터 유출 탐지

### DB 이름 탈취

![DB 이름 탈취](https://github.com/user-attachments/assets/41dd7117-117d-43bb-aaca-9a06df5581de)

---

### 테이블 이름 탈취

![테이블 이름 탈취](https://github.com/user-attachments/assets/7eeefc89-e858-4104-ae44-31085132ecb0)

---

### 컬럼 이름 탈취

![컬럼 이름 탈취](https://github.com/user-attachments/assets/4b601d3f-09e6-4e39-bb3d-578625689dec)

---

### 데이터 정보 탈취

![데이터 정보 탈취](https://github.com/user-attachments/assets/c8d1ac2d-2c3e-49be-bba0-39e939f65160)

---

## Reference

- [University of Toronto - SQLMap](http://www.cs.toronto.edu/~arnold/427/15s/csc427/tools/sqlmap/index.html)
- [sqlmap GitHub Wiki](https://github.com/sqlmapproject/sqlmap/wiki/Usage)
- [BinaryTides - SQLMap Hacking Tutorial](https://www.binarytides.com/sqlmap-hacking-tutorial)
