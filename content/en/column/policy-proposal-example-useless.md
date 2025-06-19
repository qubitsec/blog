---
title: "[Report] Why the ISMS Certification System Is No Longer Valid"
date: 2025-06-14
draft: false
description: "This report analyzes the structural limitations of the ISMS certification system—such as mandatory IPS deployment, annual audits, third-party antivirus requirements, and lack of response to modern attacks—by presenting four real-world cases that demonstrate the need for a shift toward actual defense capabilities."
featured_image: "cdn/column/policy-proposal-example-useless.png"
tags: ["Information Security", "ISMS", "Security Function Verification", "Certification System", "Policy Proposal", "Credential Stuffing", "LoL", "Defender", "Penetration Testing"]
---

# Report on the Technical Irrationalities and Real-World Gaps in Korea's Information Security Certification System

## Overview and Background

Korea’s Information Security Management System (ISMS) and security conformity certification frameworks have long served as essential guidelines for ensuring cybersecurity in both private and public sectors. However, as technology and cyber threats continue to evolve rapidly, **some certification standards remain stuck in outdated paradigms**, resulting in growing discrepancies with today’s security realities. This report examines these discrepancies through four specific case examples:

<!--more-->

![Policy Proposal](https://blog.plura.io/cdn/column/policy-proposal-example-useless.png)

---

### 1. Structural Flaws in Mandatory Intrusion Prevention System (IPS) Deployment

The mandatory deployment of Intrusion Prevention Systems (IPS) offers a prime example of the **disconnect between outdated policies and today’s encryption-driven network environment**.

Currently, over 95% of global internet traffic is encrypted via protocols such as HTTPS and SSL/TLS. While some TLS traffic can be partially analyzed with decryption tools, protocols like **SSH, RDP, VPN, and proprietary encryption schemes are virtually impossible to decrypt and monitor in practice**.

Nevertheless, the ISMS and other domestic certification programs in Korea **still mandate IPS as a core requirement**, and its mere presence is factored into the evaluation criteria. This requirement is a legacy of 1990s–2000s perimeter-based security models built on plaintext traffic and serves as a **clear example of a system that values “compliance by existence” over real security outcomes**.

Ultimately, **enforcing the use of tools that cannot inspect encrypted traffic leads to ineffective security while wasting budget and human resources**. This outdated approach underscores **a policy structure that prioritizes formal checklists over actual technical efficacy**, and it is a clear indicator that systemic reform is urgently needed.

---

### 2. Questionable Effectiveness of Annual Vulnerability Assessments and Penetration Testing

The requirement for annual vulnerability assessments and penetration tests **raises serious concerns about their effectiveness in keeping pace with fast-changing cyber threats**.

Modern attackers exploit newly disclosed vulnerabilities within hours, and the deployment cycles for systems and services have accelerated, making **threat exposure a constant reality throughout the year**. Yet, certification criteria often consider a single annual assessment and submission of its report sufficient for compliance.

Worse still, penetration testing is **typically conducted on pre-approved IP ranges using authorized test accounts**, which **fail to emulate the unpredictability and evasion techniques of real-world attackers**. This reduces the entire process to a **procedural formality** rather than a meaningful test of defense capabilities.

Such performative assessments **do little to validate actual attack surfaces or organizational detection and response readiness**, ultimately drawing criticism that these tests have devolved into **annual rituals that erode the true purpose of the certification system**.

---

### 3. Problems with the Practice of Antivirus Software Adoption

The practice surrounding antivirus software adoption **poses significant issues in that it continues to follow outdated evaluation criteria, disconnected from advancements in technology and the realities of modern security operations**.

A prime example is Microsoft Defender, which in recent years has consistently received **top-tier detection performance ratings from AV-TEST**, and comes natively integrated into the Windows OS with features such as behavior-based detection, real-time protection, and cloud-based analysis.

Despite this, some certification reviews or internal audits still **criticize the use of Defender alone without additional third-party antivirus products**, or treat the mere **purchase of a commercial security solution as an indirect indicator of security maturity**.

This reflects an **outdated mindset that equates “what was purchased” with security effectiveness**, resulting in the **undervaluation of free yet sufficiently capable solutions**.

Ultimately, **evaluation methods that rely on product branding can distort actual security capabilities**, making this a representative case of how certifications may misjudge technical competence.

---

### 4. Insufficient Certification Criteria for Modern Attack Techniques

Techniques frequently used by modern cyber attackers—such as Credential Stuffing and Living off the Land (LoL)—are **difficult to counter with traditional signature-based security solutions or standardized control frameworks**.

Credential Stuffing leverages leaked credentials and automates their use in legitimate login processes, making it **undetectable by firewalls or IPS**, and requiring the deployment of **MFA and behavioral anomaly detection systems**.

LoL attacks, meanwhile, involve abusing legitimate system tools like PowerShell, RDP, and WMI to **bypass detection by operating internally**. These **fileless, behavior-based attacks** are increasingly common. However, current certification frameworks **do not explicitly require tailored countermeasures** for such threats, and only **refer to general controls like access management and log audits**.

As a result, **while cyber threat techniques have evolved, certification criteria have remained stagnant**, creating a **structural gap where even “certified” organizations may be completely exposed to modern attacks**. This gap **highlights the limitations of a compliance-focused rather than reality-based evaluation system**.

---

Each case is analyzed by comparing the latest technical trends and real-world security challenges with relevant certification criteria, evaluation items, and international security standards (e.g., NIST, ENISA). Insights are also drawn from real-world breach cases and media reports. Finally, a **summary table** outlines how well each technical issue is reflected in current regulations and emphasizes the need for policy reform.

---

## 1. IPS and Encrypted Traffic: Outdated Regulations vs. Current Reality

### Technical Background and Security Reality

In the past, network security primarily relied on a model that **detected and blocked intrusions based on plaintext traffic**. Traditional Intrusion Prevention Systems (IPS) operated by inspecting packet payloads to detect known attack signatures. However, the majority of today’s internet traffic is composed of **encrypted traffic based on SSL/TLS, such as HTTPS**, with some reports indicating that **over 95% of traffic was encrypted as of 2024**. Additionally, **SSH, RDP, VPN, and proprietary encryption protocols** are widely used both internally and externally in organizations.

In this environment, while a portion of TLS traffic can be partially analyzed using SSL proxies or decryption devices, **it is virtually impossible to decrypt and analyze traffic over SSH, RDP, VPN, or custom-encrypted channels like BPFDoor**. For instance, the recently discovered **BPFDoor malware** bypasses packet filtering and communicates while **masquerading as SSH traffic without opening a TCP port**, concealing command-and-control operations within encrypted channels and rendering IPS detection ineffective.

As a result, **although IPS systems are unable to identify or analyze the content of encrypted traffic and are losing practical effectiveness**, they are still **considered mandatory security equipment under Korea’s certification systems**. This stems from **institutional remnants of a 1990s–2000s security model based on plaintext networks**, and represents a **policy error disconnected from today’s realities**.

### Comparison with Certification Standards and Evaluation Items

Under Korea’s security certification standards (such as ISMS), the implementation and operation of **network security systems** including firewalls and **intrusion detection/prevention systems (IDS/IPS)** are effectively required as baseline controls. Especially for organizations managing critical information assets, **IPS deployment is expected and frequently verified during audits**. These expectations are rooted in the security paradigms of the time the standards were created—namely, perimeter security models that block malicious activity by inspecting packet content.

For example, the privacy protection framework includes clauses like “**security systems must be installed and operated to prevent illegal access and data leaks from personal information systems**.” In practice, this is interpreted to include **network IPS alongside WAFs and DLPs**. However, this does **not address visibility into encrypted traffic**, and in reality, even when an organization possesses an IPS, it often **fails to detect or block threats embedded within encrypted communications such as HTTPS, SSH, or VPN**. **Yet many certification audits consider the mere presence of IPS equipment as sufficient**, reflecting an **evaluation structure that prioritizes form over substance**.

### International Security Guidelines Approach

Internationally, various **complementary strategies** are recommended for dealing with threats within encrypted traffic. NIST acknowledges the limitations of network-based IDS/IPS and recommends **monitoring in pre-encryption or post-decryption segments**—for example, **decrypting SSL traffic via proxies** or **deploying agents on endpoints (clients/servers)** to inspect communications. ENISA and other European guidelines emphasize the need for **TLS visibility and zero trust architectures**, and recommend **behavior-based detection, memory forensics, and command-line logging** to maintain security visibility in encrypted environments.

This also explains the global popularity of next-generation firewalls (NGFWs) and SSL visibility solutions. According to a 2023 Gigamon report, over 70% of surveyed organizations **allow encrypted traffic to pass through internal networks without inspection**, and visibility into this traffic is cited as a **top security priority for 2024**. Many global enterprises are moving toward **TLS inspection proxies, SSL offload devices, and EDR (Endpoint Detection & Response)** as means to **compensate for or replace traditional IPS limitations**.

### Real-World Cases and Implications

In reality, reliance on IPS alone often leads to **undetected attacks embedded within encrypted traffic**, which has already been confirmed in numerous cases. In various **APT attacks and malware distribution incidents**, attackers used encrypted C2 (Command & Control) channels over HTTPS or SSH to **bypass IPS and firewalls** and exfiltrate internal data.

Notably, **BPFDoor** is a prime example of a sophisticated attack that **hid backdoor commands within spoofed encrypted SSH sessions**, performing operations **undetectable by traditional intrusion prevention systems**. Attackers now leverage **SSL, SSH, RDP, VPN, and proprietary encryption channels** to evade detection, and most of this traffic **cannot be analyzed by IPS**.

As a result, while the **“IPS is operational” checkbox may be ticked**, the reality is that **organizations often lack meaningful threat detection and blocking capabilities**. These cases strongly **highlight the need for certification reform**.

**Current standards should not merely require IPS ownership**, but must **mandate visibility strategies for encrypted traffic**. Certification criteria should recognize organizations that **deploy TLS decryption technologies or alternative security controls like EDR**.

Ultimately, we must break away from the 1990s **“perimeter-based network security” paradigm** and urgently transition toward a **policy framework reflecting zero trust and behavior-based security strategies**.

---

**Item 1: Mandatory IPS Deployment vs. Reality of Encrypted Traffic – Comparative Summary**

| Item                 | Current Certification Practice                              | Changes in Real-World Security Environment                                                                            | International Recommendations and Examples                                                            | Necessity for Policy Reform                                                                 |
|----------------------|-------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| **Mandatory IPS**    | IDS/IPS installation at network perimeter is required. Emphasis on equipment operation status | Most traffic is encrypted via SSL/TLS ⇒ IPS cannot inspect contents. Attackers bypass IPS using encryption.<br>SSH, RDP, VPN, and proprietary encryption are non-decryptable | NIST: Monitoring recommended in decrypted segments<br>ENISA: Emphasizes TLS visibility and Zero Trust<br>Global enterprises: Use SSL inspection proxies, adopt EDR | **Redefine IPS requirements:** Revise standards to include visibility measures for encrypted traffic. Recognize alternative controls (e.g., SSL proxies, EDR, behavior-based detection) |

---

## 2. Limitations and the Need to Abandon the Annual Vulnerability Assessment and Pen-Testing Regulation

### High Cost, Low Efficiency, and Outdated Practice

Today, most security certification and compliance frameworks still mandate “at least one annual vulnerability assessment and penetration test.” However, this annualized approach is increasingly disconnected from actual security effectiveness.

For small and medium-sized enterprises—and even for large corporations—conducting a single annual pen test can cost tens of millions of won, up to 100 million won (~$75,000 USD), making it practically infeasible or restricted to a minimal scope. Moreover, a one-year gap does not reflect today’s continuous threat landscape, leaving the organization **exposed to newly discovered vulnerabilities between assessments**. Nonetheless, certification audits only verify whether the assessment took place annually, **ignoring critical aspects like automation, incident response, or actual defense capabilities**.

As such, annual testing often becomes a “ceremonial paperwork exercise,” leading to waste of budgets and manpower while creating dangerous gaps in threat response. More critically, **the current system enforces expensive, infrequent methods while offering no evaluation credit for low-cost, real-time alternatives**—a fundamental design flaw in the system.

### Global Standards Are Shifting Toward Continuous, Automated, and Risk-Based Models

International frameworks such as the NIST Cybersecurity Framework, PCI-DSS 11.x, and Europe’s TIBER-EU have already recognized the limitations of annual assessments and are moving away from them. These standards recommend the use of automated scanning tools and SaaS-based continuous assessments on a weekly or even daily basis. For critical infrastructure, they incorporate risk-based red teaming activities. Furthermore, depending on company size and security maturity, many are now adopting continuous testing strategies such as bug bounty programs and Attack Surface Management (ASM).

In essence, frequency and cost should not be fixed regulatory requirements but rather flexibly managed. Eliminating high-cost annual events is becoming the new global norm.

### Repeated Breaches Reveal Systemic Failures

The structural flaws of the current system are consistently highlighted by real-world incidents. A notable example is the 2017 Equifax breach, where a vulnerability left unpatched less than 60 days after a completed annual audit resulted in the leakage of personal information of over 140 million people. Similarly, in Korea, there have been cases where new vulnerabilities were disclosed after year-end audits, but no action was taken for several months until the next scheduled assessment, leading to breaches.

Attackers always exploit the “gap between assessments.” Unfortunately, the current system doesn’t reduce these gaps—it institutionalizes them.

### Why This Model Must Be Abandoned and What Should Replace It

The traditional annual vulnerability assessment model is no longer valid and must be completely discarded to ensure effective response capabilities. As an alternative, organizations should adopt automated scanning systems to perform weekly assessments and manage Mean Time to Remediate (MTTR) to within seven days. Penetration testing should also move away from uniform annual checks toward continuously running bug bounty programs and 1–2 yearly rounds of sophisticated red team exercises targeting critical infrastructure.

Incident response drills should no longer be optional. They must become mandatory, with quarterly table-top or blue team exercises conducted to enhance real-world crisis response capabilities continuously.

This approach goes beyond reducing costs—it actively improves an organization’s security posture. **A shift from rigid compliance-based evaluations to capability-focused assessments is urgently needed.**

In conclusion, the once-a-year assessment model has outlived its usefulness in today’s security landscape. Certification systems must now be **completely replaced** with frameworks that are continuous, cost-effective, and risk-based in order to deliver real security impact.

**Item 2: Annual Vulnerability Assessments/Penetration Testing – Comparative Summary**

| Item                  | Current Certification Requirements                        | Real-World Security Environment and Issues                                                                 | International Best Practices and Recommendations                                   | Improvement and Reform Directions                                                                                      |
|-----------------------|------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| **Vulnerability Scan Frequency** | Typically requires **at least one regular scan per year** | New vulnerabilities emerge constantly → Annual cycles create large gaps<br>Vulnerabilities disclosed post-scan may remain unpatched until the next assessment | PCI-DSS: Annual + additional tests upon major changes<br>Global trend: **continuous scanning/pentesting** | **Adopt continuous evaluation:** Include **quarterly scans, on-demand patch checks** and year-round security management in certifications |
| **Penetration Testing Realism** | Conducted **safely after pre-agreed scope and scenarios** (for compliance purposes) | Real attacks occur unexpectedly and via various vectors → Current pentests **lack realism**<br>Awareness of testing can **inflate defense success rates** | Finance sector (e.g. TIBER-EU): **threat-based autonomous red teaming**<br>NIST: recommends **regular penetration exercises** | **Diversify scenarios:** Introduce **surprise attacks, insider threat simulations**<br>Assess **attack surface management** and threat hunting capabilities |

---

## 3. Antivirus Solutions: Microsoft Defender vs Third-Party Products

### Recent Technological Trends and Security Realities

For decades, one of the basic rules for securing PCs and servers was installing **antivirus software**. Until the Windows XP/7 era, built-in OS security features were limited, making third-party antivirus products from AhnLab, Symantec, Trend Micro, etc., seem essential. However, since **Windows 10, Microsoft has bundled its own Defender antivirus**, which has drastically improved in recent years. **In authoritative evaluations like AV-TEST**, Microsoft Defender has consistently scored **near-perfect results (6 out of 6) in detection, usability, and performance**, often outperforming the industry average. This indicates that Windows Defender now provides **protection on par with paid antivirus software**.

Among security professionals, the consensus is growing that "**the built-in security of Windows is sufficient**." Many believe that with just the OS’s native functions and **regular updates**, users can adequately defend against most common malware threats without installing additional antivirus programs.

Microsoft Defender also offers advanced features beyond simple virus scanning, such as **behavior-based detection, memory protection, and cloud-integrated threat reputation services**. At the organizational level, it expands into EDR (Endpoint Detection & Response) through **Defender for Endpoint**. One of its biggest advantages is that it’s **available at no extra cost within the Windows environment**. In essence, the reality now is that the old equation "**antivirus = paid software**" is no longer valid, and the market is shifting toward **next-gen endpoint security integrating OS-level protection and cloud AI**.

Some third-party antivirus vendors still attempt to differentiate themselves with **specialized ransomware protection, password managers, or bundled VPN services**, but these features often suffer from inferior quality compared to dedicated tools and may even burden the system. Thus, **more features do not always mean better protection**. Moreover, today’s threats have evolved beyond traditional viruses to include **fileless attacks and Living-off-the-Land techniques**, making it clear that **a single antivirus solution is insufficient**.

Ultimately, today’s security landscape demands not just a standalone antivirus but a **comprehensive endpoint defense strategy**.

### Comparison of Certification Standards and Practices

Under Korea’s information security management standards, “**establishing anti-malware measures**” is a common requirement, typically verified by checking for **antivirus installation, regular updates, and responses to malware alerts**. Although these standards don’t specify a particular antivirus product, in practice, **all agency PCs are expected to have antivirus software installed and operated**. A key issue is the **lack of clarity in some audits or guidelines regarding the use of built-in solutions like Windows Defender**. Historically, Defender was perceived as basic anti-spyware, leading to the belief that “**antivirus = third-party product**,” and **many institutions still default to purchasing separate antivirus products**. For instance, some internal audit checklists ask whether antivirus solutions like AhnLab V3 are installed, or require **additional explanations if only Defender is used**—a practice based more on precedent than official guidance.

Procurement and budgeting also reflect this, where **antivirus software purchases are considered security investments**, potentially resulting in the **perception that purchasing third-party solutions equals stronger security**. For example, in one agency’s cybersecurity evaluation, **using “domestically or internationally certified antivirus products”** was considered a plus factor. Conversely, **built-in tools like Defender may be overlooked**, leading to misjudgments about security investment levels. In summary, **although certification standards don’t explicitly mandate third-party antivirus use**, **both auditors and organizations often equate “external antivirus = enhanced security”** due to entrenched habits.

These practices diverge from current realities. Despite **Defender offering robust protection in modern Windows environments**, it is still often dismissed as **“free and therefore untrustworthy”**, and institutions may believe that **spending money demonstrates commitment to security**. However, the true purpose of certification should be to ensure **endpoint malware defense capabilities**, not to assess **brand-name software usage**.

### International Perspectives and Examples

International standards (e.g., ISO/IEC 27002) specify **anti-malware controls** without mandating specific products, encouraging organizations to **choose appropriate methods based on their environment**. In practice, many global enterprises have recognized Defender’s improvements and are **transitioning from paid antivirus solutions to Defender**, with organizations like Gartner ranking Microsoft as a **leader in endpoint security**. In the U.S., **federal agencies include Defender in approved product lists**, and CIS benchmarks recommend **optimizing Defender settings**. This reflects a global view that **built-in OS security tools like Defender can be sufficient if properly configured**.

From a **multi-layered security** standpoint, international guidelines now recommend integrated strategies over simple antivirus. For instance, the **Australian Cyber Security Centre’s “Essential Eight”** includes **application control, memory protection, and macro restrictions** to reduce reliance on traditional antivirus. Similarly, **NIST SP 800-83** (on malware defense) notes the **limitations of signature-based antivirus** and encourages the use of **complementary methods like behavior blocking**. The global trend focuses less on **which AV product is used** and more on **how effectively malicious behavior is detected and blocked at the endpoint**. Defender’s evolution is therefore seen as **strengthening baseline endpoint security**, and international standards increasingly **encourage its effective use** rather than excluding it.

### Implications and Recommendations

There are reports of **institutions being flagged during audits for using only Defender**, while others that had **purchased third-party antivirus software but failed to update it** were also criticized. What truly matters is the **effectiveness of the solution in use**, not its brand. For example, in a **2019 hack of a manufacturing company**, attackers bypassed a paid antivirus product, but after adopting an EDR solution, the company improved behavioral detection and avoided recurrence. This illustrates that **modern threats—especially fileless and script-based attacks—cannot be stopped by legacy antivirus alone**, and require **supplemental tools like EDR** for effective detection and response.

To improve policy, certification evaluations should shift from **checking for tool ownership** to assessing **actual defense capabilities**. For instance, an institution using Defender should still be rated highly if it **monitors alerts via a central console and enables cloud protection**. Conversely, a poor score should be assigned to any institution using third-party antivirus software that is **months out-of-date or lacks alert monitoring**. This requires **more detailed audit guidelines**. Also, providing a **guide for leveraging OS-native security** can help smaller organizations avoid unnecessary spending by encouraging **better use of built-in tools**. Ultimately, the evaluation system should prioritize **how well an organization responds to threats**, rather than **what products they purchase**.

**Item 3: Antivirus Solution Adoption Practices – Comparative Summary**

| Item                  | Traditional Certification Practices                                                                 | Realistic Security Level                                                                                   | Global Trends and Examples                                                                                   | Direction for Improvement                                                                                           |
|-----------------------|------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| **Use of Antivirus**  | Focus on whether **third-party antivirus** is installed on PC/servers<br>(Rarely mention built-in solutions like Defender) | Significant improvement in Windows Defender performance → **High detection rate even without additional AV**<br>Includes advanced features like EDR | Many global companies transitioning to Defender<br>Defender receives top scores from AV-TEST<br>**ISO/NIST:** Emphasize effectiveness over specific product | **Function-based evaluation:** Any solution is acceptable if it provides up-to-date protection and behavioral detection.<br>Provide guidance on using Defender; avoid pressuring for extra purchases |
| **Certification Perception** | Tendency to view third-party antivirus use as a “security investment indicator”<br>May require explanation or penalize if only built-in AV used | Even third-party antivirus is ineffective if poorly managed<br>Built-in security can be effective if properly configured and monitored | **Gartner MQ:** Classifies MS Defender as a leader<br>**Global regulations:** Recommend leveraging OS-native security (e.g., CIS Benchmarks) | **Improve evaluation criteria:** Shift from “AV purchase status” to overall “malware response capability.”<br>Recognize and encourage various anti-malware approaches including Defender |

---

We have reviewed the issues within the ISMS certification system through items 1 to 3, along with technical case studies. However, a more critical issue lies not only in these structural limitations, but also in the fact that **the certification system lacks practical guidelines to address modern cyber threats**.

For example, despite growing concern in the security industry over the past few years regarding **Credential Stuffing** and **Living off the Land (LoL) attacks**, there is **no specific requirement in the ISMS certification criteria that mandates detection or response capabilities for such threats**.

Although existing certification items mention broad areas like account management, access control, and log analysis, most are still **based on outdated attack models** and **do not adequately assess an organization's ability to detect or respond to today’s sophisticated and covert attack techniques**.

Ultimately, this shows that the certification system is primarily focused on **“basic security compliance”** and fails to evaluate actual **threat detection capabilities or response frameworks**, leading to a **structural flaw**.

It is now essential to shift from conventional security controls to **criteria that evaluate vulnerabilities from an attacker's perspective**, and determine whether organizations have practical response capabilities. This requires **explicit inclusion of modern threats like Credential Stuffing and LoL attacks into certification frameworks**, along with concrete assessments of detection and mitigation systems.

---

## 4. Certification Standards' Response to Modern Attack Techniques (Credential Stuffing, Living off the Land, etc.)

### Background: The Rise of Credential Stuffing & LoL Attacks

**Credential Stuffing** has emerged as a **primary method for account hijacking attacks** today. Attackers acquire large lists of IDs and passwords leaked from other services and use automated scripts to input them into different websites in an attempt to **gain unauthorized access to accounts**. If users reuse passwords across services, the success rate increases, leading to severe consequences like identity theft or financial loss.

In fact, **since 2023, multiple high-profile credential stuffing attacks have occurred in South Korea**, involving companies like GS Retail, Starbucks Korea, and the Korea Student Aid Foundation, resulting in the **leak of tens of thousands to hundreds of thousands of personal data entries**. For instance, in the **GS Retail incident**, attackers randomly input credentials obtained from various sources and extracted the personal information of around 90,000 customers. **Security experts emphasized the importance of multi-factor authentication (MFA) and anomaly detection for login behavior** as countermeasures.

Despite **Credential Stuffing** becoming a **common attack method**, it cannot be stopped by traditional security controls like firewalls or antivirus. Instead, **enhancements at the authentication stage**, particularly **MFA and login anomaly detection**, are essential.

**LoL** (Living off the Land) attacks, as mentioned earlier, **abuse legitimate system tools already present on the machine**. For example, attackers use Windows tools like **PowerShell, WMI, MSHTA, and DLLs** to execute malicious behavior. Since **these attacks use fileless techniques and run within legitimate processes**, they often **evade detection by traditional security solutions**. LoL attacks are widely used by **APT groups and ransomware operators**. A 2023 report stated that **fileless/LoL attacks surged by 1400% year-over-year**, becoming the most reported attack technique in MITRE ATT&CK. Even **North Korean hackers targeting South Korea** have used internal admin tools to **evade detection**, highlighting LoL as a hallmark of advanced threats.

What these modern techniques have in common is that **they are difficult to detect using signature-based or conventional controls**. Credential Stuffing involves **legitimate logins using stolen credentials**, bypassing firewalls or IPS. LoL attacks utilize **legitimate processes**, making them invisible to antivirus. Effective detection and response depend on **security teams having strong visibility, behavioral analysis, and security monitoring frameworks**. The key issue is whether **current certification systems include explicit controls that address such techniques**.

### Controls and Limitations in Current Certification Systems

Looking at requirements in frameworks like ISMS-P, items such as **access control**, **account management**, and **log monitoring** are somewhat related to detecting unauthorized login attempts or controlling administrator tool usage. Examples include “**monitoring for anomalies in system or service behavior**” or “**log analysis for unauthorized access attempts**,” though these are described in general terms. However, **terms like ‘Credential Stuffing Prevention’** or ‘**LoL Detection**’ are **not explicitly included in the standards**. In practice, certification audits may check for **account lockout policies** or **alerts on failed logins**, but **they do not deeply evaluate how to detect thousands of ID/password attempts spread across distributed IPs**. Similarly, **use of EDR/UTM to detect admin tool abuse or insider threats** is not explicitly part of audit checklists.

In summary, **certification criteria are broadly stated, but lack specific controls tailored to modern attack methods**. For example, **personal information protection standards** may require **password complexity and account sharing bans**, but do not mention methods to **detect use of already-leaked credentials** (e.g., MFA or password leak matching). Likewise, controls such as “**programming tool usage restrictions**” may exist, but are not **evaluated through the lens of LoL or APT attack scenarios**. In practice, **the requirements seem to exist, but actual evaluation and countermeasure checks remain insufficient**.

### Approaches from International Standards and Guidelines

Internationally, there are increasing **recommendations for mitigating authentication attacks like Credential Stuffing**. **ENISA** and the **European Data Protection Supervisor (EDPS)** identify Credential Stuffing as a major threat, recommending the adoption of **multi-factor authentication (MFA)**, **password leak monitoring** (e.g., comparing with Have I Been Pwned databases), and **login pattern analysis**. **NIST SP 800-63B (Digital Identity Guidelines)** explicitly requires comparison against known leaked password lists to prevent users from setting previously compromised credentials. **OWASP** provides a **Credential Stuffing Prevention Cheat Sheet**, which includes IP-based rate limiting, CAPTCHA, MFA, and failed login monitoring. **Financial institutions and large platform services** are increasingly implementing **abnormal login detection systems** (e.g., attempts to log into multiple accounts from one IP, or geographically anomalous login attempts).

For LoL attacks, international guidelines emphasize both **behavioral detection and preventive blocking**. The **MITRE ATT&CK** framework catalogs TTPs (Tactics, Techniques, and Procedures) like PowerShell usage or script execution, helping security teams monitor and respond. **NSA** and **CISA** provide **guidelines on responding to fileless malware**, recommending **memory forensics, command-line logging, and script execution restrictions**. Modern **EDR products** are built to detect LoL activity in real time, and tools like **Microsoft Defender for Endpoint** offer features like **blocking suspicious PowerShell commands**. ENISA’s Cyber Threat Reports also highlight the **growing abuse of legitimate system tools**, urging security controls to be enhanced to detect such behavior.

Ultimately, international best practices focus on **implementing security controls that assume modern attack techniques as a given**. For example, in the **Access Management** domain, **UEBA-based anomaly detection and strong authentication** are fundamental. In **Endpoint Security**, techniques like **behavioral detection, memory monitoring, and application control** are emphasized. The **Zero Trust model** can be seen as a comprehensive strategy that incorporates these detailed technologies.

### Real-World Breach Cases and Implications for Improvement

The damage caused by credential stuffing underscores the urgency raised in previous cases. In the **GS Retail** incident, the company had obtained ISMS certification and was regarded as maintaining “solid security,” but ultimately, it **fell victim to login attacks using credentials leaked from other services**. Only after the incident did the company **lock affected accounts and notify users to change their passwords**—a situation that could have been mitigated had **MFA been implemented** or a **login anomaly detection system actively operated**. This highlights that **even certified organizations are vulnerable if they lack preparation for real-world attack techniques**. It points to a **gap in certification standards when they fail to account for evolving threats**.

Regarding LoL attacks, in a **2019 financial sector breach**, attackers used **only built-in Windows tools** (e.g., Netsh, WMIC) throughout the attack phase and remained undetected for **eight months**. Despite the institution operating numerous security products, the absence of **rules to identify abnormal behavior from legitimate tools** allowed the attack to proceed. Though EDR solutions and advanced log monitoring were implemented afterward, the **data breach had already occurred**. This case demonstrated that **having multiple security tools is meaningless if they fail to detect what truly matters**, and that **certification alone cannot ensure preparedness against high-risk scenarios**.

Therefore, the direction for policy improvements is clear. Certification standards must **explicitly require preparation against modern attack methods**. For example, by introducing a new “**Account Attack Mitigation**” category to evaluate *MFA implementation, brute-force login detection, and password breach monitoring*, and by strengthening controls over “**Anomaly Detection**” to assess whether *EDR or similar technologies are used to detect abuse of legitimate tools*. Scattered items like *account lockout policies or admin log reviews* should be **centralized into focused control categories**, with stricter auditing for these items. Additionally, incorporating **scenario-based evaluations** (e.g., red team simulations using LoL techniques) can uncover vulnerabilities that may be missed during document-based audits.

In summary, there must be a **paradigm shift toward certifications designed from the attacker’s perspective**. Outdated controls must be revised, and we must aim for a **“living” security certification system that can respond to increasingly sophisticated attack techniques**.

**Item 4: Standards for Responding to Modern Attack Techniques – Comparative Summary**

| Item                          | Current Certification Controls                                  | Real-World Threat Landscape & Risks                                                                                     | International Recommendations & Responses                                                                    | Improvement Needs                                                                                                          |
| ---------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Credential Stuffing Response** | Indirectly mentioned under account management and access control<br>(e.g., password policy, login failure limits) | Widespread credential leaks lead to brute-force login attempts → **No MFA = defenseless**<br>Major cause of data breaches | ENISA: Identifies credential stuffing as a key threat<br>**Recommendations:** MFA, login anomaly detection, breached password blocking<br>OWASP provides detailed guidance | **Strengthen Certification Standards:** Evaluate MFA implementation<br>Clearly define requirements for monitoring and blocking anomalous login behavior |
| **Living off the Land Response** | General references to log monitoring and admin access control | Increasing **attacks disguised using legitimate tools like PowerShell** → Signature-based detection fails<br>APT groups & ransomware actively use LoL (fileless attacks up 1400%) | MITRE ATT&CK establishes structured identification of attack techniques<br>**Recommendations:** EDR, behavioral detection, script execution restrictions, memory forensics | **Clarify Controls:** Evaluate adoption of EDR/behavioral detection<br>Require alert systems for signs of tool abuse in logs<br>Include LoL scenarios in security event detection rules |

---
## Summary Comparison and Conclusion

The following table summarizes the **gap between current certification systems and real-world security conditions**, as well as the **need for policy improvement**, based on the four cases covered in this report. It is structured to allow for quick comparison of key issues and recommended directions for each category.

| Issue (Technology)                      | Position in Current Certification Standards              | Real-World Security Conditions and Challenges                                                  | Comparison with International Guidelines/Practices                                   | Policy Improvement Needs (Summary)                                                                        |
| -------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Mandatory IPS Deployment** (Encrypted Traffic)        | Required as a basic security solution in ISMS<br>Focus on perimeter security | Most traffic is encrypted (TLS) → Traditional IPS cannot identify internal threats<br>Effectiveness reduced despite deployment | NIST: Recommends monitoring after decrypting traffic<br>Global trend: Use of SSL visibility tools, EDR | **Modernize IPS Requirements:** Include encrypted traffic response<br>Allow SSL inspection or alternative controls where necessary |
| **Annual Vulnerability Assessment** (Penetration Testing) | Compliance met if conducted once a year                   | New vulnerabilities appear frequently, attacks happen year-round → Annual checks leave security gaps<br>Pre-arranged tests differ from real-world attacks | PCI: Requires annual + on-demand testing<br>Industry: Emphasis on **Continuous Testing**      | **Shift to Continuous Evaluation:** Quarterly scans/patches, unannounced red team drills<br>Recognize annual testing as minimum |
| **Antivirus Solutions** (Defender vs. Third-Party)       | Verifies presence of anti-malware solutions               | MS Defender is free but third-party AV often required by convention<br>→ **Built-in security underestimated**, formal adoption without substance | Defender performance proven (AV-TEST top scores)<br>Gartner MQ leader, includes EDR capabilities | **Outcome-Based Evaluation:** Focus on effectiveness regardless of vendor<br>Recognize and assess actual use of Defender if properly configured |
| **Response to Modern Attack Techniques** (Cred. Stuffing, LoL) | Some related controls exist, but lack specific requirements | **Frequent credential stuffing attacks**, surge in fileless attacks → Difficult to detect with traditional controls | Recommendations: MFA, anomaly detection (UEBA), use of EDR<br>※ Technique-centric control systems gaining ground | **Define Control Items Clearly:** Add MFA and account protection requirements<br>Strengthen behavioral detection/response evaluation (include scenario-based testing) |

## Conclusion: An Outdated Certification System, A Fundamental Shift Is Needed

South Korea’s current information security certification system did make some contributions in the early 2000s by helping organizations establish a certain level of security framework. However, **its contribution effectively ended two decades ago.**  
Today, the system **fails to keep pace with the rapid technological changes and evolving attacker strategies**, and has **degenerated into a mere ritual of ineffective, procedural formalities.**

Legacy requirements such as IPS deployment, annual assessments, and reliance on third-party antivirus solutions **no longer correlate with actual security effectiveness**,  
and the absence of standards for detecting and responding to modern threats like **Credential Stuffing and Living off the Land (LoL) attacks**  
**clearly illustrates how detached the system has become from on-the-ground realities.**

Ultimately, today's certification regime is **no longer a tool for security—it has become a bureaucratic procedure disguised as security**,  
perpetuating the dangerous myth that "**compliance equals safety.**"  
Rather than maintaining a system that **undermines real-world defense capabilities under the pretense of formal compliance**,  
it is time to **transition to an entirely new framework grounded in practical effectiveness and measurable defense capabilities.**

In short, we must **stop repeating formality for formality's sake in the name of certification.**  
We should now be able to confidently answer the question: "**What has this system actually protected?**"  
**Only systems that can demonstrably block real threats are worth preserving**—the rest **should be dismantled.**  
That is the first real step toward genuine security.

Therefore, the change we need is not technological, but rather a **complete overhaul of the policy framework that governs how we view and apply technology.**

---

## References

1. Jieun Shin, “GS Retail Suffers Credential Stuffing Attack, Leaks Personal Data of 90,000 Customers,” *Security News* (2025-01-05).  
2. Personal Information Protection Commission, “Credential Stuffing on Korea Student Aid Foundation Website Leaks Data of 32,000 Users,” Press Release (2024-11-18).  
3. Cloudflare Radar Team, *2024 Year in Review: Encryption on the Web* (2024-12).  
4. Gigamon, *State of SSL/TLS Visibility Report 2023* (2023-09).  
5. ISACA, “Fileless Attacks on the Rise: 1,400 Percent Increase” (2023-10).  
6. AV-TEST Institute, *Product Review and Certification Report – Microsoft Defender Antivirus (Windows 10) Nov-Dec 2024* (2025-01).  
7. Trend Micro, “BPFDoor: Hidden Controller Used Against Asia, Middle East Targets” (2025-04).
