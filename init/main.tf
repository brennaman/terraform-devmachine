provider "azurerm" {
  environment                   = "${var.azure_environment}"
  subscription_id               = "${var.azure_subscription_id}"
  client_id                     = "${var.azure_client_id}"
  client_certificate_path       = "${var.client_certificate_path}"
  client_certificate_password   = "${var.client_certificate_password}"
  tenant_id                     = "${var.azure_tenant_id}"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "Default-Storage-EastUS"
    storage_account_name = "pbterraformsaeus"
    container_name       = "tfstate"
    key                  = "devmachine.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
        name = "${var.prefix}-group"
        location = "${var.location}"

        tags = {
        environment = "${var.environment}"
    }
}

resource "azurerm_virtual_network" "mynetwork" {
    name                = "${var.prefix}-${var.location_key}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    tags = {
        environment = "${var.environment}"
    }
}

resource "azurerm_subnet" "mysubnet" {
    name                 = "main-subnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.mynetwork.name}"
    address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "mypublicip" {
    name                         = "${var.prefix}-${var.location_key}-pip"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "${var.environment}"
    }
}