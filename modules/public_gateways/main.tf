variable "vpc_resource_group" {
    description = "the name of the resource group in which the gateways will be created"
}

variable "vpc_id" {
    description = "the id of the VPC in which the gateways will be created"
}

variable "region" {
    description = "the region in which the VPC is located"
    default = "us-south"
}

data "ibm_resource_group" "vpc_resource_group" {
    name = "${var.vpc_resource_group}"
}

variable "vpc_name" {
    description = "the name of the VPC in which the gateways will be created"
}

##############################################################################
# Create Public Gateways
##############################################################################
resource "ibm_is_public_gateway" "zone1_gateway" {
    name           = "${var.vpc_name}-zone1-gateway"
    resource_group = data.ibm_resource_group.vpc_resource_group.id
    vpc            = var.vpc_id
    zone           = "${var.region}-1"

}

resource "ibm_is_public_gateway" "zone2_gateway" {
    name           = "${var.vpc_name}-zone2-gateway"
    resource_group = data.ibm_resource_group.vpc_resource_group.id
    vpc            = var.vpc_id
    zone           = "${var.region}-2"

}

resource "ibm_is_public_gateway" "zone3_gateway" {
    name           = "${var.vpc_name}-zone3-gateway"
    resource_group = data.ibm_resource_group.vpc_resource_group.id
    vpc            = var.vpc_id
    zone           = "${var.region}-3"

}

output "zone1_gateway_id" {
    value = ibm_is_public_gateway.zone1_gateway.id
}

output "zone2_gateway_id" {
    value = ibm_is_public_gateway.zone2_gateway.id
}

output "zone3_gateway_id" {
    value = ibm_is_public_gateway.zone3_gateway.id
}