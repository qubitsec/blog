---
title: "Do We Really Need NIPS/NDR, Even for SMEs or Large Enterprises?"
date: 2024-12-22T00:00:01
draft: false
description: "Why WAF + EDR/HIPS can often be sufficient—unless you're dealing with a highly specialized environment—and the exceptional scenarios where NIPS/NDR may be warranted."
featured_image: "cdn/column/ips_ndr_needed.png"
tags: ["Overengineering", "IPS", "NIPS", "HIPS", "NDR", "Security", "PLURA-XDR"]
---

⛑️Focusing on **small- to mid-sized enterprises (SMEs)**, we revisit the question of whether **NIPS** (Network-based Intrusion Prevention System) and **NDR** (Network Detection & Response)—both network-layer security solutions—are truly indispensable.

🚀 To cut right to the chase: **unless you operate in a highly specialized environment or must comply with specific regulations**, you often do not need NIPS/NDR. In most cases, **WAF + EDR/HIPS** can provide a sufficiently robust security posture.

![NIPS/NDR—Is it really necessary?](https://blog.plura.io/cdn/column/ips_ndr_needed.png)

<!--more-->

---

## 1. **Typical Security Environments for SMEs**

In many **small- to mid-sized enterprises**, the following conditions typically apply:

1. **No Mandatory Regulatory Compliance**

   * Unlike banking/finance or government sectors, there are often no explicit mandates or audit items requiring the adoption of NIPS/NDR.

2. **No OT (Operational Technology), or It Is Isolated**

   * If industrial control systems are used, they may be on **physically separate networks**, making it difficult for typical external threats to penetrate.

3. **90–95% of Attacks Are Web-Based**

   * In reality, most attack vectors involve **HTTP/HTTPS** channels such as SQL injection, XSS, and file upload vulnerabilities.
   * Other protocols—SSH, VPN, RDP—are often **encrypted** or used infrequently, thus narrowing the overall attack surface.

Given that a **majority of threats** enter through web traffic, a **WAF** (Web Application Firewall) combined with **host-based security** (EDR/HIPS) already offers a **significant level of practical defense**.

---

## 2. **Why You Likely Don’t Need NIPS/NDR**

### (1) **Over 90% of Key Threats Are Web Attacks**

* When looking at real-world attack vectors for SMEs, most exploits target **web traffic** (e.g., SQL injection, XSS, file upload vulnerabilities).
* A **WAF** is specialized in mitigating these web threats, while an **EDR** can intercept and block malicious activities once they reach internal systems.

  > 👍 [If you don’t have a WAF yet, it’s time to implement one](https://blog.plura.io/ko/column/web-application-firewall-is-like-a-seatbelt/)
  > 👍 [Introduction to the PLURA-WAF service](https://www.plura.io/platform/waf)

### (2) **Predominantly Encrypted Traffic**

* Today, most protocols (e.g., HTTPS) use **TLS/SSL** encryption, making deep packet inspection by NIPS/NDR difficult.
* Protocols like SSH, RDP, and VPN are restricted to authorized users and are generally handled by **EDR** on the host side, so a separate network-layer solution doesn’t necessarily add significant defensive value.

### (3) **Cost-Effectiveness and Operational Efficiency**

* Beyond **cost**, adopting NIPS/NDR also requires the right **staff** and **technical expertise** to run it effectively.
* From an SME perspective, if **WAF + EDR** already covers most real-world web threats, deploying NIPS/NDR can be **extreme overengineering**.
* **Overengineering** can be counterproductive. Adding functionality beyond your genuine needs only inflates **cost and complexity**, potentially reducing overall security due to the increased burden on personnel and systems.

---

## 3. **Exceptional Situations Where NIPS/NDR May Be Necessary**

Still, **some special cases** may call for NIPS/NDR:

### (1) **Mandatory Regulations or Client Requirements**

* In finance, military, or government sectors, **network-based security solutions** may be required.
* In such cases, NIPS/NDR might be unavoidable.

### (2) **Highly Complex, Large-Scale Networks Using Cleartext Protocols**

* Infrastructures with thousands of servers and a mix of various protocols and services—some of which may be **unencrypted**—could benefit from network-level monitoring and blocking.
* That said, in environments dominated by **encrypted** traffic, NIPS/NDR provides far less value.

### (3) **Specific Industry Protocols Using Cleartext**

* **SCADA/ICS**, certain ERP protocols, or **legacy DB connections** might still transmit data in cleartext.
* In such cases, NIPS/NDR can help monitor and block malicious activity at the **network level**. However,
* Many ICS environments can still be protected via **ICS-specific gateways** or **host-based controls** (agents, host firewalls). Implementing a full-blown NIPS/NDR solution could be **overkill** unless strictly necessary.

---

## 4. **Conclusion: “If You Don’t Have Special Requirements, Don’t Bother with NIPS/NDR.”**

1. **WAF + EDR/HIPS Often Suffices**

   * If **most threats** come via web traffic, WAF filters external attacks while EDR/HIPS detects and blocks malicious processes internally.
   * Access through SSH or RDP can be managed with whitelisting, MFA, or VPN-based **access controls**.

2. **NIPS/NDR: A Solution for “Exceptional” Demands**

   * Without **regulatory obligations**, **large-scale complex networks**, or **specialized protocols**,
   * NIPS/NDR is likely **not cost-effective** and could be **over-specified**, requiring excessive staff time.
   * Even large enterprises, if not bound by compliance or dealing with complex environments, may not need NIPS/NDR.

3. **Focus on “Selectivity and Priority”**

   * For SMEs, where **web attacks** account for 90% (or more) of threats, **robustly managing WAF and host-level security** generally yields better results in both cost and efficiency.
   * Absent any special requirements, it’s more rational to classify NIPS/NDR as a **non-essential** solution.

> **By analogy**:
>
> * “Wearing boots (**WAF**) is often enough to keep your feet dry in the rain.
> * Adding height-boost insoles (**NIPS/NDR**) on top might just introduce **extra cost and discomfort**.
> * **Can you even walk properly that way?**
> * And if the odds of wading through deep puddles are **very low**,
>
>   * Boots alone should suffice to keep your feet dry,
>   * making those **inserts** (NIPS/NDR) an unnecessary case of overkill.

![Boots and height-boost insoles](https://blog.plura.io/cdn/column/ips_ndr_needed-2.png)

---

## ✍️ **Key Takeaways**

* For most standard corporate environments, **WAF + host-based security** is enough to counter common threats.
* If you don’t have **special requirements** (regulations, vast networks, OT/ICS, etc.), NIPS/NDR will likely be **superfluous**.
* Even **large enterprises** without mandated compliance obligations don’t necessarily gain much from NIPS/NDR.
* Considering **cost** and **operational overhead**, using NIPS/NDR only where truly needed is the **smarter choice**.
* Finally, remember that **overengineering** is detrimental.

  * Adding unnecessary layers increases **maintenance points**,
  * and potentially opens doors to system failures or security gaps.

---
