Labo réseau automatisé — Ansible, FRRouting & Containerlab

Automatisation de la configuration et du routage dynamique OSPF sur une infrastructure réseau virtualisée, selon une approche NetDevOps.

Ce projet applique les principes d'Infrastructure as Code (IaC) et de NetDevOps à un environnement réseau simulé. Il couvre l'ensemble du cycle : déploiement d'une topologie réseau virtualisée, configuration automatisée du routage dynamique OSPF, vérification de l'état du réseau et sauvegarde des configurations — sans intervention manuelle sur les équipements.

Architecture
router1 ────── router2 ────── router3
              (intermédiaire)

  eth1                eth1  eth2              eth1
192.168.100.10   192.168.100.11  192.168.101.11   192.168.101.12
   └──────── 192.168.100.0/24 ────┘  └──── 192.168.101.0/24 ────┘

Trois routeurs FRRouting, déployés en conteneurs via Containerlab et interconnectés par des liens virtuels, hébergés dans WSL2 (Ubuntu) avec Docker Engine natif.

Stack technique
Composant	Rôle
Containerlab	Déploiement et câblage de la topologie réseau
Docker Engine (natif, WSL2)	Exécution des conteneurs routeurs
FRRouting (FRR)	Système de routage — OSPF
Ansible	Automatisation de la configuration et de la vérification
Jinja2	Génération dynamique des configurations FRR
Structure du dépôt
.
├── Dockerfile                 # Image FRR personnalisée
├── topology.clab.yml          # Définition de la topologie Containerlab
├── inventory.ini              # Inventaire Ansible
├── group_vars/
│   └── all.yml                # Variables communes à tous les routeurs
├── host_vars/
│   ├── router1.yml            # Variables spécifiques : IP, router-id, réseaux OSPF
│   ├── router2.yml
│   └── router3.yml
├── templates/
│   └── frr.conf.j2            # Template Jinja2 de configuration FRR
└── playbooks/
    ├── config.yml             # Génère et déploie la configuration, active OSPF
    ├── verify.yml             # Vérifie l'état du réseau
    └── backup.yml             # Sauvegarde horodatée des configurations
Prérequis
Windows avec WSL2 (Ubuntu), systemd actif
Docker Engine natif installé dans WSL2
Containerlab
Ansible
Installation et utilisation

Déployer la topologie

bash
sudo containerlab deploy -t topology.clab.yml

Déployer la configuration OSPF

bash
ansible-playbook -i inventory.ini playbooks/config.yml

Vérifier l'état du réseau

bash
ansible-playbook -i inventory.ini playbooks/verify.yml

Sauvegarder les configurations

bash
ansible-playbook -i inventory.ini playbooks/backup.yml

Détruire le labo

bash
sudo containerlab destroy -t topology.clab.yml --cleanup
Approche technique

La configuration de chaque routeur est générée dynamiquement à partir d'un template Jinja2 unique combiné aux variables propres à chaque hôte (adresse IP, router-id, réseaux annoncés en OSPF). Ansible déploie ensuite cette configuration et redémarre le service FRR.

Cette approche évite la duplication de fichiers de configuration statiques et permet d'ajouter un routeur au labo par simple ajout d'un fichier de variables, sans modification du template ni des playbooks.

Résultats
Adjacences OSPF Full établies entre les trois routeurs (DR/BDR corrects)
Routes apprises automatiquement de bout en bout (router1 ↔ router3 via router2)
Idempotence validée : une ré-exécution des playbooks ne modifie pas un état déjà conforme
Sauvegarde automatique et horodatée des configurations
Problèmes rencontrés et résolutions
Problème	Résolution
Instabilité de GNS3/QEMU sous Windows (kernel panic, blocages de démarrage)	Migration vers Containerlab, solution conteneurisée plus légère et stable
Erreurs réseau récurrentes avec Docker Desktop (bridge not found) lors du déploiement	Passage à Docker Engine natif sous WSL2
Permission refusée en écriture sur /etc/frr/frr.conf	Ajout de become: true dans les playbooks concernés
Absence de la commande service dans les conteneurs FRR	Utilisation de /usr/lib/frr/frrinit.sh restart
Pistes d'amélioration
Chiffrement des identifiants avec Ansible Vault
Playbook d'audit de conformité avec détection automatique d'écarts
Mise en place de règles de filtrage (ACL) entre sous-réseaux
Extension à un scénario BGP en complément d'OSPF
