# tenant-network-baseline

Terraform module that provisions a baseline of network and security
resources inside an existing PCD tenant.

## What it creates

- One internal network
- One internal subnet on that network
- One router with an external gateway
- One router interface attaching the subnet to the router
- One security group for web traffic
- Two security group rules (HTTP, HTTPS ingress)

## What it does not create

- The tenant itself. The tenant must already exist; pass its ID as
  `tenant_id`.
- Compute resources, volumes, or any other tenant-internal resources.
  This module is a networking baseline.

## Required inputs

| Variable | Description |
|----------|-------------|
| `name_prefix` | Prefix applied to all resource names |
| `tenant_id` | PCD tenant ID where resources will be created |
| `external_network_id` | External network for the router to attach to |
| `internal_cidr` | CIDR block for the internal subnet |

## Optional inputs

| Variable | Default |
|----------|---------|
| `dns_nameservers` | `["1.1.1.1", "8.8.8.8"]` |

## Outputs

| Output | Description |
|--------|-------------|
| `internal_network_id` | Network ID |
| `internal_subnet_id` | Subnet ID |
| `router_id` | Router ID |
| `web_security_group_id` | Security group ID |
