# variable.tf File

variable "AWS_REGION" {
   default = "us-east-1"
}

variable "AMI" {
   type = map(string)
   default = {
      us-east-1 = "ami-002070d43b0a4f171" # Centos 7 HVM
    }
}

variable "PUBLIC_KEY_PATH" {
    default = "~/.ssh/id_rsa.pub" # Ansible Server SSH Key
}

variable "INSTANCE_TYPE" {
     default = "t2.medium"
}

variable "AZ" {
    default = "us-east-1a"
}
