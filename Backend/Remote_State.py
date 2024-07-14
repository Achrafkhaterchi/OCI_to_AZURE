import os
import random
import string
from openpyxl import load_workbook
from jinja2 import Template

parent_dir = os.path.dirname(os.path.abspath(__file__))
output_file_path = os.path.join(parent_dir, '..', 'Network', 'VNets', 'main.tf')
storage_file_path = os.path.join(parent_dir, '..', 'Network', 'Storage', 'main.tf')
excel_file_path = os.path.join(parent_dir, 'OCI.xlsx')
wb = load_workbook(excel_file_path, data_only=True)

def generate_random_name(prefix, length=8):
    return prefix + ''.join(random.choices(string.ascii_lowercase + string.digits, k=length))

def extract_resource_group(wb):
    vcn_sheet = wb["VCN"]
    resource_group = vcn_sheet.cell(row=2, column=1).value
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

template_1 = Template(template_str)
template_2 = Template(template_bck)

new_resources = template_2.render(
    storage_account_name=storage_account_name,
    resource_group=resource_group,
    region=region
)

existing_content = ""
if os.path.exists(output_file_path):
    with open(output_file_path, "r") as f:
        existing_content = f.read()

updated_content = existing_content + "\n" + new_resources

with open(output_file_path, "w") as f:
    f.write(updated_content)

print("Les nouvelles ressources ont été ajoutées au fichier main.tf avec succès.")

new_storage_content = template_1.render(
    resource_group=resource_group,
    storage_account_name=storage_account_name,
    region=region
)

with open(storage_file_path, "w") as f:
    f.write(new_storage_content)

print("Le contenu pour le fichier storage a été généré avec succès.")
