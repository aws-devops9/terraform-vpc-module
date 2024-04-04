data "aws_availability_zones" "azs" { # to get the default Availability Zones in your VPC
    state = "available" 
}

data "aws_vpc" "default" { # to get the default VPC info/id
    default = true
}

data "aws_route_table" "default" {
    vpc_id = data.aws_vpc.default.id
    filter {
        name = "association.main"
        values = ["true"]
    }
}