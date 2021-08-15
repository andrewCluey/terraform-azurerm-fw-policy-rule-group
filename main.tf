resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  name               = var.fw_rule_collection_group_name
  firewall_policy_id = var.fw_policy_id
  priority           = var.priority

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collection
    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.key
          protocols             = rule.value.protocols                              # list
          destination_ports     = rule.value.destination_ports                      # list - Required
          source_addresses      = lookup(rule.value, "source_addresses", null)      # list
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)      # list Specifies a list of source IP groups.
          destination_addresses = lookup(rule.value, "destination_addresses", null) # list - ["192.168.1.1", "192.168.1.2"]
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", null) # list of destination IP groups.
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null)     # list of destination IP groups.
        }
      }
    }
  }
}


