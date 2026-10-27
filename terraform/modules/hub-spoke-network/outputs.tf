output "resource_group_name" {
  value = azurerm_resource_group.network.name
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

output "hub_subnets" {
  value = { for k, v in azurerm_subnet.hub : k => v.id }
}

output "spoke_subnets" {
  value = { for k, v in azurerm_subnet.spoke : k => v.id }
}
