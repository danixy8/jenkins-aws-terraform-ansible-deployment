# !/bin/bash

terraform apply -auto-approve
terraform_exit_code=$?

if [ $terraform_exit_code -eq 0 ]; then
    echo "Terraform apply completed successfully."
    retries=5 
    while [ $retries -gt 0 ]; do
	sleep 2
        ansible-playbook jenkins-installation-playbook.yaml -v && break
        echo "Error in ansible-playbook. Retrying..."
        retries=$((retries - 1))
    done
else
    echo "Error in Terraform apply. Exit code: $terraform_exit_code"
fi
