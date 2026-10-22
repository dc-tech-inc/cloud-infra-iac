locals {
  tags = {
    "project"    = var.name
    "managed-by" = "terraform"
  }
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.name}-vcn"
  cidr_blocks    = [var.vcn_cidr]
  dns_label      = "paasdemo"
  freeform_tags  = local.tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-igw"
  enabled        = true
  freeform_tags  = local.tags
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-public-rt"
  freeform_tags  = local.tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

# Default-deny: only SSH from admin_cidr and HTTP/HTTPS from anywhere are allowed in.
resource "oci_core_security_list" "paas" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-paas-sl"
  freeform_tags  = local.tags

  ingress_security_rules {
    protocol    = "6" # TCP
    source      = var.admin_cidr
    description = "SSH from the admin range only"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "HTTP (redirected to HTTPS by the reverse proxy)"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "HTTPS"

    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Outbound for package updates and image pulls"
  }
}

resource "oci_core_subnet" "public" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.this.id
  display_name      = "${var.name}-public"
  cidr_block        = var.subnet_cidr
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.paas.id]
  dns_label         = "public"
  freeform_tags     = local.tags
}

resource "oci_core_instance" "paas" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "${var.name}-vm"
  shape               = "VM.Standard.A1.Flex"
  freeform_tags       = local.tags

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gbs
  }

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  launch_options {
    is_pv_encryption_in_transit_enabled = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}
