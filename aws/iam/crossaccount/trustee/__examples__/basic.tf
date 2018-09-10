module "trustee" {
  source = "../"

  trustor_account_name = "Client"
  trustor_account_arn  = "1111111111111"
  trustee_account_name = "TableXI"
  trustee_group_name   = "Operations"
}
