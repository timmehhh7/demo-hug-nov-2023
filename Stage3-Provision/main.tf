data "vault_aws_access_credentials" "creds" {
  backend = "aws-demo"
  role    = "demo-nov-2023"
  type    = "creds"
}

data "vault_azure_access_credentials" "creds" {
  backend                     = "azure-demo"
  role                        = "demo-nov-2023"
  validate_creds              = true
  num_sequential_successes    = 3
  num_seconds_between_tests   = 1
  max_cred_validation_seconds = 120
  subscription_id             = "7a517e97-91a1-4629-81c4-f65dfe169f57"
  tenant_id                   = "4328f5c5-4e1f-4b4d-b5ee-604e7fe12ccf"
}

data "vault_generic_secret" "creds" {
  path = "gcp-demo/roleset/demo-nov-2023/key"
}

resource "aws_instance" "demo" {
  ami           = "ami-06873c81b882339ac"
  instance_type = "t2.micro"
  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
  tags = {
    Name = "demo-instance"
  }
}

resource "azurerm_resource_group" "demo" {
  location = "canadaeast"
  name     = "demo-rg"
}

resource "azurerm_virtual_network" "demo" {
  name                = "demo-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_subnet" "demo" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "demo" {
  name                = "demo-nic"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "demo" {
  name                  = "demo-instance"
  location              = azurerm_resource_group.demo.location
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "demo-instance"
  disable_password_authentication = false
  admin_username = "demo"
  admin_password = "Demo$1234"

  #   admin_ssh_key {
  #     username   = var.username
  #     public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  #   }

  #   boot_diagnostics {
  #     storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  #   }
}

resource "google_compute_instance" "demo" {
  project      = "main-499"
  name         = "demo-instance"
  machine_type = "n1-standard-1"
  zone         = "northamerica-northeast1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}