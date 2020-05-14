##############################################################################
# Create Subnets in a VPC
#
# This template will create 3 subnets, one in each availability zone of the region
#
##############################################################################

variable "vpc_id" {
    description = "the id of the VPC"
}

variable "resource_group" {
    description = "the ID of the resource group where the subnets will be created"
}

variable "region" {
    description = "the multi-zone region where the VPC exists"
    default = "us-south"
}

variable "subnet_name_prefix" {
    description = "string to be prepended to the name of the subnet"
}

variable "network_acl" {
    description = "id of the network ACL to use for the subnets"
}

# String list of CIDR blocks
variable "subnet_cidr_blocks" {
    type        = list(string)
    description = "list of CIDR blocks to be used on subnets in zone1, zone2, zone3 order"
}

variable "public_gateways" {
    type        = list(string)
    description = "list of public gateways in zone1, zone2, zone3 order"
}




##############################################################################
# Create Subnets
##############################################################################
resource "ibm_is_subnet" "subnet1" {
    name            = "${var.subnet_name_prefix}-subnet1"
    resource_group  = var.resource_group
    vpc             = var.vpc_id
    zone            = "${var.region}-1"
    ipv4_cidr_block = var.subnet_cidr_blocks[0]
    public_gateway  = var.public_gateways[0]
    network_acl     = var.network_acl

#    depends_on = [ibm_is_vpc.vpc1, ibm_is_vpc_address_prefix.address_prefix1, ibm_is_public_gateway.zone1_gateway, ibm_is_network_acl.isNetworkACL]
}

resource "ibm_is_subnet" "subnet2" {
    name            = "${var.subnet_name_prefix}-subnet2"
    resource_group  = var.resource_group
    vpc             = var.vpc_id
    zone            = "${var.region}-2"
    ipv4_cidr_block = var.subnet_cidr_blocks[1]
    public_gateway  = var.public_gateways[1]
    network_acl     = var.network_acl

#    depends_on = [ibm_is_vpc.vpc1, ibm_is_vpc_address_prefix.address_prefix2, ibm_is_public_gateway.zone2_gateway, ibm_is_network_acl.isNetworkACL]
}

resource "ibm_is_subnet" "subnet3" {
    name            = "${var.subnet_name_prefix}-subnet3"
    resource_group  = var.resource_group
    vpc             = var.vpc_id
    zone            = "${var.region}-3"
    ipv4_cidr_block = var.subnet_cidr_blocks[2]
    public_gateway  = var.public_gateways[2]
    network_acl     = var.network_acl

#    depends_on = [ibm_is_vpc.vpc1, ibm_is_vpc_address_prefix.address_prefix3, ibm_is_public_gateway.zone3_gateway, ibm_is_network_acl.isNetworkACL]
}

output subnet1_id {
    value = ibm_is_subnet.subnet1.id
}

output subnet2_id {
    value = ibm_is_subnet.subnet2.id
}

output subnet3_id {
    value = ibm_is_subnet.subnet3.id
}