---
title: "Cold‑Boot 공격 다시보기 – RAM 잔류 데이터로 암호화 키를 훔치는 물리적 위협"
date: 2025-06-20
draft: false
description: "2008년 ‘Lest We Remember’ 논문으로 알려진 Cold‑Boot 공격은 2018년 F‑Secure 연구에서 현대 노트북에서도 재현되었습니다. 본 글은 공격 원리·랜섬웨어 시나리오에서의 현실성·TPM·MOR bit 등 실무 대응 방안을 정리합니다."
featured_image: "cdn/tech/cold-boot-attack.png"
tags: ["Cold Boot Attack", "RAM 잔류 데이터", "암호화 키", "BitLocker", "F‑Secure", "물리적 공격", "정보보안"]
---

> **요약 3줄**  
> 1️⃣ Cold‑Boot 공격은 냉각한 RAM 잔류 데이터에서 암호화 키를 추출합니다.  
> 2️⃣ 2008년 프린스턴대 연구로 존재가 입증되었고, 2018년 F‑Secure가 최신 노트북에서도 재현했습니다.  
> 3️⃣ 대규모 랜섬웨어보다 **표적 공격·포렌식**에 현실적이며, TPM 활용·MOR bit 보호가 주요 대응책입니다.

![Cold‑Boot Attack](https://blog.plura.io/cdn/tech/cold-boot-attack.png)

<!--more-->

## 🧊 Cold‑Boot 공격이란?

Cold‑Boot 공격은 시스템 전원을 강제로 차단한 뒤 **DRAM을 급속 냉각**해 데이터 소멸을 지연시키고, 재부팅한 별도 OS로 **RAM 잔류 데이터(remnant data)** 를 덤프해 암호화 키·세션 토큰을 추출하는 물리적 기법입니다.  
주된 목표는 BitLocker·FileVault·LUKS 등의 **디스크 암호화 우회**입니다.

---

## 🗓 역사적 맥락 – 2008 ⇨ 2018 업데이트

| 연도 | 연구/사건 | 주요 내용 |
|------|-----------|----------|
| **2008** | **〈Lest We Remember〉**, 프린스턴대 USENIX Security ’08 | BitLocker·FileVault·TrueCrypt 키를 실제로 복구해 디스크 암호화를 우회 가능함을 시연 :contentReference[oaicite:0]{index=0} |
| **2018** | **F‑Secure “Reinventing Cold‑Boot Attack”** | MOR bit(Memory Overwrite Request) 보호를 끄는 펌웨어 취약점을 이용해 최신 노트북에서도 공격 성공 :contentReference[oaicite:1]{index=1} |

> 🔎 **MOR bit란?** 부팅 시 DRAM을 0x00으로 덮어쓰는 기능입니다. 일부 OEM 펌웨어는 이 비트를 S3/S4 절전 전환 때만 활성화하거나, 디버그 모드에서 비활성화할 수 있어 우회가 가능합니다.

---

## 🎯 랜섬웨어와의 연관성 – 현실적 위협 평가

- **물리적 접근**·**냉각 장비**·**짧은 시간 제약** 때문에 **대규모 랜섬웨어 캠페인**에서 Cold‑Boot 사례는 사실상 보고되지 않았습니다.  
- 다만 **도난 노트북**·**현장 압수 장치** 등 _고가치 타깃_ 에 대한 **표적 공격**이나,  
  **디지털 포렌식**에서 암호화 키 복구 목적으론 여전히 실전 선택지로 고려됩니다.

> 📌 **결론** : 일반 기업 환경에서는 우선순위가 낮지만, **장치 분실·탈취 리스크**가 높은 조직(언론·연구소·금융)이라면 대비가 필요합니다.

---

## 🛡 대응 방안 (Check List)

| 카테고리 | 조치 | 설명 |
|----------|------|------|
| **펌웨어** | **MOR bit 보호 활성화** | BIOS/UEFI에서 “Memory Overwrite Request” 항목 Enabled |
| **암호화 설정** | **TPM + PIN** 방식의 BitLocker | 전원‑OFF 후 부팅 때 추가 인증 필요 |
| **전원 정책** | **Sleep/Hibernate 비활성화** | RAM 콘텐츠를 지속적으로 보존할 필요가 없도록 설계 |
| **보안 칩** | **Apple T2 / MS Pluton** | 암호화 키를 SoC 내부 Secure Enclave에 격리 → DRAM에 평문 키 없음 |
| **물리 보안** | 랩톱 케이블 락·보관 금고 | 물리적 탈취 자체를 차단 |

```powershell
# BitLocker를 TPM+PIN 모드로 전환 (PowerShell/관리자)
Manage-bde -protectors -add C: -TPMAndPIN
````

> ☢ **주의** : BIOS 업데이트나 전원 정책 변경 전, OS‑재설정·백업 절차를 반드시 확인하십시오.

---

## ⚖ 면책 조항

본 글은 교육 목적입니다. 펌웨어 설정 변경·BitLocker 재구성 등 고위험 작업은 **전문가와 상담** 후 진행하십시오. 하드웨어·OEM 모델에 따라 메뉴 구조와 지원 기능이 상이할 수 있습니다.

---

## 🔚 맺음말

Cold‑Boot 공격은 “옛날 해킹 트릭”으로 여겨졌지만, **펌웨어 취약점과 결합**하면 최신 장치도 취약할 수 있습니다.
체계적인 **키 보호 정책(TPM, Secure Enclave)** 과 **물리적 장치 보안**만이 근본적인 방어책입니다.

> **장치를 잃더라도, 데이터까지 잃어서는 안 됩니다.**
> *키를 지키면, 모든 것을 지킬 수 있습니다.*

