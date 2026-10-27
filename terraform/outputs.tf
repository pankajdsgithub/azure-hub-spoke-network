output "resource_group_name" {
  value = module.hub_spoke.resource_group_name
}

output "hub_vnet_name" {
  value = module.hub_spoke.hub_vnet_name
}

output "hub_vnet_id" {
  value = module.hub_spoke.hub_vnet_id
}

output "spoke_vnet_name" {
  value = module.hub_spoke.spoke_vnet_name
}

output "spoke_vnet_id" {
  value = module.hub_spoke.spoke_vnet_id
}

output "hub_subnets" {
  value = module.hub_spoke.hub_subnets
}

output "spoke_subnets" {
  value = module.hub_spoke.spoke_subnets
}
