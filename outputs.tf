output "name" {
  description = "생성된 NAT 서비스의 이름"
  value       = google_compute_router_nat.nat.name
}

output "id" {
  description = "생성된 NAT 리소스의 고유 식별자"
  value       = google_compute_router_nat.nat.id
}

output "region" {
  description = "NAT 리소스가 생성된 GCP 리전"
  value       = google_compute_router_nat.nat.region
}

output "project" {
  description = "NAT 리소스가 속한 GCP 프로젝트 ID"
  value       = google_compute_router_nat.nat.project
}

output "router" {
  description = "NAT 리소스가 연결된 Cloud Router 이름"
  value       = google_compute_router_nat.nat.router
}

output "source_subnetwork_ip_ranges_to_nat" {
  description = "NAT가 적용된 서브네트워크 구성 방식"
  value       = google_compute_router_nat.nat.source_subnetwork_ip_ranges_to_nat
}

output "nat_ip_allocate_option" {
  description = "NAT 외부 IP 할당 방식 (MANUAL_ONLY 또는 AUTO_ONLY)"
  value       = google_compute_router_nat.nat.nat_ip_allocate_option
}

output "nat_ips" {
  description = "NAT에 할당된 외부 IP들의 self-links"
  value       = google_compute_router_nat.nat.nat_ips
}

output "drain_nat_ips" {
  description = "제거된 NAT IP들의 self-links"
  value       = google_compute_router_nat.nat.drain_nat_ips
}

output "min_ports_per_vm" {
  description = "각 VM에 할당된 최소 포트 수"
  value       = google_compute_router_nat.nat.min_ports_per_vm
}

output "max_ports_per_vm" {
  description = "각 VM에 할당된 최대 포트 수"
  value       = google_compute_router_nat.nat.max_ports_per_vm
}

output "udp_idle_timeout_sec" {
  description = "UDP 연결의 유휴 타임아웃 시간 (초)"
  value       = google_compute_router_nat.nat.udp_idle_timeout_sec
}

output "icmp_idle_timeout_sec" {
  description = "ICMP 연결의 유휴 타임아웃 시간 (초)"
  value       = google_compute_router_nat.nat.icmp_idle_timeout_sec
}

output "tcp_established_idle_timeout_sec" {
  description = "TCP Established 연결의 유휴 타임아웃 시간 (초)"
  value       = google_compute_router_nat.nat.tcp_established_idle_timeout_sec
}

output "tcp_transitory_idle_timeout_sec" {
  description = "TCP Transitory 연결의 유휴 타임아웃 시간 (초)"
  value       = google_compute_router_nat.nat.tcp_transitory_idle_timeout_sec
}

output "tcp_time_wait_timeout_sec" {
  description = "TCP TIME_WAIT 상태 타임아웃 시간 (초)"
  value       = google_compute_router_nat.nat.tcp_time_wait_timeout_sec
}

output "enable_dynamic_port_allocation" {
  description = "동적 포트 할당 활성화 여부"
  value       = google_compute_router_nat.nat.enable_dynamic_port_allocation
}

output "enable_endpoint_independent_mapping" {
  description = "Endpoint Independent Mapping 활성화 여부"
  value       = google_compute_router_nat.nat.enable_endpoint_independent_mapping
}

output "auto_network_tier" {
  description = "자동 NAT IP 예약 시 네트워크 계층"
  value       = google_compute_router_nat.nat.auto_network_tier
}

output "log_config" {
  description = "NAT 로그 설정"
  value = {
    enable = try(google_compute_router_nat.nat.log_config[0].enable, false) # 기본값으로 false 반환
    filter = try(google_compute_router_nat.nat.log_config[0].filter, "NONE") # 기본값으로 NONE 반환
  }
}

output "rules" {
  description = "NAT 규칙 설정"
  value       = google_compute_router_nat.nat.rules
}

output "subnetworks" {
  description = "NAT가 적용된 서브네트워크 정보"
  value = [
    for subnet in google_compute_router_nat.nat.subnetwork : {
      name                     = subnet.name
      source_ip_ranges_to_nat  = subnet.source_ip_ranges_to_nat
      secondary_ip_range_names = subnet.secondary_ip_range_names
    }
  ]
}