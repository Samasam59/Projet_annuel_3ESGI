provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}
