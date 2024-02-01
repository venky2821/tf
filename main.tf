provider "azurerm"  {
  features {}
}

resource "azurerm_virtual_network" "net" {
 name = "myvnet"
 location = "Central US"
 address_space = ["10.0.0.0/16"]
 resource_group_name = "venkatesh-rg"
}
resource "azurerm_subnet" "subnet" {
  name = "mysubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
  address_prefix = "10.0.10.0/24"
}
resource "azurerm_network_interface" "nic" {
  name = "my-nic"
  location = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
     name = "myipconfig"
     subnet_id = azurerm_subnet.subnet.id
     private_ip_address_allocation = "Dynamic"
     public_ip_address_id = azurerm_public_ip.pip.id
    }
}
resource "azurerm_public_ip" "pip" {
  name = "venky-ip"
  location = "Central US"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
}
resource "azurerm_storage_account" "stor" {
  name = "venky"
  location = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
  account_tier = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_linux_virtual_machine" "vm" {
  name = "LinuxVm"
  location = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
  vm_size = "Standard_DS1_V2"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  storage_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "16.04-LTS"
      version = "latest"
  }
}
