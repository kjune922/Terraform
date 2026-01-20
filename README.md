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
- **Greedy & Heap:** 그리디 알고리즘의 최적 부분 구조를 이해하고, `heapq`를 활용하여 '카드 정렬하기' 등 복잡도가 높은 문제들을 효율적으로 해결 ($O(N \log N)$)
