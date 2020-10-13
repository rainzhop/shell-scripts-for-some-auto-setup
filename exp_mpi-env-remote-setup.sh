#! /usr/bin/expect

set host [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]

set timeout -1

spawn ssh $user@$host
expect "Welcome"
send "echo $password | sudo -S apt update\n"
expect "Reading state information... Done"
send "echo $password | sudo -S apt install -y mpich\n"
expect "newly installed"

send "exit\n"

expect eof
