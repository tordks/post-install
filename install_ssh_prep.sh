# Source: http://www.tecmint.com/install-openssh-server-in-linux/

#install tools
sudo apt-get install openssh-server openssh-client

# make a copy of config file
sudo cp /etc/ssh/sshd_config  /etc/ssh/sshd_config.original_copy

# test if the openssh server is working
nc -v -z 127.0.0.1 22

# Disable root login
vim /etc/ssh/sshd_config

#Change PermitRootLogin to no (or remove # in front of it)

#We need to restart SSH deamon serivce
/etc/init.d/ssh restart

#passwordless login
# http://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/


# Debugging and fixing dynamic ip: 
# http://askubuntu.com/questions/181723/connecting-to-ubuntu-server-via-ssh-externally


