module "instance_role" {
  source = "../../modules/ec2-instance-role"

  role_name      = "ec2-default-role"
  secret_arns    = var.secret_arns
  kms_key_arns   = [var.kms_key_arn]
  event_bus_arns = var.event_bus_arns
}

module "instances" {
  source   = "../../modules/ec2-instance"
  for_each = var.instances

  hostname             = each.key
  ami                  = each.value.ami
  instance_type        = each.value.instance_type
  subnet_id            = each.value.subnet_id
  security_group_ids   = each.value.security_group_ids
  os_family            = each.value.os_family
  key_name             = each.value.key_name
  iam_instance_profile = module.instance_role.instance_profile_name
  root_volume_size     = each.value.root_volume_size
  additional_disks     = each.value.additional_disks
  user_data            = each.value.user_data
  kms_key_id           = var.kms_key_arn
  tags                 = each.value.tags
}

module "buckets" {
  source   = "../../modules/s3-bucket"
  for_each = var.buckets

  bucket_name       = each.key
  kms_key_arn       = var.kms_key_arn
  enable_versioning = each.value.enable_versioning
  create_iam_user   = each.value.create_iam_user
  tags              = each.value.tags
}
