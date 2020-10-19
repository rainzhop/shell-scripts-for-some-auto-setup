#! /bin/bash

local_ip="<ip>"
local_passwd="<pw>"

share_dir="<dir>"
nfs_clients_subnet="<ip>/<mask>"

remote="<ip>"
remote_user="<username>"
remote_passwd="<password>"

echo $local_passwd | sudo -S pwd


# expect
sudo apt install -y expect

# ssh no password ok
# sudo bash -c "echo '$remote $remote_host' >> /etc/hosts"
expect ./exp_ssh-nopw.sh $remote $remote_user $remote_passwd $local_ip $local_host

# nfs ok
./nfs-server-setup.sh $share_dir $local_passwd $nfs_clients_subnet
expect ./exp_nfs-client-remote-setup.sh $remote $remote_user $remote_passwd $local_ip $share_dir

# mpi ok
sudo apt install -y mpich
expect ./exp_mpi-env-remote-setup.sh $remote $remote_user $remote_passwd

# local cuda ok
./gpu-env-setup.sh $local_passwd

# remote cuda todo
expect ./exp_gpu-env-remote-setup.sh $remote $remote_user $remote_passwd $share_dir
# 涉及重启问题 todo

