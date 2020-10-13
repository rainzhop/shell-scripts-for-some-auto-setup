#! /bin/bash
# need cuda_10.1.243_418.87.00_linux.run

passwd=$1

echo $passwd | sudo -S pwd

echo -e "\033[47;34m CHECK pci-nvidia... \033[0m"
check_results=`lspci | grep -i nvidia`
if [[ $check_results =~ "NVIDIA" ]]
then
    echo "[OKay] pci-nvidia found."
else
    echo "[FAIL] pci-nvidia not found."
    exit
fi


echo -e "\033[47;34m CHECK linux version... \033[0m"
check_results=`uname -m && cat /etc/*release`
if [[ $check_results =~ "x86_64" ]]
then
    echo "[OKay] linux version supported."
else
    echo "[FAIL] linux version not supported."
    exit
fi


echo -e "\033[47;34m CHECK gcc... \033[0m"
check_results=`dpkg -s build-essential`
if [[ $check_results =~ "install ok installed" ]]
then
    echo "[OKay] gcc installed."
else
    echo "gcc not found..."
    echo "INSTALL gcc"
    sudo apt install -y build-essential
fi


echo -e "\033[47;34m CHECK kernel headers... \033[0m"
check_results=`dpkg -s linux-headers-$(uname -r)`
if [[ $check_results =~ "install ok installed" ]]
then
    echo "[OKay] linux-headers installed."
else
    echo "linux-headers not found..."
    echo "INSTALL linux-headers"
    sudo apt-get install -y linux-headers-$(uname -r)
fi


echo -e "\033[47;34m CHECK nouveau disabled... \033[0m"
check_results=`lsmod | grep nouveau`
if [[ $check_results = "" ]]
then
    echo "[OKay] nouveau disabled."
else
    sudo bash -c 'echo "blacklist nouveau
options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf'
    sudo update-initramfs -u

    echo "*** NEED REBOOT ***"
    echo "The computer will be reboot in 60 seconds"
    echo "Please rerun this script after rebooted."
    read -t 60 -n 1 -p "Press any key to reboot immediately..." _a
    # reboot
fi


echo -e "\033[47;34m CHECK nvidia driver... \033[0m"
check_results=`dpkg -s nvidia-driver-430`
if [[ $check_results =~ "install ok installed" ]]
then
    echo "[OKay] nvidia driver installed."
else
    echo "nvidia driver not found..."
    echo "INSTALL nvidia driver"
    sudo apt-get install -y nvidia-driver-430
    echo "The computer will be reboot in 60 seconds"
    echo "Please rerun this script after rebooted."
    read -t 60 -n 1 -p "Press any key to reboot immediately..." _a
    # reboot
fi


echo "INSTALL CUDA toolkit"
sudo sh ./cuda_10.1.243_418.87.00_linux.run --silent --toolkit


echo 'export CUDA_HOME="/usr/local/cuda-10.1"
export PATH="/usr/local/cuda-10.1/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH"
' >> ~/.bashrc
export CUDA_HOME="/usr/local/cuda-10.1"
export PATH="/usr/local/cuda-10.1/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH
