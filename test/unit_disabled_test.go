package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestUnitDisabled(t *testing.T) {
	t.Parallel()

	// only if the environment variables are set to non-empty they will be passed to terraform
	vars := map[string]interface{}{
		"gcp_project":         os.Getenv("TEST_GCP_PROJECT"),
		"gcp_org_domain":      os.Getenv("TEST_GCP_ORG_DOMAIN"),
		"gcp_billing_account": os.Getenv("TEST_GCP_BILLING_ACCOUNT"),
	}

	for key, value := range vars {
		if value == "" {
			delete(vars, key)
		}
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-disabled",
		Vars:         vars,
		Upgrade:      true,
	}

	defer terraform.Destroy(t, terraformOptions)

	stdout := terraform.InitAndPlan(t, terraformOptions)

	resourceCount := terraform.GetResourceCount(t, stdout)
	assert.Equal(t, 0, resourceCount.Add, "No resources should have been planned to be created. Found %d instead.", resourceCount.Add)
	assert.Equal(t, 0, resourceCount.Change, "No resources should have been planned to be changed. Found %d instead.", resourceCount.Change)
	assert.Equal(t, 0, resourceCount.Destroy, "No resources should have been planned to be destroyed. Found %d instead.", resourceCount.Destroy)
}
