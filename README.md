# Capture the Flag (CTF) Repo

Trust's capture the Flag (CTF) resources for Cybersecurity Awareness month.

This repository contains the Terraform that can be used to deploy an instance of OWASP Juice Shop on EC2 instance along with CFTd app to help manage the CTF event.

## OWASP Juice Shop & CTFd

![Juice Shop](https://raw.githubusercontent.com/juice-shop/juice-shop/develop/frontend/src/assets/public/images/JuiceShop_Logo_100px.png)    [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) is probably the most modern and sophisticated insecure web application! 

![CTFd](https://ctfd.io/static/img/ctfd.svg)    [CTFd](https://ctfd.io/) is a Capture The Flag (CTF) framework designed for ease of use.

# Usage Instructions

### Step 1: Provision AWS resources via Terraform

```
terraform init
terraform apply
```

### Step 2: Install applications via Ansible playbooks

- Replace the `s3://bucket-name` with the value of the `s3_bucket_name_ansible_playbooks` output from the Terraform apply. 
- Replace the `--instance-ids` values with the corresponding `ec2_cftd_instance_id` and `ec2_owaspjs_instance_id` output values from the Terraform apply.

```
aws s3 sync ./ansible s3://bucket-name --include "*.yml"
# Install CFTd
aws ssm send-command --document-name "AWS-RunAnsiblePlaybook" --instance-ids "i-0xxxxxxxxxxxxxxxx" --max-errors 1 --parameters '{"extravars":["SSM=True"],"check":["False"],"playbookurl":["s3://bucket-name/playbook_cftd.yml"]}' --timeout-seconds 600 --region ca-central-1
# Install OWASP Juice Shop
aws ssm send-command --document-name "AWS-RunAnsiblePlaybook" --instance-ids "i-0xxxxxxxxxxxxxxxx" --max-errors 1 --parameters '{"extravars":["SSM=True"],"check":["False"],"playbookurl":["s3://bucket-name/playbook_owaspjs.yml"]}' --timeout-seconds 600 --region ca-central-1
```

### Step 3: Configure the Flags

[juice-shop-ctf-cli (OWASP Juice Shop CTF Extension)](https://www.npmjs.com/package/juice-shop-ctf-cli)

> The Node package juice-shop-ctf-cli helps you to prepare Capture the Flag events with the OWASP Juice Shop challenges for different popular CTF frameworks. This interactive utility allows you to populate a CTF game server in a matter of minutes.
