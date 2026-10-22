# Offline plan tests: the OCI provider is mocked, so no tenancy or credentials are needed.
mock_provider "oci" {}

run "default_plan_shape" {
  command = plan

  assert {
    condition     = oci_core_instance.paas.shape == "VM.Standard.A1.Flex"
    error_message = "VM must use the Ampere A1 flex shape."
  }

  assert {
    condition     = oci_core_instance.paas.instance_options[0].are_legacy_imds_endpoints_disabled
    error_message = "Legacy IMDS endpoints must stay disabled."
  }

  assert {
    condition     = oci_core_subnet.public.cidr_block == var.subnet_cidr
    error_message = "Subnet must use the requested CIDR."
  }
}

run "ssh_never_open_to_world" {
  command = plan

  variables {
    admin_cidr = "0.0.0.0/0"
  }

  expect_failures = [var.admin_cidr]
}
