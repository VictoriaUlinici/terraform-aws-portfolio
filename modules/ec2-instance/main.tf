locals {
  linux_device_names   = ["/dev/sdb", "/dev/sdc", "/dev/sdd", "/dev/sde", "/dev/sdf", "/dev/sdg"]
  windows_device_names = ["xvdb", "xvdc", "xvdd", "xvde", "xvdf", "xvdg"]
  device_names         = var.os_family == "linux" ? local.linux_device_names : local.windows_device_names

  default_tags = merge(var.tags, {
    Name = var.hostname
  })
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data

  disable_api_stop        = false
  disable_api_termination = true

  root_block_device {
    encrypted   = true
    kms_key_id  = var.kms_key_id
    volume_size = var.root_volume_size
    volume_type = "gp3"

    tags = {
      Name = "${var.hostname}-root"
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = local.default_tags

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      root_block_device[0].volume_size,
    ]
  }
}

resource "aws_ebs_volume" "extra" {
  count = length(var.additional_disks)

  availability_zone = aws_instance.this.availability_zone
  size              = var.additional_disks[count.index]
  type              = "gp3"
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = {
    Name = "${var.hostname}-disk-${count.index + 1}"
  }

  lifecycle {
    ignore_changes = [size]
  }
}

resource "aws_volume_attachment" "extra" {
  count = length(var.additional_disks)

  device_name = local.device_names[count.index]
  instance_id = aws_instance.this.id
  volume_id   = aws_ebs_volume.extra[count.index].id
}
