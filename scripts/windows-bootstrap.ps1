<powershell>
# Minimal EC2 userdata example for Windows instances provisioned by modules/ec2-instance.
# Renames the instance and notifies a provisioning pipeline via EventBridge once the
# instance is ready. Replace the placeholders below with real values (or template
# them in from Terraform, as the "<hostname>" placeholder is here).

$hostname = "<hostname>"
$eventBusArn = "arn:aws:events:eu-west-1:123456789012:event-bus/provisioning"

$ip = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp).IPAddress | Select-Object -First 1

Rename-Computer -NewName $hostname -Force

# Example: read a bootstrap secret provisioned via Secrets Manager
# (see modules/ec2-instance-role, var.secret_arns).
# $secret = (Get-SECSecretValue -SecretId "arn:aws:secretsmanager:eu-west-1:123456789012:secret:bootstrap/ec2-XXXXXX").SecretString | ConvertFrom-Json

Import-Module AWS.Tools.EventBridge

$entry              = New-Object -TypeName Amazon.EventBridge.Model.PutEventsRequestEntry
$entry.Source       = "ec2.bootstrap"
$entry.DetailType   = "instance_ready"
$entry.Detail       = "{""hostname"":""$($hostname.ToUpper())"",""ip"":""$ip""}"
$entry.EventBusName = $eventBusArn

Write-EVBEvent -Entry $entry

Restart-Computer -Force
</powershell>
