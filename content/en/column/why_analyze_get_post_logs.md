---
date: 2017-02-23T00:00:00
draft: false
title: "Why Do We Analyze GET/POST Logs?"
description: 
featured_image: "cdn/column/why_analyze_get_post_logs-1.png"
tags: ["HTTP", "GET Method", "POST Method", "Web Log Analysis", "Security", "PLURA"]
---

## What is HTTP?

HTTP (Hypertext Transfer Protocol) is a protocol that enables communication between clients and servers.  
It operates on a **request-response** structure: the client sends a request to the server, and the server returns a response.

HTTP supports several request methods such as GET, HEAD, POST, PUT, DELETE, OPTIONS, TRACE, and CONNECT. However, for security reasons, most web servers allow only the **GET** and **POST** methods.  
Below, we’ll take a closer look at GET and POST methods.

![why_analyze_get_post_logs](https://blog.plura.io/cdn/column/why_analyze_get_post_logs-1.png)
<!--more-->
---

## GET Method

```plaintext
/test/test_form.php?name1=value1&name2=value2
````

The **GET method** sends data through the URL (URI). Since data is exposed in the URL, it's typically used for **non-sensitive information**, such as search queries or page numbers.

### Characteristics

* **Data exposure**: Data is visible in the URL and can be seen by anyone.
* **Size limitation**: URLs are typically limited to 4096 bytes, restricting the size of transmittable data.
* **Use cases**: Search queries, pagination in forums or listings, etc.

---

## POST Method

```plaintext
POST /test/test_form.php HTTP/1.1
Host: plura.io
name1=value1&name2=value2
```

The **POST method** transmits data in the HTTP Body. It’s mainly used to send **personal or sensitive data** through HTML forms.

### Characteristics

* **Data protection**: Data is not visible in the URL, making it more secure than GET.
* **No size limit**: Large amounts of data can be sent as long as the server responds in time.
* **Use cases**: Login credentials, personal information submission, etc.

---

## PLURA's Analysis of GET/POST Logs

The PLURA Agent analyzes client request data by separating **GET** and **POST** methods.

### GET Log Analysis

* When a client sends data in the form of a URL (URI), PLURA analyzes the **logs left in the request**.

### POST Log Analysis

* When a client sends data in the HTTP Body, PLURA analyzes the **logs within the POST body**.

### Analysis Results

* PLURA visualizes attack types, potential damage, attacker intent, and vulnerable paths.
* It also provides actionable response suggestions to help secure your server.

---

## Example: GET Log Analysis by PLURA Agent

![GET Method Example](https://blog.plura.io/cdn/column/why_analyze_get_post_logs_01.png)

---

## Example: POST Log Analysis by PLURA Agent

![POST Method Example](https://blog.plura.io/cdn/column/why_analyze_get_post_logs_02.png)

---

## ✍️ Conclusion

Attacks using the POST method are far more frequent than those using GET. This is because POST data is sent in the HTTP Body and often **does not get recorded** in standard server logs.
Therefore, thoroughly analyzing and managing POST data is essential for security.

GET and POST are the most commonly used HTTP methods, each with distinct pros and cons.
From a security perspective, POST data is particularly critical, as it is **often unlogged**—if not properly managed, it poses a serious threat.

The PLURA Agent analyzes both GET and POST methods, allowing real-time monitoring of client request data and providing insights into attack types, potential impact, and recommended responses.
This enables rapid threat detection and effective response.

**So why should we analyze POST logs?**
Because POST requests represent the most vulnerable surface from a security standpoint.
Effectively analyzing POST data is a crucial first step toward strengthening system security.
GET and POST log analysis is not just about recording data—it’s a **fundamental security process** for proactively detecting threats and protecting systems.
