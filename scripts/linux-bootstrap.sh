#!/bin/bash
# Minimal EC2 userdata example for Linux instances provisioned by modules/ec2-instance.
# Sets the hostname and notifies a provisioning pipeline via EventBridge once the
# instance is ready. Replace the placeholders below with real values (or template
# them in from Terraform, as the "<hostname>" placeholder is here).

set -euo pipefail

LOGFILE="/var/log/bootstrap.log"
exec >> "$LOGFILE" 2>&1

VM_HOSTNAME="<hostname>"
VM_HOSTNAME="${VM_HOSTNAME,,}"

EVENT_BUS_ARN="arn:aws:events:eu-west-1:123456789012:event-bus/provisioning"

hostnamectl set-hostname "$VM_HOSTNAME"

IP=$(hostname -I | awk '{print $1}')
echo "$IP $VM_HOSTNAME" >> /etc/hosts

# Example: read a bootstrap secret provisioned via Secrets Manager
# (see modules/ec2-instance-role, var.secret_arns).
# SECRET=$(aws secretsmanager get-secret-value \
#   --secret-id arn:aws:secretsmanager:eu-west-1:123456789012:secret:bootstrap/ec2-XXXXXX \
#   --query SecretString --output text)

json=$(jq -n --arg hostname "$VM_HOSTNAME" --arg ip "$IP" --arg bus "$EVENT_BUS_ARN" '[
  {
    "DetailType": "instance_ready",
    "Source": "ec2.bootstrap",
    "EventBusName": $bus,
    "Detail": ("{\"hostname\":\"" + $hostname + "\",\"ip\":\"" + $ip + "\"}")
  }
]')

aws events put-events --entries "$json"

echo "Bootstrap complete."
