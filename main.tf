resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  name               = var.fw_rule_collection_group_name
  firewall_policy_id = var.fw_policy_id
  priority           = var.priority

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = rule.value.name
          source_addresses  = lookup(rule.value, "source_addresses", null)
          destination_fqdns = lookup(rule.value, "destination_fqdns", null)

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collections
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collections.value.rules
        content {
          name                  = rule.value.name
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

  dynamic "nat_rule_collection" {
    for_each = var.nat_rule_collections
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collections.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols                         # list
          source_addresses    = lookup(rule.value, "source_addresses", null) # list
          destination_address = lookup(rule.value, "destination_addresses", null)
          destination_ports   = lookup(rule.value, "destination_ports", null)  # list
          source_ip_groups    = lookup(rule.value, "source_ip_groups", null)   # list of source IP groups.
          translated_address  = lookup(rule.value, "translated_address", null) # Specifies the translated address
          translated_port     = lookup(rule.value, "translated_port", null)    # Specifies the translated port.
        }
      }
    }
  }

}


