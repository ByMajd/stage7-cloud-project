resource "azurerm_storage_account" "storage" {
  name                     = "${local.resource_name_prefix}blob${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

resource "azurerm_storage_container" "pdfs" {
  name                  = "pdfs"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_container_name" {
  value = azurerm_storage_container.pdfs.name
}
