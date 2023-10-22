provider "aws"{
    region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "andreprocopeuno"
        key = "state/terraform.tfstate"
        encrypt = true
        region = "us-east-1"
    }

}