resource_group_name = "LZdemo-network-cmp"
location            = "East US"

#--------------------------------------------------------------------

vnets = {
  LZdemo-Hub-vcn = {
    address_space = ["10.0.0.0/24"]
  }
  Spoke-Devops = {
    address_space = ["10.1.0.0/24"]
  }
  Spoke-prod = {
    address_space = ["10.2.0.0/24"]
  }
}

peerings = [
  {
    vnet1 = "LZdemo-Hub-vcn"
    vnet2 = "Spoke-Devops"
  },
  {
    vnet1 = "LZdemo-Hub-vcn"
    vnet2 = "Spoke-prod"
  },
  {
    vnet1 = "Spoke-Devops"
    vnet2 = "LZdemo-Hub-vcn"
  },
  {
    vnet1 = "Spoke-prod"
    vnet2 = "LZdemo-Hub-vcn"
  },
]

#--------------------------------------------------------------------

GatewaySubnet = {
  vnet_name = "LZdemo-Hub-vcn"
  address_prefixes = ["10.0.0.224/27"]
}

subnets = {
  LZdemo-Hub-vcn-Firewall-subnet = {
    vnet_name       = "LZdemo-Hub-vcn"
    address_prefixes = ["10.0.0.0/25"]
  }
  LZdemo-Hub-vcn-PublicLB-subnet = {
    vnet_name       = "LZdemo-Hub-vcn"
    address_prefixes = ["10.0.0.128/26"]
  }
  Spoke-Devops-Devops-subnet = {
    vnet_name       = "Spoke-Devops"
    address_prefixes = ["10.1.0.0/26"]
  }
  Spoke-prod-DB-subnet = {
    vnet_name       = "Spoke-prod"
    address_prefixes = ["10.2.0.128/26"]
  }
  Spoke-prod-oke-subnet = {
    vnet_name       = "Spoke-prod"
    address_prefixes = ["10.2.0.0/26"]
  }
  Spoke-prod-opensearch-subnet = {
    vnet_name       = "Spoke-prod"
    address_prefixes = ["10.2.0.64/26"]
  }
}

#--------------------------------------------------------------------

route_tables = {
  LZdemo-Hub-Firewall-subnet-rtable = {
    routes = [
      {
        name             = "route-to-internet"
        address_prefix   = "0.0.0.0/0"
        next_hop_type    = "Internet"
      }/*,
      {
        name             = "route-to-spoke_devops"
        address_prefix   = "10.1.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      },
      {
        name             = "route-to-Spoke-prod"
        address_prefix   = "10.2.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      }*/
    ]
  },
  LZdemo-Hub-PublicLB-subnet-rtable = {
    routes = [
      {
        name              = "route-to-internet"
        address_prefix    = "0.0.0.0/0"
        next_hop_type     = "Internet"
      }/*,
      {
        name             = "route-to-spoke_devops"
        address_prefix   = "10.1.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      },
      {
        name             = "route-to-Spoke-prod"
        address_prefix   = "10.2.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      }*/
    ]
  },
  Spoke-Devops-Devops-subnet-rtable = {
    routes = [
      /*{
        name             = "route-to-LZdemo-Hub"
        address_prefix   = "10.0.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      },*/
      {
        name             = "route-to-Spoke-prod"
        address_prefix   = "10.2.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      }
    ]
  },
  Spoke-prod-DB-subnet-rtable = {
    routes = [
      /*{
        name             = "route-to-LZdemo-Hub"
        address_prefix   = "10.0.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      },*/
      {
        name             = "route-to-Spoke-devops"
        address_prefix   = "10.1.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      }
    ]
  },
  Spoke-prod-oke-subnet-rtable = {
    routes = [
      /*{
        name             = "route-to-LZdemo-Hub"
        address_prefix   = "10.0.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      },*/
      {
        name             = "route-to-Spoke-devops"
        address_prefix   = "10.1.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      }
    ]
  },
  Spoke-prod-opensearch-subnet-rtable = {
    routes = [
      /*{
        name             = "route-to-LZdemo-Hub"
        address_prefix   = "10.0.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      },*/
      {
        name             = "route-to-Spoke-devops"
        address_prefix   = "10.1.0.0/24"
        next_hop_type    = "VirtualNetworkGateway"
      }
    ]
  }
}

route_table_associations = [
  {
    subnet = "LZdemo-Hub-vcn-Firewall-subnet"
    route_table = "LZdemo-Hub-Firewall-subnet-rtable"
  },
  {
    subnet = "LZdemo-Hub-vcn-PublicLB-subnet"
    route_table = "LZdemo-Hub-PublicLB-subnet-rtable"
  },
  {
    subnet = "Spoke-Devops-Devops-subnet"
    route_table = "Spoke-Devops-Devops-subnet-rtable"
  },
  {
    subnet = "Spoke-prod-DB-subnet"
    route_table = "Spoke-prod-DB-subnet-rtable"
  },
  {
    subnet = "Spoke-prod-oke-subnet"
    route_table = "Spoke-prod-oke-subnet-rtable"
  },
  {
    subnet = "Spoke-prod-opensearch-subnet"
    route_table = "Spoke-prod-opensearch-subnet-rtable"
  }
]

































/*
environment = "production"
nat_gateway_public_ip_associations = {
  nat1_association = {
    nat_gateway = "nat1"
    public_ip   = "public_ip1"
  }
}
*/











