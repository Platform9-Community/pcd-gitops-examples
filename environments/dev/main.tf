terraform {
  required_version = ">= 1.15.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
  }
}

provider "openstack" {
  cloud = "pcd"
}

module "analytics_team" {
  source = "../../modules/tenant-network-baseline"

  name_prefix         = "analytics-team"
  tenant_id           = var.analytics_team_tenant_id
  external_network_id = var.external_network_id
  internal_cidr       = "10.10.1.0/24"
}