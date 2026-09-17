# Kit Claude Code sbx pour Windows 11

Ce kit `sbx` étend l'agent intégré `claude` avec Ansible, OpenSSH, Docker,
les MCP demandés, les plugins Claude Code et une cible Debian 13. La cible est
un conteneur Docker interne démarré en arrière-plan à chaque démarrage du sandbox.

## Prérequis

- Docker Desktop et Docker Sandboxes `sbx` (installation détectée : `v0.39.0`).
- Git et PowerShell 7 ou Windows PowerShell 5.1.
- Un compte Claude Code, ou une credential Anthropic configurée dans `sbx`.

## Démarrage

Depuis PowerShell, à la racine du dépôt :

```powershell
sbx secret set github
sbx secret set gitlab
sbx kit validate .\kit
.\scripts\run-claude-sandbox.ps1
```

`sbx secret set` affiche une saisie masquée et place les PAT dans le Gestionnaire
d'identifiants Windows. Les valeurs ne sont jamais copiées dans le sandbox : les
variables `GITHUB_TOKEN` et `GITLAB_TOKEN` ne contiennent qu'un marqueur que le proxy
sbx remplace à destination des API. Au premier lancement, sbx demande d'approuver
l'injection des credentials pour les domaines déclarés par le kit.

## Plugins et MCP

Les plugins installés par `claude plugin install --scope user` dans
`%USERPROFILE%\.claude\plugins` sont la seule source de vérité. Le lanceur
[scripts/run-claude-sandbox.ps1](scripts/run-claude-sandbox.ps1) lit
`installed_plugins.json`, monte ce répertoire en lecture seule dans le sandbox et
passe chaque version installée à Claude Code avec `--plugin-dir`. Les skills, agents,
commandes, hooks et MCP fournis par ces plugins sont donc chargés sans copie dans le
kit ni modification de `~/.claude/settings.json`, qui est géré par sbx.

Contrôlez la commande construite, sans créer de sandbox, avec :

```powershell
.\scripts\run-claude-sandbox.ps1 -WhatIf
```

Après une installation, mise à jour ou suppression de plugin sur Windows, recréez le
sandbox avec le lanceur pour appliquer l'inventaire courant.

Claude Code découvre automatiquement la configuration MCP à la racine,
[.mcp.json](.mcp.json), pour charger Context7, GitHub, GitLab, `mcp-ssh`,
`mcp-docker`, `mcp-ansible` et `mcp-fs`. Les MCP locaux sont téléchargés à leur
première exécution avec `npx` ou `uvx`.

La cible par défaut utilise `sandbox@127.0.0.1:2222`; sa clé est générée dans le
sandbox à `/home/agent/.ssh/claude-admin-target/id_ed25519`. Le MCP SSH expose cette
cible sous l'alias `target`. `TARGET_HOST`, `TARGET_PORT`, `TARGET_USER` et
`TARGET_PKEY` peuvent être remplacés avec les options `sbx run -e` lors de la création.

## Vérifications

Dans Claude Code, acceptez les MCP du projet puis lancez `/mcp`. Depuis PowerShell,
les vérifications SSH et Ansible sont :

```powershell
sbx exec claude-admin-lab sh -lc 'ssh -p "$TARGET_PORT" -i "$TARGET_PKEY" -o StrictHostKeyChecking=accept-new "$TARGET_USER@$TARGET_HOST" hostname'
sbx exec claude-admin-lab sh -lc 'ansible target -i "$TARGET_HOST," -m ping -u "$TARGET_USER" --private-key "$TARGET_PKEY" -e ansible_port="$TARGET_PORT"'
```

Pour arrêter le sandbox, utilisez `sbx stop claude-admin-lab`; pour le supprimer,
`sbx rm claude-admin-lab`. Recréez-le avec le lanceur après une mise à jour de plugin.

## Sécurité

`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` et
`SUPERPOWERS_DISABLE_TELEMETRY=1` sont activés dans [kit/spec.yaml](kit/spec.yaml).
Le kit applique une liste d'hôtes sortants limitée. Le Docker interne est nécessaire à
`mcp-docker` et à la cible Debian, mais reste isolé dans la VM Docker Sandboxes; il ne
monte pas le socket Docker Desktop Windows.

Le montage des plugins utilisateur est en lecture seule. N'ajoutez pas
`%USERPROFILE%\.claude\settings.json` aux chemins montés : le sandbox gère sa propre
configuration Claude Code et le lanceur utilise explicitement les répertoires de
plugins déclarés dans l'inventaire utilisateur.

Pour un GitLab auto-hébergé, adaptez simultanément `GITLAB_HOST`, le domaine de la
credential `gitlab` et `permissions.network.allow` dans [kit/spec.yaml](kit/spec.yaml)
avant de créer le sandbox.

# Plan de formation Claude Code pour administrateurs

* durée : 2 jours
* public cible : administrateurs système et DevOps

* objectifs
  - Installer et configurer l'assistant IA (1/2j)
  - Organiser le travail admin + IA : boucle proposition, vérification, tests (1/2j)
  - Connaître la sécurité et les bonnes pratiques dans les scripts assistés par IA (1/2j)
  - industrialiser l’IA avec git et les workflows CI/CD (1/2j)


## Installer et configurer l'assistant IA

* Ce que l’IA fait bien : génération de squelette, suggestions, refactoring, documentation
* Ce qu’elle ne doit pas décider seule : sécurité, architecture, opérations sensibles

### Installer et configurer l'assistant

* Préparer l’environnement : IDE, gestion des clés, variables d’environnement, proxy d’entreprise
* Installation de l’extension et vérifications de connectivité
* Paramétrages essentiels : modèles, limites de contexte, préférences de génération, confidentialité
* Organisation du dépôt : structure, fichiers de contexte, READMEs, conventions de nommage

> Atelier fil rouge : installation complète sur poste, configuration projet, ajout d’un fichier de contexte et premier échange “Hello Project” avec l’agent


## Organiser le travail admin + IA : boucle proposition, vérification, tests

* Exemples de tâches type : collecte d’infos, rotation de logs, sauvegardes simples, surveillance de services
* Structurer ses demandes pour obtenir un script exploitable et lisible
* Ajouter des garde-fous : vérifications, messages, codes de retour, logs
* Adapter et franciser les scripts proposés par l’IA pour son contexte

> Atelier pratique : générer et adapter plusieurs scripts Bash pour des tâches récurrentes avec des commandes /slash


### Durcir et relire des scripts existants

* Faire relire un script par l’IA pour identifier fragilités et mauvaises pratiques
* Améliorer la gestion des erreurs, des paramètres, des chemins et des permissions
* Ajouter de la journalisation, des contrôles de cohérence et des messages explicites

>Atelier pratique : créer un agent qualité/sécurité pour construire une version durcie


## Sécurité et bonnes pratiques dans les scripts assistés par IA

* Identifier les patterns dangereux : commandes destructrices, sudo mal utilisé, chemins en dur
* Imposer des règles internes : scripts de prod, validation par revue humaine, tests obligatoires
* Limiter l’exposition de données sensibles lors des échanges avec un moteur IA
* Documenter les scripts générés ou modifiés par l’IA pour assurer leur reprise

> Atelier pratique : établir une check-list de validation pour tout script issu d’une aide IA


## Industrialiser l’usage en équipe

* Modèles de prompts réutilisables et snippets d’équipe
* Standardiser les gabarits de tickets, PR et docs générés par l’agent
* Intégration au workflow Git, CI/CD, qualité et sécurité applicative

> Atelier pratique : créer un répertoire “ia/” partagé avec prompts modèles, scripts d’automatisation et guide d’usage d’équipe