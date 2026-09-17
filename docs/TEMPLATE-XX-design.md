# Conception de script - <nom du script>

> Statut : brouillon | revue | approuve | implemente
>
> Auteur : <nom>
>
> Date : <YYYY-MM-DD>
>
> Script cible : `<chemin/vers/script.sh>`

## 1. Contexte et objectif

### Probleme traite

<Decrire la situation operationnelle, son impact et la raison d'etre du script.>

### Objectif mesurable

<Exprimer le resultat attendu et les conditions qui permettent de le constater.>

### Hors perimetre

- <Ce que le script ne doit pas faire>
- <Decision reservee a un humain ou a un autre systeme>

## 2. Contrat d'utilisation

| Element | Definition |
| --- | --- |
| Utilisateur ou automatisation | <qui lance le script> |
| Systeme cible | <OS, distribution, hote, environnement> |
| Commande | `<commande et options>` |
| Entrees | <arguments, fichiers, flux standard, variables> |
| Sorties | <stdout, stderr, fichiers, code de retour> |
| Effets de bord | <modifications, reseau, service, suppression, aucun> |
| Frequence | <manuel, cron, CI, evenement> |

### Exemples d'appel

```bash
# Cas nominal
<commande>

# Cas avec option ou entree representative
<commande> <option> <valeur>
```

## 3. Prerequis et limites

### Dependances

| Dependances | Version ou contrainte | Verification |
| --- | --- | --- |
| Shell | <bash, sh, version> | `<commande>` |
| Outils | <commandes requises> | `<commande>` |
| Acces | <fichiers, reseau, sudo, SSH, API> | <controle> |

### Hypotheses

- <Hypothese sur le systeme, les donnees ou le reseau>
- <Hypothese a valider avant implementation>

### Contraintes

- <Portabilite : Bash uniquement, POSIX sh, distributions cibles>
- <Temps d'execution, volume maximal, disponibilite>
- <Exigences de journalisation ou de conformite>

## 4. Conception

### Deroulement

1. <Valider les arguments, dependances et preconditions.>
2. <Collecter les donnees necessaires.>
3. <Calculer ou appliquer le traitement principal.>
4. <Verifier le resultat.>
5. <Afficher un bilan et retourner le code approprie.>

### Pseudo-code

```text
SI les preconditions ne sont pas satisfaites
  afficher une erreur exploitable
  quitter avec le code <n>
FIN SI

pour chaque <element>
  <traitement>
FIN POUR

verifier <postcondition>
```

### Fichiers et donnees

| Ressource | Lecture/ecriture | Format | Duree de vie | Proprietaire |
| --- | --- | --- | --- | --- |
| <chemin ou source> | <L/E> | <format> | <temporaire/persistant> | <role> |

## 5. Securite et permissions

### Niveau de risque

<Faible, modere ou eleve, avec justification.>

### Droits necessaires

| Action | Cible | Justification | Approbation humaine |
| --- | --- | --- | --- |
| <lecture> | <cible> | <raison> | <oui/non> |
| <ecriture/execution> | <cible> | <raison> | <oui/non> |

### Regles de securite

- Ne jamais afficher de secret, jeton, mot de passe ou cle privee.
- Valider les chemins, arguments et valeurs avant leur emploi.
- Quoter les variables shell et eviter `eval`.
- Limiter les operations destructives a une cible explicite et verifiee.
- <Regle supplementaire propre au script>

### Retour arriere et reprise

<Decrire la marche a suivre apres echec ou une action erronee. Indiquer clairement si aucun rollback n'est possible.>

## 6. Gestion des erreurs et observabilite

### Codes de retour

| Code | Signification | Action de l'operateur |
| --- | --- | --- |
| `0` | Succes | Aucune |
| `<n>` | <erreur connue> | <action> |

### Journalisation

| Evenement | Niveau | Destination | Informations exclues |
| --- | --- | --- | --- |
| Demarrage et parametres valides | INFO | <stdout/fichier/syslog> | secrets |
| Echec de precondition | ERROR | <destination> | secrets |
| <evenement metier> | <niveau> | <destination> | <donnees sensibles> |

## 7. Validation

### Criteres d'acceptation

- [ ] <Critere observable du cas nominal>
- [ ] <Critere pour une entree invalide ou absente>
- [ ] <Critere de non-regression ou d'idempotence>
- [ ] <Critere de securite ou de protection des donnees>

### Strategie de test

| Niveau | Cas | Methode | Resultat attendu |
| --- | --- | --- | --- |
| Syntaxe | <script> | `bash -n <script>` | aucune erreur |
| Lint | <script> | `shellcheck <script>` | alertes corrigees ou justifiees |
| Unitaire | <cas> | Bats | <resultat> |
| Integration | <cible isolee> | <commande> | <resultat> |
| Echec | <condition> | <commande> | code et message attendus |

### Commandes de validation

```bash
bash -n <script>
shellcheck <script>
bats <repertoire-de-tests>
```

## 8. Decisions et revue

### Decisions figees

| Decision | Justification | Alternative ecartee | Consequence |
| --- | --- | --- | --- |
| <decision> | <raison> | <alternative> | <impact> |

### Questions ouvertes

- [ ] <Question, responsable et date cible>

### Approbation

| Role | Nom | Decision | Date |
| --- | --- | --- | --- |
| Exploitation | <nom> | <approuve/refuse> | <date> |
| Securite, si necessaire | <nom> | <approuve/refuse> | <date> |
| Relecteur technique | <nom> | <approuve/refuse> | <date> |
