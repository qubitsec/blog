---
date: 2024-03-04
description: 
featured_image: 
tags: 
title: "PLURA에서 Microsoft Defender Antivirus 로그 확인하기"
---

![1](https://github.com/user-attachments/assets/a86fa6bd-605a-46b4-83b2-e16889dc87d4)

**Microsoft Defender Antivirus는 Microsoft Windows의 바이러스 백신 소프트웨어 구성 요소입니다**. [1]

Defender 역시 실행 결과를 Log로 남기며, PLURA는 Microsoft Defender에서 작성하는 Log 역시 가져옵니다. [2]

즉, PLURA의 필터에 매칭되는 alert 뿐 아니라 Defender에서 탐지되는 Host 단의 악성 감염에 대한 alert도 받아보실 수 있습니다.

**PLURA 룰에 매칭되는 Defender의 Log들을 확인해 보겠습니다.**

![대한산업_01-1024x360](https://github.com/user-attachments/assets/c66faa41-45bb-42a8-af63-ee9de9dda521)

#### 첫 번째 로그입니다.
위 로그는 Host 단에서 설치한 것으로 예상되는 파일에 관련된 탐지였습니다.

**"Microsoft Office 관련 ISO 이미지 파일로 해당 ISO 파일 내부의 setup.exe 파일이 Trojan으로 탐지되었습니다."**


![대한산업_02-1024x271](https://github.com/user-attachments/assets/5752f1a2-d764-4a08-b353-e436c0401778)

이어서 Defender의 조치 내용에 대한 로그도 확인할 수 있었고, 위의 경우에는 보호 조치가 진행되었습니다.

공격자들은 악성코드를 심어둔 ISO 파일을 유포하기도 합니다. 따라서 ISO 파일을 다운로드할 때에는 주의가 필요합니다.

Defender의 오진일 수 있으나 ISO 파일의 설치 및 유입 경로 등 관리자들이 특이 사항을 확인해 볼 필요가 있는 내용으로 보입니다.

![코리아메디케어_01-1](https://github.com/user-attachments/assets/b11d0c20-271e-441a-b85e-8bac9fe48c96)

#### 다음으로 두 번째 로그입니다.
위 로그도 역시 Host 단에서 설치한 것으로 예상되는 파일에 관련된 탐지입니다.

'Windows Defender 멀웨어 탐지'라는 필터와 같이 '사용자 동의 없이 설치된 소프트웨어'라는 필터가 같이 탐지되었으며, 해당 로그에서 PUA는 원치 않는 파일을 의미합니다.

**"탐지된 파일은 uTorrent.exe로 해당 파일에 포함되는 Conduit engine(광고 엔진) 등을 Defender에서 원치 않는 파일로 간주하는 것으로 예상됩니다."**


![코리아메디케어_02-1](https://github.com/user-attachments/assets/1a5c3489-8de6-46bf-b4bb-138501025860)

같이 탐지된 필터로 **'악성 IP 주소 접속 시도 (port 80)' 필터**가 있었으며, 내부에서 uTorrent와 관련된 IP로 80 접근 시도가 확인되었습니다.

Torrent를 통한 파일 다운로드의 경우 악성코드 감염에 매우 취약하여 권장하지 않으며, 위와 같은 내용이 관리자에게 제공된다면 관리자의 통제하에 진행할 수 있을 것으로 보입니다.


![천주교_02-1024x357](https://github.com/user-attachments/assets/b0d3df15-7e15-4f91-abf2-3a3b9f843b5e)
![천주교_01-1024x400](https://github.com/user-attachments/assets/791169b2-3bf3-440d-98de-8e1d02c99018)

#### 마지막 세 번째 로그입니다.
위 로그는 Defender가 backdoor 의심 파일을 탐지한 내용이 PLURA의 **'Windows Defender 멀웨어 탐지'** 필터에 매칭된 로그입니다.

특정 zip 파일의 내부에 admin, root 경로로 지정된 asp 파일들, jpg 파일로 보이기 위한 asp와 php 파일들이 확인되었습니다.

위험해 보이는 경로에 확장자를 속이려는 의도가 명백한 악성 파일이 확인됩니다.

이런 심각한 악성파일이 발견되어도 Host 단에서는 흘려 넘기는 경우도 다수 있을 것이며, 남겨진 악성코드와 조치 없는 유입 경로는 보안 사고로도 이어질 수 있습니다.

**이와 같이, Defender의 Critical Log를 관리자가 인지할 수 있다면 그에 대한 조치와 예방이 가능합니다**.

> 아직까지 Defender 설치 및 운영에 소극적이라면  
> 반드시 지금 바로 사용하길 권해 드립니다. by PLURA

---

**Q. Microsoft Defender Antivirus 라이선스에 대하여 설명해 주세요**

> **Microsoft Defender Antivirus는 Microsoft Windows에 내장된 안티바이러스 및 안티멀웨어 솔루션입니다.**  
> **사용자는 별도의 라이선스 비용 없이 이 소프트웨어를 사용할 수 있으며, Windows 운영 체제의 유효한 라이선스를 보유하고 있다면 추가 비용 없이 Microsoft Defender Antivirus의 기능을 이용할 수 있습니다.**  
> **이는 개인 사용자와 기업 사용자 모두에게 해당됩니다.**
> 
> Windows 10 및 Windows 11에 기본적으로 포함되어 있는 Microsoft Defender Antivirus는 실시간 보호, 바이러스 및 기타 유해 소프트웨어 감지, 그리고 악성 소프트웨어의 제거 기능을 제공합니다. 이러한 기능들은 운영 체제의 일부로 제공되기 때문에 별도의 소프트웨어 구매나 설치 없이 자동으로 활성화되고 업데이트됩니다.
> 
> Windows Server 환경에서도, 특정 버전의 Windows Server에는 Microsoft Defender Antivirus가 포함되어 있으며, 서버 운영 체제를 정품으로 구매한 경우 이 기능을 추가 비용 없이 사용할 수 있습니다. 그러나 서버 용도와 설정에 따라 Microsoft Defender Antivirus의 설치 및 활성화 절차가 다를 수 있습니다. 또한, 고급 보안 기능이나 관리 기능이 필요한 기업 환경에서는 Microsoft Defender for Endpoint와 같은 추가적인 보안 솔루션을 구매해야 할 수도 있습니다.
> 
> 요약하자면, **Microsoft Defender Antivirus는 Microsoft Windows 운영 체제에 포함된 무료 안티바이러스 솔루션입니다**. 사용자는 Windows의 정품 라이선스를 통해 이 솔루션을 이용할 수 있으며, 별도의 라이선스 구매 없이 보안 기능을 사용할 수 있습니다. 기업 환경에서는 추가 보안 요구 사항을 충족하기 위해 별도의 보안 솔루션 구매를 고려해야 할 수 있습니다.
> 
> by ChatGPT v4.0

**외부 참고 사이트**

[1] [Microsoft Defender Antivirus](https://en.wikipedia.org/wiki/Microsoft_Defender_Antivirus)  
[2] [Review event logs and error codes to troubleshoot issues with Microsoft Defender Antivirus](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/troubleshoot-microsoft-defender-antivirus?view=o365-worldwide)
