provider "aws" {}

resource "aws_s3_bucket" "mod" {
  bucket = "${var.name}-tf"

  tags {
    Name = "${var.name} terraform configutation"
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "tf_state_locking" {
  hash_key       = "LockID"
  name           = "${var.name}_tf"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
