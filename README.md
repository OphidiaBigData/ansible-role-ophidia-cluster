Ophidia cluster role
====================

This ansible role deploys and configures all services required for an Ophidia cluster. 

Introduction
------------

This repository contains Ansible roles that are published in
Ansible Galaxy: https://galaxy.ansible.com/OphidiaBigData/ophidia-cluster/

Role Variables
--------------

1. cert_passwd: the password for the certificates and user account
2. ophdb_passwd: the password for MySQL
3. oph_user: user that will run the Ophidia framework
4. base_path: base path for shared data folder
5. io_prefix: hostname perfix of Ophidia IO nodes
6. io_node_number: number of IO nodes considered in the cluster
7. io_hostnames: list of hostnames of Ophidia IO nodes
8. io_ips: list of IP addresses of Ophidia IO nodes
9. server_hostname: Ophidia Server node hostname
10. server_ip: Ophidia Server node ip address
11. nfs_subnet: subnetwork for the Ophidia io-compute nodes (for NFS folder mount)
12. mysql_subnet: subnetwork for MySQL server on the cluster nodes (for database grant)
13. deploy_type: type of deployment ('install', 'configure' or 'complete')
14. node_type: type of node to deploy ('server' or 'io')

Dependencies
------------

Requires grycap.nfs and grycap.slurm roles.

Requirements
------------

Requires at least Ansible v2.3.

Example Playbook
----------------

An example of playbook to install the Ophidia cluster:

```
---
- hosts: oph-server
  roles:
    - { role: 'OphidiaBigData.ophidia-cluster', node_type: 'server', deploy_type: 'install', server_hostname: "{{ansible_hostname}}", io_hostnames: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_hostname')|list }}", server_ip: "{{ ansible_default_ipv4.address }}", io_node_number: "{{ groups['oph-io']|length }}" }

- hosts: oph-io
  roles:
    - { role: 'OphidiaBigData.ophidia-cluster', node_type: 'io', deploy_type: 'install', server_hostname: "{{ hostvars['oph-server']['ansible_hostname'] }}", io_hostnames: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_hostname')|list }}", server_ip: "{{ hostvars['oph-server']['ansible_default_ipv4']['address'] }}" }

```

An example of playbook to configure the Ophidia cluster:

```
---
- hosts: oph-server
  roles:
    - {role: 'OphidiaBigData.ophidia-cluster', node_type: 'server', deploy_type: 'configure', server_hostname: "{{ansible_hostname}}", io_hostnames: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_hostname')|list }}", io_ips: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_default_ipv4')|list }}", server_ip: "{{ ansible_default_ipv4.address }}", io_node_number: "{{ groups['oph-io']|length }}" }

- hosts: oph-io
  roles:
    - {role: 'OphidiaBigData.ophidia-cluster', node_type: 'io', deploy_type: 'configure', server_hostname: "{{ hostvars['oph-server']['ansible_hostname'] }}", io_hostnames: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_hostname')|list }}", io_ips: "{{ groups['oph-io']|map('extract', hostvars, ['ansible_default_ipv4', 'address'])|list }}", server_ip: "{{hostvars['oph-server']['ansible_default_ipv4']['address']}}" }

```

Further documentation
---------------------

* Ophidia: http://ophidia.cmcc.it
* Installation and configuration: http://ophidia.cmcc.it/documentation/admin/index.html

