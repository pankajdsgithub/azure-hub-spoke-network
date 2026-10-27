variable "location" {
  description = "Azure region for the network resources."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group that contains the hub and spoke networking components."
  type        = string
  default     = "rg-hub-spoke-dev"
}

variable "hub_vnet_name" {
  description = "Name of the shared hub virtual network."
  type        = string
  default     = "vnet-hub-dev"
}

variable "hub_address_space" {
  description = "CIDR blocks used by the hub virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
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
  default = {}
}

variable "spoke_vnet_name" {
  description = "Name of the application spoke virtual network."
  type        = string
  default     = "vnet-spoke-dev"
}

variable "spoke_address_space" {
  description = "CIDR blocks used by the application spoke virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
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
  default = {}
}

variable "tags" {
  description = "Common tags applied to the resource group and network resources."
  type        = map(string)
  default = {
    project     = "hub-spoke-network"
    managed_by  = "terraform"
    environment = "dev"
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
}
