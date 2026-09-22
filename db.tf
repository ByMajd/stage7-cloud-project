resource "random_password" "postgres_admin_password" {
  length  = 20
  special = true
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "${local.resource_name_prefix}-pg-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "centralus"

  version = "16"

  administrator_login    = "stage6admin"
  administrator_password = random_password.postgres_admin_password.result

  storage_mb = 32768
  sku_name   = "B_Standard_B1ms"

  public_network_access_enabled = true

  tags = local.common_tags

  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_vm" {
  name      = "allow-stage6-vm"
  server_id = azurerm_postgresql_flexible_server.postgres.id

  start_ip_address = azurerm_public_ip.web_vm_publicip.ip_address
  end_ip_address   = azurerm_public_ip.web_vm_publicip.ip_address
}

output "postgres_host" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_admin_user" {
  value = azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "postgres_admin_password" {
  value     = random_password.postgres_admin_password.result
  sensitive = true
}
