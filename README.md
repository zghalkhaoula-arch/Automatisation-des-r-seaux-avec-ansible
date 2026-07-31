# Labo réseau automatisé — Ansible + FRRouting + Containerlab

## Contexte
Labo réseau virtualisé pour automatiser la configuration OSPF de 3 routeurs 
avec Ansible.

## Architecture
router1 -- router2 -- router3
192.168.100.0/24    192.168.101.0/24

## Stack
Containerlab, Docker (WSL2), FRRouting, Ansible (templates Jinja2)

## Utilisation
containerlab deploy -t topology.clab.yml
ansible-playbook -i inventory.ini playbooks/config.yml
ansible-playbook -i inventory.ini playbooks/verify.yml
ansible-playbook -i inventory.ini playbooks/backup.yml

## Résultat
Adjacences OSPF Full établies entre les 3 routeurs, routage dynamique 
fonctionnel, configuration générée dynamiquement via templates Jinja2 
et host_vars.
