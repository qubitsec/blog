---
title: "Comprehensive Summary of the SKT USIM Hacking Incident: Causes, Impact, and Response Measures"
date: 2025-05-02
draft: false
description: "A simplified overview of the large-scale USIM data breach incident at SK Telecom in April 2025, including causes, damage scope, and practical countermeasures"
featured_image: "cdn/column/skt_usim.png"
tags: ["SKT Hacking", "SKT USIM Leak", "USIM Hacking", "SIM Swapping", "BPFDoor", "APT Attack", "PLURA-XDR", "Data Breach", "Demonstration", "Demo"]
---

> **Key Summary**  
> The SK Telecom **HSS** breach, confirmed on April 18, 2025, exposed USIM authentication data of up to **23 million** users. On April 28, SKT announced free USIM replacements for all customers.

<!--more-->
![SKT USIM Leak](https://blog.plura.io/cdn/column/skt_usim.png)

---

## 🗓️ Timeline
| Date | Event |
|------|-------|
| **April 18** | Internal breach detection and HSS server isolation |
| **April 19** | KISA issues alert: “Suspected BPFDoor malware” |
| **April 28** | SKT public notice → Announces free USIM replacement for all, stock drops –8.5% |
| **May 5 (expected)** | Suspension of new signups at 2,600 stores nationwide for focused replacement |

---

## 🔍 Breach Method: BPFDoor APT Scenario (Presumed)
* **BPFDoor** leverages Linux kernel BPF hooks to implement a **portless backdoor** technique that leaves no packet traces.  
* Initial internal forensic analysis reported reverse shell activity on `udp/53` and `tcp/443` submitted to KISA (prior to final report).

> **NDR Limitations & Lessons**  
> Stealth backdoors like BPFDoor using portless design and TLS encryption have **zero visibility**, making them undetectable by signature-based NDR/IDS tools.

---

## ⚠️ Secondary Threat: SIM-Swapping
The leaked combination of **IMSI‧Ki‧IMEI** can be exploited for SIM-swapping attacks, making it necessary to reissue financial/public authentication certificates and reset 2FA settings.

---

## 🛡️ Response by SKT ∙ Users ∙ Industry
1. **SKT Actions**  
   * Free USIM replacement for all customers, complimentary USIM Protection Service  
   * Suspension of new signups for a week, followed by HSS reinspection  
2. **User Best Practices**  
   ① Reserve USIM replacement → ② Reset 2FA on key accounts → ③ Block suspicious SMS links  
3. **Industry Implications**  
   * Deployment of **multi-layered detection systems** (PLURA-XDR) is essential  
   * Strengthen **rootkit detection** on core network equipment such as HSS/HLR  

---

## 🔐 Strengthening with PLURA-XDR

### ✅ Enhanced Behavior-Based Detection

* **Memory Execution Detection:** Real-time detection of memory loading and execution from abnormal paths like `/dev/shm`, enabling early-stage backdoor installation blocking through process tracking.  
* **Portless Communication Detection:** eBPF filter-based analysis of non-standard communication patterns missed by signature-based NDR/IDS systems.  
* **Reverse Shell Detection:** Early detection and alert of reverse shell attempts (e.g., `udp/53`, `tcp/443`) typically missed by firewalls and NDR systems via real-time behavior analysis.

### ✅ Advanced Log Correlation Analysis

* **Unified Log Analysis:** Integration of network, system, and application logs to perform intelligent correlation analysis.  
* **Attack Graph Analysis:** Chronological connection of logs for attacker infiltration, lateral movement, and data exfiltration stages to clearly visualize attack paths and impact.  
* **Early Warning of Anomalies:** Preemptive anomaly detection enables administrators to act before incidents escalate.

### ✅ Automated Real-Time Response

* **Automated Response:** PLURA-XDR blocks or isolates attack connections automatically upon detecting attack patterns or anomalies to prevent further damage.  
* **Automated Forensic Reporting:** Instantly generates detailed forensic data for detected attacks, aiding in quick incident response and reporting by administrators.

> **Conclusion:** Stealth APT attacks like BPFDoor cannot be countered with traditional pattern detection. PLURA-XDR's advanced detection and response capabilities provide complete visibility and control from the initial intrusion phase to post-incident analysis.

---

### 🆙 PLURA Update Notice
* [PLURA Update](https://github.com/qubitsec/plura/blob/main/update/v5.5/en/2025.md)
