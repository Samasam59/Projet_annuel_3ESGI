variable "azure_subscription_id" {
  description = "ID de la souscription Azure"
  type        = string
}

variable "proxmox_endpoint" {
  description = "URL de l'API Proxmox (ex: https://pve.example.com:8006/)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Token API Proxmox (format: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Ignorer la vérification TLS (certificat auto-signé)"
  type        = bool
  default     = false
}
