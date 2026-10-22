output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.this.name
}

output "subnet_id" {
  description = "ID of the workload subnet."
  value       = azurerm_subnet.workload.id
}

output "lb_public_ip" {
  description = "Public IP address of the load balancer."
  value       = azurerm_public_ip.lb.ip_address
}

output "storage_account_id" {
  description = "ID of the artifacts storage account."
  value       = azurerm_storage_account.artifacts.id
}
