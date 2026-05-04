terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
  }
}

resource "openstack_networking_network_v2" "internal" {
  name           = "${var.name_prefix}-internal"
  tenant_id      = var.tenant_id
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "internal" {
  name            = "${var.name_prefix}-internal-subnet"
  network_id      = openstack_networking_network_v2.internal.id
  tenant_id       = var.tenant_id
  cidr            = var.internal_cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.name_prefix}-router"
  tenant_id           = var.tenant_id
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "internal" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.internal.id
}

resource "openstack_networking_secgroup_v2" "web" {
  name        = "${var.name_prefix}-web"
  description = "Allow inbound HTTP and HTTPS"
  tenant_id   = var.tenant_id
}

resource "openstack_networking_secgroup_rule_v2" "web_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.id
}

resource "openstack_networking_secgroup_rule_v2" "web_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.id
}
