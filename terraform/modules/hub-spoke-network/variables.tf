variable "location" {
  description = "Azure region for the network resources."
  type        = string
  default     = "eastus"

  validation {
    condition     = trimspace(var.location) != ""
    error_message = "location must be set to a valid Azure region."
  }
}

variable "resource_group_name" {
  description = "Resource group that contains the hub and spoke networking components."
  type        = string
  default     = "rg-hub-spoke-core"

  validation {
    condition     = length(trimspace(var.resource_group_name)) >= 3
    error_message = "resource_group_name must be at least 3 characters long."
  }
}

variable "hub_vnet_name" {
  description = "Name of the shared hub virtual network."
  type        = string
  default     = "vnet-hub"
}

variable "hub_address_space" {
  description = "CIDR blocks used by the hub virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]

  validation {
    condition = (
      length(var.hub_address_space) > 0 &&
      alltrue([
        for cidr in var.hub_address_space : can(cidrhost(cidr, 0))
      ])
    )
    error_message = "hub_address_space must contain valid IPv4 CIDR ranges."
  }
}

variable "hub_subnets" {
  description = "Map of hub subnets with their required CIDR blocks and NSG rules."
  type = map(object({
    address_prefix = string
    nsg_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  default = {
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

  validation {
    condition = (
      length(var.hub_subnets) > 0 &&
      alltrue([
        for subnet in values(var.hub_subnets) :
        can(cidrhost(subnet.address_prefix, 0))
      ])
    )
    error_message = "Each hub subnet must include a valid IPv4 CIDR prefix."
  }
}

variable "spoke_vnet_name" {
  description = "Name of the application spoke virtual network."
  type        = string
  default     = "vnet-spoke"
}

variable "spoke_address_space" {
  description = "CIDR blocks used by the application spoke virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]

  validation {
    condition = (
      length(var.spoke_address_space) > 0 &&
      alltrue([
        for cidr in var.spoke_address_space : can(cidrhost(cidr, 0))
      ])
    )
    error_message = "spoke_address_space must contain valid IPv4 CIDR ranges."
  }
}

variable "spoke_subnets" {
  description = "Map of spoke subnets with their required CIDR blocks and NSG rules."
  type = map(object({
    address_prefix = string
    nsg_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  default = {
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

  validation {
    condition = (
      length(var.spoke_subnets) > 0 &&
      alltrue([
        for subnet in values(var.spoke_subnets) :
        can(cidrhost(subnet.address_prefix, 0))
      ])
    )
    error_message = "Each spoke subnet must include a valid IPv4 CIDR prefix."
  }
}

variable "tags" {
  description = "Common tags applied to the resource group and network resources."
  type        = map(string)
  default = {
    project     = "hub-spoke-network"
    managed_by  = "terraform"
    environment = "shared"
  }
}

variable "enable_firewall_route" {
  description = "When true, a default route table is created for the spoke subnets and points to an optional firewall appliance."
  type        = bool
  default     = false
}

variable "firewall_private_ip" {
  description = "Optional private IP of an existing firewall appliance used as the default next hop. This does not create a new Azure Firewall resource."
  type        = string
  default     = ""

  validation {
    condition = (
      var.firewall_private_ip == "" || can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.firewall_private_ip))
    )
    error_message = "firewall_private_ip must be an empty string or a valid IPv4 address."
  }
}
