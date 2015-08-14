#!/usr/bin/env bash
#
# Bootstrap the vagrant VM by installing Ansible and
# letting Ansible do the provisioning in local connection mode
#

# Check if Ansible is installed and install it if necessary
echo "Checking for Ansible..."
if [ -z `which ansible` ]
then
    echo "Ansible is not yet installed"
    echo "Adding the official Ansible repository to the apt sources list"
    sudo apt-get -qq update
    sudo apt-get -y -qq install python-software-properties
    sudo apt-add-repository -y ppa:ansible/ansible

    echo "Installing the newest version of Ansible..."
    sudo apt-get -qq update
    sudo apt-get -y -qq install ansible

    echo "Done"
else
    echo "Ansible is already installed"
fi

# Now run the Ansible playbook
echo "Running Ansible playbook..."
cd /vagrant/vagrant/ansible
sudo ansible-playbook playbook.yml -i "localhost," --connection=local