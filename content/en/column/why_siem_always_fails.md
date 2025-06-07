---
title: "So You Deployed a SIEM—Now What? If You Can’t Collect or Analyze Logs Properly"
date: 2025-05-16T00:00:01
draft: false
description: "If you’ve invested in SIEM but can’t gather logs or lack the capability to analyze them, it’s merely an expensive visualization tool. Let’s explore the real-world limitations."
featured_image: "cdn/column/why_siem_always_fails.png"
tags: ["SIEM", "Security Operations", "Overengineering", "Log Analysis", "Security", "PLURA-XDR"]
---

📉 Many companies consider deploying **Unified Log Management** or a **SIEM**.
However, there’s a critical question: **Are you actually collecting your logs?** And if so, **do you have the capabilities to analyze them?**

Here’s the bottom line: **most organizations fail at properly collecting logs in the first place**,
and **even fewer have the capacity to analyze what they do collect**.

In such situations, a SIEM becomes nothing more than an **expensive dashboard** with no real security benefits.

*(SIEM: Security Information and Event Management)*

![The Illusion of Deploying a SIEM](https://blog.plura.io/cdn/column/why_siem_always_fails.png)

<!--more-->

---

## 1. The Reality: You Can’t Even Collect Logs 🛑

### (1) Limitations of Web Server Logging

* Most **web servers** only generate **access logs**, containing data such as:

  * **IP address**, **URL**, **HTTP status code**, **basic request headers**, etc.
* The **request body** and **response body** are often **not** logged by default.

  * 👉 **SQL Injection** typically involves malicious queries inside the request body.
  * 👉 **Data exfiltration** of personal information can happen in the response body.
* As a result, **key attack details** may be **completely absent** from logs,
  making it hard to investigate an incident solely via logs.

> Some solutions (like WAF) or advanced logging can capture **request/response bodies**,
> but **performance overhead** and **additional costs** often prevent widespread implementation.

👉 [Responding to data exfiltration attacks via web traffic](https://blog.plura.io/en/column/dlp/)  
👉 [Why analyzing entire web logs is crucial](https://blog.plura.io/en/respond/very_important_analyze_web_logs/)

---

### (2) Lack of Audit Policy for Operating System Logs

* On **Windows** or **Linux**, if **auditing** (Event/Log Policy) is disabled,

  * **User logins**, **process executions**, **privilege changes**, and other critical events may be **unrecorded**.
* Even if auditing is enabled, in environments generating **hundreds of thousands to millions** of logs,

  * You need clear **rules** or **analysis criteria** to sift through normal vs. abnormal events.
  * Otherwise, you’ll have “logs in place, but no ability to interpret or categorize them.”

---

### (3) Limitations of Security Product Log Collection

As with web servers or operating systems, **IPS**, **NDR**, **WAF**, **EDR**, and other security solutions each face constraints on what logs they can collect.

#### [1] IPS (Intrusion Prevention System) Logging Limitations

1. **HTTPS Decryption**

   * **IPS** appliances generally provide only partial or limited decryption capabilities for **HTTPS** traffic.
   * Full decryption at large scale imposes huge **performance** overhead and must be carefully vetted for vendor support.

2. **Inability to Decrypt SSH, RDP, and Other Encrypted Protocols**

   * **SSH** and **RDP** use end-to-end encryption with session keys, making **man-in-the-middle** decryption by IPS nearly impossible.
   * An IPS can only analyze **headers** and **connection info**, not the **session contents** (commands, file transfers).

3. **Conclusion**

   * **IPS logs** typically contain **TCP/IP-level** data.
   * **HTTPS** decryption is usually handled by a **WAF** or **TLS proxy**, while protocols like SSH/RDP remain opaque.
   * Relying on the IPS alone to feed rich, decrypted data to a SIEM is impractical.

👉 [Understanding Intrusion Prevention Systems (IPS)](https://blog.plura.io/en/column/ips_understanding/)

---

#### [2] NDR (Network Detection & Response) Logging Limitations

NDR (Network Detection & Response) analyzes traffic from a **behavioral** perspective, but still faces similar issues:

1. **HTTPS Decryption (Same as IPS)**

   * Some NDR products can partially decrypt HTTPS using **certificates** or **proxies**,
     but they generally don’t deeply analyze full **HTTP bodies** like a WAF might.

2. **Lack of Decryption for SSH, RDP, etc. (Same as IPS)**

   * **SSH** and **RDP** remain end-to-end encrypted, preventing NDR from decrypting.
   * Consequently, **in-session details** (commands, files) can’t be logged or provided to a SIEM.

3. **Conclusion**

   * **NDR**, like **IPS**, cannot forward the **payload** of encrypted protocols (SSH, RDP) to the SIEM.
   * Full HTTPS body analysis is also uncommon.
   * Relying on NDR alone won’t capture the **granular** contents of encrypted traffic.

👉 [NDR’s Limitations: A Mission Impossible](https://blog.plura.io/en/column/limitations_of_ndr/)

---

#### [3] WAF (Web Application Firewall) Logging Limitations

1. **Limitations on Forwarding the Entire Original Payload**

   * A **WAF** can log detailed **events** (for requests flagged as malicious),
     but sending the **entire raw data** of all “normal” traffic to the SIEM is often limited.
   * Full data capture can introduce **performance** or **storage** overhead,
     so it’s highly dependent on product capabilities and careful configuration.


---

#### [4] EDR (Endpoint Detection & Response) Logging Limitations

1. **Requires OS Auditing to Be Enabled for Meaningful Logs**

   * **EDR** tracks **process execution**, **file modifications**, **registry changes**, etc.
   * If Windows or Linux **auditing** is turned off, **core events** remain unlogged.
   * Without those events, the EDR can’t feed significant data to the SIEM.

---

### Final Summary

* **Web servers** logging only **basic access** data can’t reveal **SQLi** or **data exfiltration** attempts in the request/response body.
* With **OS auditing** disabled, essential logs **don’t even exist**.
* Both **IPS** and **NDR** can’t decrypt protocols like **SSH/RDP**, and even **HTTPS** decryption is rarely complete.
* **WAF** can decrypt/analyze malicious traffic but may not pass **all normal traffic** to a SIEM.
* **EDR** is meaningless if OS audits are disabled.

Fully capturing **encrypted traffic** or **host-level behavior** demands:

1. Verifying **which data** each solution can gather **beforehand**,
2. Configuring the right **policies** (OS auditing, TLS proxying, advanced logging),
3. Applying these capabilities to fit your operational environment.

Without these, the logs feeding your SIEM might be insufficient to detect **major attacks** or **intrusion footprints**.

---

## 2. Log Analysis? Not Happening 🤔

### (1) Can You Identify Malicious Web Queries from SIEM?

To detect **SQL Injection**, **XSS**, or **web shells** via SIEM:

* You must ingest and **index** the **malicious payload** fields (often in the **request/post body**).

#### Why the Request Body?

* Typical **web server access logs** contain IP address, URL, HTTP status, and headers.
* **SQL Injection** often resides in `POST`/`PUT` **request bodies**, e.g., “`SELECT * FROM ...`”.
* If the **request body** isn’t logged, then you can’t locate “`select * from`” or other suspicious patterns.

#### “Can’t We Just Collect the Request Body, Then?”

* Yes, you can capture **request bodies** and forward them to SIEM via **WAF** or specialized agents.
* But even with **complete data**, a SIEM can’t magically classify “this is definitely SQLi.”

  * Not all “`select * from`” strings are malicious; they could be legitimate queries.
  * Operators must craft **detection rules** (e.g., suspicious strings + conditions) and manage exceptions.

#### Ultimately, You Must Define the “Attack Query” Rules

* Even if you can do “`WHERE request_body CONTAINS 'select * from'`” in SIEM,

  * Distinguishing legitimate queries from malicious ones requires **fine-tuned** user rules.
* So don’t expect SIEM to auto-detect SQLi out of the box. You must:

  * Collect the **request body**,
  * Write **detection rules** for suspicious patterns,
  * Exclude normal usage scenarios manually.

👉 [Why Analyze GET/POST Logs?](https://blog.plura.io/en/column/why_analyze_get_post_logs/)

---

### (2) Identifying Advanced Threats like BPFDoor?

**BPFDoor** is a **highly advanced backdoor** hidden at the **Linux kernel** level:

* It rarely shows up as a **user-mode process** or standard **OS event logs**.
* Used in major hacks like the [SK Telecom breach in April 2025](https://blog.plura.io/ko/column/leak_of_skt_usim/), causing serious damage. 💀

#### Why Doesn’t It Show in “Normal” Logs?

* **Kernel-level** malware/backdoors can hide from ordinary OS events (process start/stop, network connections).
* Threats exploiting **eBPF** or **kernel hooking** can invisibly manipulate or mask traces at user space.

#### “What If a Forensic Tool Reports ‘BPFDoor Suspect Event’ to SIEM?”

* Suppose some specialized forensic tool examines **kernel memory** or **eBPF programs**, flags suspicious BPFDoor activity, and sends those logs to SIEM.
* For SIEM to auto-classify it as “100% BPFDoor,” you’d need:

  * **Predefined** rules or detection logic referencing “bpfd,” “hash values,” or “specific call patterns.”

#### Advanced Threats Depend on **User-Defined Knowledge/Rules**

* Even if a **forensic tool** gathers logs, the SIEM itself doesn’t magically know if it’s malicious.
* Without **user-defined** attack patterns and correlation logic, the SIEM might only see a benign “log event.”

---

### (3) Detecting DLL Injection?

**DLL Injection** is a technique where malicious DLLs are forcibly loaded into another process to escalate privileges or run arbitrary code.

#### Process Logs Alone Are Inadequate

* Standard “process execution” logs typically don’t detail “which DLL was loaded and when.”
* Accurately detecting DLL injection requires capturing

  * “**Who** loaded **which DLL**, at **what** time,”
  * via specialized logging like **ETW** or **Sysmon**.

#### Having Data Isn’t Enough—Is the DLL Malicious?

* For instance, a simple rule: “`WHERE dll_name = 'malicious.dll'`.”

  * Attackers can rename files or even exploit benignly signed DLLs.
  * The SIEM might simply ignore it if the name is unexpected.
* You must set rules like “Any DLL loaded from an **unusual path** is suspicious” or “No **unsigned DLL** is allowed.”
* So, you need constant rule updates to track the dynamic nature of malicious DLL injection.

---

### (4) Handling Credential Stuffing?

**Credential stuffing** occurs when attackers reuse **exposed username/password** combos from one breach to attempt logins on another service or system.

* Example: Using account credentials leaked from “Service A” to brute-force “Service B.”

*(The [GS Retail breach in January 2025](https://blog.plura.io/ko/threats/case-gs_credential_stuffing/) leveraged such an attack. 💀)*

#### Why Is SIEM Alone Insufficient?

1. Merely seeing repeated “login failures” doesn’t guarantee it’s malicious.

   * Detecting credential stuffing requires correlating “which IP made how many user login attempts” in a certain timeframe.

2. **User credentials** (IDs) are typically in the **POST body**.

   * Standard access logs might only show “login URL,” “HTTP status” (200, 401, etc.).
   * Without capturing **request bodies** (username, password), you can’t identify “IP A tried user1, user2, user3…”

3. **User-defined** correlation rules are essential.

   * Example: “Same IP attempted **multiple user accounts** in a **short timeframe** → suspicious.”
   * Without carefully defined conditions in SIEM, it just sees repeated failures.

#### Example: Building a “Credential Stuffing” Detection Rule

* `WHERE action='login' AND result='fail' AND ip_count > 5 IN 10min`
* `WHERE request_body.user_id_count > 3 AND ip=’xxx.xxx.xxx.xxx’ IN 5min`
* You must specify IP attempts, time windows, and user thresholds for SIEM to flag it as suspicious.

#### Conclusion

* For **credential stuffing** detection, analyzing **request bodies** is critical.
* You also need a correlation rule that groups login failures by IP, time, and user counts.
* Automated responses (account lockouts, MFA triggers) require further integrations (SOAR, WAF).
* Again, **operators** must define detection logic, as the SIEM won’t auto-detect these patterns by default.

---

### ✅ Summary: “At the End of the Day, You Must Define Every Attack for SIEM”

Common issues in examples like web attacks, BPFDoor, DLL injection, and credential stuffing:

1. Even if logs are collected,
2. The SIEM won’t **automatically** decide “this is an attack.”

   * **Users** must **predefine** detection rules and exceptions.
   * Only then can the SIEM flag these as suspicious events.

Hence:

* Expecting “**SIEM = automatic attack analysis**” is often unrealistic.
* Without **quality logging**, well-crafted **rules**, and **expert knowledge**,
* You’ll end up manually querying logs with no real automation.

> **Key Takeaway**: A SIEM simply **stores and queries** incoming data.
> It doesn’t inherently **decide** “what’s malicious.”
> That ultimately requires **trained personnel** and robust processes.

---

## 3. A SIEM Is More Than a Dashboard 📊

### (1) Nice Charts ≠ Log Analysis

* SIEM vendors hype “AI dashboards” or “visual risk scores.”
* Eye-catching visuals do **not** equal automatic threat detection.
* Without **log quality** (what data is collected, how detailed it is) and
  **analysis expertise** (how to interpret these logs),

  * A dashboard is little more than a pretty graph.

### (2) SIEM ≠ All-Purpose Security Solution

* A SIEM is mainly for **storing and correlating** gathered logs.
* **Without** a plan for “what to collect” and “how to analyze,”

  * 👎 it’s just a **hollow statistics display**.
* Many organizations fall for **overengineering**:

  * Believing “**If we build a SIEM, we’ll block all attacks**.”
  * In reality, if you don’t integrate **proper log collection** and **rule design**,

    * even a pricey SIEM will prove worthless.

### (3) SIEM + AI ≠ Magic Bullet

* Some believe feeding “**all logs**” to an **AI engine** in SIEM will
  **automatically** detect every threat.
* Even with AI, humans must define:

  * **Which data** is worth analyzing,

  * The **priority** and **scoring** criteria.

  * Dumping all logs indiscriminately may drive up costs while diluting accuracy.

  * If logs are **noisy** or lack meaningful signals, AI won’t reliably spot real threats.
* An **AI model** also needs **domain knowledge** (which patterns matter, which data fields are significant) and
  well-structured **rules**.

  * “Garbage in, garbage out.” If your data is messy, AI outputs will be equally poor.
* So even with **SIEM + AI**, you still need:

  * **Quality log collection**, **analysis policies**, and
  * **Human** oversight for final interpretation.
* Therefore, “**AI alone solves our security**” is an **overly optimistic** assumption.
  Without **human-centric** operational processes, SIEM+AI can become pointless.

---

## 4. Conclusion: Before You Get a SIEM, Do This ✅

1. **Establish a Proper Logging Environment.**

   * Collect **request/response bodies**, OS audit logs, DB audit logs, etc., where relevant.
   * As logging scope expands, **storage** and **network bandwidth** costs rise.
     Start with priorities and scale gradually.

2. **Design Detection Rules and Use Cases.**

   * Map out potential attack scenarios using **OWASP Top 10**, **MITRE ATT\&CK**, and internal policies.
   * “Which events count as suspicious? Which logs do we focus on storing/analyzing first?”
   * If this framework is missing, SIEM can’t operate effectively.

3. **Ensure Skilled Personnel and Training.**

   * No matter how advanced the SIEM, if operators lack knowledge of logs and rules, it’s pointless.
   * Invest in people, training, and establishing cooperation among security teams, developers, and ops.

4. **Realistic Operational Costs.**

   * SIEM deployment demands ongoing resources: **log storage**, **analysis staff**, **query tuning**, etc.
   * If you start capturing request bodies or OS audit logs,

     * **Storage** usage skyrockets, and
     * **License** costs may surge too.
   * You also need skilled **security analysts** to keep rules updated, investigate events, and differentiate false positives.
   * Total costs exceed the purchase itself and include **maintenance, licenses, staff**, etc.

5. **FAQ**

   **Q1. “How do we manage overwhelming log volume?”**

   > **A1.** Scope your log collection based on security/business priorities.
   > Separate archival (long-term) from real-time online analytics.
   > Use indexing or compression to reduce storage costs.

   **Q2. “How do we create tailored attack scenarios?”**

   > **A2.** Reference public frameworks like OWASP Top 10, MITRE ATT\&CK,
   > then incorporate your unique services and workflows.
   > Regularly test and refine scenarios to validate real-world relevance.

   **Q3. “If we apply an AI model, can we reduce security headcount?”**

   > **A3.** AI can automate repetitive tasks or filter out some false positives,
   > but final interpretation (“Is this truly malicious?”) still requires human expertise.
   > Domain experts must maintain data quality and update scenarios.

   **Q4. “Does deploying a SIEM automatically enable SOAR?”**

   > **A4.** Theoretically, **SOAR** (Security Orchestration, Automation, and Response) can automate responses to SIEM alerts.
   > However, you need reliable **detection** first—SIEM must provide accurate alerts,
   > and you must configure automation workflows carefully.
   > If SIEM has too many false positives, SOAR could block legitimate traffic.
   > It’s best to stabilize SIEM first, then consider SOAR integration.

Hence:

> (1) Deploy SIEM, stabilize **log collection** and **detection rules**,
> (2) Build competency to differentiate “false positives vs. real threats,”
> (3) Once SIEM yields **fairly accurate results**, consider **SOAR**.

> There’s a saying, “It’s never too late to adopt SOAR after perfecting your SIEM,”
> because you need **SIEM proficiency** before SOAR can be effective.
> Aim for something like **[PLURA-SIEM](https://www.plura.io/platform/siem)** as your benchmark.

> **In short**, implementing SIEM is more about **operations** than mere **deployment**.
> If you haven’t established the right logging and analysis frameworks, your SIEM becomes a **costly dashboard** with little real value.

> No logs, no detection.
> No rules, no analysis.
> Ultimately, a dashboard is just **a pretty picture**. 🎨

---

## 5. SIEM Pre-Deployment Checklist 📋

Before rolling out a SIEM, verify these points:

| Category                        | Key Questions                                                                                                                                            | Check |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| **Log Collection Scope**        | - Can we capture crucial attack data (request/response bodies)? <br>- Are OS/DB audit logs enabled?                                                      | □     |
| **Auditing Policy** (Win/Linux) | - Are key events like user logins, process executions, privilege changes fully logged? <br>- Could the sheer volume of logs overwhelm analysis?          | □     |
| **Attack Detection Rules**      | - Have we prepared rules referencing OWASP Top 10, MITRE ATT\&CK, and internal scenarios? <br>- Can we handle advanced threats (BPFDoor, DLL injection)? | □     |
| **Staff & Team Organization**   | - Do we have skilled personnel to manage the SIEM? <br>- Is there a clear collaboration process among security, dev, and ops teams?                      | □     |
| **Automation & Infrastructure** | - Is our network/storage infrastructure ready for large-scale log flow? <br>- How do we handle SIEM maintenance and performance issues?                  | □     |

By thoroughly considering these items and creating a solid plan **before** adopting a SIEM, you’ll avoid ending up with a **fancy but useless dashboard**, instead achieving **meaningful security** benefits.

---

## ✍️ Final Takeaways

* SIEM deployment **isn’t** the end goal—**operational effectiveness** is key.
* Without robust **log collection**, a SIEM means nothing.
* Without skilled **log analysis** capabilities, a SIEM is practically worthless.
* Hence, ensure you have **log ingestion**, **detection rules**, and **trained staff** in place before deploying SIEM.

> “**99.999% of existing SIEM setups may not function properly for these reasons.**” 🤫

---

### 📚 PLURA Blog

* [If You Deploy SIEM, Then What? If Log Collection & Analysis Don’t Work](https://blog.plura.io/en/column/why_siem_always_fails/)
* [Is Log Analysis for Hack Investigations a Myth?](https://blog.plura.io/en/column/myth/)
* [Analyzing Request Body Logs in Splunk](https://blog.plura.io/en/column/splunk_request_body_analysis/)
* [Introduction to Preventing Data Exfiltration via Web Traffic](https://blog.plura.io/en/column/dlp/)
* [Traditional SOC vs. PLURA-XDR Platform](https://blog.plura.io/en/column/traditional_soc_vs_plura_xdr/)
* [If You Deploy SOAR, Then What? No Real Automated Response If It Can’t Act](https://blog.plura.io/en/column/why_soar_always_fails/)

### 🌟 PLURA-XDR Services

* [Introduction to PLURA-XDR](https://www.plura.io/platform/xdr)

> In practice, SIEM can be far **more complex** than expected.
> But if you **properly** prepare log collection and analysis,
> SIEM can become a **powerful security intelligence** tool.

> If you find **building and operating a SIEM** in-house too burdensome in terms of cost, maintenance, and expertise,
> we recommend using a **unified solution** like the **[PLURA-XDR](https://www.plura.io/platform/xdr) automated platform** to streamline your security operations.
