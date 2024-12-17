---
date: 2023-03-15T00:00:00
draft: false
title: "Kubernetes(k8s) と PLURA"
description: 
featured_image: "cdn/tech/k8s-1.png"
tags: ["Kubernetes", "k8s", "PLURA", "ログ収集", "ウェブログ", "syslog", "コンテナログ", "セキュリティ"]
---

## 0. 概要

PLURAは以下を対象に**ログ生成・収集・分析および異常検知**を提供する統合セキュリティイベント管理(SIEM)サービスです。

> - オペレーティングシステム: イベントログ、syslog、auditlog  
> - ウェブサーバー: アクセスログ (リクエスト本文 & レスポンス本文含む)  
> - アプリケーション: すべての種類のテキストファイル  
> - ネットワーク製品: syslog  
> - 情報保護製品: syslog  

このドキュメントでは、**Kubernetes環境**でPLURAを使用してコンテナから生成される**アプリケーションログ、Syslog、ウェブログ**を収集および分析する方法を説明します。

<!--more-->
---

## 1. 前提条件

本ドキュメントで扱わない内容:
- **コントローラー**: DaemonSet, StatefulSet
- **Nodeレベルのログ管理**
- **PLURAエージェントのコンテナイメージ**

Kubernetesは環境に応じてさまざまな構成が可能であり、それぞれの環境に適した設定が必要です。  
そのため、本ドキュメントは一般的な構成例に基づいて記載されています。

---

## 2. インストール

1つのMaster-Nodeと2つのWorker-Nodeで構成されたKubernetes環境で、各Worker-NodeにPLURAをインストールします。

![k8s_plura_drawio](https://github.com/user-attachments/assets/4b0d8714-dfd2-43e9-9651-1965d0c88de3)

---

## 3. Kubernetes アプリケーションログ収集例

### nginx-deployment.yml

以下は、Worker-Nodeで実行される**nginxオブジェクトの構成ファイル**の例です。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

### ログパス

- nginxのアクセスログパス: `/var/log/containers` (元のパス: `/var/log/pods`)  
- **PLURAを利用したアプリケーションログ収集**: 構成ファイルでログパスを再定義し、収集パスに追加します。

![14](https://github.com/user-attachments/assets/da429c8c-6a09-4757-ab68-9ceec1714ed4)

### PLURAでログを確認

nginxのアクセスログをPLURAに登録し、Worker-Nodeで発生するログをPLURAアプリケーションログで確認します。

![31](https://github.com/user-attachments/assets/585ac061-e01f-4dca-b9b5-c8502500ec88)  
![32](https://github.com/user-attachments/assets/68ab7bff-3994-4adb-baa8-d5e8e3d01bc0)

---

## 4. Kubernetes Syslog収集例

### 必須項目と手順

1. HostとContainerの`/var/log/plura`ディレクトリを共有  
2. Worker NodeにPLCをインストール  
3. 各Podでrsyslogをインストールし、`rsyslog.conf`を設定  
4. PLCを設定  

### 内部IP確認

各Pod内にアクセスし、内部IPを確認します。

![pod_internal_ip](https://github.com/user-attachments/assets/4fc2be9c-8689-440a-9237-267c4a7d4e30)

### rsyslog.conf設定

- **Kernel Log無効化**および**Syslog送信サーバーIP設定**:
```plaintext
... (省略)
# module(load="imklog") // Kernel Log収集モジュール無効化
... (省略)
*.info @10.244.2.1
```

- rsyslogサービスを再起動:
```bash
service rsyslog restart
```

Worker Nodeの`/var/log/plura`ディレクトリに`ceelog-{内部IP}.log`ファイルが生成されていることを確認します。

![varlogplura_ceelog](https://github.com/user-attachments/assets/691fc6cc-2cb2-4edf-9e85-40d460bca0f3)

---

## 5. Kubernetes ウェブログ収集例

### 注意事項

1. HostとContainerの`/var/log/plura`ディレクトリを共有  
2. 各Nodeで実行されるnginx構成ファイルディレクトリに`plura.conf`をコピー (/etc/nginx/nginx.confを参照)  
3. modpluraを設定  

### plura_docker.yml

以下はWorker Nodeで実行されるnginxオブジェクトの構成ファイル例です。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      volumes:
        - name: plura
          hostPath:
            path: /var/log/plura
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
          volumeMounts:
            - name: plura
              mountPath: /var/log/plura
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxUnavailable: 1
```

### PLURAでのログ有効化

- PLURA Webログ収集パスに再定義されたnginxログパスを追加: `/var/log/plura/weblog.log`
- Webログ収集を有効化:  
  `PLURA.io > システム管理 > Worker Node設定 > Webログ収集 On`

![modplura_enable](https://github.com/user-attachments/assets/42fcd1f0-92bf-4602-a01d-91c0a251c18f)

これでWorker Nodeで発生するnginxのアクセスログをPLURAウェブログで確認できます。

![k8s_plura_weblog-1024x514](https://github.com/user-attachments/assets/5ea8edb9-f159-4182-9ab2-b879be498b00)

---

## 環境情報

| Host        | OS       | Role          | IP (NAT)      | IP (Host-Only-Network) |
|-------------|----------|---------------|----------------|-------------------------|
| k8s-master  | Rocky 8.6 | Master-Node   | 172.16.14.89   | 192.168.100.201         |
| k8s-worker1 | Rocky 8.6 | Worker-Node-1 | 172.16.14.90   | 192.168.100.202         |
| k8s-worker2 | Rocky 8.6 | Worker-Node-2 | 172.16.14.91   | 192.168.100.203         |

### Kubernetes構成

- **Version**: 1.26.2  
- **CRI**: containerd  
- **CNI**: flannel  
