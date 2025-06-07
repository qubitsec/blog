---
title: "Understanding Intrusion Prevention Systems (IPS)"
date: 2024-02-23T00:00:02
draft: false
description: "Analyzing Intrusion Prevention Systems (IPS) through the OSI model and exploring network and host security within a comprehensive strategy."
featured_image: "cdn/column/ips_understanding-1.png"
tags: ["IDS", "IPS", "NDR", "OSI Model", "Security"]
---

🛡️An **Intrusion Prevention System (IPS)** is a critical technology for **proactively detecting and blocking security threats** at both the network and host levels. However, in today’s environment—where threats are **diverse and increasingly sophisticated**—it is limiting to view IPS purely as a **single-point solution**. Implementing **multiple security tools** in a so-called **multi-layered defense model** can lead to **compatibility issues**, **alert fatigue from redundant notifications**, and **fragmented budgets and personnel**.

Therefore, even if you consider every layer of the **OSI model**, it is far more **efficient and effective** to adopt a **unified security platform** that **protects both the network and hosts in an integrated manner**, rather than mindlessly adding **separate security devices**.

<!--more-->

![IPS Explanation](https://blog.plura.io/cdn/column/ips_understanding-1.png)

---

## 1. IPS and OSI Model-Based Security

Network communications are often evaluated through the **7-layer OSI model**.
**IPS** addresses these layers differently, requiring distinct defensive strategies at each level.

### Layer 3: Network Layer

* **IP Address-Based Filtering**
  Identifies and blocks malicious actions such as IP spoofing or abnormal routing attempts.
* **Routing Rules**
  Restricts unnecessary inter-network traffic, reducing the overall attack surface by limiting access to internal resources.

### Layer 4: Transport Layer

* **Port Number Filtering**
  Mitigates DoS attacks like port scans (searching for open ports) or SYN floods (repeatedly targeting a specific port).
* **Session Management**
  Tracks TCP/UDP connection states, detecting abnormal patterns or excessive simultaneous connections for quick containment.

### Layer 7: Application Layer

* **HTTP Traffic Analysis**
  Inspects **SQL injection**, **XSS**, or **web shell uploads** hidden in web requests, blocking malicious payloads before they reach the server.
* **Encrypted Traffic**
  With HTTPS or TLS, it’s difficult to thoroughly inspect packets at the network layer.
  Hence, **host-based security** (e.g., HIPS) plays a critical role in monitoring behaviors after decryption.

---

## 2. Network-Based Security Solutions: Firewalls and WAF

At the **network layer**, two essential security components are the classic firewall and the Web Application Firewall (WAF).

### Network & Transport Layers: Firewall

1. **IP and Port Filtering**
   Preemptively blocks unwanted traffic, preventing unauthorized access to critical servers or internal assets.
   This serves as the most fundamental line of defense.

2. **Stateful Inspection**
   Unlike stateless filtering, which examines packets in isolation, stateful inspection tracks the **entire connection** (session).
   For example, it checks whether TCP’s 3-way handshake completes normally and identifies abnormal connection attempts.
   While it cannot inspect **encrypted packet** contents, it can still detect **suspicious traffic** based on session data and statistical metrics (e.g., number of connections, session duration).

### Application Layer: Web Application Firewall (WAF)

* **Web Request Inspection**
  A security solution specialized for web applications, the WAF inspects **malicious patterns** (e.g., SQL injection code) hidden in HTTP(S) requests.
* **Customized Policies**
  Because the WAF’s rules can be finely tuned to each application, it excels at **application-layer security** more so than a traditional firewall.
  However, analyzing encrypted traffic requires **SSL decryption** and additional configuration.

---

## 3. The Importance of Host-Based Security Solutions

Relying solely on network-layer solutions has a major drawback: it’s **difficult to fully inspect encrypted traffic**.
To address this, **host-based security solutions** (e.g., HIPS) operating directly within each server or PC are indispensable.

### Encrypted Traffic and the Host Layer

* **Decryption Point**
  TLS/HTTPS data eventually gets decrypted within the host (server) itself.
  This is where host-based solutions can **closely monitor actual application processes**.
* **Real-Time Behavioral Analysis**
  They can block malicious actions by evaluating **filesystem activity**, **memory modifications**, and **inter-process communications** from a holistic perspective.

### Examples of Host-Based Solutions

1. **Antivirus/Anti-Malware**
   Identifies and removes viruses or ransomware hidden in files, preventing system compromise.
2. **Endpoint Detection & Response (EDR)**
   More advanced solutions that continuously track **anomalous behavior** at the host level and automatically respond to detected threats or alert administrators.
3. **Data Loss Prevention (DLP)**
   Monitors for attempts to exfiltrate encrypted sensitive data or personal information and blocks unauthorized transfers.
4. **Application Whitelisting**
   Restricts software execution to approved programs, reducing the security risks posed by unverified applications.
5. **Security Information and Event Management (SIEM)**
   Collects logs from both hosts and network devices, enabling comprehensive threat detection and incident response across the entire organization.

---

## 4. A Comprehensive Definition of IPS

As the above illustrates, **IPS** is not just “a single device or program preventing network intrusions.” Rather, it’s a **cooperative effort**—

* **Network Level:** Firewalls, WAFs, routing policies, etc.
* **Host Level:** HIPS, EDR, DLP, SIEM, etc.

All of these work in unison to **prevent intrusions across multiple layers**.
In modern environments where encryption is widespread and cloud adoption is growing, **host-based security** is increasingly critical.

> ✍️ **In other words, an Intrusion Prevention System (IPS) is not merely a standalone product, but a holistic security framework spanning both network and host defenses.**

---

## Additional Considerations and Warnings

1. **Encrypted Traffic Challenges**
   Firewalls or WAFs can use **SSL inspection proxies** to process encrypted packets, but this may introduce **extra resource usage** and **privacy concerns**.
   This highlights the growing importance of **HIPS, EDR**, and other host-level solutions.

2. **Environment-Specific Requirements**
   Every organization’s environment is unique in terms of **traffic patterns**, **network architecture**, and **data criticality**, requiring a tailored IPS design and deployment.

3. **Continuous Updates and Monitoring**
   Since attack techniques evolve rapidly, ongoing **security patches** and **policy updates** are crucial for both network and host-based tools.

> **💡 Bottom Line**: A robust IPS strategy in modern environments means covering **all layers of the OSI model**, pairing **network-based** solutions with **host-based** defenses.
> Even as encryption technology evolves, **stateful inspection**, **behavioral analysis**, and **centralized log management** remain key to identifying and blocking threats from multiple angles.

---
