variable "common_tags" {
  default = {
    Project     = "expense"
    Terraform   = true
    Environment = "dev"
  }
}
variable "mysql_sg_tags" {
  default = {
    component = "mysql"
  }

}
variable "backend_sg_tags" {
  default = {
    component = "backend"
  }

}
variable "frontend_sg_tags" {
  default = {
    component = "frontend"
  }

}
variable "bastion_sg_tags" {
  default = {
    component = "bastion"
  }

}

variable "anisble_sg_tags" {
  default = {
    component = "ansible"
  }

}

# variable "sg_name" {
#   default = "mysql"

# }

variable "project_name" {

    default = "expense"
  
}
variable "environment" {

    default = "dev"
  
}