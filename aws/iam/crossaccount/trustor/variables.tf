variable "trustee_account_name" {
  description = "Account name getting access"
}

variable "trustee_account_arn" {
  description = "Account ARN getting access"
}

variable "assume_role_policy" {
  default = ""
  description = "The policy that grants an entity permission to assume the role"
}

variable "access_policy" {
  default = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "dynamodb:DeleteTable",
        "rds:DeleteDBCluster",
        "rds:DeleteDBInstance",
        "s3:DeleteBucket"
      ],
      "Resource": "*"
    }
  ]
}
JSON
  description = "Default policy of cross account role"
}
