#! /usr/bin/expect

set host [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]

set timeout 3 

spawn ssh-keygen -t rsa
expect {
    "Enter file" {send "\n"; exp_continue}
    "y/n" {send "y\n"; exp_continue}
    "Enter passphrase" {send "\n"; exp_continue}
    "passphrase again:" {send "\n"}
}
expect eof

spawn bash -c "scp ~/.ssh/id_rsa.pub $user@$host:~/id_rsa.pub"
expect {
    "yes/no" {send "yes\n"; exp_continue}
    "password:" {send "$password\n"}
}

spawn ssh $user@$host
expect {
    "yes/no" {send "yes\n"; exp_continue}
    "password:" {send "$password\n"}
}

expect "Welcome"
send "mkdir ~/.ssh\n"
send "cat ~/id_rsa.pub >> ~/.ssh/authorized_keys\n"
send "exit\n"

expect eof
