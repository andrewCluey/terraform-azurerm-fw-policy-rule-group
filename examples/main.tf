resource "azurerm_resource_group" "example" {
  name     = "rg-fw-policy"
  location = "uksouth"
}


module "azfirewall_policy" {
  source  = "andrewCluey/azfirewall-policy/azurerm"
  version = "0.1.1"

  fw_policy_name      = "example_default_policy"
  resource_group_name = azurerm_resource_group.example.name
}


module "default_policy_rule_collection" {
  source = "../"

  fw_rule_collection_group_name = "default"
  priority                      = "500"
  fw_policy_id                  = module.azfirewall_policy.id
  network_rule_collection = {
    default_network_rule_collection = {
        priority = "500"
        action   = "Allow"
        rules = {
          default_network_rules_AllowRDP = {
            protocols             = ["TCP"]
            source_addresses      = ["10.0.0.1"]
            destination_addresses = ["192.168.0.21"]
            destination_ports     = ["3389"]
          }
        }
    }
  }
}