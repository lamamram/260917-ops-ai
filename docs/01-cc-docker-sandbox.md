# utiliser un sandbox docker avec claude code

## 1. Installation avec un sandbox docker

![Installation avec un sandbox docker](https://www.docker.com/app/uploads/2026/04/Screenshot-2026-04-09-at-3.23.44-PM-1536x862.png)

### windows

* activer le support de hyperviseur sur Windows 11
  [ici](https://docs.docker.com/ai/sandboxes/install/)

`Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All`

* redémarrer le PC et installer le client sbx avec winget

`winget install -h Docker.sbx`

* se donner un compte sur docker.com et se connecter avec `sbx login` avec tiers de confiance

### linux ubuntu

Prérequis : Ubuntu 24.04 ou ultérieur, processeur 64 bits, virtualisation KVM
activée et prise en charge par la machine. Dans une VM ou un environnement VDI,
la virtualisation imbriquée doit être disponible.

* vérifier que KVM est disponible :

```bash
lsmod | grep kvm
```

La commande doit afficher `kvm_intel`, `kvm_amd`, `kvm_arm64` ou `kvm`. Si elle
ne renvoie rien, utiliser `kvm-ok` pour diagnostiquer le support de KVM.

* ajouter l'utilisateur courant au groupe `kvm` :

```bash
sudo usermod -aG kvm $USER
newgrp kvm
```

La déconnexion/reconnexion est l'alternative à `newgrp kvm`.

* installer Docker Engine et sbx :

```bash
curl -fsSL https://get.docker.com | sudo SBX=1 sh
```

Ou, pour installer uniquement `sbx` sans Docker Engine sur l'hôte :

```bash
curl -fsSL https://get.docker.com | sudo REPO_ONLY=1 sh
sudo apt install docker-sbx
```

* se connecter avec le compte Docker :

```bash
sbx login
```

* lancer le sandbox avec les plugins Claude Code de portée utilisateur :

```bash
bash ./scripts/run-claude-sandbox.sh
```

Le script charge les plugins déclarés dans `~/.claude/plugins/installed_plugins.json`,
monte leur cache en lecture seule et transmet chaque plugin à Claude avec
`--plugin-dir`. Pour contrôler la commande sans créer de sandbox :

```bash
bash ./scripts/run-claude-sandbox.sh --dry-run
```

> Docker ne prend officiellement en charge que Ubuntu, pas ses dérivées telles que Linux Mint ou Pop!_OS, ni même Debian.

## 2. Finalité et fonctionnement

Docker Sandboxes isole Claude Code dans une microVM contrôlée par un hyperviseur.
La microVM possède son propre système de fichiers, ses paquets, son historique
d'agent et son démon Docker. Claude peut donc installer des dépendances, lancer
des conteneurs et exécuter des commandes d'administration sans obtenir l'accès au
démon Docker ni au répertoire personnel de l'hôte.

Un sandbox persiste après la fermeture de Claude Code : les paquets installés, les
images Docker et les fichiers internes sont conservés jusqu'à `sbx rm`. Les fichiers
du workspace principal, eux, sont montés depuis l'hôte en lecture-écriture par
défaut : les modifications de Claude apparaissent donc immédiatement dans le dépôt.
Pour isoler également le dépôt, créer le sandbox avec `--clone` ; Claude travaille
alors dans un clone privé du sandbox.

```bash
sbx run --clone --name claude-admin-lab claude .
sbx ls
sbx exec -it claude-admin-lab bash
sbx stop claude-admin-lab
sbx rm claude-admin-lab
```

Le trafic sortant de la microVM passe par le proxy sbx de l'hôte. Ce proxy applique
la politique réseau du kit et injecte les credentials autorisées sans jamais copier
leur valeur réelle dans la microVM.

### Kit et lanceurs

Le fichier [kit/spec.yaml](../kit/spec.yaml) est un *mixin* : il étend l'agent
Docker intégré `claude`. Il est évalué lors de la création du sandbox par l'option
`--kit`. Les lanceurs [scripts/run-claude-sandbox.ps1](../scripts/run-claude-sandbox.ps1)
et [scripts/run-claude-sandbox.sh](../scripts/run-claude-sandbox.sh) construisent
la commande suivante, adaptée aux chemins Windows ou Ubuntu :

```text
sbx run claude --name claude-admin-lab --kit ./kit <workspace> <plugins>:ro -- --plugin-dir <plugin-actif> ...
```

`<workspace>` est le montage principal accessible en écriture. `<plugins>:ro`
monte `~/.claude/plugins` en lecture seule. Les scripts lisent son inventaire
`installed_plugins.json` et ajoutent un `--plugin-dir` pour chaque plugin de portée
utilisateur : skills, agents, commandes, hooks et MCP de ces plugins sont ainsi
chargés dans la session, sans copier leur cache dans le kit.

| Mécanisme | Déclaration dans le kit ou les scripts | Commande ou option sbx associée |
| --- | --- | --- |
| Agent de base | `requires.agent: claude` | `sbx run claude` |
| Kit hérité | `kind: mixin`, `spec.yaml` | `sbx kit validate ./kit`, puis `sbx run --kit ./kit ...` |
| Montage du dépôt | Premier chemin passé aux scripts | `sbx run claude <workspace>` ; ajouter `:ro` pour un montage lecture seule |
| Montage des plugins | `<plugins>:ro` dans les scripts | chemin supplémentaire `~/.claude/plugins:ro` |
| Fichiers statiques | `kit/files/` est injecté à la création, notamment la cible SSH interne | `sbx run --kit ./kit ...` ; utiliser `sbx cp` pour une copie ponctuelle |
| Commandes d'installation | `setup.install` installe Ansible, SSH, Python et `uv` une fois à la création | recréer le sandbox avec `sbx rm` puis le lanceur pour rejouer l'installation |
| Commandes de démarrage | `setup.startup` génère la clé SSH et démarre la cible Debian à chaque démarrage | `sbx run --name claude-admin-lab` pour redémarrer le sandbox et rejoindre Claude Code |
| Environnement | `environment.variables` fournit les variables de cible et désactive la télémétrie non essentielle | `sbx run -e NOM=valeur` ou `sbx run --env-file fichier.env` pour compléter une session |
| Réseau | `permissions.network.allow` limite les domaines accessibles | `sbx policy log` pour diagnostiquer les connexions et `--deny-network` pour restreindre un sandbox |
| Secrets | `credentials` décrit les en-têtes à injecter par le proxy | `sbx secret set github`, `sbx secret set gitlab`, `sbx secret ls` |
| Publication de port | non définie par le kit actuel | création : `sbx run --publish 8080:3000 ...` ; sandbox existant : `sbx ports claude-admin-lab --publish 8080:3000` |
| MCP fixes | `.mcp.json` à la racine du dépôt est découvert par Claude Code | `sbx run --static-mcp nom-serveur ...` pour fixer un ensemble MCP géré par sbx à la création |

Les options de création, dont `--kit`, `--clone`, `--publish`, `--env`, `--env-file`,
`--static-mcp`, `--memory` et `--cpus`, s'appliquent lors de la première création.
Pour changer les montages, le kit, le mode clone ou la publication initiale d'un
sandbox existant, le supprimer puis le recréer. Pour ajouter un port à un sandbox
existant, employer `sbx ports`.

### Exemples de lancement

Sous Windows, depuis la racine du dépôt :

```powershell
.\scripts\run-claude-sandbox.ps1
.\scripts\run-claude-sandbox.ps1 -WhatIf
```

Sous Ubuntu :

```bash
bash ./scripts/run-claude-sandbox.sh
bash ./scripts/run-claude-sandbox.sh --dry-run
```

Les modes `-WhatIf` et `--dry-run` vérifient l'inventaire local des plugins et
affichent l'action prévue sans créer de microVM.

