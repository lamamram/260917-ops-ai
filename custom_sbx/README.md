# Claude Code avec Docker Compose

Cette variante execute Claude Code et une cible Debian SSH dans un projet Docker
Compose simple. Elle ne monte pas le socket Docker de l'hote et ne fournit pas de
demon Docker au conteneur Claude.

## Demarrage

Depuis la racine du depot, creer le fichier de variables puis indiquer le cache de
plugins installe par Claude Code :

```powershell
Copy-Item .\custom_sbx\.env.example .\custom_sbx\.env
```

Sous Windows, renseigner `CLAUDE_PLUGIN_ROOT=C:/Users/<utilisateur>/.claude/plugins`
dans `custom_sbx/.env`. Sous Ubuntu, utiliser
`CLAUDE_PLUGIN_ROOT=/home/<utilisateur>/.claude/plugins`.

Lancer ensuite Claude Code :

```powershell
docker compose --env-file .\custom_sbx\.env -f .\custom_sbx\docker-compose.yml run --rm claude
```

Sous Ubuntu :

```bash
docker compose --env-file ./custom_sbx/.env -f ./custom_sbx/docker-compose.yml run --rm claude
```

Au premier lancement, connecter Claude Code de maniere interactive. Son etat est
conserve dans le volume `claude-home`. Le cache `~/.claude/plugins` de l'hote est
monte en lecture seule ; l'entrypoint charge tous les plugins de portee `user` de
`installed_plugins.json` avec `--plugin-dir`.

## Architecture

Le service `target` n'est joint qu'au reseau interne `admin`. Claude y accede avec
`sandbox@target:2222` et la cle partagee par le volume `target-ssh-keys`. Aucun port
de la cible SSH n'est publie sur l'hote.

Le conteneur Claude ne peut pas utiliser Docker. Au demarrage, son entrypoint produit
une configuration MCP temporaire a partir du `.mcp.json` du projet, sans
`mcp-docker`, puis lance Claude avec `--strict-mcp-config`. Le fichier projet reste
donc intact pour le parcours `sbx`. Les MCP declares uniquement par des plugins ne
sont pas charges dans cette variante simple.

Le reseau `egress` donne a Claude un acces sortant pour Anthropic et les MCP HTTP.
Docker Compose ne fournit pas
la liste blanche de domaines du kit `sbx`. N'inscrivez dans `.env` que les secrets
necessaires, ne le versionnez pas, et utilisez un proxy d'entreprise ou des regles
reseau Docker pour appliquer une politique de sortie supplementaire.

## Arret et nettoyage

```bash
docker compose --env-file ./custom_sbx/.env -f ./custom_sbx/docker-compose.yml down
docker compose --env-file ./custom_sbx/.env -f ./custom_sbx/docker-compose.yml down -v
```

`down` conserve les volumes et l'authentification Claude. `down -v` supprime l'etat
Claude et la cle de la cible.