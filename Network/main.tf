provider "azurerm" {
  features {}
}

#------------------------------------------------------------------VNets---------------------------------------------------------------

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets
  name                = each.key
  address_space       = each.value.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  /*tags = {
    environment = var.environment
  }*/
}

#----------------------------------------------------------------VNet Peering----------------------------------------------------------
/*
resource "azurerm_virtual_network_peering" "vnet_peering" {
  for_each = {
    for peering in var.peerings :
    "${peering.vnet1}-to-${peering.vnet2}" => peering
  }

  name                          = "${each.value.vnet1}-to-${each.value.vnet2}-peering"
  resource_group_name           = var.resource_group_name
  virtual_network_name          = each.value.vnet1
  remote_virtual_network_id     = azurerm_virtual_network.vnet[each.value.vnet2].id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = true
  #use_remote_gateways           = true
}
*/
#-----------------------------------------------------------------Subnets--------------------------------------------------------------

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_name].name
  address_prefixes     = each.value.address_prefixes
}

#-------------------------------------------------------------------VPN----------------------------------------------------------------

resource "azurerm_subnet" "hub_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.GatewaySubnet.vnet_name
  address_prefixes     = var.GatewaySubnet.address_prefixes
}

/*
resource "azurerm_public_ip" "vpn_public_ip" {
  name                = "vpn-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "vpn-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vpn-gateway-ip-configuration"
    public_ip_address_id          = azurerm_public_ip.vpn_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway_subnet.id
  }
}

#-----------------------------------------------------------------Route Tables---------------------------------------------------------

resource "azurerm_route_table" "route_table" {
  for_each            = var.route_tables
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
}

locals {
  all_routes = flatten([
    for table_key, table_value in var.route_tables : [
      for route in table_value.routes : {
        table_key = table_key
        route     = route
      }
    ]
  ])
}

resource "azurerm_route" "route" {
  for_each = {
    for idx, route in local.all_routes : "${route.table_key}-${route.route.name}" => route
  }

  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.route_table[each.value.table_key].name
  name                = each.value.route.name
  address_prefix      = each.value.route.address_prefix
  next_hop_type       = each.value.route.next_hop_type
}


resource "azurerm_subnet_route_table_association" "route_association" {
  for_each       = { for assoc in var.route_table_associations : "${assoc.subnet}-${assoc.route_table}" => assoc }
  subnet_id      = azurerm_subnet.subnet[each.value.subnet].id
  route_table_id = azurerm_route_table.route_table[each.value.route_table].id
}

*/