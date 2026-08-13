locals {
  # one (subnet_key, principal_account_id) pair per row, for the principal associations
  subnet_principal_pairs = {
    for pair in flatten([
      for subnet_key, subnet in var.subnets : [
        for account_id in subnet.principal_account_ids : {
          key        = "${subnet_key}-${account_id}"
          subnet_key = subnet_key
          account_id = account_id
        }
      ]
    ]) : pair.key => pair
  }
}

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}

resource "aws_ram_resource_share" "this" {
  for_each = var.subnets

  name                      = each.key
  allow_external_principals = true
}

resource "aws_ram_resource_association" "subnet" {
  for_each = var.subnets

  resource_arn       = aws_subnet.this[each.key].arn
  resource_share_arn = aws_ram_resource_share.this[each.key].arn
}

resource "aws_ram_resource_association" "security_group" {
  for_each = var.internal_security_group_id != null ? var.subnets : {}

  resource_arn       = data.aws_security_group.internal[0].arn
  resource_share_arn = aws_ram_resource_share.this[each.key].arn
}

resource "aws_ram_principal_association" "this" {
  for_each = local.subnet_principal_pairs

  principal          = each.value.account_id
  resource_share_arn = aws_ram_resource_share.this[each.value.subnet_key].arn
}
