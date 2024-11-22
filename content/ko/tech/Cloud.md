---
date: 2017-09-21T00:00:00
description: 
featured_image: 
tags: 
title: "퍼블릭 클라우드를 활용한 웹 호스팅"
---

![1](https://github.com/user-attachments/assets/4efacf1e-7021-45eb-8253-a32b33e34a36)

큐비트시큐리티는 홈페이지/블로그를 PLURA 서비스 망과 완전히 분리하여 운영하고 있습니다. <br>
안정성과 보안성에 무게를 둔 PLURA 서비스 망과 달리, 저희 홈페이지/블로그는 퍼포먼스에 중점을 두고
퍼블릭 클라우드에 구성하였습니다. <br>
대략적인 구성은 다음과 같습니다.

![2](https://github.com/user-attachments/assets/e6fd658c-babd-48cb-a612-d9303b8a86d7)

상황에 맞게 클라우드 전 스택(IaaS, PaaS, SaaS)을 모두 사용하였습니다.

구성을 차례대로 알아보도록 하겠습니다.

## 1. CDN (AWS: CloudFront, Azure: CDN)
AWS 엣지 로케이션에 위치한 CDN레이어에서는 대부분의 컨텐츠를 캐싱하고 있다가 요청시에 바로 전달합니다. 또한 이 레이어에서는 WAF 레이어를 더하여 SQL 인젝션이나 XSS 등의 공격을 1차 필터링합니다.
MS Azure의 경우에는 Akamai, Verizon 등의 글로벌 파트너들을 통해 CDN을 제공하고 있습니다.
또한 웹 서버로부터 이 레이어까지는 http를 압축해 전달하며, 이 레이어를 지나 신뢰할 수 없는 인터넷망을 통해 사용자까지 데이터가 전달되므로 기밀성을 위해 https로 변환합니다.
또한 AWS에서 제공하는 CDN과 Load Balancer 레이어에서는 레거시시스템과 달리 트래픽을 그대로 넘겨주기때문에 Source 확인을 위해 X-Forwardfor 등의 설정을 하지 않아도 됩니다.

* AWS: aws.amazon.com/cloudfront/
* Azure: azure.microsoft.com/en-us/services/cdn/

 

## 2. Load Balancer (AWS: ELB, Azure: Load Balancer)
캐싱된 컨텐츠가 아닌 다른 요청이 들어왔을시에 웹서버를 부하분산합니다. 기본은 인스턴스 한 대로 되어 있으나 CloudWatch가 CPU를 주시하다가, 사용량이 80%를 넘을 시 CloudFormation을 트리거해 미리 정의된 스크립트대로 웹서버 인스턴스를 복제, 생성해 부하분산 pool에 포함시킵니다.

* AWS: aws.amazon.com/elasticloadbalancing/
* Azure: azure.microsoft.com/en-us/services/load-balancer/

 

## 3. Webserver (AWS: EC2, Azure: Virtual Machines)
가상머신에 웹서버를 설치 후 워드프레스로 구축하였습니다.
또한, 오토스케일링시 복제되어 생성되는 머신과의 데이터 불일치를 막기 위해 가상머신 외부에 존재하는 AWS S3에 컨텐츠를 백업하고 동기화하도록 설정하였습니다. FUSE를 이용해서 S3를 NFS처럼 마운트 하는 방법도 있지만 퍼포먼스나 안정성 등에서 많은 손해를 보기 때문에 워드프레스에서 제공하는 플러그인을 이용해 S3로 컨텐츠를 동기화하길 추천합니다.
추가적으로, ElasticBeanstalk와 같이 PaaS를 사용하시면 PHP머신에 wordpress코드만 업로드해서 사용가능하기에 운영부담이 줄어듭니다. 저희의 경우에는 웹서버에서 log를 취합하기 위해서 가상머신에 직접 웹서버와 PHP를 올려서 구축하였습니다.
호스팅할 페이지가 정적인 페이지일 경우, 페이지를 S3에 업로드하는 것 만으로도 웹호스팅이 가능합니다. 이 방법을 사용하시면 모든 관리프로세스가 없어집니다.

* AWS: aws.amazon.com/ec2/
* Azure: azure.microsoft.com/en-us/services/virtual-machines/

* FUSE를 이용한 S3 직접 마운트: github.com/s3fs-fuse/s3fs-fuse/
* Wordpress 플러그인을 이용한 S3 백업: wordpress.org/plugins/amazon-s3-and-cloudfront/

 

## 4. Database (AWS: RDS, Azure: SQL Database)
가상머신 인스턴스에 직접 DB를 설치하는 방식(IaaS)이 아니라 관리형DB를 선택(PaaS/SaaS)하였습니다. 이는 오토스케일링, 리전간 DB복제, 자동 업데이트 및 백업 등을 간편하게 지원합니다. 관리형DB의 경우에는 하위레이어인 DB의 OS에 직접 접근할 수 없으며 mysql 명령어를 통한 접근만 가능합니다.

* AWS: aws.amazon.com/rds/
* Azure: azure.microsoft.com/en-us/services/sql-database/

 

## 5. Virtual Network (AWS: VPC, Azure: VNet)
가상네트워크를 정의하는 방식은 AWS와 Azure 사이에 유사한 점이 많습니다. 네트워크 가용 IP 개수를 계산할 때에 레거시 환경에서는 2개(네트워크 주소, 브로드캐스트 주소)를 제하는 반면 퍼블릭 클라우드에서는 5개(네트워크 주소, 브로드캐스트 주소, 게이트웨이, 가상 DNS, 예약주소)를 제합니다.
서브네팅 범위는 벤더에 따라서 차이가 있습니다. Azure의 경우에는 레거시 방식과 동일하게 제공하는 반면 AWS는 제약이 있습니다. 예를들어, A클래스 사설네트워크(10.0.0.0/8)의 경우 기존대로라면 8~30 bit 의 서브네팅이 가능합니다. 다만 클라우드에서는 5개의 주소가 기본적으로 사용되는 점을 감안하면 8~29 bit가 사용가능한 서브네팅 범위가 될 것입니다.
Azure에서는 실제로 8~29bit 까지 서브네팅을 허용합니다. AWS의 경우에는 16~28bit 범위 내에서의 서브네팅만 허용합니다. 이런점을 통해서도 레거시 지원에 충실한 MS와 기존형식에 얽매이지 않고 새롭게 만들어가는 AWS의 성향 차이가 보이는 것 같습니다.

* AWS: aws.amazon.com/vpc/
* Azure: azure.microsoft.com/en-us/services/virtual-network/

 

## 6. 리전 및 redundancy 관련
고가용성 설계를 위해서는 redundancy에 대한 고려 또한 중요합니다.
AWS의 경우에는 각 각의 리전이 있고 각 리전은 다시 2~3개의 가용지역(AZ)를 갖습니다. 서울 리전의 경우에 2개의 AZ로 구성되어 있으며 각각은 서울 기준으로 남,북에 있는 것으로 알려져 있습니다. 리전 간 가격차이는 있으나, AZ간 가격차이는 없습니다.
Azure의 경우에는, 각 지역간 쌍을 이루어 리전이 존재합니다. 우리나라의 경우 Korea Central, Korea South로 각각 서울, 부산에 있습니다. AWS의 경우에는 AZ가 단지 redundancy를 위해서 컴퓨팅 자원을 나눠서 배치하는것만 고려하면 되지만 Azure의 경우에는 Korea Central – Korea South 간 가격 차이도 존재합니다.
리전과 관련한 더 깊은 내용은 다음 링크를 참조 바랍니다.

이 부분에서는 Azure가 비교적 좋은 평가를 받습니다. VM을 만들 때에, update domain, fault domain 등을 설정할 수 있으며 컴퓨팅자원이 어디에서 실행되는지 전혀 가시성을 제공하지 않는 AWS와 다르게 Azure는 다양한 방법으로 보여주는데, 레거시 환경에 대한 지원이 뛰어난 MS이기에 가능한 것이 아닌가 합니다.

* AWS: docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
* Azure: azure.microsoft.com/en-us/regions/

Azure에서의 가용성 설정: docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability

 

## Reference
* https://aws.amazon.com/blogs/security/
* https://azure.microsoft.com/en-us/blog/
