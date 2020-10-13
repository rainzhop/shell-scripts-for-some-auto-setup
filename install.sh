#! /bin/bash

local_host="<ip>"
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
expect ./exp_ssh-nopw.sh $remote $remote_user $remote_passwd

# nfs ok
./nfs-server-setup.sh $share_dir $local_passwd $nfs_clients_subnet
expect ./exp_nfs-client-remote-setup.sh $remote $remote_user $remote_passwd $local_host $share_dir

# mpi ok
sudo apt install -y mpich
expect ./exp_mpi-env-remote-setup.sh $remote $remote_user $remote_passwd

# local cuda ok
./gpu-env-setup.sh $local_passwd

# remote cuda todo
expect ./exp_gpu-env-remote-setup.sh $remote $remote_user $remote_passwd $share_dir
# 涉及重启问题 todo

