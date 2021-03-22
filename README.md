Ophidia cluster role
====================

This ansible role deploys and configures an ECAS cluster, providing a complete environment for scientific data analysis based on the Ophidia framework, JupyterHub and a Grafana-based monitoring system.

Introduction
------------

This repository contains Ansible roles that are published in
Ansible Galaxy: https://galaxy.ansible.com/OphidiaBigData/ophidia-cluster/

Role Variables
--------------

1. cert_passwd: the password for the certificates and user account
2. ophdb_passwd: the password for MySQL
3. oph_user: user that will run the Ophidia framework
4. oph_account_user: username of the Ophidia user account to be created
5. oph_account_passwd: password of the Ophidia user account to be created
6. base_path: base path for shared data folder
7. io_prefix: hostname perfix of Ophidia IO nodes
8. io_node_number: number of IO nodes considered in the cluster
9. io_hostnames: list of hostnames of Ophidia IO nodes
10. io_cpus: number of cores for Ophidia IO nodes 
11. io_ips: list of IP addresses of Ophidia IO nodes
12. server_hostname: Ophidia Server node hostname
13. private_server_ip: private IP address of Ophidia Server node
14. public_server_ip: public IP address of Ophidia Server node
15. nfs_subnet: subnetwork for the Ophidia io-compute nodes (for NFS folder mount)
16. mysql_subnet: subnetwork for MySQL server on the cluster nodes (for database grant)
17. deploy_type: type of deployment ('install', 'configure' or 'complete')
18. node_type: type of node to deploy ('server', 'io' or 'single')
19. user_home: path of the user home directory
20. force_reinstall: flag (false or true) to define if instance should be updated when the role is executed a second time

Dependencies
------------

Requires grycap.nfs and grycap.slurm roles.

Requirements
------------

Requires at least Ansible v2.3.

Example Playbook
----------------

An example of playbook to install and configure the ECAS cluster:

```
- hosts: oph-server
  pre_tasks:
   - name: gather facts from oph-io
     setup:
     delegate_to: "{{ item }}"
     delegate_facts: true
     loop: "{{ groups['oph-io'] }}"

   - name: Creates NFS shared directory
     file: path=/data state=directory owner=root group=root

  roles:
     - { role: 'OphidiaBigData.ophidia-cluster', node_type: 'server', deploy_type: 'complete', server_hostname: "{{ansible_hostname}}", io_hostnames: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_hostname')|list }}", io_ips: "{{ groups['oph-io']|map('extract', hostvars, ['ansible_default_ipv4','address'])|list if 'oph-io' in groups else []}}", private_server_ip: "{{ ansible_default_ipv4.address }}", public_server_ip: "{{ ansible_default_ipv4.address }}", nfs_subnet: 'oph-*', mysql_subnet: 'oph-%'}

- hosts: oph-io
  roles:
     - { role: 'OphidiaBigData.ophidia-cluster', node_type: 'io', deploy_type: 'complete', server_hostname: "{{ hostvars['oph-server']['ansible_hostname'] }}", io_hostnames: "{{ groups['oph-io']|map('extract', hostvars, 'ansible_hostname')|list if 'oph-io' in groups else []}}", io_ips: "{{ groups['oph-io']|map('extract', hostvars, ['ansible_default_ipv4', 'address'])|list if 'oph-io' in groups else []}}", private_server_ip: "{{ hostvars['oph-server']['ansible_default_ipv4']['address'] }}", public_server_ip: "{{ hostvars['oph-server']['ansible_default_ipv4']['address'] }}", nfs_subnet: "oph-*", mysql_subnet: "oph-%" }
```

Further documentation
---------------------

* Ophidia: http://ophidia.cmcc.it
* Installation and configuration: http://ophidia.cmcc.it/documentation/admin/index.html

