provider "azurerm" {
  features {}
  subscription_id = "sub-id"
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_app_environment" "env" {
  name                = var.environment_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"

      ports {
        port     = 80
        protocol = "TCP"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
  }
}
