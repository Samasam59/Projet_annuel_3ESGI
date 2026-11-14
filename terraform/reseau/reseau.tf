terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = "f68acff6-e141-4e8b-a4bf-6c58ad7c2dae"
  tenant_id                       = "76756655-8eeb-424d-ae59-730256edb8b3"
  resource_provider_registrations = "none"
}

# ---------------------------------------------------------------
# Groupes de ressources
# ---------------------------------------------------------------
variable "groupes" {
  type    = set(string)
  default = ["reseau-vnet", "SRV-INFRA", "SRV-APP", "SRV-SQL", "VOIP", "SRV-VPN", "SRV-MGMT", "SRV-SEC", "SRV-SPRV", "BACKUP", "DMZ"]
}

resource "azurerm_resource_group" "rg" {
  for_each = var.groupes

  name     = each.value
  location = "norwayeast"
}

# ---------------------------------------------------------------
# Réseau virtuel Azure (10.20.0.0/16)
# ---------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "reseau-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.rg["reseau-vnet"].location
  resource_group_name = azurerm_resource_group.rg["reseau-vnet"].name
}

# ---------------------------------------------------------------
# Sous-réseaux : le 3e octet = numéro du snet
# ---------------------------------------------------------------
variable "subnets" {
  type = map(string)
  default = {
    "snet-wan"        = "10.20.1.0/24"   # pfSense côté Internet
    "snet-50-app"     = "10.20.50.0/24"
    "snet-51-sql"     = "10.20.51.0/24"
    "snet-52-vpn"     = "10.20.52.0/24"  # pfSense côté LAN
    "snet-60-infra"   = "10.20.60.0/24"
    "snet-70-sec"     = "10.20.70.0/24"
    "snet-80-mgmt"    = "10.20.80.0/24"
    "snet-90-sprv"    = "10.20.90.0/24"
    "snet-100-backup" = "10.20.100.0/24"
    "snet-110-voip"   = "10.20.110.0/24"
    "snet-120-dmz"    = "10.20.120.0/24"
  }
}

resource "azurerm_subnet" "snet" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}
