#! /bin/bash

share_dir=$1
passwd=$2
clients=$3

echo $passwd | sudo -S pwd


echo -e "\033[47;34m CHECK nfs-server installed... \033[0m"
check_results=`dpkg -s nfs-server`
if [[ $check_results =~ "install ok installed" ]]
then
    echo "[OKay] nfs-server installed."
else
    echo "nfs-server not found..."
    echo "INSTALL nfs-server"
    sudo apt install -y nfs-kernel-server
fi


sudo mkdir -p $share_dir
sudo chown nobody:nogroup $share_dir
sudo chmod 777 $share_dir

sudo bash -c "echo '$share_dir  $clients(rw,sync,no_subtree_check)' >> /etc/exports"
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
# sudo ufw allow from $clients to any port nfs
# sudo ufw enable / sudo ufw disable
