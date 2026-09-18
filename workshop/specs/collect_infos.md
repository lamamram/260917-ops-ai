# Collecteur d'informations projet

Le script explore un dossier, selectionne les fichiers correspondant aux extensions configurees et recherche quelques technologies dans le code dans les instructions d'import.

nom du script : `collect_infos.sh`

## Prerequis

- Bash 4 ou plus recent
- Les commandes `find`, `grep`, `wc` et `sed`

Sous Windows, lancez les commandes depuis Git Bash ou WSL.

## Configuration

Les valeurs par defaut sont definies dans [.env](.env) :

```dotenv
TARGET_DIRECTORY=.
EXTENSIONS=.py,.js,.ts,.tsx,.jsx,.java,.go,.rb,.php,.cs,.sh
```

`TARGET_DIRECTORY` designe le dossier analyse. `EXTENSIONS` est une liste d'extensions separees par des virgules. Les arguments passes au script restent prioritaires sur les valeurs du fichier `.env`.

## Execution

Analyser le dossier configure dans `.env` :

```bash
bash ./collect_infos.sh
```

Analyser un dossier precis :

```bash
bash ./collect_infos.sh /chemin/vers/le/projet
```

Limiter la collecte aux fichiers Python :

```bash
bash ./collect_infos.sh /chemin/vers/le/projet --extensions .py
```

Analyser plusieurs extensions :

```bash
bash ./collect_infos.sh /chemin/vers/le/projet -e .py,.yml,.yaml
```

Afficher l'aide :

```bash
bash ./collect_infos.sh --help
```

## Informations collectees

Le script affiche :

- le dossier et les extensions utilises ;
- le nombre de fichiers examines ;
- le nombre de fichiers sources et leurs lignes cumulees ;
- la liste des fichiers sources trouves ;
- les fichiers correspondant aux technologies detectees.

Les dossiers `.git`, `node_modules`, `.venv`, `venv`, `__pycache__`, `dist`, `build` et `coverage` sont ignores.

## Technologies detectees

Le script recherche motifs associes à des imports de frameworks connus. La detection est basee sur des expressions regulieres simples et peut etre incomplete.

La detection est volontairement simple : elle sert a illustrer une collecte initiale d'informations avant une analyse plus approfondie par Claude Code.

## Exemple de sortie

```text
Project information
===================
Directory: /chemin/vers/le/projet
Extensions: .py,.yml,.yaml
Files examined: 42
Source files found: 18
Source lines: 1260

Detected technologies
---------------------

[FastAPI] 3 file(s)
  - /chemin/vers/le/projet/app/main.py
  - /chemin/vers/le/projet/app/routes.py
  - /chemin/vers/le/projet/requirements.txt
```