variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

variable "vnets" {
  description = "Map of VNETs with their address spaces"
  type        = map(object({
    address_space = list(string)
  }))
}
/*
variable "peerings" {
  description = "A list of VNet peerings to create"
  type = list(object({
    vnet1 = string
    vnet2 = string
  }))
}
*/
variable "GatewaySubnet" {
  description = "Configuration for the Gateway Subnet"
  type = object({
    vnet_name        = string
    address_prefixes = list(string)
  })
}


variable "subnets" {
  description = "Map of subnets with their address prefixes and associated VNET"
  type        = map(object({
    vnet_name       = string
    address_prefixes = list(string)
  }))
}
/*
variable "route_tables" {
  description = "La liste des tables de routage Azure avec les règles de routage."
  type        = map(object({
    routes = list(object({
      name                     = string
      address_prefix           = string
      next_hop_type            = string
    }))
  }))
}

variable "route_table_associations" {
  description = "A list of VNet peerings to create"
  type = list(object({
    subnet = string
    route_table = string
  }))
}

*/


















/*variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}*/






