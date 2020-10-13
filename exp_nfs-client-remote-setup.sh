#! /usr/bin/expect

set host [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]
set nfs_server [lindex $argv 3]
set share_dir [lindex $argv 4]

set timeout -1

spawn ssh $user@$host
expect "Welcome"
send "echo $password | sudo -S apt update\n"
expect "Reading state information... Done"
send "echo $password | sudo -S apt install -y nfs-common\n"
expect "newly installed"
send "sudo mkdir -p $share_dir\n"
send "sudo mount $nfs_server:$share_dir $share_dir\n"

send "exit\n"

expect eof
