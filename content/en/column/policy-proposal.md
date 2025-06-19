---
title: "[Policy Proposal] South Korea's Hacking Problem Stems from Government Certification Systems"
date: 2025-06-15
draft: false
description: "Recurring hacking incidents are no longer the fault of individual companies. Government-mandated, formality-driven systems such as ISMS, CC Certification, and Security Conformity Certification are actively obstructing effective security. This is a clear failure of administration. PLURA calls for the abolishment of certification regimes and proposes a practical, web-based defense strategy as a viable alternative."
featured_image: "cdn/column/policy-proposal.png"
tags: ["Information Security Policy", "Software Certification", "ISMS", "ISMS-P", "Security Function Certificate", "Abolish Certification", "Security Breach", "Security Workforce Waste", "PLURA", "Web-Based Defense", "MITRE ATT&CK"]
---

# Abolishing Korea’s Information Security Certification System and Implementing a Complete Attack Response Strategy

> **The government-mandated security certification system has failed to prevent actual hacking.**  
> **Hacking response failure is no longer a corporate issue—it’s a failure of government policy.**

<!--more-->

![Policy Proposal](https://blog.plura.io/cdn/column/policy-proposal.png)

## 1. Introduction

Korean companies and institutions commonly use government-authorized information security certification systems such as the **Information Security Management System (ISMS·ISMS-P)**, **Common Criteria (CC) Certification**, and **Security Conformity Certification** to demonstrate their security posture. However, a string of recent hacking incidents—including *YES24, GS Retail, Boramae Hospital,* and even telecom giant *SK Telecom*—have occurred despite these entities holding valid certifications, fueling ongoing debates over the **effectiveness of these systems**.

YES24 obtained ISMS-P certification in 2023, but according to domestic media reports from June 9–12, 2025, it suffered a ransomware attack that shut down its services for four days. Similarly, SK Telecom, which renewed its ISMS-P in early 2025, confirmed a breach just six months later that exposed **26.95 million subscriber identifiers** (IMSI·ICCID). These two cases fundamentally challenge the notion that "**certification equals safety.**"

**These repeated failures surrounding security certification systems are not merely due to corporate negligence—they represent a failure in policy design that fails to keep pace with evolving threat models.** The private sector has faithfully followed the standards, but the standards themselves have proven inadequate against modern threats.

This has also created a serious structural issue in which **security professionals are excessively diverted from actual defense work into documentation for certification audits.** In one major company, it was reported that approximately **30% of internal security staff** were engaged in annual certification maintenance projects, with over **three months** typically spent on document preparation and procedural verification.

Ultimately, the root cause of hacking incidents lies not in corporate carelessness but in a **policy framework that refuses to modernize an outdated certification system.** Without a policy-level shift, the same failures will continue to occur.

This article outlines these systemic flaws through real-world examples and proposes a more **effective and practical response strategy.**

---

## 2. Structural Limitations of the Certification System and Recurring Breach Cases

### 1) Structure and Limitations of Information Security Certification Systems

South Korea’s ISMS/ISMS-P certifications are government-recognized systems that verify whether an organization’s information security management system meets a certain level. The certification evaluates a total of 101 criteria through document reviews and on-site inspections. CC (Common Criteria) certification assigns a security grade (EAL) to IT products based on international standards, while the Security Conformity Certification assesses the stability of IT systems used in public institutions.

While these systems contribute somewhat to establishing a basic protection framework, they are built around a structure where **meeting a fixed set of evaluation items guarantees certification**, resulting in companies having **little incentive to continuously enhance their security posture**. As a result, many organizations simply aim to **check off the required boxes**.

In particular, during the preparation and audit process, **specialized security personnel are often tied up for several months addressing formal checklist items**, pushing actual threat detection and response activities to the background. For small and mid-sized enterprises or organizations with limited security staff, the **resources consumed for certification can actually weaken their real security capabilities**.

### 2) Real-World Hacking Incidents Reveal the Lack of Certification Effectiveness

**YES24**, a company with ISMS-P certification, suffered a ransomware attack between June 9–12, 2025, which paralyzed its website and app services for four days. Despite expanding its security budget by over **30%** compared to the previous year, the attack was not prevented. Follow-up reports indicated delays in requesting technical assistance from KISA during the early response phase, which prolonged recovery. This highlights a **failure of effective incident response mechanisms**.

**GS Retail**, also ISMS-P certified (since 2022), experienced a breach between December 27, 2024, and January 4, 2025, during which its convenience store website was hacked and the personal data of approximately **90,000 customers** was leaked. An additional **1.58 million records** were reportedly leaked from **GS Home Shopping**, another group affiliate, raising concerns about a **possible chain breach**.

**SK Telecom** renewed its ISMS-P certification in October 2024, but in April 2025, it was belatedly revealed that **26.95 million subscriber identifiers** (IMSI·ICCID) had been leaked. As a telecommunications provider dealing with massive data flows, this case reconfirmed that **certification alone is insufficient to prevent large-scale breaches**.

**Boramae Hospital**, operated by the Seoul Metropolitan Government, also held ISMS-P certification (2023), yet on February 18, 2025, its IT systems were paralyzed for 11 hours, causing outpatient services to halt. Investigators gave a preliminary conclusion of a **ransomware attack (still under investigation)**.

#### Breach Statistics

According to statistics from KISA, the number of breach reports from ISMS-certified companies surged from **6 in 2021 → 13 in 2022 → 101 in 2023**, with **96 cases reported in 2024**—remaining at a double-digit level. This clearly demonstrates that **certification does not equate to immunity from security breaches**.

### 2‑1) Summary of Certification System Design Limitations

| System          | Key Limitations                                                                                                                        |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| ISMS / ISMS‑P   | ▸ Checklist-based evaluation → **Lack of incentives for continuous security enhancement**<br>▸ **No evaluation of real-world defense capability or MFA implementation**<br>▸ **Security staff excessively tied up with certification work → Weakens hands-on response capacity** |
| CC Certification| ▸ Actual operational settings and tuning are outside certification scope<br>▸ **Cannot keep up with frequent update cycles in CI/CD environments**                                                  |
| Security Conformity Certification | ▸ Insufficient post-certification monitoring and renewal procedures<br>▸ **Heavy administrative burden during audits → Increased strain on small organizations**                        |

In the industry, ISMS is often compared to a "**health checkup**." Just as being declared ‘healthy’ doesn’t prevent illness, earning certification does not guarantee immunity from hacking.

---

### 2‑2) Summary of Ineffectiveness Based on Incident Cases

| Case                 | Certification Status (Date Acquired/Renewed) | Incident / Damage (Source)                                                    | Key Implications                                                    |
| ------------------- | -------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| **YES24**            | ISMS‑P (2023)                                | June 9–12, 2025: Ransomware infection → Website/App disabled, user data at risk (ETNews, June 15, 2025) | ▸ Delayed initial response → **Lack of effective incident response system**<br>▸ Focused on certification upkeep → Lack of real-world incident drills |
| **GS25 (GS Retail)** | ISMS‑P (2022)                                | Dec 27, 2024 – Jan 4, 2025: Hacked → 90,000 customers’ data leaked (Asia Economy, Jan 8, 2025) | ▸ **Poor defense against credential stuffing/login attacks** → No certification evaluation for modern credential attacks |
| **GS Shop**          | Same corporate group                         | June 21, 2024 – Feb 13, 2025: Additional breach indications → ~1.58M records estimated leaked (MoneyToday, Feb 14, 2025) | ▸ **Cascade breach across group systems** → Certification does not ensure **organization-wide integrated control** |
| **SK Telecom**       | ISMS‑P recertified (Oct 2024)                | April 2025: **26.95 million** subscriber identity records leaked (IT Chosun, May 19, 2025, media estimates) | ▸ Even the largest telecom provider is not exempt → Certification **ineffective against large-scale data breaches** |
| **Seoul Boramae Hospital** | ISMS‑P (2023)                           | Feb 18, 2025: System failure → 11-hour outpatient service disruption, **suspected ransomware** (Security News, Feb 20, 2025) | ▸ Risk of **critical service paralysis in medical institutions** → **Gaps in protecting public infrastructure** despite certification |

---

### 3) [Report] [Why the ISMS Certification System Is No Longer Valid]

This report analyzes the **technical limitations of the cybersecurity certification system through four key cases**. In addition to the structural issues in system design, it also addresses the **lack of response standards for modern attacks** such as credential stuffing and Living off the Land (LoL).

1. **The mandatory deployment of Intrusion Prevention Systems (IPS) highlights the technical disconnect with today’s encryption-centered communication environment.**  
   Despite IPS being considered a required system in security certification standards, it cannot effectively analyze encrypted traffic over SSL/TLS. Today, more than 95% of all internet traffic is encrypted (e.g., HTTPS), and while some TLS traffic can be partially analyzed via decryption appliances, **SSH, RDP, VPN, and proprietary encryption protocols** are practically **impossible to decrypt or inspect**. Modern malware like **BPFDoor** even disguises itself within encrypted SSH sessions to evade detection. Thus, the obligation to implement IPS—designed for plaintext traffic in the 1990s–2000s—has become a prominent example of outdated and ineffective requirements in today’s environment of **invisible traffic**.

2. **The effectiveness of annual vulnerability assessments and penetration testing is no longer sufficient to keep up with the evolving threat landscape.**  
   There is growing criticism that annual vulnerability scans and pentests cannot address the constant emergence of new security threats. In 2024 alone, over 29,000 public CVEs were published (an average of 80 per day), creating structural **gaps between testing intervals**. Especially problematic is the use of **pre-agreed IP ranges and credentials** during pentests, which diverges significantly from real-world attack methods—leading many to view these assessments as procedural formalities rather than exercises in improving actual readiness.

3. **The certification practice around antivirus software adoption is also disconnected from technical realities.**  
   Microsoft **Defender** now includes advanced detection and real-time response features and received perfect **6/6 scores** in detection, performance, and usability in AV-TEST’s Nov–Dec 2024 evaluation. Yet some certification frameworks and review practices still **prioritize the use of paid antivirus software as a “proof of enhanced security”**, reflecting an outdated mindset where **“what was purchased” is valued more than “how well it defends.”**

4. **The certification system is severely lacking in its ability to address modern attack techniques.**  
   **Credential stuffing** and **Living off the Land (LoL)** attacks are inherently hard to detect using traditional security tools. Credential stuffing requires **MFA and anomalous login detection** to be blocked effectively, and LoL attacks—especially **fileless** ones—can only be identified using **EDR-based behavior analysis**. However, the current certification system offers **little to no specific requirements for detection or response** to these techniques, covering them only under generic access control or log management policies—making it difficult to verify if an effective defense is truly in place.

In summary, the current security certification system faces **technical limitations that prevent it from addressing encrypted traffic, modern attack methods, and the realities of security operations**. Formal equipment checklists and periodic audits alone cannot defend against real-time threats, rendering the system **ineffective**.

A transition is now imperative—not toward rigid standards, but toward a **dynamic, continuous-response, and autonomously operated security framework**.

---

## 3. Practical Alternatives to Replace Formal Certifications

To improve actual security posture on the ground, organizations must go beyond formal certifications and adopt **effective technical and operational strategies**. Solutions such as those promoted by **PLURA** offer **web-based threat response frameworks** that go beyond supplementing existing standards and represent **realistic, comprehensive alternatives**:

### 1) Web Application Firewall (WAF) Deployment and Real-Time Tuning

Web services are frequently targeted by various types of web-based intrusions such as SQL injection and XSS attacks. A **WAF** serves as the first line of defense by blocking these malicious web requests in real time. The key is to **configure the WAF precisely and continuously tune it**. For instance, by performing **real-time log monitoring**, early signs of **mass SQL injection scanning** or **credential stuffing** can be detected, allowing rapid adjustment of WAF or firewall settings to minimize damage. Since attackers attempt to bypass WAFs using techniques like **double URL encoding** or **special character obfuscation**, security teams must analyze **evasion patterns in logs** to strengthen WAF rules.

Traditional inline (bridge) setups require the WAF to be directly connected on the L2 path, presenting risks of bypass and hardware dependency in case of failures. In contrast, a reverse proxy-based WAF terminates TLS sessions, enabling full inspection of encrypted traffic, and ensures service availability by allowing quick rerouting via GSLB or DNS in the event of downtime.

Notably, proxy-based WAFs support autoscaling and automatic ruleset synchronization (virtual patching) in container and Kubernetes environments, naturally integrating into DevSecOps pipelines. This ensures consistent application of security policies across all nodes, significantly improving responsiveness to real-time and sophisticated web threats while maintaining performance and scalability.

### 2) Integrated Web Log Monitoring and Anomaly Detection

Modern attacks are increasingly sophisticated and often unfold over multiple stages in stealthy ways. Therefore, **focusing only on individual requests** may lead to missing critical attack signs. Instead, **continuously collecting and analyzing full web traffic logs** provides deeper and broader security insights. Emerging threats like **zero-day attacks** and **credential stuffing** (mass login attempts) often blend into normal logs, so identifying them requires observing unusual traffic patterns and repeated error attempts **in aggregate**. For example, login failures from dozens of IPs might appear to be isolated issues, but **analyzing the entire log trend reveals large-scale brute-force attacks**. Similarly, **web shell uploads** or **parameter tampering for privilege escalation** can only be understood through comprehensive log analysis.

A practical technology stack for implementing this is the **SIEM–UEBA layer**. **PLURA-XDR** builds the data collection and storage layer, linking a rule/statistics-based SIEM (Security Information and Event Management) and its proprietary UEBA (User & Entity Behavior Analytics) engine into a single pipeline. The collected logs are correlated in real time based on attacker TTP patterns, and the resulting **Anomaly Score** is visualized on the dashboard. This integrated monitoring system captures behavioral anomalies—often overlooked by traditional certification frameworks—within seconds, greatly enhancing incident response capabilities.

### 3) Advanced Audit Logging and Internal Security Monitoring

Beyond visible web attacks, detecting **anomalies within the system itself** is equally important. To achieve this, you must activate **advanced audit policies on servers and OSes**, leaving detailed **audit logs** (event logs) for analysis. In the case of **Windows Advanced Audit Policy**, it allows detailed logging of various security events that are not recorded by default. In Linux environments, tools like **Auditd** and **eBPF-based LSM (audit-ebpf)** enable precise tracking of kernel calls and file/process events.

These collected event logs should be integrated into an **automated analysis and response loop via EDR/platform connections**. For example, the **PLURA-XDR EDR** module collects both audit logs and endpoint telemetry, instantly isolating or terminating processes and creating incident tickets for activities like **suspicious PowerShell execution, abnormal use of admin accounts, or large-scale data exfiltration**. As emphasized in the PLURA blog, “**Advanced audit policies are not just logging tools but essential security systems for detection and prevention.**” Strengthening such **internal audit log monitoring frameworks** plays a critical role in **preventing security incidents beforehand** and minimizing potential damage.

### 4) The Need to Transition to MITRE ATT&CK Framework-Based Operations

MITRE ATT&CK is a globally recognized knowledge base that categorizes real-world cyber attack techniques into tactics and techniques. It has become one of the most practical standards for responding to cyber threats today. Organizations can use this framework to diagnose which attack methods their current security systems are prepared for and identify specific areas of vulnerability. For example, by referencing the MITRE ATT&CK matrix, one can assess whether essential logs are being collected by tactic and technique, and whether proper detection and response rules are in place.

Practical implementation involves using open-source tools like **CALDERA** and **Atomic Red Team** to automate **adversary emulation**, and quantifying the results using KPIs such as **Detection Coverage %** and **Mean Time To Detect (MTTD)**. **PLURA-XDR** integrates CALDERA scenarios with collected logs to visually map out coverage, enabling rapid identification of "**detection blind spots**" and the addition of corresponding detection rules.

Whereas traditional certification frameworks rely on documentation and formal evaluation, MITRE ATT&CK-based assessments verify actual security capabilities. In particular, rather than relying on costly third-party penetration tests, implementing an **internal, continuous evaluation system based on MITRE ATT&CK** proves to be far more practical and effective.

Therefore, policymakers must move beyond conventional certification reviews and consider **reforming the system to grant certification only to organizations with MITRE ATT&CK-based adversary simulation and log-driven response frameworks**. This shift changes the focus from evaluating whether "security exists" to verifying whether "actual response capabilities are in place."

Operating under MITRE ATT&CK is essentially **a defense strategy that audits systems from the attacker’s perspective**, providing a key approach to overcoming the limitations of current certification systems and genuinely improving national cybersecurity standards.

### 5) Accelerating “Detection → Sample Analysis → Response” with LLM Integration

Traditional security solutions, based on rules, signatures, and whitelists, are **effective against known attacks**, but **struggle with new vulnerabilities and mutation-based threats**. To address this, organizations can integrate **Large Language Models (LLMs, e.g., GPT)** to identify and analyze **high-risk logs indicative of potential zero-day attacks**, reclassifying them based on semantic understanding.

The LLM receives **sampled events** from detection logs collected by WAFs or EDRs, summarizing within seconds the **attack intent, similar case references, and recommended responses**. For example, it can identify suspicious elements in unstructured logs — such as **unusual URIs, User-Agents, and abnormal header combinations** — and tag them as “suspected novel attacks.” These can then be fed into an automated response system to trigger **real-time blocking or ruleset (virtual patch) updates**.

In essence, an LLM is not a one-size-fits-all engine, but performs best when used as an **intelligent analyst alongside the detection system**, helping security teams **minimize the time and personnel gap in responding to zero-day threats**.

By simultaneously applying these **five practical strategies** — **perimeter defense (WAF)**, **visibility (logs and auditing)**, **internal response (EDR)**, **attacker-oriented validation (ATT&CK)**, and **AI-driven novel threat analysis (LLM)** — organizations can establish a **fully integrated threat prevention system**. This results in a **near-perfect cybersecurity environment** capable of **real-time detection, blocking, and adaptation even against emerging zero-day threats**.

### [PLURA-XDR] [Cybersecurity Campaign for Complete Response]

---

## 4. Conclusion

As we have examined, South Korea’s information security certification systems—such as ISMS, CC Certification, and Security Conformance Certification—remain **formalistic frameworks that only evaluate basic security management**, revealing clear limitations in effectively responding to rapidly evolving cyber threat environments.

In particular, the **“three-year periodic certification” approach for software-based security products and systems is completely detached from today’s reality.** Modern cybersecurity products are updated multiple times a day, and their configurations and detection logic are adjusted in real time based on emerging threats.

For example:

* Web Application Firewall (WAF) detection signatures are updated multiple times a day to counter new attacks.
* Endpoint Detection and Response (EDR) products continuously update their AI-based detection models and policies.
* Cloud-based SaaS security solutions follow a **CI/CD** model where new features are deployed frequently.

In such environments, **pre-certification on a multi-year basis is not only meaningless but actively hampers the flexibility** required of modern security solutions that must respond rapidly to threats.

Furthermore, the current certification regime **wastes substantial time and resources**. Many companies dedicate internal security personnel for months to prepare documentation and respond to formal audits, during which **actual security operations are deprioritized**, and core staff often **burn out or leave due to administrative fatigue**. Certification auditors, too, are forced to focus on irrelevant paperwork and repetitive processes, leading to a **systemic misuse of cybersecurity talent**. For instance, as of 2024, **17 out of 20 public institutions that experienced hacking incidents already held ISMS certification**, exposing the ineffectiveness of form-based assessments.

Despite these realities, some argue that “the certification system should be maintained and supplemented,” or that it “can be reinforced with penetration tests and additional detection requirements.”

However, such arguments are **mere stopgaps that miss the core issue**, dangerously ignoring the flaws of the framework itself.

> **The issue is not the inadequacy of the system—it is the bloated nature of the system itself.**  
> The notion that a formalistic certification model can still be salvaged is nothing more than **self-justification for preserving vested interests.**

We must no longer be misled by this illusion. It is time to **decisively dismantle the outdated certification model** and move in a new direction, rather than continue to drain field personnel and resources on superficial requirements under renamed but unchanged frameworks.

A particularly serious problem is that this **administration-centric system has conditioned corporate CEOs to believe that “being certified means being secure,”** leading them to **prioritize compliance over actual preparedness against cyberattacks**.  
**This is not just an operational oversight—it is a policy failure that structurally distorts decision-making.**

Therefore, the current certification system must undergo **a bold and complete redesign**. As a practical alternative, the nation should adopt a **guidance-based, autonomous security operations model**, such as that proposed by the **NIST Zero Trust Architecture (ZTA)** framework.

In short,

* The **government** should provide guidelines and technical documentation aligned with the latest developments in security technologies.
* **Companies and institutions** should take autonomous responsibility for building and operating systems based on these guidelines.
* In the event of a security breach, **accountability should be determined based on the level of implementation and response readiness**.

Only through this kind of structure can we respond flexibly and swiftly to real-time hacking threats. The goal should not end with certification acquisition; rather, it should foster a **structure in which continuous security maintenance and autonomous improvement efforts are embedded.**

“**There is no such thing as perfect cybersecurity, but with a layered and real-time response system, we can come extremely close to complete protection.**”  
The foundation of this lies in **precise log collection, proactive analysis, and the operation of a real-time response system.**

Information security policy must now shift away from document- and checklist-centered certification to a **real-time, operations-based model** capable of immediate threat response.  
Providing **guidance while making each organization responsible for its own operations** is the first true step toward a practical and resilient cybersecurity framework.

In conclusion, we must no longer **repeat formalities for the sake of formality under the name of certification.**  
We must now be able to answer the question, “**What has this system actually protected?**” with confidence.  
**Only systems that can truly block threats are worth keeping; otherwise, they must be discarded.**

#### That is the first true step toward real security.

> Hacking is no longer the fault of individual companies.  
> It is the **result of an outdated system that has been left unchecked and enforced by current policy frameworks.**  
> Security professionals in the field are wasting more time and resources on meeting certification requirements than on actual defense, all under the **‘ineffective safety net’** designed by the government.  
> The misconception that **“certification means safety”** was not created by companies, but by the system itself.

#### We must stop placing the blame for security failures solely on companies and **squarely face the responsibility of the policy authorities that designed and enforced the system.**

Policy authorities must now make it explicitly clear:

> Just because a security certification has been acquired  
> does **not** mean that an organization is capable of responding to hacking attempts.  
> These certifications are merely **administrative procedures for system operation**.  
> In reality, this process **does not provide any practical protection functions such as threat detection, threat blocking, or enhancement of security capabilities**.  
> Nevertheless, governments, local municipalities, public institutions, and companies are **obligated to comply with these procedures**,  
> which requires the consumption of **tremendous amounts of money, manpower, and time**.  
> Moreover, regardless of actual security performance, failure to meet the requirements may result in **administrative sanctions**.

---

## References

### News Reports and Incident Articles

1. Yuri Ahn, “Even Yes24 with ISMS-P Falls to Ransomware—Effectiveness in Question”, *EToday* (2025‑06‑11).  
2. Seorin Park, “Yes24 Concealed Hacking Damage—Slow Recovery Under Fire”, *ZDNet Korea* (2025‑06‑11).  
3. Hyunju Kang, “Will Adding ‘Penetration Testing’ Improve ISMS Effectiveness?”, *Security News* (2025‑06‑10).  
4. Minji Choi & Bomin Kim, “Yes24 Hacked Again—Why Did MSIT and KISA Demand Data Retention?”, *Digital Daily* (2025‑06‑10).  
5. Aryeong Kim, “Security Management in Retail—A Time Bomb Waiting to Explode”, *Economic Daily* (2025‑05‑26).  
6. Youngjoo Jeon et al., “Better to Pay Hackers Than Waste ₩10 Billion—Most Companies Just Give In”, *Asia Economy* (2025‑05‑26).  
7. *IT Chosun*, “SKT IMSI/ICCID Leak Allegations—MSIT Launches Investigation” (2025‑05‑19).

### Domestic Official Reports and Statistics

8. Korea Internet & Security Agency (KISA), *Cybersecurity Incident Statistics Yearbook 2024* (2025‑03).  
9. KISA, *ISMS Certification Guidelines v4.0* (2024‑07).

### Technical Reports and Global Security References

10. NIST, *Zero Trust Architecture (ZTA)*, Special Publication 800-207, National Institute of Standards and Technology (2020).  
11. NIST, *National Vulnerability Database (NVD)*, [https://nvd.nist.gov](https://nvd.nist.gov)  
12. CVE® Program, *2024 Year in Review* (2025‑01).  
13. MITRE, *ATT&CK Framework*, [https://attack.mitre.org](https://attack.mitre.org)  
14. MITRE Engenuity, *CALDERA User Guide v4.2* (2024‑11).  
15. OWASP Foundation, *ModSecurity Core Rule Set 3.4 Release Notes* (2025‑01).  
16. Trend Micro Research, “BPFDoor: A Covert Backdoor Using Raw Sockets” (2025‑04).  
17. AV‑TEST GmbH, “Microsoft Defender Antivirus (Windows 10) – Nov–Dec 2024 Evaluation”, [https://www.av-test.org/en/antivirus/home-windows/](https://www.av-test.org/en/antivirus/home-windows/)  
18. Cloudflare Radar Team, “Encryption on the Web 2024 Review” (2024‑12).  
19. Google Cloud DORA Team, *Accelerate State of DevOps Report 2024* (2024‑10).  
20. OpenAI, *GPT‑4o System Card* (2025‑05).  
21. Cloud Security Alliance, *WAAP Guidance v1.1* (2024‑03).

### Company Blogs and Technical Insights

22. PLURA Blog, “Why Full Web Log Analysis Matters” (2025‑02‑20).  
23. PLURA Blog, “Leveraging Advanced Audit Policies with MITRE ATT&CK” (2023‑02‑21).  
24. PLURA Blog, “Do We Really Need Multi-Layered Security?” (2025‑05‑05).  
25. PLURA Blog, “Traditional SOC vs. PLURA-XDR Based SOC: From Reactive to Preventive” (2025‑02‑27).  
26. PLURA Blog, “BPFDoor Malware from SKT Hack: Analysis and PLURA-XDR Response Strategy” (2025‑05‑02).  
27. PLURA Blog, “Zero-Day Attack Response Strategy” (2025‑02‑23).  
28. PLURA Blog, “How to Instantly Confirm If a Hack is in Progress – Real-Time Visibility with PLURA-XDR” (2025‑06‑09).
