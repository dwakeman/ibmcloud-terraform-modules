variable "vpc_name" {
    description = "the name of the vpc to be created"
}

variable "region" {
    description = "the region in which the VPC will be created"
    default = "us-south"
}

variable "environment" {
    description = "the name of the environment for this VPC.  Used to create a tag"
}

variable "schematics_workspace_name" {
    description = "the name of the schematics workspace.  Used to create a tag"
}

variable "vpc_resource_group" {
    description = "the name of the resource group in which the VPC will be created"
}

variable "address_prefix_cidr_blocks" {
    description = "list of strings of address prefix CIDR blocks in zone1, zone2, zone3 order"
}

data "ibm_resource_group" "vpc_resource_group" {
    name = "${var.vpc_resource_group}"
}


##############################################################################
# Create VPC
##############################################################################
resource "ibm_is_vpc" "vpc1" {
    name                      = var.vpc_name
    resource_group            = data.ibm_resource_group.vpc_resource_group.id
    address_prefix_management = "manual"
    tags                      = ["${var.environment}", "Schematics: ${var.schematics_workspace_name}"]

}


resource "ibm_is_network_acl" "isNetworkACL" {
    name           = "${var.vpc_name}-default-acl"
    vpc            = ibm_is_vpc.vpc1.id
    resource_group = data.ibm_resource_group.vpc_resource_group.id

    rules {
      name = "outbound"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "outbound"
    }
    rules {
      name = "inbound"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "inbound"
    }

    depends_on = [ibm_is_vpc.vpc1]
}

##############################################################################
# Create Security Group and Rules
##############################################################################
resource "ibm_is_security_group" "default_security_group" {
    name           = "${var.vpc_name}-default-sg"
    vpc            = ibm_is_vpc.vpc1.id
    resource_group = data.ibm_resource_group.vpc_resource_group.id

    depends_on = [ibm_is_vpc.vpc1]
}

resource "ibm_is_security_group_rule" "default_security_group_rule_all_inbound" {
    group     = ibm_is_security_group.default_security_group.id
    direction = "inbound"

    depends_on = [ibm_is_security_group.default_security_group]
 }

##############################################################################
# Create Rule to allow IKS Management traffic
##############################################################################
resource "ibm_is_security_group_rule" "default_security_group_rule_iks_management" {
    group     = ibm_is_security_group.default_security_group.id
    direction = "inbound"
    tcp {
        port_min = 30000
        port_max = 32767
    }

    depends_on = [ibm_is_security_group.default_security_group]
 }

##############################################################################
# Create Rule in default security group to allow IKS Management traffic
##############################################################################
resource "ibm_is_security_group_rule" "vpc_default_security_group_rule_iks_management" {
    group     = ibm_is_vpc.vpc1.default_security_group
    direction = "inbound"
    tcp {
        port_min = 30000
        port_max = 32767
    }

    depends_on = [ibm_is_security_group.default_security_group]
 }



resource "ibm_is_security_group_rule" "default_security_group_rule_all_outbound" {
    group     = ibm_is_security_group.default_security_group.id
    direction = "outbound"

    depends_on = [ibm_is_security_group.default_security_group]
 }


##############################################################################
# Create Address Prefixes
##############################################################################
resource "ibm_is_vpc_address_prefix" "address_prefix1" {
    name = "prefix1"
    zone = "${var.region}-1"
    vpc  = ibm_is_vpc.vpc1.id
    cidr = var.address_prefix_cidr_blocks[0]

    depends_on = [ibm_is_vpc.vpc1]

}

resource "ibm_is_vpc_address_prefix" "address_prefix2" {
    name = "prefix2"
    zone = "${var.region}-2"
    vpc  = ibm_is_vpc.vpc1.id
    cidr = var.address_prefix_cidr_blocks[1]

    depends_on = [ibm_is_vpc.vpc1]

}

resource "ibm_is_vpc_address_prefix" "address_prefix3" {
    name = "prefix3"
    zone = "${var.region}-3"
    vpc  = ibm_is_vpc.vpc1.id
    cidr = var.address_prefix_cidr_blocks[2]

    depends_on = [ibm_is_vpc.vpc1]

}

output "vpc_id" {
    value = ibm_is_vpc.vpc1.id
}

output "network_acl_id" {
    value = ibm_is_network_acl.isNetworkACL.id
}