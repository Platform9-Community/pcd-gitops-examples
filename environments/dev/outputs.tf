output "analytics_team_network_id" {
  description = "Internal network ID created in the analytics team tenant"
  value       = module.analytics_team.internal_network_id
}

output "analytics_team_router_id" {
  description = "Router ID created in the analytics team tenant"
  value       = module.analytics_team.router_id
}
