locals {
  policy_rule_collection_name = var.fw_rule_collection_group_name != "" ? var.fw_rule_collection_group_name : "${var.fw_policy_name}-rcg"
}

resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  name               = local.policy_rule_collection_name
  firewall_policy_id = var.fw_policy_id
  priority           = var.priority

  dynamic "application_rule_collection" {

  }


  dynamic "network_rule_collection" {
      for_each = var.network_rule_collection
      content {
          name                  = network_rule_collection.value.name                                   # string
          description           = lookup(network_rule_collection.value, "description", null)           # string
          source_addresses      = lookup(network_rule_collection.value, "source_addresses", null)      # list EXAMPLE - ["10.0.0.0/16",]
          source_ip_groups      = lookup(network_rule_collection.value, "source_ip_groups", null)      # list
          destination_ports     = network_rule_collection.value.destination_ports                      # list EXAMPLE - ["53",]
          destination_fqdns     = lookup(network_rule_collection.value, "destination_fqdns", null)     # list (DNS Proxy must be enabled to use FQDNs.)
          destination_ip_groups = lookup(network_rule_collection.value, "destination_ip_groups", null) # list
          destination_addresses = lookup(network_rule_collection.value, "destination_addresses", null) # list EXAMPLE -  ["8.8.8.8","8.8.4.4",]
          protocols             = network_rule_collection.value.protocols                              # list EXAMPLE - ["TCP","UDP",]
      }
  }


  dynamic "nat_rule_collection" {

  }


}