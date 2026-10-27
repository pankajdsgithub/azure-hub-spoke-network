location            = "eastus"
resource_group_name = "rg-hub-spoke-dev"
hub_vnet_name       = "vnet-hub-dev"
hub_address_space   = ["10.10.0.0/16"]
hub_subnets = {
  "AzureFirewallSubnet" = {
    address_prefix = "10.10.0.0/24"
    nsg_rules      = []
  }
  "snet-shared-services" = {
    address_prefix = "10.10.10.0/24"
    nsg_rules = [
      {
        name                       = "AllowBastionInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
    ]
  }
}
spoke_vnet_name     = "vnet-spoke-dev"
spoke_address_space = ["10.20.0.0/16"]
spoke_subnets = {
  "snet-web" = {
    address_prefix = "10.20.10.0/24"
    nsg_rules = [
      {
        name                       = "DenyInternetInbound"
        priority                   = 4096
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    ]
  }
  "snet-data" = {
    address_prefix = "10.20.20.0/24"
    nsg_rules = [
      {
        name                       = "AllowAppInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "10.20.10.0/24"
        destination_address_prefix = "*"
      }
    ]
  }
}

tags = {
  project     = "hub-spoke-network"
  managed_by  = "terraform"
  environment = "dev"
}

enable_firewall_route = false
firewall_private_ip   = ""
