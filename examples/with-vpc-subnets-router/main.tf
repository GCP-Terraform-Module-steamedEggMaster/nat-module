module "vpc" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/vpc-module.git?ref=v1.0.0"

  name                    = "test-vpc"
  auto_create_subnetworks = false # 자동 서브네트워크 생성 비활성화
}

module "subnet1" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/subnets-module.git?ref=v1.0.0"

  name          = "test-subnet1"
  network       = module.vpc.id
  ip_cidr_range = "10.0.0.0/24"
  region        = "asia-northeast3"
}

module "subnet2" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/subnets-module.git?ref=v1.0.0"

  name          = "test-subnet2"
  network       = module.vpc.id
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-northeast3"
  secondary_ip_ranges = [
    {
      range_name              = "secondary-range-1"
      ip_cidr_range           = "10.1.0.0/24"
      reserved_internal_range = null
    },
    {
      range_name              = "secondary-range-2"
      ip_cidr_range           = "10.2.0.0/24"
      reserved_internal_range = null
    }
  ]
}

module "router" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/router-module.git?ref=v1.0.0"

  name    = "test-router"
  network = module.vpc.self_link
  region  = "asia-northeast3"
}

module "nat_ip" {
  source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/address-module.git?ref=v1.0.0"

  name         = "test-nat-ip"
  address_type = "EXTERNAL"
  region       = "asia-northeast3"
  network_tier = "PREMIUM"
  ip_version   = "IPV4"
  description  = "Static nat IP for test"
  labels       = { environment = "test" }
}

module "nat" {
  source = "../../" # NAT 모듈의 경로를 지정

  # 필수 변수
  name                               = "test-nat"
  router                             = module.router.name
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS" # 특정 서브네트워크만 NAT 적용
  nat_ip_allocate_option             = "MANUAL_ONLY"         # 외부 IP 수동 설정

  # 수동 NAT IP 설정
  nat_ips = [
    module.nat_ip.self_link
  ]

  # 서브네트워크 구성
  subnetworks = [
    {
      name                     = module.subnet1.name
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"] # 서브넷 내 모든 IP NAT 적용
      secondary_ip_range_names = []                # 보조 IP 없음
    },
    {
      name                    = module.subnet2.name
      source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"] # 기본 IP 범위만 NAT 적용
      secondary_ip_range_names = [
        for range in module.subnet2.secondary_ip_ranges : range.range_name
      ]
    }
  ]

  # 로그 설정
  log_config = {
    enable = true                # 로그 활성화
    filter = "TRANSLATIONS_ONLY" # NAT 번역 로그만 포함
  }

  # 포트 및 연결 설정
  min_ports_per_vm                 = 64   # VM당 최소 포트 수
  max_ports_per_vm                 = 2048 # VM당 최대 포트 수
  enable_dynamic_port_allocation   = true # 동적 포트 할당 활성화
  udp_idle_timeout_sec             = 30   # UDP 유휴 타임아웃
  tcp_established_idle_timeout_sec = 1200 # TCP Established 유휴 타임아웃

  # Timeout 설정
  timeout_create = "30m"
  timeout_update = "20m"
  timeout_delete = "15m"
}