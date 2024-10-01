variable "common_tags" {
  default = {
    Project     = "expense"
    Terraform   = true
    Environment = "dev"
  }
}


variable "project_name" {

  default = "expense"

}
variable "environment" {

  default = "dev"

}
variable "mysql_tags" {

  default = {
    component = "mysql"
  }

}
variable "backend_tags" {

  default = {
    component = "backend"
  }

}
variable "frontend_tags" {

  default = {
    component = "frontend"
  }

}

variable "ansible_tags" {

  default = {
    component = "ansible"
  }

}

variable "zone_name" {

  default = "sujithyerra.online"

}