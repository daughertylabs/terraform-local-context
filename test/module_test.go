package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformModuleWithDefaults(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/minimal",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "name_prefix")
	assert.Equal(t, "dbs-dc-dbs-sbox-minimalcontext", output)
	assert.Equal(t, "dbs-dc-dbs", terraform.Output(t, terraformOptions, "namespace_full"))
}

func TestTerraformModuleWithAllVariablesSet(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/full",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "name_prefix")
	assert.Equal(t, "dbs-az-root-workloads", output)
}

func TestTerraformModuleWithSubContexts(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/subcontext",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert.Equal(t, "dbs-az-root-workloads", terraform.Output(t, terraformOptions, "parent_name_prefix"))
	assert.Equal(t, "dbs-az-root-workloads-devteams", terraform.Output(t, terraformOptions, "child_name_prefix"))
	assert.Equal(t, "dbs-az-root-workloads-devteams-redteam", terraform.Output(t, terraformOptions, "grandchild_name_prefix"))
}
