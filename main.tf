provider "azurerm"  {
    features {}
}
 // resource "azurerm_resource_group" "rg" {
  // name = "venkatesh-rg"
  // location = "Central US"
    
  
  resource "azurerm_virtual_network" "vnet" {
   name = "myvnet"
   location = "Central US"
   address_space = ["10.0.0.0/16"]
   resource_group_name = "venkatesh-rg"
  }
  resource "azurerm_subnet" "subnet" {
    name = "mysubnet"
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name = "venkatesh-rg"
    address_prefixes =   ["10.0.10.0/24"]
  }
  resource "azurerm_network_interface" "nic" {
    name = "my-nic"
    location = "Central US"
    resource_group_name = "venkatesh-rg"
    ip_configuration {
       name = "myipconfig"
       subnet_id = azurerm_subnet.subnet.id
       private_ip_address_allocation = "Dynamic"
       public_ip_address_id = azurerm_public_ip.pip.id
      }
  }
  resource "azurerm_public_ip" "pip" {
    name = "venkyip"
    location = "Central US"
    resource_group_name = "${venkatesh-rg}"
    allocation_method = "Dynamic"
    domain_name_label = "venky"
  }
  resource "azurerm_storage_account" "stor" {
    name = "venky"
    location = "Central US"
    resource_group_name = "venkatesh-rg"
    account_tier = "Standard"
    account_replication_type = "LRS"
  }
  resource "azurerm_linux_virtual_machine" "vm" {
    name = "LinuxVm"
    location = "Central US"
    resource_group_name = "venkatesh-rg"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    size = "Standard_DS1_v2"
   
    os_disk {
      name                 = "myOsDisk"
      caching              = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }
    admin_username = "azureadmin"
   admin_ssh_key {
    username = "azureadmin"
    public_key = "file(/.ssh/venky.pub)"
  }
  
    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }
  }
