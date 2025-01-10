resource "google_compute_router_nat" "nat" {
  # 필수 옵션
  name                               = var.name                               # NAT 서비스 이름
  router                             = var.router                             # NAT를 구성할 Cloud Router 이름
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat # 서브네트워크 NAT 구성 방식

  # IP 할당 관련 옵션
  nat_ip_allocate_option = var.nat_ip_allocate_option # NAT IP 할당 방식 (AUTO_ONLY 또는 MANUAL_ONLY)
  initial_nat_ips        = var.initial_nat_ips        # 초기 NAT IP 목록
  nat_ips                = var.nat_ips                # NAT IP 목록
  drain_nat_ips          = var.drain_nat_ips          # 제거할 NAT IP 목록

  # 포트 설정
  min_ports_per_vm               = var.min_ports_per_vm               # VM당 최소 포트 수
  max_ports_per_vm               = var.max_ports_per_vm               # VM당 최대 포트 수
  enable_dynamic_port_allocation = var.enable_dynamic_port_allocation # 동적 포트 할당 활성화 여부

  # 연결 유휴 타임아웃 설정
  udp_idle_timeout_sec             = var.udp_idle_timeout_sec             # UDP 연결 유휴 타임아웃 (초)
  icmp_idle_timeout_sec            = var.icmp_idle_timeout_sec            # ICMP 연결 유휴 타임아웃 (초)
  tcp_established_idle_timeout_sec = var.tcp_established_idle_timeout_sec # TCP Established 연결 유휴 타임아웃 (초)
  tcp_transitory_idle_timeout_sec  = var.tcp_transitory_idle_timeout_sec  # TCP Transitory 연결 유휴 타임아웃 (초)
  tcp_time_wait_timeout_sec        = var.tcp_time_wait_timeout_sec        # TCP TIME_WAIT 상태 유휴 타임아웃 (초)

  # 기타 NAT 설정
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping # Endpoint Independent Mapping 활성화 여부
  auto_network_tier                   = var.auto_network_tier                   # 자동 NAT IP 예약 시 네트워크 계층 (PREMIUM 또는 STANDARD)

  # 리전 및 프로젝트 정보
  region  = var.region  # NAT 리소스가 생성될 GCP 리전
  project = var.project # NAT 리소스가 속한 GCP 프로젝트 ID

  # 서브네트워크 설정
  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                     = subnetwork.value.name                     # NAT를 적용할 서브네트워크 이름
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat  # NAT 적용 대상 IP 범위
      secondary_ip_range_names = subnetwork.value.secondary_ip_range_names # NAT에 허용된 보조 IP 범위
    }
  }

  # 로그 설정
  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    content {
      enable = log_config.value.enable # 로그 활성화 여부
      filter = log_config.value.filter # 로그 필터 수준 (ERRORS_ONLY, TRANSLATIONS_ONLY, ALL)
    }
  }

  # 규칙 설정
  dynamic "rules" {
    for_each = var.rules
    content {
      rule_number = rules.value.rule_number
      description = rules.value.description
      match       = rules.value.match

      dynamic "action" {
        for_each = rules.value.action != null ? [rules.value.action] : []
        content {
          source_nat_active_ips = action.value.source_nat_active_ips
          source_nat_drain_ips  = action.value.source_nat_drain_ips
        }
      }
    }
  }

  # Timeout 설정
  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}
