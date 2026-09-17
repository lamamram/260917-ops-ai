# Gérer le débit & la consommation de tokens avec Claude Code

> Il n'existe pas un outil unique. La gestion se fait en 3 couches :

|Couche|Objectif|Outil principal|
| --- | --- | --- |
|Visibility|Savoir combien on consomme|ccusage + /cost|
|Contrôle contextuel|Réduire les tokens par session|Settings natifs + bonnes pratiques|
|Hard cap / proxy|Plafonner le débit / le budget|LiteLLM / Helicone|

## 1. Visibilité — ce qu'on utilise le plus

### ccusage (le plus populaire dans la communauté)

Lit les logs JSON locaux de Claude Code (~/.claude/projects/) et produit un rapport détaillé :

```bash
# Install
npm install -g ccusage
# ou
bun install -g ccusage

# Usage
ccusage summary                # résumé du jour / semaine / mois
ccusage daily                 # par jour
ccusage model                 # par modèle (haiku / sonnet / opus)
ccusage session               # par session (la plus gourmande ?)
ccusage cost                  # coût estimé en $
ccusage daily --since 2026-01-01   # depuis une date
```

Sortie type :
```text
┌─────────┬──────────┬───────────┬───────────┬────────┐
│ Date    │ Input    │ Output    │ Cache R/W │ Cost $ │
├─────────┼──────────┼───────────┼───────────┼────────┤
│ 07/07  │ 1.2M tok │ 340K tok  │ 45M tok   │  $4.21 │
│ 08/07  │  890K    │  210K     │ 32M tok   │  $3.05 │
└─────────┴──────────┴───────────┴───────────┴────────┘
```

> C'est l'outil de référence pour "combien j'ai dépensé / où ça va".
> Intégré à Claude Code

```bash
# Commandes intégrées à Claude Code
/cost          # tokens + coût de la session courante
/compact       # comprime le contexte (réduit les tokens futurs)
/clear         # reset complet de la conversation
/model         # basculer haiku / sonnet / opus
```

### claude-code-monitor / ccmon

> Dashboard temps réel (local web ou TUI)
> Affiche le contexte utilisé / restant en direct
> Alerte si la session approche de la limite de contexte

```bash
npm install -g ccmon
ccmon          # ouvre un dashboard local
```

## 2. Contrôle contextuel (le plus impactant)

> C'est là qu'on économise le plus, sans proxy :

|Levier|Gain|Comment|
| --- | --- | --- |
|Choisir le bon modèle|×3 à ×15 sur le coût|Haiku pour les tâches simples, Sonnet par défaut, Opus pour le reasoning|
|/compact régulièrement|Évite le gonflement du contexte|À faire quand la conversation dépasse ~50K tokens|
|CLAUDE.md bien fait|Contexte injecté 1× au lieu de 10×|Conventions, exemples, structure → pas besoin de re-rapporter|
|Subagents|Chaque subagent a son propre contexte|Paralleliser = moins de tokens dans le contexte principal|
|--max-turns (automations)|Limite le nombre d'allers-retours|claude --max-turns 10 "prompt"|
|Ne pas recharger les gros fichiers|Un fichier de 5000 lignes = ~12K tokens|Utiliser grep / sections ciblées plutôt que cat|

### Settings dans .claude/settings.json

```json
{
  "model": "sonnet",
  "maxOutputTokens": 8192,
  "autoCompact": true
}
```

> Règle d'or pour un sysadmin

```text
Haiku  → "corrige ce script bash" / "explique cette ligne"
Sonnet → "refactor ce playbook Ansible" / "debug ce pipeline CI"
Opus   → "conçois l'architecture du monitoring" / "review sécurité complète"
```
Chaque montée de modèle coûte 3× à 15× plus cher en tokens.

## 3. Hard cap / Proxy (pour les équipes / budgets stricts)

Si vous voulez un plafond dur (ex. : 50 $/jour max, 100 req/min), il faut passer par un proxy :
LiteLLM (le plus complet, open-source)

```bash
pip install litellm
```

```yaml
# litellm_config.yaml
model_list:
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY

litellm_settings:
  max_budget: 50              # $50/jour (dur)
  max_request_timeout: 60
  num_retries: 2

general_settings:
  master_key: "sk-your-proxy-key"
```

```bash
litellm --config litellm_config.yaml --port 4000
```

* Puis pointer Claude Code vers ce proxy :
```bash
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_API_KEY=sk-your-proxy-key
```

### Alternatives

* Helicone (SaaS, observabilité)

    Dashboard web (replays, coûts, latence)
    Rate limiting + budgets
    Multi-équipes / multi-clés
    pip install helicone ou proxy HTTP

* Portkey AI Gateway

    Similaire à LiteLLM mais SaaS
    Guardrails (blocage de patterns, max tokens par réponse)
    A/B testing de modèles


