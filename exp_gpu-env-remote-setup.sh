#! /usr/bin/expect

set host [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]
set share_dir [lindex $argv 3]

set timeout -1

spawn ssh $user@$host
expect "Welcome"
send "cd $share_dir\n"
send "./gpu-env-setup.sh $password\n"
send "exit\n"

expect eof
