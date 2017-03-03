# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

# ---- Dependencies

require 'yaml'

# ---- Global variables

VAGRANT_VERSION     = 2
VAGRANT_CONFIG_FILE = "Vagrantconfig"

# ---- Default params

defaults = Hash.new
defaults['vm_name']   = 'ansible-mgmt'
defaults['vm_cpus']   = 1
defaults['vm_memory'] = 512

# ---- Loading params from YAML file

yaml = Hash.new
if File.exist?(VAGRANT_CONFIG_FILE)
  yaml = YAML::load_file(VAGRANT_CONFIG_FILE)
end

# ---- Mapping YAML parameters to my parameters (setting default values eventually)

params = Hash.new
defaults.each do |key, default_value|
  params[key] = yaml.has_key?(key) ? yaml[key] : default_value
end

# ---- Fixed params

params['vm_box'] = 'ubuntu/xenial64'

# ---- HACK to get all the directory mounted every time you reload

SYNCED_FOLDERS_CONFFILE=File.join(File.dirname(__FILE__), ".vagrant/machines/#{params['vm_name']}/virtualbox/synced_folders")
if File.exist?(SYNCED_FOLDERS_CONFFILE)
  File.delete(SYNCED_FOLDERS_CONFFILE)
end

# ---- Vagrant configuration

Vagrant.configure(VAGRANT_VERSION) do |config|

  config.vm.define params['vm_name'] do |node|
    node.vm.box      = params['vm_box']
    node.vm.hostname = params['vm_name']

    node.vm.box_check_update = false

    node.vm.provider "virtualbox" do |vb|
      vb.name   = params['vm_name']
      vb.cpus   = params['vm_cpus']
      vb.memory = params['vm_memory']
    end

    node.vm.synced_folder ".", "/vagrant", disabled: true

    node.vm.synced_folder "ansible", "/home/ubuntu/ansible"
    node.vm.synced_folder "bin",     "/home/ubuntu/bin"
    node.vm.synced_folder "config",  "/home/ubuntu/config"

    node.vm.provision :shell, path: "bootstrap.sh"
  end

end
