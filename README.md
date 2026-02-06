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


----------------------------------------------------------------
2026-01-29
----------------------------------------------------------------

🚀 Terraform 기반 클라우드 인프라 모듈화 프로젝트
본 프로젝트는 단일 파일로 구성된 테라폼 코드를 서비스별 모듈로 리팩토링하여 재사용성과 유지보수성을 극대화한 인프라 자동화(IaC) 실습입니다. 최종적으로는 3-Tier 아키텍처 설계를 목표로 합니다.

🏗️ 아키텍처 구조 (Ground & Buildings)
본 프로젝트는 인프라를 '땅(네트워크)'과 '건물(애플리케이션)'로 분리하여 설계하였습니다.

1. Network Layer (The Ground)
VPC & Subnets: 모든 서비스의 기반이 되는 격리된 네트워크 환경을 구축합니다.

Internet Gateway & Route Tables: 외부 인터넷과의 통신 경로를 정의합니다.

2. Application Layer (The Building)
Dockerized Server: userdata.sh를 통해 Docker 및 Docker-compose 환경을 자동 구축합니다.

Security Group: 서비스별(HTTP, SSH) 맞춤형 방화벽 정책을 적용합니다.

📁 프로젝트 구조 (Directory Structure)
Plaintext

terraform-aws/
├── modules/
│   ├── vpc/           # 네트워크 인프라 (VPC, Subnet, IGW 등)
│   └── ec2/           # 서버 인프라 (EC2, Security Group, UserData)
├── terraform.tfvars   # 프로젝트 설정값 (AMI, 인스턴스 타입, 프로젝트명 등)
├── variables.tf       # 전역 변수 선언
├── outputs.tf         # 최종 출력값 정의 (Public IP 등)
├── aws_main.tf        # 메인 지휘자 (모듈 조립 및 프로바이더 설정)
└── userdata.sh        # 서버 초기화 및 앱 배포 스크립트
🛠️ 주요 리팩토링 포인트
관심사의 분리 (SoC): 네트워크 인프라와 컴퓨팅 자원을 독립된 모듈로 분리하여 독립적인 수정 및 확장이 가능하게 설계했습니다.

변수 기반 제어 (IaC Best Practice): 하드코딩을 제거하고 tfvars 파일을 통해 리전, 인스턴스 사양, 프로젝트 태깅을 한곳에서 관리합니다.

모듈 간 의존성 관리: VPC 모듈의 output 정보를 루트 모듈을 거쳐 EC2 모듈의 input으로 전달하는 데이터 파이프라인을 구축했습니다.

LocalStack 시뮬레이션: 실제 AWS 비용 발생 없이 로컬 환경에서 인프라 배포 및 트러블슈팅을 수행할 수 있도록 엔드포인트를 구성했습니다.

🚀 시작하기
환경 준비
Terraform v1.0+

LocalStack (Docker 기반 AWS 시뮬레이터)

실행 순서
Bash

# 1. 초기화 및 모듈 로드
terraform init

# 2. 실행 계획 확인 (Lock 이슈 발생 시 -lock=false 사용)
terraform plan

# 3. 인프라 배포
terraform apply
⚠️ 트러블슈팅 기록
State Lock Issue: 비정상 종료 시 발생하는 .terraform.tfstate.lock.info 교착 상태를 force-unlock 또는 물리적 삭제로 해결.

Path Reference: 모듈 내부에서 루트 경로의 파일을 참조하기 위해 ${path.root} 변수를 활용.

Provider Endpoint: 로컬 시뮬레이터를 위해 STS 및 EC2 엔드포인트를 http://localhost:4566으로 매핑.

💡 Tech Stack
Infrastructure: Terraform (HCL)

Container: Docker, Docker-compose

Backend: Flask (Python)

Database: MySQL 8.0

Cloud Simulation: LocalStack


#
--------------------------------------------------
2026-01-30
--------------------------------------------------

🚀 Terraform 기반 AWS 3-Tier 아키텍처 자동화 프로젝트
본 프로젝트는 Terraform을 사용하여 확장성 있고 보안이 강화된 3-Tier 웹 애플리케이션 인프라를 코드로 구축(IaC)한 포트폴리오입니다. 단순 리소스 생성을 넘어, 모듈 간 데이터 연계를 통한 완전 자동화 프로비저닝을 구현하는 데 중점을 두었습니다.

🏗️ 1. 아키텍처 개요
본 인프라는 외부 인터넷과 통신하는 **Public 영역(Web Tier)**과 데이터 보호를 위해 격리된 **Private 영역(Database Tier)**으로 나뉩니다.

VPC: 전용 가상 네트워크 구축 및 퍼블릭/프라이빗 서브넷 분리.

Web Tier: Public Subnet 내 EC2 인스턴스 (Docker 기반 Flask App).

DB Tier: Private Subnet 내 EC2 인스턴스 (MySQL Server). 인터넷 게이트웨이와 연결되지 않아 외부 접근이 원천 차단됩니다.

🛠️ 2. 핵심 기술적 성취 (Technical Highlights)
🔗 모듈 간 데이터 바인딩 (Output - Root - Variable 파이프라인)
테라폼의 모듈 캡슐화를 유지하면서, 리소스 간 의존성을 해결하기 위해 데이터 브로커링(Brokering) 구조를 설계했습니다.

배달 A (Security): EC2 모듈에서 생성된 Security Group ID를 Output으로 추출하여 DB 모듈의 인바운드 규칙(Variable)으로 주입. (IP가 아닌 Identity 기반 보안 구현)

배달 B (Connectivity): DB 모듈 생성 시 할당되는 Private IP를 Output으로 추출하여 Web 모듈의 userdata에 동적으로 주입.

⚙️ templatefile을 통한 완전 자동화 프로비저닝
인프라 배포 시점에 결정되는 DB 서버의 IP 주소를 Web 서버의 환경 설정에 자동으로 반영하기 위해 테라폼의 templatefile 함수를 사용했습니다.

userdata.sh 내 가상 변수(${db_private_ip}) 배치.

테라폼 실행 시 DB의 실제 IP를 해당 위치에 치환하여 주입.

결과: 인프라 생성과 동시에 애플리케이션이 DB 서버를 즉시 찾아 연결되는 Zero-config 배포 달성.

🛡️ 계층적 보안 설계
Network Level: Private Subnet 배치를 통해 DB 서버의 물리적 노출 차단.

Application Level: DB 보안 그룹 규칙에 오직 **"Web 보안 그룹 이름표(ID)"**를 가진 트래픽만 허용하도록 설정하여 VPC 내부의 침입 시도까지 방어.

📂 3. 프로젝트 구조 (Directory Structure)
Plaintext

.
├── aws_main.tf         # Root Configuration (모듈 조립 및 데이터 중개)
├── variables.tf        # 전역 변수 설정
├── userdata.sh         # Web 서버 프로비저닝 템플릿 (Docker/App 설정)
├── db_setup.sh         # DB 서버 프로비저닝 스크립트 (MySQL 설정)
└── modules/
    ├── vpc/            # 네트워크 리소스 (VPC, Subnet, RouteTable)
    ├── ec2/            # Web 서버 리소스 (Security Group, Instance)
    └── db/             # DB 서버 리소스 (Security Group, Instance)
📝 4. 주요 학습 내용 및 회고
의존성 관리: 리소스 간 데이터를 주고받는 것만으로 테라폼이 생성 순서를 스스로 판단하는 암시적 의존성(Implicit Dependency) 원리를 이해함.

IaC의 가치: 수동으로 IP를 확인하고 설정 파일을 수정하는 번거로움 없이, 코드 한 줄로 전체 인프라와 앱 설정이 동기화되는 자동화의 강력함을 경험함.

문제 해결 능력: 모듈화 과정에서 발생하는 Unsupported argument 에러 등을 해결하며 입력(Variable)과 출력(Output) 포트 매칭의 중요성을 체득함.

🚀 실행 방법
LocalStack 또는 AWS CLI 환경 준비.

terraform init : 모듈 및 프로바이더 초기화.

terraform plan : 실행 계획 확인 및 데이터 주입 경로 검증.

terraform apply : 인프라 배포.

🛠 오늘 진행한 과정 (Workflow)
LocalStack 탈피 및 Real AWS 환경 전이: 로컬 모의 환경에서 실제 AWS 서울 리전(ap-northeast-2)으로 프로바이더 설정을 변경하고 인프라 구축 시작.

상태 관리(State Management) 정화: 로컬스택의 잔재가 남은 terraform.tfstate와 좀비 프로세스를 정리하여 스테이트 락(State Lock) 충돌 해결.

IAM 자격 증명 및 인증: aws configure를 통해 실제 IAM 사용자의 Access Key를 등록하고 STS 인증 에러 해결.

AMI 및 리전 종속성 해결: 리전마다 다른 AMI ID의 특성을 파악하여 서울 리전용 Ubuntu 24.04 LTS 이미지로 교체.

보안 및 접속 설정: AWS 콘솔에 실제 키 페어(lee_key)를 등록하고, EC2에 퍼블릭 IP를 할당(associate_public_ip_address)하여 외부 접속 경로 확보.

인프라 완공 및 자원 회수: 총 14개의 리소스(VPC, Subnet, EC2, RDS 등)를 성공적으로 배포한 후, 비용 방지를 위해 terraform destroy로 깔끔하게 정리.

💡 습득한 주요 이론 (Learned Theories)
Terraform State Locking: 여러 작업자가 동시에 상태를 변경하지 못하도록 보호하는 메커니즘. 비정상 종료 시 발생하는 락 파일을 수동으로 관리하는 법 습득.

AMI Region Specificity: 동일한 OS라도 리전마다 AMI ID가 다르다는 점과 리전 간 인프라 복제 시 고려해야 할 핵심 요소 이해.

Public vs Private Networking: IGW를 통한 외부 통신(Public IP/DNS)과 VPC 내부망을 통한 안전한 데이터베이스 통신(Private IP/DNS)의 차이점 및 보안적 이점.

Immutable Infrastructure: 기존 리소스의 속성 변경 시(예: 퍼블릭 IP 추가) 테라폼이 이를 삭제 후 재생성하는 '불변 인프라'의 동작 원리 체득.

----------------------------------------
2026-02-05
----------------------------------------
# 1. terraform apply 이후에 AWS에 원격접속하기

우선 terraform 루트폴더에 내 key.pem파일 넣기

ssh -i lee_key.pem ubuntu@<내 EC2 퍼블릭IPv4 IP>

# 2. RDS에 접속해보기, private구간

우선 mysql -h <복사한 엔드포인트주소> -u 내 사용자명(kjune922) -p 입력

여기서 접속이 안되는데, 그 이유는 현재 rds 보안그룹에 3306을 설정안해줘서그럼

그래서 aws콘솔에서 rds에 들어간다음에, 연결 및 보안에서 보안그룹 들어가서
인바운드 그룹 변경 눌러서
3306을 추가해주는데, 돋보기 부분에서 네트워크 허락범위를 내가 이전에 만든 보안그룹 lee-fullstack-sg가 있음, 그걸 타이핑해서 설정하고 완료

그리고 다시하면 mysql에 원격접속이 가능해짐

--->> 외부인터넷과 격리된 DB에 내가 만든 서버를 통해서만 안전하게 접근하는 3-Tier 아키텍처

-------------------------------------------
2926-02-06
-------------------------------------------

aws ec2 원격접속하기

명령어: ssh -i <내 .pem키> ubuntu@<내 ec2퍼블릭ip>

이제 데이터베이스 접속

명령어: mysql -h <복사한 rds엔드포인트주소> -u kjune922 -p

--------------------------------------------
원격접속이후에 이제 mysql을 가상환경에서 실행

--------------------------------------------
# 1. 패키지 리스트 업데이트 (설치 전 필수)
sudo apt update

# 2. MySQL 클라이언트 설치 (명령어 창에서 DB 접속용)
sudo apt install mysql-client -y

# 3. 파이썬 패키지 매니저(pip) 설치
sudo apt install python3-pip -y

-----------------------------------------------
# 4. 가상환경 도구 설치
sudo apt install python3-venv -y

# 5. 'myenv'라는 이름의 가상환경 만들기
python3 -m venv myenv

# 6. 가상환경 속으로 들어가기 (프롬프트 앞에 (myenv)가 떠야 함)
source myenv/bin/activate

# 7. 이제 가상환경 안에서 PyMySQL 설치 (sudo 안 붙여도 됨!)
pip install pymysql

가상환경 pymsql main.py생성 후 코딩

import pymysql
import os

# 1. 환경 변수에서 값 가져와서 '변수'에 저장하기
host = os.environ.get("DB_HOST")
user = os.environ.get("DB_USER")
password = os.environ.get("DB_PASS")
database = os.environ.get("DB_NAME")

# 2. DB 연결하기
connection = pymysql.connect(
    host=host,
    user=user,
    password=password,
    database=database,
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor # 결과를 딕셔너리 형태로 받기
)

try:
    # 3. 커서(명령을 내릴 도구) 생성
    with connection.cursor() as cursor:
        # 4. SQL 실행
        sql = "SELECT count(*) as cnt FROM study_log;"
        cursor.execute(sql)

        # 5. 결과 한 줄 가져오기
        result = cursor.fetchone()
        print(f"현재 DB에 저장된 공부 기록 개수: {result['cnt']}")

finally:
    # 6. 연결 닫기 (오류가 나도 반드시 닫도록 finally 사용)
    connection.close()

그리고 
mydb안에는

CREATE TABLE study_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_VALUE
);

-- 테스트용 데이터 하나 넣기
INSERT INTO study_log (content) VALUES ('오늘도 테라폼과 파이썬');

이렇게 넣어서 테스트해보기


