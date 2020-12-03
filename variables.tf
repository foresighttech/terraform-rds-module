variable "subnet_ids" {}
variable "publicly_accessible" {
    default = false
}
variable "env" {}

variable "engine_mode" {
    default = "serverless"
}

variable "instance_count" {
    default = 0
}

data "aws_subnet" "_" {
    id = var.subnet_ids[0]
}