#!/usr/bin/env bash

# functions
function die {
    ( >&2 echo $@ )
    exit 1
}

function cpmod {
    cp_src=${1}
    shift
    cp_dst=${1}
    shift
    owner=${1}
    shift
    mod=${1}
    shift

    cp "$@" "${cp_src}" "${cp_dst}"
    chown "${owner}" "${cp_dst}"
    chmod "${mod}" "${cp_dst}"
}

function mkmod {
    mk_dir=${1}
    owner=${2}
    mod=${3}

    mkdir -p "${mk_dir}"
    chown "${owner}" "${mk_dir}"
    chmod "${mod}" "${mk_dir}"
}

function link_etc {
    ln -s "${1}" "/etc/${2}"
}

function link_usr {
    ln -s "${1}" "/home/ubuntu/${2}"
}

function remove {
    target=${1}
    if [ -d "${target}" ]; then
        rm -rf "${target}"
    elif [ -e "${target}" ]; then
        rm -f "${target}"
    else
        rm -f "${target}"
    fi
}

# update system
apt-get update
apt-get upgrade -y

# install ansible (http://docs.ansible.com/intro_installation.html)
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y upgrade
apt-get -y install ansible

# check if SSH source directory exists
ssh_dir_src="/home/ubuntu/config/ssh"
if ! [ -d "${ssh_dir_src}" ]; then
    die "Missing SSH source dir \"${ssh_dir_src}\""
fi

# make SSH destination dir
ssh_dir_dst="/home/ubuntu/.ssh"
mkmod "${ssh_dir_dst}" "ubuntu:ubuntu" "700"

# copy SSH files
for file in $( find "${ssh_dir_src}" -type f ); do
    file_name=$( basename "${file}" )
    file_dest="${ssh_dir_dst}/${file_name}"
    if [ "${file_name}" != ".keep" ] && [ "${file_name}" != "authorized_keys" ]; then
        remove "${file_dest}"
        cpmod "${file}" "${file_dest}" "ubuntu:ubuntu" "600"
    fi
done

# make public keys readable by group and others
for file in $( find "${ssh_dir_dst}" -type f -iname "*.pub" ); do
    chmod 644 "${file}"
done

# check if SSH source directory exists
config_dir="/home/ubuntu/config"
if ! [ -d "${config_dir}" ]; then
    die "Missing config source dir \"${config_dir}\""
fi

# link ubuntu user .bashrc
user_bashrc="${config_dir}/user/bashrc"
remove "/home/ubuntu/.bashrc"
if [ -f "${user_bashrc}" ]; then
    link_usr "${user_bashrc}" ".bashrc"
else
    link_usr "${user_bashrc}.default" ".bashrc"
fi

# link ubuntu user .ansible.cfg
user_ansiblecfg="${config_dir}/user/ansible.cfg"
remove "/home/ubuntu/.ansible.cfg"
if [ -f "${user_ansiblecfg}" ]; then
    link_usr "${user_ansiblecfg}" ".ansible.cfg"
else
    link_usr "${user_ansiblecfg}.default" ".ansible.cfg"
fi

# link hosts file
etc_hosts="${config_dir}/hosts"
remove "/etc/hosts"
if [ -f "${etc_hosts}" ]; then
    link_etc "${etc_hosts}" "hosts"
else
    link_etc "${etc_hosts}.default" "hosts"
fi
