#!/bin/sh -x


echo "Hi"
cd ssh-jenkins
pwd
terraform init
terraform plan -out="dev.plan"
terraform apply -auto-approve -lock=false > apply.txt
terraform output instance_ip > ip.txt
cat ip.txt | tr -d '"' >out.txt
my_var=$(cat out.txt)

#terraform destroy -auto-approve > delete.txt

echo "----------------------------------------------------------------------------------"
echo "Done With Terraform"
echo "-----------------------------------------------------------------------------------"

cd ..
cd inventories
pwd
echo "[My_Group]\n${my_var} ansible_ssh_user=niveus ansible_ssh_private_key_file=~/.ssh/lab_ssh_key  ansible_python_interpreter=/usr/bin/python3" >> hosts

echo "Sucessfully appended"

cd ..
pwd
ansible My_Group -m ping
#ansible-playbook -i $my_var, jenkins.yml > output.txt
ansible-playbook installJenkins.yml
ansible-playbook sonar.yaml
#ansible-playbook allinone.yaml 

echo "Done With ALL in ONE"









#service jenkins stop
#sudo apt-get remove --purge jenkins
#sudo apt-get autoclean
#sudo apt-get clean
#sudo apt-get autoremove
echo "Done!"
