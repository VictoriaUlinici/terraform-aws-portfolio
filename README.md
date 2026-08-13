# terraform-aws-portfolio

Terraform modules and example root configurations for provisioning AWS infrastructure: EC2 instances with IAM roles, S3 buckets, and an ALB-based reverse proxy with cross-account subnet sharing.

Written as a self-contained portfolio project: no real account IDs, ARNs or backend configuration are included — every example uses fictitious placeholder values and expects you to supply your own.

## Structure

```
modules/
  ec2-instance/        EC2 instance with encrypted root/extra EBS volumes, IMDSv2 enforced
  ec2-instance-role/    IAM role + instance profile for EC2, with opt-in policy statements
                        (Secrets Manager / KMS / EventBridge) driven entirely by variables
  s3-bucket/            S3 bucket with SSE-KMS (or SSE-S3) encryption, versioning, public
                        access block, and an optional dedicated IAM user for programmatic access
  alb-routing/           Target groups + listener rules on an existing ALB, one entry per service
  shared-subnet/        Subnet + cross-account sharing via AWS RAM

examples/
  account/               Template: wires ec2-instance(-role) + s3-bucket into a per-account root config
  network/                Template: wires alb-routing + shared-subnet into a networking root config

accounts/
  <name>/                 One real deployable copy of examples/account per AWS account
                          (e.g. accounts/esempio1/), with its own vars/{dev,test,prod}.tfvars

reverse-proxy/             One real deployable copy of examples/network, with its own
                          envs/{dev,qua,prod}.tfvars

scripts/
  linux-bootstrap.sh     Example EC2 userdata: hostname + EventBridge "instance ready" notification
  windows-bootstrap.ps1  Same, for Windows
```

## Usage

Each folder under `examples/` is an independent Terraform root module with its own state.

```bash
cd examples/account
cp terraform.tfvars.example terraform.tfvars   # fill in with your own values
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply
```

```bash
cd examples/network
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply
```

Configure your own remote state backend in `versions.tf` before running against real infrastructure — none is set by default.

## Adding a new account / environment

To provision a real account, duplicate `examples/account/` (all `.tf` files, not `terraform.tfvars.example`) into `accounts/<name>/`, e.g. `accounts/esempio1/`. Same for the network layer: duplicate `examples/network/` into `reverse-proxy/`.

Each deployable folder keeps a single Terraform state per environment, using [workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) plus one `.tfvars` file per environment (`vars/` for accounts, `envs/` for `reverse-proxy`, matching the account example's `dev`/`test`/`prod` and the network example's `dev`/`qua`/`prod`):

```bash
cd accounts/esempio1
terraform init
terraform workspace new dev        # once per environment; "select" afterwards
terraform plan  -var-file="vars/dev.tfvars"
terraform apply -var-file="vars/dev.tfvars"
```

```bash
cd reverse-proxy
terraform init
terraform workspace new qua
terraform plan  -var-file="envs/qua.tfvars"
terraform apply -var-file="envs/qua.tfvars"
```

Workspaces keep each environment's state isolated (the S3 backend automatically prefixes state by workspace) without any code changes — none of the modules or root configs read `terraform.workspace` directly.
