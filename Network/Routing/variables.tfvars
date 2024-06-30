resource_group_name = "LZdemo-network-cmp"
location            = "East US"

#--------------------------------------------------------------------

peerings = [
  {
    hub = "LZdemo-Hub-vcn"
    spoke = "Spoke-Devops"
  },
  {
    hub = "LZdemo-Hub-vcn"
    spoke = "Spoke-prod"
  }
]

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

