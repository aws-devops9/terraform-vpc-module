variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16" # User can override
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

variable "common_tags" {
  type = map  
  default = {} # It is optional
}

variable "vpc_tags" { # User has to provide
  type =map 
}

variable "project_name" { # User has to provide
  type = string
}

variable "environment" { # User has to provide
  type = string
}

variable "igw_tags" {
  type = map
  default = {}
}

variable "public_subnets_cidr" { # User has to provide
  type = list
  validation {
    condition = length(var.public_subnets_cidr) == 2
    error_message = "Please give 2 valid public subnets CIDR"
  }
}

variable "public_subnets_tags" {
  default = {}
}

variable "private_subnets_cidr" {
  type = list 
  validation {
    condition = length(var.private_subnets_cidr) == 2
    error_message = "Please give 2 valid private subnets CIDR"
  }
}

variable "private_subnets_tags" {
  default = {}
}

variable "database_subnets_cidr" {
  type = list 
  validation {
    condition = length(var.database_subnets_cidr) == 2
    error_message = "Please give 2 valid database subnets CIDR"
  }
}

variable "database_subnets_tags" {
  default = {}
}

variable "nat_gw_tags" {
  default = {}
}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
  default = {}
}

variable "database_route_table_tags" {
  default = {} # {} -- means empty for map variable types
}

variable "is_peering_required" {
  type = bool
  default = "false"
}

variable "acceptor_vpc_id" {
  type = string
  default = "" # "" -- means empty for string variable types
}

variable "vpc-peering_tags" {
  default = {}
}