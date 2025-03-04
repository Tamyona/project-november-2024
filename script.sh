#!/bin/bash

# Provide permissions to .sh files with command: "sudo chmod +x FILENAME"

function prepare_bastion() {
    sudo apt update
    sudo apt install ansible -y
    if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]   # if file does not exist run command
    then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    fi
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
}

# initialize terraform infrstructure
function create_instance() {
    cd terraform/       # go terraform folder and run the command there
    terraform init
    terraform apply --auto-approve
}

# automatically update IP of the VM you are working with in ansible-playbooks hosts file
function update_ip() {
    terraform output -raw ec2 > ../ansible/hosts
}

# invoke ansible-playbook
function ansible() {
    cd ../ansible
    ansible-playbook main.yml
}

prepare_bastion
create_instance
update_ip
sleep 20
ansible