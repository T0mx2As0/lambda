#!/bin/bash

name="TestLamda"

echo "Controlli preliminari..."

n_instances=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].Tags[*].Value" --output text --filters "Name=tag:Name,Values=$name" --filters "Name=instance-state-name,Values=running" | wc -l )

if [ "$n_instances" -ge 1 ]; then

    echo "Esiste gia un instanza con questo nome ....."

else

    echo "esecuzione terraform ...."

    echo "esecuzione Terraform init "
    terraform init 

    echo "esecuzione Terraform plan "    
    terraform plan > ./log/log-plan.txt 

    echo "esecuzione Terraform apply "
    #terraform apply  > ./log/log-apply.txt

fi

#    echo "esecuzione Terraform plan "    
#    terraform plan -out plan-terraform.txt > ./log/log-plan.txt 
#    echo "esecuzione Terraform apply "
#    terraform apply "plan-terraform.txt" -auto-approve > ./log/log-apply.txt