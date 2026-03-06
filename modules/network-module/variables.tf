variable "cidr-block" {
  type        = string
  description = "Defines the CIDR Block range for VPC"
}

variable "vpc-name" {
  type        = string
  description = "Defines the name of the VPC"
}

variable "subnets" {
  type = map(object({
    cidr-block        = string
    availability-zone = string
    subnet-name       = string
    routes = list(object({
      destination-block = string
      target-type      = string
    }))
  }))
}

variable "ig-name" {
  type        = string
  description = "Defines the name of the internet gateway"
}

variable "route-table-name" {
  type        = string
  description = "Defines the name of the route table"
}