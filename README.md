### AWS VPC Module

This module will create following resources
We are using HA (High Availability), we are getting first 2 AZ (Availability Zones) atomatically.

* VPC
* Internet Gateway
* 2 Public Subnets in 1a & 1b
* 2 Private Subnets in 1a & 1b
* 2 Database Subnets in 1a & 1b
* Elastic IP
* NAT Gateway in 1a public subnet
* Public route table
* private route table
* database route table
* subnets and route tables association
* VPC peering if user request
* Adding peering route in default VPC if user doesn't provide Acceptor VPC explicitly (from Acceptor VPC to Requester VPC).
* Adding peering routes in public, private and database route tables1 (from Requester VPC to Acceptor VPC).

### Inputs
* project_name (required) : user needs to provide
* environment (required) : user needs to provide
* vpc_cidr (optionl) : default value is "10.0.0.0/16", User can override this value
* enable_dns_hostnames (optional) : default value is "true"
* common_tags (optional) : better to provide
* vpc_tags (optional)
* internet_gateway_tags (optional)
* public_subnets_cidr (required) : user must provide 2 valid public subnet cidr
* public_subnets_tags (optional) 
* private_subnet_cidr (required) : user must provide 2 valid private subnet cidr
* private_subnets_tags (optional)
* database_subnet_cidr (required) : user must provide 2 valid database subnet cidr
* database_subnets_tags (optional) 
* nat_gateway-tags (optional)
* public_route_table_tags (optional)
* private_route_table_tags (optional)
* database_route_tale_tags (optional)
* is_peering_required (optional) : default value is false
* acceptor_vpc_id (optional) : default value is default VPC ID, type is "string"
* vpc_peering_tags (optional) : default value is empty, type is "map"

### Outputs
* vpc_id : id of created VPC
* public_subnet_ids : 2 public subnet ids
* private_subnet_ids : 2 private subnet ids
* database_subnet_ids : 2 database subnet ids



