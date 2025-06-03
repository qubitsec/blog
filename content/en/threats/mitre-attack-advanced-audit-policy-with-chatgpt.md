---
date: 2023-02-19T05:00:00
draft: false
title: "Using the Advanced Audit Policy from a MITRE ATT&CK Perspective with ChatGPT"
description: ""
featured_image: "cdn/threats/mitre_attack_advanced_audit_policy_with_chatgpt-1.png"
tags: ["MITRE ATT&CK", "Advanced Audit Policy", "Event Channel", "Windows PowerShell Channel", "Windows Event Log"]
---

> This content is a summary of a Q\&A session with ChatGPT. There have been no arbitrary modifications to the portions written by ChatGPT.

<!--more-->

### Q1. Is it absolutely necessary to use the Advanced Audit Policy to strengthen log monitoring from a MITRE ATT\&CK perspective?

> Yes. **Strengthening log monitoring is crucial to prevent large-scale hacking attacks such as MITRE ATT\&CK.**
> Log monitoring refers to the process of collecting, storing, and analyzing events that occur within a system.
> Through this, you can detect and respond to abnormal signs or malicious activities.
>
> **The Advanced Audit Policy is one feature that helps reinforce log monitoring.**
> The Advanced Audit Policy is a feature used in the Windows operating system that automatically collects and analyzes specific events in the Event Log.
> This allows administrators to analyze the Event Log more easily and quickly identify malicious activity.
>
> In addition, the Advanced Audit Policy allows you to specify which events to collect and provides filtering features so you can collect only the necessary events.
> This helps reduce the volume of log data and makes analysis much easier.
>
> **Therefore, strengthening log monitoring is essential to prevent large-scale hacking attacks such as MITRE ATT\&CK,
> and the Advanced Audit Policy makes log monitoring more efficient and helps you detect malicious activities more quickly.**

### Q2. How many event channels does Windows provide?

> The number of event channels provided by the Windows operating system varies depending on the version and edition, but in general there are many event channels.
> For example, **Windows 10 includes around 2,000 event channels**, while **Windows Server 2019 includes around 2,500 event channels**.
> Event channels are primarily used for logging and monitoring functions, and each channel logs information about specific event types.
> You can use the Event Viewer to view logs from the event channels and search, filter, or analyze the information you need.

### Q3. Not all channels are active by default. Approximately how many channels are active, and could you provide a list?

> **Not all event channels in Windows are always active.**
> Typically, there are channels that are activated by default, but users can enable additional channels they need or disable channels that are unnecessary.
>
> The major event channels that are active by default in Windows 10 are as follows:
>
> * Application
> * Security
> * Setup
> * System
>
> The major event channels that are active by default in Windows Server 2019 are as follows:
>
> * Application
> * Security
> * Setup
> * System
> * Windows PowerShell
>
> Besides these, various other channels may be activated depending on the version and edition, and you can manually enable or disable channels as needed.

### Q4. I've heard that the Windows PowerShell channel can be disabled. Is it actually enabled or disabled?

> The **Windows PowerShell channel is enabled by default on Windows Server operating systems but may be disabled on Windows client operating systems.**
> This is due to security reasons—Windows client operating systems are typically configured to limit PowerShell script execution by default.
>
> Therefore, to use the PowerShell channel on a Windows client operating system, you need to manually enable it.
> To enable the PowerShell channel, you can follow these steps:
>
> **1) Run PowerShell with administrator privileges**
> **2) Enter the following command:**
> Enable-NetFirewallRule -DisplayGroup "Windows PowerShell"
>
> This command adds a firewall rule that allows PowerShell script execution.
> After that, you can view events in the PowerShell channel.
>
> Conversely, if you want to disable the PowerShell channel, run the command:
> Disable-NetFirewallRule -DisplayGroup "Windows PowerShell"

### Q5. Qubit Security’s plura.io provides a MITRE ATT\&CK–focused detection capability using the Advanced Audit Policy. Could you explain?

> Qubit Security’s plura.io is one of the cloud-based security monitoring service platforms.
> The Advanced Audit Policy provided by this platform collects and analyzes various events occurring on a user’s system to detect security issues.
> Through this, you can quickly detect and respond to large-scale hacking attacks such as MITRE ATT\&CK.
>
> Events that can be detected using the Advanced Audit Policy include the following:
>
> **1) Login Events**
>
> * When multiple login attempts occur simultaneously from various IPs
> * When an abnormal number of failed login attempts occur
> * When login attempts happen too frequently
>
> **2) Administrator Account Events**
>
> * When attempts are made to change administrator account information
> * When there are failed login attempts with an administrator account
> * When abnormal activities occur under an administrator account
>
> **3) Network Events**
>
> * When access attempts occur from unknown IP addresses
> * When multiple IP addresses attempt access at the same time
> * When a large volume of data is transferred
>
> In addition to these, a wide range of events can be detected, and notifications or alerts are provided based on such events so administrators can respond quickly.
> Furthermore, you can analyze the event occurrence history to develop future response strategies.
>
> **Therefore, using the Advanced Audit Policy offered by plura.io is extremely useful for detecting and responding to various events, including large-scale attacks such as MITRE ATT\&CK.**

![mitre\_attack\_advanced\_audit\_policy\_with\_chatgpt](https://blog.plura.io/cdn/threats/mitre_attack_advanced_audit_policy_with_chatgpt-1.png)

## 📖 Further Reading

* [Windows Event Log](https://learn.microsoft.com/en-us/windows/win32/wes/windows-event-log)
