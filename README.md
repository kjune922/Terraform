# ☁️ Cloud AI Infrastructure Portfolio (IaC)

2026년 졸업 예정인 예비 클라우드 엔지니어로서, 효율적이고 안전한 인프라를 구축하는 과정을 기록한 저장소입니다.

## 🚀 Project Overview
실제 AWS 비용 발생을 방지하기 위해 **LocalStack** 환경에서 인프라를 구축하며, 모든 리소스는 **Terraform**을 통해 코드로 관리(IaC)합니다.

## 🛠 Tech Stack
- **Infrastructure:** Terraform, AWS (VPC, Subnet, IGW, SG, EC2)
- **Environment:** WSL2 (Ubuntu), Docker, LocalStack
- **Tools:** AWS CLI v2, Git, Python

## 🏗 Key Implementation
### 1. Networking Foundation
- VPC(10.0.0.0/16) 및 Public Subnet 설계
- Internet Gateway와 Route Table을 통한 외부 통신 경로 확보
- Security Group을 활용한 인바운드 트래픽(HTTP:80, SSH:22) 제어

### 2. EC2 Automation
- **User Data:** 인스턴스 부팅 시 Python 웹 서버가 자동으로 구동되도록 셸 스크립트 자동화 주입
- **Metadata Verification:** AWS CLI를 통해 Base64로 인코딩된 User Data가 정상 주입되었는지 검증 완료

## 🛠 Troubleshooting (가장 중요한 부분)
- **개발 환경 최적화:** 가상 머신의 디스크 용량 한계를 극복하기 위해 WSL2 기반 개발 환경으로 완전 이그레이션 수행
- **Immutable Infrastructure 실천:** 실행 중인 인스턴스의 User Data 수정 시 발생하는 `InvalidUserData.Malformed` 에러를 분석하여 `user_data_replace_on_change` 옵션을 적용, 인프라의 불변성(Immutability)을 보장하는 구조로 개선
- **CLI 연동:** LocalStack 환경에서 AWS CLI v2를 수동 설치하고 `alias` 설정을 통해 개발 효율성 증대

## 🧠 Algorithm Study
- **Greedy & Heap:** 그리디 알고리즘의 최적 부분 구조를 이해하고, `heapq`를 활용하여 '카드 정렬하기' 등 복잡도가 
높은 문제들을 효율적으로 해결 ($O(N \log N)$)

## 🚀 Update (2026-01-21 ~ 01-22)

### 1. Infrastructure Automation (IaC)
단순 인프라 생성을 넘어, 서버 부팅과 동시에 애플리케이션 환경이 완성되는 **Bootstrap 자동화**를 구현했습니다.
- **Docker & Docker-Compose 자동 설치:** `user_data` 스크립트를 통해 인스턴스 생성 시 최신 Docker 엔진과 Compose 라이브러리를 자동 배포.
- **Web Service 배포 자동화:** Nginx 컨테이너를 부팅 직후 자동 실행하여 인프라와 서비스의 결합도 최적화.



### 2. Verification & Troubleshooting (Engineering Excellence)
LocalStack(Simulator) 환경의 한계를 극복하기 위해 다음과 같은 **Metadata 검증 전략**을 사용했습니다.
- **문제 상황:** LocalStack 무료 버전 특성상 실제 컨테이너 내부 스크립트 실행(Docker-in-Docker)은 제한됨.
- **해결 방안:** AWS CLI(`awslocal`)를 사용하여 EC2 인스턴스의 `userData` 속성을 추출하고, 이를 **Base64 디코딩**하여 설계도(Terraform)와 실제 주입된 실행 지침서가 일치하는지 데이터 무결성 검증 완료.
- **주요 명령어:**
  ```bash
  awslocal ec2 describe-instance-attribute --instance-id [ID] --attribute userData




🚀 2026-01-23: Algorithm & Cloud Infrastructure Milestone

🧠 1. Algorithm: Dijkstra (최단 경로)
가중치가 있는 그래프에서 시작점으로부터 모든 노드까지의 최단 거리를 구하는 알고리즘을 구현했습니다.

핵심 설계 논리
우선순위 큐(Priority Queue): 파이썬의 heapq를 사용하여 거리가 가장 짧은 노드를 $O(\log V)$의 시간 복잡도로 추출합니다.

가지치기(Pruning): 큐에서 꺼낸 거리 값이 이미 기록된 최단 거리(distance[now])보다 클 경우 무시하여 중복 연산을 획기적으로 줄였습니다.

시간 복잡도: 전체 알고리즘은 $O(E \log V)$의 효율성을 가집니다.

🏗️ 2. Infrastructure as Code: Terraform & Docker
수동으로 서버를 설정하던 방식을 벗어나, **코드에 의한 인프라 관리(IaC)**를 구현했습니다.

주요 구현 내용
Dockerizing: Python(Flask) 애플리케이션을 가벼운 python:3.9-slim 베이스 이미지로 컨테이너화했습니다.

Layer Optimization: requirements.txt를 먼저 복사하여 종속성 설치 단계를 캐싱함으로써 빌드 속도를 최적화했습니다.

Bootstrap Automation: Terraform의 user_data를 활용해 EC2 인스턴스 생성 시 아래 과정이 완전 자동화되도록 설계했습니다.

Docker & Docker Compose 엔진 설치

Application Source Code 생성 및 환경 구성

Docker Image 빌드 및 컨테이너 서비스 런칭 (Port 80)

Docker 로컬스텍 명령어
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
