terraform{
  backend "s3" {
    bucket         = "k2terraform-state"
    region         = "eu-central-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}