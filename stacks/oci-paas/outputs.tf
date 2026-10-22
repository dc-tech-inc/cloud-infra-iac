output "vcn_id" {
  description = "OCID of the VCN."
  value       = oci_core_vcn.this.id
}

output "subnet_id" {
  description = "OCID of the public subnet."
  value       = oci_core_subnet.public.id
}

output "instance_public_ip" {
  description = "Public IP of the PaaS VM (the host that runs paas/compose.yaml)."
  value       = oci_core_instance.paas.public_ip
}
