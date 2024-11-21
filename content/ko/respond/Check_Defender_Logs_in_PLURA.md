---
date: 2024-03-04
title: "PLURA에서 Microsoft Defender Antivirus 로그 확인하기"
description: "Microsoft Defender와 PLURA를 활용한 보안 로그 관리"
featured_image: ""
tags: ["Microsoft Defender", "보안 로그", "PLURA", "안티바이러스"]
---

![column_20240304](https://github.com/user-attachments/assets/a254870f-a26f-4a89-997c-c93368c40408)

### Microsoft Defender Antivirus란?

**Microsoft Defender Antivirus**는 Microsoft Windows의 내장 바이러스 백신 소프트웨어 구성 요소입니다. [1]  
Defender는 탐지 결과를 로그로 남기며, PLURA는 이 로그를 수집하여 관리자가 악성 감염 및 탐지 이벤트를 효과적으로 파악할 수 있도록 지원합니다.

---

### PLURA를 통해 확인한 Microsoft Defender 로그 사례

#### 첫 번째 로그: ISO 이미지 파일 탐지

![대한산업_01-1024x360](https://github.com/user-attachments/assets/05b23392-5f65-4f1c-b328-0d30002452f8)

- **탐지 내용:** Microsoft Office 관련 ISO 이미지 내부의 `setup.exe` 파일이 Trojan으로 탐지됨.  
- **Defender 조치:** 보호 작업이 실행되어 위협 제거.

> 공격자들이 악성코드를 포함한 ISO 파일을 배포하는 경우가 있으므로, 다운로드 시 주의가 필요합니다.

---

#### 두 번째 로그: PUA 및 악성 IP 탐지

![코리아메디케어_02-1-1536x416](https://github.com/user-attachments/assets/c47daf58-486f-4ccc-b65c-7167c813352d)

- **탐지 내용:** `uTorrent.exe` 파일이 PUA(원치 않는 파일)로 탐지됨.  
- **추가 로그:** 악성 IP로의 접근 시도가 감지됨 (`port 80` 접속 시도).  

> Torrent를 통한 파일 다운로드는 악성코드 감염에 취약하며, 관리자의 통제를 통해 보안을 강화할 필요가 있습니다.

---

#### 세 번째 로그: Backdoor 의심 파일 탐지

![천주교_02-1024x357](https://github.com/user-attachments/assets/106efb22-9b27-4e6f-a395-8bb07c6b03a9)

- **탐지 내용:** 특정 zip 파일 내 `admin`, `root` 경로로 지정된 악성 `asp` 및 `php` 파일 발견.  
- **위험도:** 파일 확장자를 위장하여 악성코드를 숨기려는 의도가 명확.  

> 이러한 로그를 통해 심각한 악성 파일 및 유입 경로를 조기에 탐지하고 대응할 수 있습니다.

---

### Microsoft Defender Antivirus 라이선스 안내

- **Microsoft Defender Antivirus는 무료로 제공됩니다.**
- Windows 10 및 Windows 11 운영 체제에 기본 포함되어 있으며, 별도의 라이선스 구매 없이 실시간 보호 및 악성 소프트웨어 제거 기능을 제공합니다.
- Windows Server에서도 특정 버전에는 Microsoft Defender Antivirus가 포함되어 있으며, 정품 라이선스를 통해 추가 비용 없이 사용할 수 있습니다.
- 고급 보안이 필요한 기업 환경에서는 **Microsoft Defender for Endpoint**와 같은 추가 보안 솔루션이 필요할 수 있습니다.

---

### 외부 참고 자료

[1] [Microsoft Defender Antivirus (Wikipedia)](https://en.wikipedia.org/wiki/Microsoft_Defender_Antivirus)  
[2] [Microsoft Defender Antivirus Troubleshooting](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide)
