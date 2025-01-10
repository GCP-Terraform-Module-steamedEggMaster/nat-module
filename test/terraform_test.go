package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCreateNat(t *testing.T) {
	// Terraform 옵션 설정
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/with-vpc-subnets-router", // Terraform 루트 모듈 경로
	}

	// Terraform Init 및 Apply 실행
	defer terraform.Destroy(t, terraformOptions) // 테스트 종료 후 리소스 정리
	terraform.InitAndApply(t, terraformOptions)
}
