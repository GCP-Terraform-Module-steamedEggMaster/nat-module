output "subnet1_details" {
  description = "서브네트워크 1 세부 정보"
  value = {
    id                         = module.subnet1.id
    name                       = module.subnet1.name
    self_link                  = module.subnet1.self_link
    gateway_address            = module.subnet1.gateway_address
    region                     = module.subnet1.region
    network                    = module.subnet1.network
    ip_cidr_range              = module.subnet1.ip_cidr_range
    ipv6_cidr_range            = module.subnet1.ipv6_cidr_range
    private_ip_google_access   = module.subnet1.private_ip_google_access
    private_ipv6_google_access = module.subnet1.private_ipv6_google_access
    secondary_ip_ranges        = module.subnet1.secondary_ip_ranges
  }
}

output "subnet2_details" {
  description = "서브네트워크 2 세부 정보"
  value = {
    id                         = module.subnet2.id
    name                       = module.subnet2.name
    self_link                  = module.subnet2.self_link
    gateway_address            = module.subnet2.gateway_address
    region                     = module.subnet2.region
    network                    = module.subnet2.network
    ip_cidr_range              = module.subnet2.ip_cidr_range
    ipv6_cidr_range            = module.subnet2.ipv6_cidr_range
    private_ip_google_access   = module.subnet2.private_ip_google_access
    private_ipv6_google_access = module.subnet2.private_ipv6_google_access
    secondary_ip_ranges        = module.subnet2.secondary_ip_ranges
  }
}

output "router_details" {
  description = "Cloud Router 세부 정보"
  value = {
    id        = module.router.id
    name      = module.router.name
    region    = module.router.region
    network   = module.router.network
    self_link = module.router.self_link
  }
}

output "nat_details" {
  description = "NAT Gateway 세부 정보"
  value = {
    id                                  = module.nat.id                                  # NAT 리소스의 고유 식별자
    name                                = module.nat.name                                # NAT 서비스 이름
    region                              = module.nat.region                              # NAT 리소스가 생성된 리전
    project                             = module.nat.project                             # NAT 리소스가 속한 프로젝트 ID
    router                              = module.nat.router                              # NAT가 연결된 Cloud Router 이름
    nat_ips                             = module.nat.nat_ips                             # NAT에 할당된 외부 IP 목록
    nat_ip_allocate_option              = module.nat.nat_ip_allocate_option              # NAT 외부 IP 할당 방식
    log_config                          = module.nat.log_config                          # NAT 로그 설정
    min_ports_per_vm                    = module.nat.min_ports_per_vm                    # 각 VM에 할당된 최소 포트 수
    max_ports_per_vm                    = module.nat.max_ports_per_vm                    # 각 VM에 할당된 최대 포트 수
    enable_dynamic_port_allocation      = module.nat.enable_dynamic_port_allocation      # 동적 포트 할당 활성화 여부
    enable_endpoint_independent_mapping = module.nat.enable_endpoint_independent_mapping # Endpoint Independent Mapping 활성화 여부
    source_subnetwork_ip_ranges_to_nat  = module.nat.source_subnetwork_ip_ranges_to_nat  # 서브네트워크 NAT 구성 방식
    subnetworks                         = module.nat.subnetworks                         # NAT가 적용된 서브네트워크 정보
  }
}