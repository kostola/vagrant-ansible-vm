# Vagrant Ansible VM

Since Ansible doesn't run natively on Windows, this repo allows you to create a generic [VirtualBox](https://www.virtualbox.org/) VM using 
[Vagrant](https://www.vagrantup.com/) based on Ubuntu 16.04.

# Configuration

## VM parameters

By default, Vagrant will name the generated VM `ansible-mgmt` and configure it with 1 core and 512MB of RAM.
There's a smart way to change these parameters if you want to. Instead of editing the `Vagrantfile`, create a `Vagrantconfig` file in the root of the 
repo with this content (it's YAML syntax):

```yaml
vm_name   : my-ansible-vm
vm_cpus   : 2
vm_memory : 2048
```

## Hosts file

If you want to set a custom `/etc/hosts` file, create it in `config/hosts`.

Vagrant bootstrap script will automatically link it in the VM, so changes will be applied immediately without the need of rerun the Vagrant 
provisioning script.

If you don't create it, `config/hosts.default` file will be used.

## User .bashrc

If you want to set a custom `~/.bashrc` file, create it in `config/user/bashrc`.

Vagrant bootstrap script will automatically link it in the VM, so changes will be applied immediately without the need of rerun the Vagrant 
provisioning script.

If you don't create it, `config/user/bashrc.default` file will be used.

## User .ansible.cfg

If you want to set a custom `~/.ansible.cfg` file, create it in `config/user/ansible.cfg`.

Vagrant bootstrap script will automatically link it in the VM, so changes will be applied immediately without the need of rerun the Vagrant 
provisioning script.

If you don't create it, `config/user/ansible.cfg.default` file will be used.

## SSH Files

To properly allow the VM to connect via SSH to your remote hosts, place all the SSH files (config, public and private keys) in the `config/ssh` 
folder.

Vagrant bootstrap script will copy all the files (except `authorized_keys`) in the `~/.ssh` folder inside the VM.

**WARNING:** SSH files are not linked, like the previous ones, so if you make a change to the content of the directory, you must rerun Vagrant 
provisioning.

# Ansible files (playbooks/inventories...)

Since this VM is intended to be generic, it provides the base tools but it doesn't contain any Ansible file (task, playbook, inventory). You're 
supposed to place them in the `ansible` subfolder, which in the VM will be located in `~/ansible`

# Custom binaries

The `bin` subfolder of this repo is intended to contain custom binaries. In the VM this folder will be located in `~/bin` and the default `.bashrc` is 
configured to append it to the `PATH` variable.

# Create the VM

Once you installed VirtualBox and Vagrant and configured everything, simply run:

```bash
$ vagrant up
```

from the root of the repo.

**Now have fun with Ansible on Windows!**
