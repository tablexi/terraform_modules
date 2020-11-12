variable "domain_names" {
  description = "(Required) List of domain names for which the certificate should be issued. All domain names after the first one will be specified as subject alternative names."
  type        = list(string)
}
