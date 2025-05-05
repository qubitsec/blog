---
title: "양자컴퓨팅 시대의 암호기술: AES, SHA-3, RSA, ECC, PQC 정리"
date: 2025-05-05
draft: true
description: "양자컴퓨팅으로 인한 기존 암호기술의 영향 및 PQC 대안, 적용 시기 정리"
featured_image: "cdn/column/quantum-era-cryptography.png"
tags: ["암호", "양자컴퓨팅", "PQC", "AES", "SHA-3"]
---

아래 내용을 바탕으로 **양자컴퓨팅이 현재 주요 암호 알고리즘에 미치는 영향**, **대응방안(PQC)과 우리의 선택지**, **실제 상용화 시점**을 간략히 정리해보겠습니다.

---

## 1. 주요 알고리즘이 양자컴퓨팅에 영향을 받는지 여부

1. **AES (대칭키 암호)**

   * **영향:** 양자 알고리즘 Grover에 의해 ‘키 검색’이 어느 정도 가속될 수 있으나, AES-256 기준으로 키 공간이 2^256 → 2^128 정도로 줄어드는 수준이므로 여전히 안전 여력이 있음.
   * **결론:** AES는 대칭 암호로서 충분히 큰 키 길이를 사용하면 양자 컴퓨팅 시대에도 계속 안전하게 사용 가능.

2. **SHA-3 (해시 함수)**

   * **영향:** 마찬가지로 Grover 알고리즘에 의해 2^n → 2^(n/2) 정도로 공격 난이도가 내려갈 수 있으나, SHA-3-512(출력 512비트) 사용 시 2^256 수준의 보안성 확보 가능.
   * **결론:** SHA-3 역시 양자 환경에서도 충분한 안전성을 유지함.

3. **RSA, ECC (비대칭키 암호)**

   * **영향:** 양자 알고리즘 Shor에 의해 소인수분해(RSA)나 이산로그(ECC) 문제가 다항 시간에 해결되므로, 이론상 **완전히 붕괴**.
   * **결론:** 양자컴퓨터가 충분한 규모로 구현될 경우 RSA와 ECC는 더 이상 안전하지 않으므로, **PQC로의 전환**이 필수.

---

## 2. 영향을 받는다면 어떤 대안이 있으며, 우리의 선택지는 무엇인가?

1. **Post-Quantum Cryptography(PQC)**

   * **NIST 표준 후보**

     * **키 교환(KEM):** CRYSTALS-Kyber, HQC
     * **디지털 서명:** CRYSTALS-Dilithium, SPHINCS+ (추가로 FALCON 표준화 예정)
   * **특징**

     * 격자 기반(Lattice-based), 코드 기반(Code-based), 해시 기반(Hash-based) 등 다양한 수학적 난제 활용
     * 양자컴퓨터의 Shor 알고리즘으로도 쉽게 풀리지 않는 구조 설계

2. **대칭 암호(AES) + PQC 조합**

   * **대칭 암호:** AES-256, 해시 함수는 SHA-3
   * **비대칭 키 교환/서명:** PQC 알고리즘 (Kyber, Dilithium 등)

3. **현실적인 선택 시나리오**

   * **하이브리드 방식**: 기존 RSA/ECC를 유지하면서, PQC 알고리즘을 병행 사용
   * 또는 **완전 교체**: PQC가 표준화되고 검증된 이후, 단계적으로 교체 진행

---

## 3. 언제쯤 일상적으로 사용될 것인가?

1. **표준화 시점**

   * NIST는 2024년경 Kyber, Dilithium, SPHINCS+ 등을 최종 표준으로 발표(예정).
   * 이후 IETF 등 국제 표준화 기구를 통해 TLS 등 네트워크 프로토콜에 반영.

2. **상용 제품 반영**

   * 이미 Google, Cloudflare 등에서 PQC-TLS 실험 서비스 중.
   * OpenSSL 3.1+와 `liboqs` 연동 등을 통해 하이브리드 모드 지원.
   * **2025\~2027년** 사이에 브라우저, 서버 등의 대규모 업그레이드가 이뤄져 상용화 확산 예상.

3. **완전 보편화 전망**

   * 양자컴퓨팅 하드웨어 성숙도에 따라 다소 유동적이지만, 2030년 전후로는 **“PQC + AES/SHA-3”** 조합이 **디폴트**로 자리 잡을 가능성이 높음.

---

## 결론

1. **대칭 암호(AES)와 SHA-3**는 양자 환경에서도 비교적 안전하므로, 기존 인프라에서 그대로 유지 가능.
2. **RSA와 ECC**는 양자컴퓨팅에 의해 깨질 우려가 커, \*\*PQC(포스트 양자 암호)\*\*로 전환이 필수적.
3. **NIST 표준(PQC) 발표**에 따라 2025\~2027년 사이에 **TLS, OpenSSL** 등 핵심 인프라에서 본격적으로 적용될 것이며, 그 후 빠르게 보편화될 전망.

---

## 참고자료

* [NIST: Post-Quantum Cryptography](https://csrc.nist.gov/Projects/post-quantum-cryptography)  
* [IETF: Post-Quantum Cryptography for Engineers](https://datatracker.ietf.org/doc/draft-ietf-pquip-pqc-engineers/)  
* [Google Security Blog: Experimenting with Post-Quantum](https://security.googleblog.com/2016/07/experimenting-with-post-quantum.html)  
* [Cloudflare Blog: Post-Quantum for All](https://blog.cloudflare.com/post-quantum-for-all/)  
* [OpenSSL & liboqs Collaboration](https://github.com/open-quantum-safe/oqs-provider)  
