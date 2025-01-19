# nat-module

GCP Terraform nat module Repo

Google Cloud Platform(GCP)에서 NAT 리소스를 생성하고 관리하기 위한 Terraform 모듈입니다. <br> 
이 모듈은 다른 리소스(VPC, Subnet 등)과 함께 구성할 수 있도록 설계되었습니다.

<br>

## 📑 **목차**
1. [모듈 특징](#모듈-특징)
2. [사용 방법](#사용-방법)
    1. [사전 준비](#1-사전-준비)
    2. [입력 변수](#2-입력-변수)
    3. [모듈 호출 예시](#3-모듈-호출-예시)
    4. [출력값 (Outputs)](#4-출력값-outputs)
    5. [지원 버전](#5-지원-버전)
    6. [모듈 개발 및 관리](#6-모듈-개발-및-관리)
3. [테스트](#테스트)
4. [주요 버전 관리](#주요-버전-관리)
5. [기여](#기여-contributing)
6. [라이선스](#라이선스-license)

---

## 모듈 특징

- Google Compute Router에 NAT 설정 추가.
- 서브네트워크별 NAT 설정 지원.
- 동적 또는 정적 NAT IP 할당 지원.
- TCP, UDP, ICMP 등 프로토콜별 유휴 타임아웃 설정 가능.
- Terraform 출력값으로 생성된 NAT 리소스 정보 제공.

<br>

## 사용 방법

### 1. 사전 준비

다음 사항을 확인하세요:
1. Google Cloud 프로젝트 준비.
2. 적절한 IAM 권한 필요: `roles/compute.networkAdmin`.
3. NAT를 적용할 Cloud Router 및 서브네트워크가 생성되어 있어야 합니다.

<br>

### 2. 입력 변수

| 변수명                           | 타입           | 필수 여부 | 기본값     | 설명                                      |
|----------------------------------|----------------|-----------|------------|-------------------------------------------|
| `name`                           | string         | ✅        | 없음       | NAT 서비스 이름 (RFC1035 준수)              |
| `router`                         | string         | ✅        | 없음       | NAT가 구성될 Cloud Router 이름              |
| `source_subnetwork_ip_ranges_to_nat` | string     | ✅        | 없음       | NAT가 서브넷별로 구성되는 방식 (ALL_SUBNETWORKS_ALL_IP_RANGES 등) |
| `nat_ip_allocate_option`         | string         | ❌        | null       | NAT 외부 IP 할당 방식 (MANUAL_ONLY 또는 AUTO_ONLY) |
| `initial_nat_ips`                | list(string)   | ❌        | null       | 초기 NAT IP의 self-links                    |
| `nat_ips`                        | list(string)   | ❌        | null       | 사용할 NAT IP들의 self-links                |
| `drain_nat_ips`                  | list(string)   | ❌        | null       | 제거할 NAT IP들의 self-links                |
| `min_ports_per_vm`               | number         | ❌        | null       | 각 VM에 할당될 최소 포트 수                 |
| `max_ports_per_vm`               | number         | ❌        | null       | 각 VM에 할당될 최대 포트 수                 |
| `enable_dynamic_port_allocation` | bool           | ❌        | false      | 동적 포트 할당 활성화 여부                  |
| `udp_idle_timeout_sec`           | number         | ❌        | 30         | UDP 연결의 유휴 타임아웃 시간 (초)           |
| `icmp_idle_timeout_sec`          | number         | ❌        | 30         | ICMP 연결의 유휴 타임아웃 시간 (초)          |
| `tcp_established_idle_timeout_sec` | number      | ❌        | 1200       | TCP Established 연결의 유휴 타임아웃 시간 (초) |
| `tcp_transitory_idle_timeout_sec` | number        | ❌        | 30         | TCP transitory 연결의 유휴 타임아웃 시간 (초) |
| `tcp_time_wait_timeout_sec`      | number         | ❌        | 120        | TCP TIME_WAIT 상태 타임아웃 시간 (초)        |
| `enable_endpoint_independent_mapping` | bool      | ❌        | false      | Endpoint Independent Mapping 활성화 여부     |
| `type`                           | string         | ❌        | "PUBLIC"   | NAT 유형 (PUBLIC 또는 PRIVATE)              |
| `auto_network_tier`              | string         | ❌        | null       | 자동 NAT IP 예약 시 네트워크 계층 (PREMIUM 또는 STANDARD) |
| `region`                         | string         | ✅        | 없음       | NAT와 라우터가 속한 GCP 리전                 |
| `project`                        | string         | ❌        | null       | GCP 프로젝트 ID                              |
| `subnetworks`                    | list(object)   | ❌        | []         | NAT에 연결할 서브네트워크 구성               |
| `log_config`                     | object         | ❌        | null       | NAT 로그 설정                                |
| `rules`                          | list(object)   | ❌        | []         | NAT 규칙 설정                                |
| `timeout_create`                 | string         | ❌        | "20m"      | 리소스 생성 제한 시간                        |
| `timeout_update`                 | string         | ❌        | "20m"      | 리소스 업데이트 제한 시간                    |
| `timeout_delete`                 | string         | ❌        | "20m"      | 리소스 삭제 제한 시간                        |

#### 서브네트워크(subnetworks) 객체 설명

| 필드명                    | 타입           | 필수 여부 | 설명                              |
|---------------------------|----------------|-----------|-----------------------------------|
| `name`                   | string         | ✅        | 서브네트워크 이름                  |
| `source_ip_ranges_to_nat` | list(string)   | ✅        | NAT 적용 대상 IP 범위 리스트         |
| `secondary_ip_range_names`| list(string)   | ❌        | 보조 IP 범위 이름                  |

#### 로그 설정(log_config) 객체 설명

| 필드명    | 타입   | 필수 여부 | 설명                              |
|-----------|--------|-----------|-----------------------------------|
| `enable`  | bool   | ✅        | NAT 로그 활성화 여부               |
| `filter`  | string | ✅        | NAT 로그 필터 수준 (ALL, ERRORS_ONLY 등) |

#### 규칙 설정(rules) 객체 설명

| 필드명                        | 타입           | 필수 여부 | 설명                              |
|-------------------------------|----------------|-----------|-----------------------------------|
| `rule_number`                 | number         | ✅        | NAT 규칙 번호                      |
| `description`                 | string         | ✅        | NAT 규칙 설명                      |
| `match`                       | string         | ✅        | NAT 규칙 조건                      |
| `action.source_nat_active_ips` | list(string)   | ❌        | 활성 NAT IP의 self-links           |
| `action.source_nat_drain_ips` | list(string)   | ❌        | 제거 NAT IP의 self-links           |
| `action.source_nat_active_ranges` | list(string) | ❌       | 활성 NAT IP 범위                   |
| `action.source_nat_drain_ranges` | list(string) | ❌       | 제거 NAT IP 범위                   |


<br>

### 3. 모듈 호출 예시

```hcl
module "nat" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/nat-module.git?ref=v1.0.0"

  # 기본 설정
  name                              = "example-nat"                     # NAT 서비스 이름
  router                            = "example-router"                  # NAT를 구성할 Cloud Router 이름
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"  # 서브네트워크 NAT 구성 방식
  region                            = "us-central1"                     # NAT 리소스가 위치한 GCP 리전
  project                           = "my-gcp-project"                  # NAT 리소스가 속한 GCP 프로젝트 ID

  # NAT IP 설정
  nat_ip_allocate_option            = "MANUAL_ONLY"                     # NAT IP 할당 방식 (MANUAL_ONLY 또는 AUTO_ONLY)
  initial_nat_ips                   = ["nat-ip-1", "nat-ip-2"]          # 초기 NAT IP의 self-links
  nat_ips                           = ["nat-ip-3", "nat-ip-4"]          # 사용 가능한 NAT IP의 self-links
  drain_nat_ips                     = ["nat-ip-2"]                      # 제거할 NAT IP의 self-links

  # 포트 설정
  min_ports_per_vm                  = 32                                # VM당 최소 포트 수
  max_ports_per_vm                  = 64                                # VM당 최대 포트 수
  enable_dynamic_port_allocation    = true                              # 동적 포트 할당 활성화 여부

  # 유휴 타임아웃 설정
  udp_idle_timeout_sec              = 60                                # UDP 연결 유휴 타임아웃 (초)
  icmp_idle_timeout_sec             = 60                                # ICMP 연결 유휴 타임아웃 (초)
  tcp_established_idle_timeout_sec  = 1500                              # TCP Established 연결 유휴 타임아웃 (초)
  tcp_transitory_idle_timeout_sec   = 45                                # TCP Transitory 연결 유휴 타임아웃 (초)
  tcp_time_wait_timeout_sec         = 200                               # TCP TIME_WAIT 상태 유휴 타임아웃 (초)

  # 기타 NAT 설정
  enable_endpoint_independent_mapping = true                            # Endpoint Independent Mapping 활성화 여부
  auto_network_tier                   = "PREMIUM"                       # NAT IP의 네트워크 계층 (PREMIUM 또는 STANDARD)

  # 서브네트워크 설정
  subnetworks = [
    {
      name                     = "example-subnet-1"                     # NAT를 적용할 서브네트워크 이름
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]                      # NAT 적용 대상 IP 범위
      secondary_ip_range_names = []                                     # NAT에 허용된 보조 IP 범위
    },
    {
      name                     = "example-subnet-2"
      source_ip_ranges_to_nat  = ["LIST_OF_SECONDARY_IP_RANGES"]
      secondary_ip_range_names = ["secondary-range-1"]
    }
  ]

  # 로그 설정
  log_config = {
    enable = true                                                      # NAT 로그 활성화 여부
    filter = "ALL"                                                     # 로그 필터 수준 (ERRORS_ONLY, TRANSLATIONS_ONLY, ALL)
  }

  # NAT 규칙 설정
  rules = [
    {
      rule_number = 1
      description = "Custom NAT rule for subnet-1"
      match       = "source-subnet-1"

      action = {
        source_nat_active_ips = ["nat-ip-1"]                           # 활성 NAT IP
        source_nat_drain_ips  = ["nat-ip-2"]                           # 제거할 NAT IP
      }
    }
  ]

  # Timeout 설정
  timeout_create = "30m"                                               # 리소스 생성 제한 시간
  timeout_update = "30m"                                               # 리소스 업데이트 제한 시간
  timeout_delete = "30m"                                               # 리소스 삭제 제한 시간
}
```

<br>

### 4. 출력값 (Outputs)

| 출력명                                | 설명                                         |
|---------------------------------------|----------------------------------------------|
| `name`                                | 생성된 NAT 서비스의 이름                     |
| `id`                                  | 생성된 NAT 리소스의 고유 식별자               |
| `region`                              | NAT 리소스가 생성된 GCP 리전                  |
| `project`                             | NAT 리소스가 속한 GCP 프로젝트 ID             |
| `router`                              | NAT 리소스가 연결된 Cloud Router 이름         |
| `source_subnetwork_ip_ranges_to_nat`  | NAT가 적용된 서브네트워크 구성 방식           |
| `nat_ip_allocate_option`              | NAT 외부 IP 할당 방식 (MANUAL_ONLY 또는 AUTO_ONLY) |
| `nat_ips`                             | NAT에 할당된 외부 IP들의 self-links           |
| `drain_nat_ips`                       | 제거된 NAT IP들의 self-links                  |
| `min_ports_per_vm`                    | 각 VM에 할당된 최소 포트 수                   |
| `max_ports_per_vm`                    | 각 VM에 할당된 최대 포트 수                   |
| `udp_idle_timeout_sec`                | UDP 연결의 유휴 타임아웃 시간 (초)            |
| `icmp_idle_timeout_sec`               | ICMP 연결의 유휴 타임아웃 시간 (초)           |
| `tcp_established_idle_timeout_sec`    | TCP Established 연결의 유휴 타임아웃 시간 (초) |
| `tcp_transitory_idle_timeout_sec`     | TCP Transitory 연결의 유휴 타임아웃 시간 (초)  |
| `tcp_time_wait_timeout_sec`           | TCP TIME_WAIT 상태 타임아웃 시간 (초)         |
| `enable_dynamic_port_allocation`      | 동적 포트 할당 활성화 여부                    |
| `enable_endpoint_independent_mapping` | Endpoint Independent Mapping 활성화 여부      |
| `auto_network_tier`                   | 자동 NAT IP 예약 시 네트워크 계층             |
| `log_config`                          | NAT 로그 설정                                 |
| `rules`                               | NAT 규칙 설정                                 |
| `subnetworks`                         | NAT가 적용된 서브네트워크 정보                |

<br>

### 5. 지원 버전

#### a.  Terraform 버전
| 버전 범위 | 설명                              |
|-----------|-----------------------------------|
| `1.10.3`   | 최신 버전, 지원 및 테스트 완료                  |

#### b. Google Provider 버전
| 버전 범위 | 설명                              |
|-----------|-----------------------------------|
| `~> 6.0`  | 최소 지원 버전                   |

<br>

### 6. 모듈 개발 및 관리

- **저장소 구조**:
  ```
  nat-module/
    ├── .github/workflows/  # github actions 자동화 테스트
    ├── examples/           # 테스트를 위한 루트 모듈 모음 디렉터리
    ├── test/               # 테스트 구성 디렉터리
    ├── main.tf             # 모듈의 핵심 구현
    ├── variables.tf        # 입력 변수 정의
    ├── outputs.tf          # 출력 정의
    ├── versions.tf         # 버전 정의
    ├── README.md           # 문서화 파일
  ```

<br>

---

### Terratest를 이용한 테스트
이 모듈을 테스트하려면 제공된 Go 기반 테스트 프레임워크를 사용하세요. 아래를 확인하세요:

1. Terraform 및 Go 설치.
2. 필요한 환경 변수 설정.
3. 테스트 실행:
```bash
go test -v ./test
```

<br>

## 주요 버전 관리
이 모듈은 [Semantic Versioning](https://semver.org/)을 따릅니다.  
안정된 버전을 사용하려면 `?ref=<version>`을 활용하세요:

```hcl
source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/nat-module.git?ref=v1.0.0"
```

### Module ref 버전
| Major | Minor | Patch |
|-----------|-----------|----------|
| `1.0.0`   |    |   |

<br>

## 기여 (Contributing)
기여를 환영합니다! 버그 제보 및 기능 요청은 GitHub Issues를 통해 제출해주세요.

<br>

## 라이선스 (License)
[MIT License](LICENSE)