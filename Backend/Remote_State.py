import os
import random
import string
from openpyxl import load_workbook
from jinja2 import Template

parent_dir = os.path.dirname(os.path.abspath(__file__))
output_file_path = os.path.join(parent_dir, '..', 'Network', 'VNets', 'main.tf')
output_file_path_routing = os.path.join(parent_dir, '..', 'Network', 'Routing', 'main.tf')
storage_file_path = os.path.join(parent_dir, '..', 'Network', 'Storage', 'main.tf')
excel_file_path = os.path.join(parent_dir, 'OCI.xlsx')
wb = load_workbook(excel_file_path, data_only=True)

def generate_random_name(prefix, length=8):
    return prefix + ''.join(random.choices(string.ascii_lowercase + string.digits, k=length))

def extract_resource_group(wb):
    RG_sheet = wb["RG"]
    resource_group = RG_sheet.cell(row=2, column=1).value
    return resource_group

resource_group = extract_resource_group(wb)

def extract_region(wb):
    compartment_sheet = wb["Compartments"]
    region = compartment_sheet.cell(row=2, column=1).value
    return region

region = extract_region(wb)

storage_account_name = generate_random_name("remotestate")

template_str = """
provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "sa" {
  name                     = "{{ storage_account_name }}"
  resource_group_name      = "{{ resource_group }}"
  location                 = "{{ region }}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.sa]
}
"""

template_bck = """
terraform {
  backend "azurerm" {
    resource_group_name  = "{{ resource_group }}"
    storage_account_name = "{{ storage_account_name }}"
    container_name       = "terraform-state"
    key                  = "VNets/terraform.tfstate"
  }
}
"""

template_bck_routing = """
data "terraform_remote_state" "vnets" {
  backend = "azurerm"

  config = {
    resource_group_name   = var.resource_group_name
    storage_account_name  = "{{ storage_account_name }}"
    container_name        = "terraform-state"
    key                   = "VNets/terraform.tfstate"
  }
}
"""

template_1 = Template(template_str)
template_2 = Template(template_bck)
template_3 = Template(template_bck_routing)

new_resources = template_2.render(
    storage_account_name=storage_account_name,
    resource_group=resource_group,
    region=region
)

new_resources_routing = template_3.render(
    storage_account_name=storage_account_name
)

existing_content = ""
if os.path.exists(output_file_path):
    with open(output_file_path, "r") as f:
        existing_content = f.read()

updated_content = existing_content + "\n" + new_resources

with open(output_file_path, "w") as f:
    f.write(updated_content)

existing_content_routing = ""
if os.path.exists(output_file_path_routing):
    with open(output_file_path_routing, "r") as f:
        existing_content_routing = f.read()

updated_content_routing = existing_content_routing + "\n" + new_resources_routing

with open(output_file_path_routing, "w") as f:
    f.write(updated_content_routing)

print("Les nouvelles ressources ont été ajoutées au fichier main.tf avec succès.")

new_storage_content = template_1.render(
    resource_group=resource_group,
    storage_account_name=storage_account_name,
    region=region
)

with open(storage_file_path, "w") as f:
    f.write(new_storage_content)

print("Le contenu pour le fichier storage a été généré avec succès.")
