module "hub_spoke" {
  source = "../../modules/hub-spoke-network"

  location            = var.location
  resource_group_name = var.resource_group_name
  hub_vnet_name       = var.hub_vnet_name
  hub_address_space   = var.hub_address_space
  hub_subnets         = var.hub_subnets
  spoke_vnet_name     = var.spoke_vnet_name
  spoke_address_space = var.spoke_address_space
  spoke_subnets       = var.spoke_subnets
  tags                = var.tags

  enable_firewall_route = var.enable_firewall_route
  firewall_private_ip   = var.firewall_private_ip
}
