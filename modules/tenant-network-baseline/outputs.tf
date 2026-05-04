output "internal_network_id" {
  description = "ID of the internal network"
  value       = openstack_networking_network_v2.internal.id
}

output "internal_subnet_id" {
  description = "ID of the internal subnet"
  value       = openstack_networking_subnet_v2.internal.id
}

output "router_id" {
  description = "ID of the tenant router"
  value       = openstack_networking_router_v2.router.id
}

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = openstack_networking_secgroup_v2.web.id
}
