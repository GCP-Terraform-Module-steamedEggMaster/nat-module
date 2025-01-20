# 필수 변수
variable "name" {
  description = "NAT 서비스 이름 (RFC1035 준수)"
  type        = string
}

variable "router" {
  description = "NAT가 구성될 Cloud Router 이름"
  type        = string
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "NAT가 서브넷별로 구성되는 방식 (ALL_SUBNETWORKS_ALL_IP_RANGES 등)"
  type        = string
}

# NAT IP 관련 변수
variable "nat_ip_allocate_option" {
  description = "NAT 외부 IP 할당 방식 (MANUAL_ONLY 또는 AUTO_ONLY)"
  type        = string
  default     = null
}

variable "initial_nat_ips" {
  description = "초기 NAT IP의 self-links"
  type        = list(string)
  default     = null
}

variable "nat_ips" {
  description = "사용할 NAT IP들의 self-links"
  type        = list(string)
  default     = null
}

variable "drain_nat_ips" {
  description = "제거할 NAT IP들의 self-links"
  type        = list(string)
  default     = null
}

# 포트 설정 변수
variable "min_ports_per_vm" {
  description = "각 VM에 할당될 최소 포트 수"
  type        = number
  default     = null
}

variable "max_ports_per_vm" {
  description = "각 VM에 할당될 최대 포트 수"
  type        = number
  default     = null
}

variable "enable_dynamic_port_allocation" {
  description = "동적 포트 할당 활성화 여부"
  type        = bool
  default     = false
}

# 유휴 타임아웃 설정 변수
variable "udp_idle_timeout_sec" {
  description = "UDP 연결의 유휴 타임아웃 시간 (초)"
  type        = number
  default     = 30
}

variable "icmp_idle_timeout_sec" {
  description = "ICMP 연결의 유휴 타임아웃 시간 (초)"
  type        = number
  default     = 30
}

variable "tcp_established_idle_timeout_sec" {
  description = "TCP 연결의 유휴 타임아웃 시간 (초)"
  type        = number
  default     = 1200
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "TCP transitory 연결의 유휴 타임아웃 시간 (초)"
  type        = number
  default     = 30
}

variable "tcp_time_wait_timeout_sec" {
  description = "TCP TIME_WAIT 상태 타임아웃 시간 (초)"
  type        = number
  default     = 120
}

# 기타 NAT 설정 변수
variable "enable_endpoint_independent_mapping" {
  description = "Endpoint Independent Mapping 활성화 여부"
  type        = bool
  default     = false
}

variable "type" {
  description = "NAT 유형 (PUBLIC 또는 PRIVATE)"
  type        = string
  default     = "PUBLIC"
}

variable "auto_network_tier" {
  description = "자동 NAT IP 예약 시 네트워크 계층 (PREMIUM 또는 STANDARD)"
  type        = string
  default     = null
}

# 프로젝트 및 리전 정보
variable "region" {
  description = "NAT와 라우터가 속한 GCP 리전"
  type        = string
  default     = null
}

variable "project" {
  description = "GCP 프로젝트 ID"
  type        = string
  default     = null
}

variable "subnetworks" {
  description = "NAT에 연결할 서브네트워크 구성"
  type = list(object({
    name                     = optional(string, null)
    source_ip_ranges_to_nat  = optional(list(string), null)
    secondary_ip_range_names = optional(list(string), null)
  }))
  default = []
}

variable "log_config" {
  description = "NAT 로그 설정"
  type = object({
    enable = optional(bool, null)
    filter = optional(string, null)
  })
  default = null
}

variable "rules" {
  description = "NAT 규칙 설정"
  type = list(object({
    rule_number = optional(number, null)
    description = optional(string, null)
    match       = optional(string, null)
    action = optional(object({
      source_nat_active_ips    = optional(list(string), null)
      source_nat_drain_ips     = optional(list(string), null)
      source_nat_active_ranges = optional(list(string), null)
      source_nat_drain_ranges  = optional(list(string), null)
    }), null)
  }))
  default = []
}

# Timeout 설정
variable "timeout_create" {
  description = "리소스 생성 제한 시간"
  type        = string
  default     = "20m"
}

variable "timeout_update" {
  description = "리소스 업데이트 제한 시간"
  type        = string
  default     = "20m"
}

variable "timeout_delete" {
  description = "리소스 삭제 제한 시간"
  type        = string
  default     = "20m"
}
