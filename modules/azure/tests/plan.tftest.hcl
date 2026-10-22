# Offline plan tests: the azurerm provider is mocked, so no subscription or credentials are needed.
mock_provider "azurerm" {}

run "lb_and_network_shape" {
  command = plan

  assert {
    condition     = azurerm_lb.this.sku == "Standard" && azurerm_public_ip.lb.sku == "Standard"
    error_message = "Use Standard SKU for the load balancer and its public IP."
  }

  assert {
    condition     = azurerm_lb_rule.https.frontend_port == 443 && azurerm_lb_rule.https.backend_port == 443
    error_message = "The LB rule must expose HTTPS only."
  }
}

run "storage_is_private_and_modern_tls" {
  command = plan

  assert {
    condition     = azurerm_storage_account.artifacts.min_tls_version == "TLS1_2"
    error_message = "Storage account must require TLS 1.2."
  }

  assert {
    condition     = azurerm_storage_account.artifacts.allow_nested_items_to_be_public == false
    error_message = "Anonymous blob access must be disabled."
  }

  assert {
    condition     = azurerm_storage_container.artifacts.container_access_type == "private"
    error_message = "Container must be private."
  }
}

run "rejects_bad_storage_name" {
  command = plan

  variables {
    storage_account_name = "Not_Valid"
  }

  expect_failures = [var.storage_account_name]
}
