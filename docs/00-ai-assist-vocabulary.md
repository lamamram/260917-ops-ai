# Lexique IA pour la programmation

---

## Table des matières

<details>
<summary>Section 1 — Le modèle</summary>

- [IA](#ai)
- [Modèle](#model)
- [Paramètres](#parameters)
- [Entraînement](#training)
- [Inférence](#inference)
- [Effort](#effort)
- [Jeton](#token)
- [Prédiction du jeton suivant](#next-token-prediction)
- [Non-déterminisme](#non-determinism)
- [Fournisseur de modèles](#model-provider)
- [Harnais](#harness)
- [Requête au fournisseur de modèles](#model-provider-request)
- [Jetons d'entrée](#input-tokens)
- [Jetons de sortie](#output-tokens)
- [Cache de préfixe](#prefix-cache)
- [Jetons en cache](#cache-tokens)

</details>

<details>
<summary>Section 2 — Sessions, fenêtres de contexte et tours</summary>

- [Sans état](#stateless)
- [Contexte](#context)
- [Fenêtre de contexte](#context-window)
- [Avec état](#stateful)
- [Agent](#agent)
- [Prompt système](#system-prompt)
- [Session](#session)
- [Tour](#turn)

</details>

<details>
<summary>Section 3 — Outils et environnement</summary>

- [Environnement](#environment)
- [Système de fichiers](#filesystem)
- [Outil](#tool)
- [Appel d'outil](#tool-call)
- [Résultat d'outil](#tool-result)
- [MCP](#mcp)
- [Demande d'autorisation](#permission-request)
- [Mode d'autorisation](#permission-mode)
- [Mode agent](#agent-mode)
- [Bac à sable](#sandbox)

</details>

<details>
<summary>Section 4 — Modes de défaillance</summary>

- [Sycophantie](#sycophancy)
- [Hallucination](#hallucination)
- [Connaissance paramétrique](#parametric-knowledge)
- [Date limite des connaissances](#knowledge-cutoff)
- [Connaissance contextuelle](#contextual-knowledge)
- [Relation d'attention](#attention-relationship)
- [Budget d'attention](#attention-budget)
- [Dégradation de l'attention](#attention-degradation)
- [Zone intelligente](#smart-zone)

</details>

<details>
<summary>Section 5 — Passages de relais</summary>

- [Réinitialisation](#clearing)
- [Passage de relais](#handoff)
- [Source primaire](#primary-source)
- [Source secondaire](#secondary-source)
- [Artefact de transfert](#handoff-artifact)
- [Spécification](#spec)
- [Ticket](#ticket)
- [Compactage](#compaction)
- [Compactage automatique](#autocompact)

</details>

<details>
<summary>Section 6 — Mémoire et pilotage</summary>

- [Système de mémoire](#memory-system)
- [AGENTS.md](#agentsmd)
- [Divulgation progressive](#progressive-disclosure)
- [Pointeur de contexte](#context-pointer)
- [Compétence](#skill)
- [Sous-agent](#subagent)

</details>

<details>
<summary>Section 7 — Modes de travail</summary>

- [Humain dans la boucle](#human-in-the-loop)
- [AFK](#afk)
- [Vérification automatisée](#automated-check)
- [Revue automatisée](#automated-review)
- [Revue humaine](#human-review)
- [Programmation au feeling](#vibe-coding)
- [Concept de conception](#design-concept)
- [Questionnement approfondi](#grilling)
- [Prototypage](#prototyping)
- [DX](#dx)
- [AX](#ax)

</details>

## Section 1 — Le modèle

<a id="ai"></a>
### IA

Une étiquette mouvante, pas une technologie. « IA » ne désigne pas un objet fixe comme le font un [modèle](#model) ou un [jeton](#token) : elle désigne ce que les ordinateurs parviennent nouvellement à faire de manière impressionnante. Aujourd'hui, elle désigne les grands modèles de langage. Elle a désigné des choses très différentes auparavant :

| Époque    | Ce que signifiait « IA »                                                                                          |
| --------- | ------------------------------------------------------------------------------------------------------------------ |
| Années 1950 | Raisonnement symbolique : démonstrateurs de théorèmes, programmes de dames.                                    |
| Années 1960-70 | Programmes symboliques fondés sur des règles : ELIZA, SHRDLU.                                                |
| Années 1980 | Systèmes experts : des milliers de règles si-alors écrites à la main encodant l'expertise humaine.             |
| Années 1990 | Recherche dans un arbre de jeu : Deep Blue bat Kasparov (1997). Les chercheurs évitent complètement le mot « IA ». |
| Années 2000 | Apprentissage automatique statistique : filtres antispam, systèmes de recommandation. Toujours commercialisé comme « machine learning », pas comme « IA ». |
| Années 2010 | Apprentissage profond : reconnaissance d'images (AlexNet, 2012), AlphaGo (2016).                               |
| Années 2020 | Grands modèles de langage : ChatGPT (2022) fait de « IA » le synonyme de chatbots.                              |

Ce pointeur se déplace selon un mécanisme connu, parfois appelé l'effet IA : dès qu'une technique fonctionne de façon fiable, elle est renommée, ce n'est « que » de la recherche, « que » des statistiques, et « IA » glisse vers le prochain problème non résolu. L'observation est ancienne. Bertram Raphael l'a formulée ainsi en 1971 : « L'IA est un nom collectif pour les problèmes que nous ne savons pas encore résoudre correctement par ordinateur. » La version de Larry Tesler, vers 1979 : « L'intelligence est tout ce que les machines n'ont pas encore fait. »

C'est pourquoi les discussions sur l'IA se croisent si souvent sans se rencontrer. Une affirmation telle que « l'IA ne peut pas raisonner » ou « l'IA est surévaluée » porte un horodatage caché : elle peut concerner les systèmes experts, les classifieurs d'images des années 2010 ou le LLM du mois dernier, et chaque référence conduit à une conclusion différente. Lorsqu'une discussion sur l'IA s'enlise, la solution consiste généralement à remplacer le mot par le terme précis visé : le modèle, le [harnais](#harness), l'[agent](#agent), le [contexte](#context) qui lui a été fourni.

_À éviter :_ « IA » dans toute affirmation technique ; nommez plutôt la partie concernée. « Programmation assistée par IA » convient pour désigner la pratique ; « l'IA hallucine » ne convient pas.

_Utilisation :_

« La CTO veut savoir si l'IA pourrait traiter la file de triage. »

« Traduis cela avant d'en définir le périmètre : elle parle d'un LLM dans un harnais ayant accès au système de tickets. “IA” seule n'est pas une spécification. »

<a id="model"></a>
### Modèle

Les [paramètres](#parameters). [Sans état](#stateless), il ne fait que de la [prédiction du jeton suivant](#next-token-prediction). « Claude Opus 4.x » et « GPT-5.x » sont des modèles. À lui seul, un modèle ne peut rien faire d'agentique : il doit être placé dans un [harnais](#harness).

Les modèles ne peuvent ni lire des fichiers, ni exécuter des commandes, ni parcourir le Web, ni se souvenir d'hier : ils reçoivent des [jetons](#token) et en prédisent d'autres, une fois par [requête au fournisseur de modèles](#model-provider-request). Tout ce qui ressemble au travail d'un [agent](#agent), choisir des [outils](#tool), lire des résultats, boucler jusqu'à la fin de la tâche, est le harnais qui orchestre ces nombreuses prédictions successives.

Les [fournisseurs de modèles](#model-provider) proposent des modèles par gammes : un grand modèle, le plus intelligent mais lent et coûteux, et de plus petits, plus rapides et moins chers mais moins capables. Choisir une gamme est une vraie décision : modèle lourd pour la planification et le débogage difficile, modèle léger pour les modifications mécaniques ; les harnais permettent d'en changer au milieu d'une [session](#session).

Employer ce mot avec rigueur affine aussi le diagnostic. « Le modèle est mauvais pour cela » est une affirmation précise : le même modèle, dans un autre harnais ou avec un autre [contexte](#context), se comporte souvent tout autrement. Avant d'accuser le modèle, vérifiez ce qui lui a été fourni : la plupart des sorties décevantes remontent au contexte ou au harnais, pas aux paramètres.

_Utilisation :_

« Devons-nous passer de Sonnet à Opus pour l'étape de planification ? »

« Essaie, mais le harnais fait l'essentiel du travail dans cette tâche. Changer de modèle n'aidera pas si le [prompt système](#system-prompt) et les outils sont mal adaptés. »

<a id="parameters"></a>
### Paramètres

Les nombres qui se trouvent dans un [modèle](#model), souvent par milliards, ajustés pendant l'[entraînement](#training). Tout ce que le modèle « sait » y réside. L'entraînement les définit ; l'[inférence](#inference) les utilise sans les modifier. On les appelle aussi _poids_.

Concrètement, les paramètres transforment l'entrée en sortie. La [prédiction du jeton suivant](#next-token-prediction) est un calcul gigantesque : les [jetons](#token) de la [fenêtre de contexte](#context-window) y entrent, sont multipliés au travers des paramètres, et une prédiction pour le jeton suivant en ressort. Il n'existe ni base de données de faits dans le modèle, ni table de recherche de code : seulement ces nombres, organisés pour que le calcul tende à produire une sortie utile. Les faits que le modèle peut réciter depuis son entraînement, comme une API de bibliothèque standard, sont des [connaissances paramétriques](#parametric-knowledge) : stockés dans les paramètres, sans être récupérés nulle part.

Le détail à retenir est que les paramètres sont figés après l'entraînement. Rien de ce que vous faites dans une [session](#session) ne les modifie : ni une correction, ni un codebase que vous lui montrez, ni une erreur dont il tirerait une leçon. Chaque session repose sur les mêmes nombres. C'est pourquoi le modèle est [sans état](#stateless), pourquoi ses connaissances intégrées s'arrêtent à la [date limite des connaissances](#knowledge-cutoff), et pourquoi tout ce qui est propre au projet doit arriver par le [contexte](#context). La seule façon de modifier les paramètres est de poursuivre l'entraînement, ce qui produit en pratique un modèle différent.

_Utilisation :_

« Peut-on le régler finement sur notre codebase ? »

« Cela modifierait les paramètres, donc le modèle serait différent après. Pour un projet, il est presque toujours moins coûteux de charger le codebase comme contexte que de le réentraîner. »

<a id="training"></a>
### Entraînement

Le processus qui règle les [paramètres](#parameters) d'un [modèle](#model), en l'exposant à d'immenses quantités de texte et en ajustant les paramètres pour améliorer la [prédiction du jeton suivant](#next-token-prediction). C'est un processus unique et coûteux réalisé par le [fournisseur de modèles](#model-provider). Il comprend le pré-entraînement, l'exécution principale, et le post-entraînement, des raffinements ultérieurs tels que le suivi d'instructions et la sûreté ; cette distinction n'a pas d'importance au niveau de ce lexique.

Le mécanisme est une répétition à grande échelle : on montre au modèle un passage de texte, on lui fait prédire le [jeton](#token) suivant, on rapproche les paramètres du jeton qui venait réellement ensuite, puis on répète cela sur des milliers de milliards de jetons. Rien n'est enregistré sous forme de faits ou de règles : tout ce que le modèle « sait » est un effet secondaire de l'amélioration de ses prédictions, compressé dans les paramètres sous forme de [connaissance paramétrique](#parametric-knowledge).

Deux conséquences comptent au quotidien. L'entraînement s'arrête à un moment donné ; le modèle a donc une [date limite des connaissances](#knowledge-cutoff) et n'a pas vu la version de bibliothèque que vous avez mise à jour le mois dernier. De plus, vous ne pouvez pas entraîner le modèle : lorsqu'il ne connaît pas votre codebase, vos conventions ou vos API internes, la solution n'est jamais de « l'enseigner au modèle », mais de placer ce matériau dans le [contexte](#context), la seule entrée que vous contrôlez.

_Utilisation :_

« Peut-on lui faire connaître notre API interne ? »

« Pas par l'entraînement : c'est un processus de plusieurs mois pour le fournisseur de modèles. Chargez plutôt la documentation de l'API dans le contexte ; c'est le levier dont vous disposez réellement. »

<a id="inference"></a>
### Inférence

L'exécution d'un [modèle](#model) entraîné pour générer une sortie : c'est ce qui se produit à chaque [requête au fournisseur de modèles](#model-provider-request). Les [paramètres](#parameters) restent fixes ; le modèle effectue simplement une [prédiction du jeton suivant](#next-token-prediction) sur le [contexte](#context) qui lui est fourni. C'est peu coûteux comparé à l'[entraînement](#training), mais facturé par [jeton](#token) et constitue le coût dominant d'utilisation d'un modèle.

La vie d'un modèle se divise en deux phases :

| Phase | Moment | Ce qu'elle fait | Paramètres |
| ----- | ------ | --------------- | ---------- |
| Entraînement | Une fois, avant la publication | Produit les paramètres à partir d'un corpus d'entraînement | En cours d'écriture |
| Inférence | Chaque fois que quelqu'un utilise le modèle | Exécute les paramètres figés sur votre contexte pour générer des jetons | Lecture seule |

Rien de ce que vous faites lors de l'inférence ne s'écrit dans les paramètres : c'est pourquoi une correction apportée aujourd'hui ne persiste pas demain. Le modèle qui commet la même erreur à la prochaine [session](#session), après que vous avez soigneusement expliqué la solution, ne vous a pas ignoré ; il est incapable d'apprendre de cet échange. Le modèle est [sans état](#stateless) : la continuité doit venir de l'extérieur, de la [fenêtre de contexte](#context-window) ou d'un [système de mémoire](#memory-system).

Ce mécanisme explique aussi votre facturation. Chaque requête exécute le modèle sur le contexte complet ; le coût augmente donc avec les [jetons d'entrée](#input-tokens) et les [jetons de sortie](#output-tokens), et un agent qui effectue des dizaines d'appels d'[outil](#tool) paie l'inférence à chaque aller-retour. C'est pourquoi la taille du contexte est autant une question de coût que de qualité.

_Utilisation :_

« Pourquoi la facture varie-t-elle selon l'utilisation plutôt que d'être une licence forfaitaire ? »

« Vous payez l'inférence : chaque requête au fournisseur de modèles exécute le modèle sur son matériel. L'entraînement a déjà eu lieu, mais les coûts d'inférence s'accumulent par requête, et un seul [tour](#turn) peut se décomposer en de nombreuses requêtes lorsque des outils sont appelés. »

<a id="effort"></a>
### Effort

L'effort est un réglage de la quantité de raisonnement qu'un [modèle](#model) produit avant de répondre. Défini pour chaque [requête au fournisseur de modèles](#model-provider-request), il contrôle la longueur de la réflexion menée par le modèle avant qu'il commence à écrire la réponse visible. Cette réflexion est générée à l'[inférence](#inference), comme le reste ; le [harnais](#harness) la masque souvent, mais le modèle effectue réellement ce travail.

Un effort plus élevé coûte davantage et s'exécute plus lentement. Le raisonnement est émis sous forme de [jetons](#token), facturés comme des [jetons de sortie](#output-tokens) même lorsque vous ne les voyez jamais, et produits un par un. Augmenter l'effort allonge donc l'attente avant la réponse et la facture. Le compromis oppose une réflexion plus poussée à la vitesse et au coût.

La plupart des harnais présentent l'effort comme une petite échelle :

| Niveau | Utilisation |
| ------ | ----------- |
| Faible | Modifications mécaniques, recherches et changements bien spécifiés ayant une seule voie claire. |
| Moyen | Programmation quotidienne, le réglage habituel. |
| Élevé | Bugs délicats, décisions de conception, plans en plusieurs étapes. |
| Maximum | Les problèmes les plus difficiles, pour lesquels une mauvaise réponse coûte cher à défaire. |

Les conséquences d'un mauvais réglage vont dans les deux sens. Avec un effort trop faible sur un problème difficile, vous obtenez une réponse assurée et superficielle qui a omis le raisonnement nécessaire : elle paraît correcte mais s'avère fausse d'une manière coûteuse plus tard. Réglez-le au maximum pour renommer une ligne et vous attendrez une longue réflexion qui n'apporte rien de plus que le niveau minimal.

Adaptez l'effort à la tâche, pas à la [session](#session). Augmentez-le pour la partie réellement difficile à raisonner, puis réduisez-le pour le travail répétitif autour.

_Utilisation :_

« Il échoue sans cesse sur cette correction de concurrence : je l'ai réexpliquée trois fois. »

« Augmente l'effort. C'est un bug qui demande beaucoup de raisonnement et, avec le réglage par défaut, il ne réfléchit pas assez longtemps avant de s'engager dans une approche. »

<a id="token"></a>
### Jeton

L'unité atomique qu'un [modèle](#model) lit et écrit. Sa taille est approximativement celle d'un mot, sans lui être exactement équivalente : les mots courants constituent un jeton, les mots rares ou longs se divisent en plusieurs. La taille de la [fenêtre de contexte](#context-window), le coût et la latence se comptent tous en jetons.

Le texte devient des jetons par un tokenizer : un vocabulaire fixe de dizaines de milliers de fragments, acquis avant l'[entraînement](#training), qui découpe toute entrée en une séquence d'éléments du vocabulaire. Le modèle ne voit jamais les caractères ni les mots : chaque texte est converti en jetons à l'entrée, et la [prédiction du jeton suivant](#next-token-prediction) produit la sortie un jeton à la fois.

En règle générale, un jeton représente environ les trois quarts d'un mot anglais ; mille jetons font donc environ 750 mots. Le code est moins prévisible : les mots-clés et idiomes courants se tokenisent de manière compacte, tandis que les identifiants générés, les hash, les blocs base64 et la sortie minifiée se divisent en beaucoup de jetons par « mot ». Le texte souvent présent dans les données sources du tokenizer reçoit des encodages courts et efficaces ; celui qui n'y figurait pas est découpé en nombreux petits morceaux. Un hash tel que `a3f9c2e1` ne figurait nulle part et se divise donc en plusieurs jetons, tandis que `function` n'en fait qu'un. C'est pourquoi un fichier apparemment petit, rempli de chaînes inhabituelles, peut occuper une part surprenante de la fenêtre de contexte.

Les jetons sont l'unité dans laquelle tout le reste est mesuré. Le coût est calculé par jeton : les fournisseurs facturent séparément les [jetons d'entrée](#input-tokens) et les [jetons de sortie](#output-tokens). La vitesse s'exprime en jetons par seconde puisque la sortie est générée un jeton après l'autre. La fenêtre de contexte contient un nombre fixe de jetons : le nombre de jetons de vos fichiers détermine donc ce qui y tient.

_À éviter :_ « mot » : les frontières des jetons ne correspondent pas à celles des mots, et les unités réellement importantes sont les jetons par seconde et les jetons par dollar.

_Utilisation :_

« Quelle taille aura ce prompt ? »

« Passe-le dans le tokenizer : le schéma est compact, mais les clés JSON sont inhabituelles ; elles se diviseront donc en plus de jetons que tu ne le penses. »

<a id="next-token-prediction"></a>
### Prédiction du jeton suivant

Ce que fait réellement le [modèle](#model). À partir d'un [contexte](#context), il échantillonne le [jeton](#token) suivant, l'ajoute, puis recommence. Toute sortie, une phrase, un [appel d'outil](#tool-call) ou un fichier de mille lignes, est construite un jeton à la fois. Le modèle n'a aucun autre mode de fonctionnement.

Chaque étape fonctionne de la même manière : les jetons de la [fenêtre de contexte](#context-window) passent dans les [paramètres](#parameters), qui produisent une probabilité pour chaque jeton du vocabulaire. L'un est très probablement le suivant, l'autre l'est moins. Un jeton est échantillonné parmi ces probabilités, ajouté, puis la boucle recommence avec un contexte légèrement plus long. Cette étape d'échantillonnage explique pourquoi le même prompt produit des sorties différentes à chaque exécution : le [non-déterminisme](#non-determinism) est inhérent au mécanisme, ce n'est pas un défaut ajouté par-dessus.

Garder ce mécanisme à l'esprit explique des comportements qui paraissent autrement étranges. Le modèle ne vérifie jamais qu'un jeton est _vrai_ avant de l'émettre, seulement qu'il est _probable_, ce qui est à l'origine des [hallucinations](#hallucination). Il s'engage sur chaque jeton au fur et à mesure ; une première phrase qui semble assurée peut donc orienter le reste de la réponse dans une mauvaise direction. Et puisque les [jetons de sortie](#output-tokens) sont produits strictement un par un, la vitesse de génération impose une limite à la rapidité de travail d'un [agent](#agent).

_Utilisation :_

« Comment l'agent “décide”-t-il d'appeler un outil ? »

« Il ne décide pas au sens strict : ce n'est que de la prédiction du jeton suivant. L'appel d'outil est simplement une chaîne structurée que le [harnais](#harness) extrait du flux de sortie. »

<a id="non-determinism"></a>
### Non-déterminisme

La même entrée peut produire des sorties différentes. Exécutez deux fois un [modèle](#model) avec un [contexte](#context) identique et vous pouvez obtenir deux réponses distinctes, parfois un seul mot, parfois une approche complètement différente. Aucun changement de votre code n'est nécessaire pour que cela arrive.

C'est une propriété de la façon dont les modèles génèrent du texte et dont les [fournisseurs de modèles](#model-provider) servent les [requêtes](#model-provider-request). Lors de l'[inférence](#inference), le modèle produit une distribution de probabilités sur les [jetons](#token) suivants possibles, puis l'un d'eux est échantillonné, généralement avec une part de hasard volontaire : toujours choisir le jeton le plus probable produit un texte répétitif et de moins bonne qualité. Un jeton échantillonné différemment au début d'une réponse modifie tous les suivants ; c'est ainsi qu'un mot différent devient une approche complètement différente. L'infrastructure du fournisseur ajoute encore de la variation : les requêtes sont regroupées sur du matériel partagé et d'infimes différences de calcul en virgule flottante entre lots peuvent faire basculer un choix serré entre deux jetons. Aucun réglage ne permet de supprimer entièrement ce phénomène.

Attendez-vous à une dispersion des résultats d'un [agent](#agent) sur une même tâche. La plupart des réponses se situent dans une courbe de qualité raisonnable, ce qui rend le non-déterminisme tolérable, mais les extrêmes sont réels : certains jours le modèle paraît vif, d'autres il semble avoir perdu le fil. Même tâche, tirages différents. Cela a deux conséquences pratiques. Réessayer est une stratégie légitime : un échec est un tirage dans la distribution et une nouvelle tentative peut simplement mieux tomber. La vérification compte aussi davantage qu'avec des outils déterministes : on ne peut pas tester une fois le comportement d'un agent et compter sur sa répétition ; les [vérifications automatisées](#automated-check) doivent intercepter les mauvais tirages.

Évitez toutefois d'en tirer un récit excessif. Les humains repèrent des motifs, et une série de mauvaises exécutions peut sembler prouver que « le modèle s'est dégradé cette semaine ». En général, ce n'est que la distribution.

_Utilisation :_

« Claude a été médiocre aujourd'hui. Ont-ils publié une version moins bonne ? »

« Probablement pas. La sortie du modèle est non déterministe : vous aurez de bons et de mauvais résultats sur une même tâche. Réessayez demain avant de chercher une cause. »

<a id="model-provider"></a>
### Fournisseur de modèles

Tout service qui exécute un [modèle](#model) pour l'[inférence](#inference). Il s'agit généralement d'un service distant (Anthropic, OpenAI, Google), mais il peut aussi être local : Ollama, LM Studio ou llama.cpp exécuté sur votre propre machine. Le [harnais](#harness) n'exécute pas lui-même le modèle ; il le demande à un fournisseur.

Le fournisseur possède l'infrastructure : les [paramètres](#parameters) résident sur son matériel et chaque [requête au fournisseur de modèles](#model-provider-request) consiste pour le harnais à envoyer des [jetons](#token) sur le réseau et à recevoir des prédictions. Il est donc à l'origine de toute une catégorie de problèmes souvent attribués à tort au modèle ou au harnais : limites de débit, capacité dégradée et pannes relèvent tous de lui. Lorsqu'un [agent](#agent) se bloque au milieu d'une [session](#session) ou échoue à chaque [tour](#turn), consultez d'abord la page d'état du fournisseur.

Le fournisseur définit aussi les conditions commerciales : tarification par jeton pour les [entrées](#input-tokens) et les [jetons de sortie](#output-tokens), remises liées au [cache de préfixe](#prefix-cache) et modèles disponibles. Le fournisseur et le créateur du modèle peuvent être des entreprises différentes : Bedrock, Vertex et OpenRouter proposent les modèles d'autres entreprises.

Les fournisseurs locaux échangent de la capacité contre du contrôle : les modèles qui tiennent sur votre matériel sont bien plus petits que les modèles de pointe, mais aucune donnée ne quitte la machine et il n'y a pas de facturation par jeton.

_Utilisation :_

« Peut-on faire fonctionner cela hors ligne pour le client isolé du réseau ? »

« Remplacez le fournisseur de modèles par un fournisseur local, Ollama ou llama.cpp sur sa machine. Le harnais s'en moque : il appelle simplement un autre point de terminaison. »

<a id="harness"></a>
### Harnais

Tout ce qui entoure le [modèle](#model) pour le transformer en [agent](#agent) : [outils](#tool), [prompt système](#system-prompt), gestion de la [fenêtre de contexte](#context-window), autorisations et hooks. **Claude.ai** et **Claude Code** s'appuient sur le même modèle, mais se comportent différemment parce que leurs harnais diffèrent.

Le modèle ne fait lui-même qu'une chose : recevoir du texte et produire du texte. Il ne peut ni lire un fichier, ni exécuter une commande, ni se souvenir du dernier [tour](#turn). Le harnais fournit tout cela. Il assemble le [contexte](#context) de chaque [requête au fournisseur de modèles](#model-provider-request), exécute les [appels d'outil](#tool-call) demandés par le modèle, y réinjecte les [résultats d'outil](#tool-result), conserve l'historique de la [session](#session), vous demande une autorisation avant les actions risquées et décide quand [compacter](#compaction). La boucle de l'agent, le modèle propose, le harnais exécute, puis on recommence, est exécutée par le harnais.

Cela compte pour le diagnostic. Quand le comportement diffère entre deux produits, ou entre hier et aujourd'hui, le modèle n'est souvent pas la variable : c'est le harnais. Un prompt système différent, un autre ensemble d'outils, une autorisation par défaut modifiée ou une nouvelle stratégie de gestion du contexte changent tous le comportement sans modifier le modèle. C'est aussi dans le harnais que réside l'essentiel de votre configuration : les fichiers [AGENTS.md](#agentsmd), les réglages d'autorisation et les hooks sont tous des instructions destinées au harnais, pas au modèle.

Exemples : Claude Code, Cursor, Codex CLI, ainsi que Claude.ai, qui est un harnais de conversation plutôt que de programmation.

_Utilisation :_

« Même modèle : pourquoi Claude Code modifie-t-il les fichiers alors que Claude.ai répond seulement aux questions ? »

« Les harnais sont différents : Claude Code dispose d'outils de [système de fichiers](#filesystem), d'un autre prompt système et d'une couche d'autorisations. Le modèle n'est pas la variable ici. »

<a id="model-provider-request"></a>
### Requête au fournisseur de modèles

Un aller-retour entre le [harnais](#harness) et le [fournisseur de modèles](#model-provider). Le harnais envoie le [contexte](#context) courant ; le fournisseur renvoie une réponse, un [appel d'outil](#tool-call) ou une réponse finale. Un seul message utilisateur peut engendrer de nombreuses requêtes au fournisseur de modèles si l'[agent](#agent) appelle des [outils](#tool) : chaque [résultat d'outil](#tool-result) déclenche une nouvelle requête.

Chaque requête transporte tout : le [prompt système](#system-prompt), la conversation complète jusqu'alors, chaque résultat d'outil. Le [modèle](#model) est [sans état](#stateless), le fournisseur ne conserve donc rien entre les requêtes : la requête quarante renvoie ce qu'avait envoyé la requête trente-neuf, avec un résultat d'outil supplémentaire. Le [cache de préfixe](#prefix-cache) rend cette répétition abordable.

La requête est également l'unité de facturation. Les [jetons d'entrée](#input-tokens), les [jetons de sortie](#output-tokens) et les remises liées au cache sont tous comptés par requête. C'est pourquoi une question apparemment anodine peut coûter étonnamment cher : le coût n'est pas proportionnel à votre message, mais au nombre de requêtes multiplié par la taille du contexte transporté par chacune.

Il est utile de distinguer la requête du [tour](#turn). Un tour est un échange avec vous, et un seul tour, « corrige le test en échec », se déroule sous la forme d'une chaîne de requêtes :

| Requête | Le modèle renvoie                        | Le harnais fait ensuite                         |
| -------- | ---------------------------------------- | ----------------------------------------------- |
| 1        | Appel d'outil : exécuter les tests       | Les exécute et ajoute la sortie de l'échec      |
| 2        | Appel d'outil : lire le fichier de test  | Ajoute le contenu du fichier                    |
| 3        | Appel d'outil : lire le fichier source   | Ajoute le contenu du fichier                    |
| 4        | Appel d'outil : modifier le fichier source | Applique la modification et ajoute le résultat |
| 5        | Appel d'outil : exécuter à nouveau les tests | Les exécute et ajoute la sortie de réussite  |
| 6        | Réponse finale : « corrigé, les tests passent » | Vous l'affiche                            |

Six requêtes pour un seul tour : chacune renvoie le contexte complet. Lorsque vous vous demandez où sont passés les [jetons](#token), comptez les requêtes, pas les tours.

_Utilisation :_

« Une seule question a consommé quarante mille jetons ? »

« Regardez les appels d'outil : douze recherches `grep`, huit lectures, quatre modifications. Chaque résultat d'outil engendre une nouvelle requête au fournisseur de modèles, et le préfixe de la [session](#session) est renvoyé à chaque fois. »

<a id="input-tokens"></a>
### Jetons d'entrée

Les [jetons](#token) que le [harnais](#harness) envoie lors de chaque [requête au fournisseur de modèles](#model-provider-request) : le [prompt système](#system-prompt), l'historique de conversation, les [résultats d'outil](#tool-result), tout ce que le [modèle](#model) lit avant d'écrire. Ils sont facturés à un tarif inférieur à celui des [jetons de sortie](#output-tokens), car ils sont moins coûteux à traiter.

En programmation [IA](#ai), les jetons d'entrée constituent l'essentiel de votre facture. Le modèle est [sans état](#stateless), chaque [tour](#turn) renvoie donc la [session](#session) complète en entrée : votre premier message, chaque réponse et chaque résultat d'outil depuis lors. L'entrée du cinquantième tour contient les quarante-neuf tours précédents. Une seule requête au fournisseur de modèles peut produire quelques centaines de jetons de sortie tout en renvoyant cent mille jetons d'entrée d'historique accumulé.

Le [cache de préfixe](#prefix-cache) réduit ce coût : l'historique qui correspond exactement à une requête précédente est facturé sous forme de [jetons en cache](#cache-tokens), moins onéreux, plutôt qu'au tarif d'entrée complet. Lorsque les coûts d'entrée restent élevés, la solution consiste à réduire ce qui est renvoyé : [réinitialiser](#clearing) ou [compacter](#compaction) entre les tâches.

_Utilisation :_

« La facture est élevée, mais l'[agent](#agent) écrit à peine. »

« Ce sont les jetons d'entrée : chaque tour renvoie la session entière. Sans le cache de préfixe, vous repayez l'historique à chaque requête. »

<a id="output-tokens"></a>
### Jetons de sortie

Les [jetons](#token) générés en retour par le [modèle](#model). Ils sont facturés à un tarif supérieur à celui des [jetons d'entrée](#input-tokens), souvent environ cinq fois plus élevé, car leur production demande davantage de calcul.

Tout ce que le modèle écrit compte : le texte que vous lisez, le code qu'il émet, les [appels d'outil](#tool-call) et toute réflexion approfondie qu'il mène avant de répondre. Ce dernier point surprend souvent : les jetons de raisonnement sont facturés comme de la sortie même lorsque le [harnais](#harness) ne vous les montre pas, et augmenter l'[effort](#effort) en consomme davantage.

Les jetons de sortie déterminent aussi le rythme d'une [session](#session). Le modèle lit les entrées rapidement, mais génère la sortie un jeton à la fois. Lorsqu'un [tour](#turn) paraît lent, c'est donc presque toujours la sortie en cours d'écriture, et non l'entrée en cours de lecture. Une longue attente annonce généralement une longue réponse.

_Utilisation :_

« La session de refactorisation consume du crédit alors que les entrées sont petites. »

« L'agent réécrit des fichiers entiers au lieu d'appliquer des correctifs. Les jetons de sortie coûtent environ cinq fois le tarif des entrées : faites-lui émettre des modifications, et la facture baissera. »

<a id="prefix-cache"></a>
### Cache de préfixe

Le stockage côté [fournisseur](#model-provider) qui permet à des [requêtes au fournisseur de modèles](#model-provider-request) consécutives d'éviter de retraiter un préfixe commun. Lorsque le début d'une requête correspond au début d'une requête récente, même [prompt système](#system-prompt), même historique jusqu'à un certain point, le fournisseur réutilise son travail précédent et facture ces [jetons](#token) comme des [jetons en cache](#cache-tokens), à un tarif bien inférieur.

Le cache est rentable parce que les sessions grandissent par ajouts successifs. Chaque requête renvoie tout l'historique sous forme de [jetons d'entrée](#input-tokens), et dans une [session](#session) normale, l'historique ne change qu'à la fin : chaque requête reprend la précédente en y ajoutant quelques nouveaux messages. Le fournisseur traite une fois le long début commun, stocke le résultat, puis reprend là où le préfixe s'arrête. Sans le cache, une session de cinquante [tours](#turn) paierait cinquante fois le retraitement du premier tour.

Les caches expirent également. La durée pendant laquelle une entrée reste active varie selon le fournisseur de modèles, généralement quelques minutes, pas quelques heures. Si une session reste inactive au-delà de cette durée, la requête suivante reconstruit une fois le préfixe au tarif complet avant que la mise en cache reprenne. Cela concerne surtout les créateurs de [harnais](#harness) ; pour l'utilisateur, l'effet visible est que les requêtes après une longue pause coûtent plus cher que celles qui la précèdent.

_Utilisation :_

« Pourquoi la facture a-t-elle augmenté brusquement au milieu de la session ? »

« Le harnais a commencé à injecter l'heure courante dans le prompt système à chaque tour. Le cache de préfixe se brise au premier jeton modifié, donc chaque requête suivante est facturée au tarif complet. »

<a id="cache-tokens"></a>
### Jetons en cache

Des [jetons d'entrée](#input-tokens) que le [fournisseur](#model-provider) a mis en cache à partir d'une précédente [requête au fournisseur de modèles](#model-provider-request), afin de ne pas avoir à les retraiter. Lorsque des requêtes consécutives partagent un préfixe, le fournisseur réutilise le travail grâce à son [cache de préfixe](#prefix-cache) et facture la partie mise en cache à un tarif bien inférieur. C'est ce qui rend les longues [sessions](#session) abordables : sans cela, chaque [tour](#turn) repaierait tout l'historique.

L'importance de ce mécanisme vient du mode de facturation des sessions. Le [modèle](#model) est [sans état](#stateless), chaque requête renvoie donc toute la conversation, le [prompt système](#system-prompt), chaque message et chaque [résultat d'outil](#tool-result), sous forme de jetons d'entrée. Au cinquantième tour, chaque requête transporte cinquante tours d'historique, qui seraient tous facturés au tarif complet à chaque fois. Le cache change le calcul : les jetons que le fournisseur a déjà traités dans un préfixe identique sont facturés comme jetons en cache, souvent à un dixième du tarif d'entrée, voire moins. Au cours d'une longue session, la plupart des jetons envoyés sont ainsi en cache, et la facture reste raisonnable.

Cet exemple montre quand les jetons sont mis en cache et quand ils ne le sont pas. Chaque lettre représente un bloc de contenu de la conversation ; chaque requête envoie la conversation accumulée :

| La requête envoie | En cache | Facturé au tarif complet | Pourquoi                                             |
| ----------------- | -------- | ------------------------ | ---------------------------------------------------- |
| `AB`              | rien     | `AB`                     | Première requête : aucun élément auquel correspondre |
| `ABC`             | `AB`     | `C`                      | `AB` est un préfixe exact de la requête précédente   |
| `ABCD`            | `ABC`    | `D`                      | Le préfixe est toujours intact                       |
| `AXCD`            | `A`      | `XCD`                    | Une modification a remplacé `B` par `X` ; la correspondance échoue ici |

Le cache est fragile d'une manière précise : il compare des préfixes exacts. Si un élément plus tôt dans la conversation change, si le [harnais](#harness) réorganise le contenu, qu'un horodatage est mis à jour ou que la représentation d'un fichier varie, le cache échoue à partir de ce point et tout ce qui suit est facturé au tarif d'entrée complet. Les caches expirent aussi après quelques minutes d'inactivité : une session reprise après une longue pause repaie une fois son historique. Lorsqu'une session devient coûteuse sans raison apparente, comparez les jetons en cache et les jetons d'entrée dans le rapport d'utilisation : c'est là qu'un cache défaillant apparaît d'abord.

_Utilisation :_

« Le coût des longues sessions est brutal : huit dollars pour une refactorisation. »

« Vérifiez les jetons en cache. Si le harnais réorganise le prompt système ou les fichiers entre les tours, le préfixe est rompu et chaque requête repaie le tarif d'entrée complet. »

## Section 2 — Sessions, fenêtres de contexte et tours

<a id="stateless"></a>
### Sans état

Ne conserve aucune information d'une interaction à l'autre. Le [modèle](#model) est sans état entre les [requêtes au fournisseur de modèles](#model-provider-request) : chaque requête renvoie la [fenêtre de contexte](#context-window) complète, car le modèle ne peut rien voir d'autre. Par défaut, un [agent](#agent) est sans état entre les [sessions](#session) : une nouvelle session commence vide, sans trace des précédentes. Contraire d'[avec état](#stateful).

Le modèle lui-même est en permanence sans état : ses [paramètres](#parameters) sont figés après l'[entraînement](#training), et rien de ce que vous faites à l'[inférence](#inference) ne les modifie. Le modèle n'apprend pas de vos corrections, ne se souvient pas qu'on lui a dit la même chose hier et n'apprend pas à vous connaître, aussi continue que puisse sembler la conversation. La continuité ressentie au sein d'une session est fabriquée par le [harnais](#harness), qui conserve la transcription et la renvoie à chaque requête. Le modèle ne se souvient pas de la conversation, il la relit.

La conséquence pratique est la suivante : si vous souhaitez qu'une information soit mémorisée entre les sessions, vous devez l'écrire quelque part où l'agent la relira. C'est le rôle des fichiers [AGENTS.md](#agentsmd), des [systèmes de mémoire](#memory-system) et des [artefacts de passage de relais](#handoff-artifact) : ils sont chargés dans le [contexte](#context) des sessions futures et remplacent la mémoire dont le modèle est dépourvu. Lorsque l'agent répète une erreur que vous avez déjà corrigée, la question n'est pas pourquoi il n'a pas appris, il ne le peut pas, mais où écrire cette correction pour que toutes les sessions futures la lisent.

_Utilisation :_

« Pourquoi oublie-t-il la convention à chaque [réinitialisation](#clearing) ? »

« Le modèle est sans état : la nouvelle session commence vide. Si vous voulez conserver l'information, écrivez-la dans AGENTS.md ou dans un fichier de mémoire que le harnais charge au début de la session. »

<a id="context"></a>
### Contexte

Les informations pertinentes auxquelles l'[agent](#agent) a accès à un instant donné. C'est un nom abstrait : ni l'entrée brute vue par le modèle, qui est la [fenêtre de contexte](#context-window), ni l'historique en cours, qui est la [session](#session), mais ce que l'agent sait qui est pertinent pour la tâche. « Charger quelque chose dans le contexte » signifie l'ajouter à cet ensemble ; l'« ingénierie de contexte » est la discipline qui consiste à le sélectionner.

Les trois termes se distinguent clairement :

| Terme | Ce qu'il désigne |
| ----- | ---------------- |
| Contexte | Les informations pertinentes pour la tâche dont l'agent dispose actuellement |
| Fenêtre de contexte | La séquence littérale de [jetons](#token) que le modèle voit à chaque requête |
| Session | La conversation en cours que le [harnais](#harness) conserve |

Cette distinction importe parce que le contexte est une mesure de qualité, pas de quantité. Une fenêtre de contexte peut être presque pleine tout en contenant un mauvais contexte, avec des milliers de jetons de résultats d'outil périmés, sans rapport avec la tâche en cours. Elle peut également être presque vide et contenir un excellent contexte : l'unique définition de type dont dépend la tâche.

La plupart des échecs courants remontent au contexte. Lorsque l'agent invente une API, contredit une décision ou devine un schéma, la première question est de savoir ce qui était dans le contexte à ce moment-là. En général, le fait pertinent n'a jamais été chargé ou se trouvait enfoui sous la [dégradation de l'attention](#attention-degradation). La solution consiste à sélectionner : charger ce dont la tâche a besoin et écarter le reste.

_Utilisation :_

« Il continue d'inventer des champs qui n'existent pas dans le type. »

« Le fichier de types n'est pas dans le contexte : il lit les sites d'appel et devine. Commencez par lire la définition. »

<a id="context-window"></a>
### Fenêtre de contexte

Tout ce que le [modèle](#model) voit lors de chaque [requête au fournisseur de modèles](#model-provider-request). Elle est finie, propre à chaque modèle, et constitue la seule surface par laquelle le modèle perçoit quoi que ce soit.

C'est une séquence unique de [jetons](#token) : le [prompt système](#system-prompt), la conversation jusqu'alors et chaque [résultat d'outil](#tool-result) que le [harnais](#harness) a réinjecté. Si un élément se trouve dans cette séquence, le modèle peut l'utiliser ; sinon, il ignore son existence, qu'il s'agisse de votre base de code, du fichier modifié hier ou d'une instruction donnée trois sessions auparavant. Tout ce qui est hors de la fenêtre doit y être introduit, généralement par un [appel d'outil](#tool-call), avant de pouvoir influer sur quoi que ce soit.

Le caractère fini implique qu'elle se remplit. Chaque tour ajoute du contenu, vos messages, les réponses du modèle et les résultats d'outil, et une longue [session](#session) finit par atteindre la limite, imposant une [compaction](#compaction) ou une [réinitialisation](#clearing). Cela signifie aussi que tous les éléments de la fenêtre sont en concurrence : chaque jeton chargé laisse une place de moins au reste, et le contenu inutile occupe malgré tout le [budget d'attention](#attention-budget) du modèle. Considérez donc la fenêtre comme un budget : chargez ce dont la tâche a besoin et laissez le reste de côté.

_À éviter :_ « mémoire » : la fenêtre de contexte est un état de travail et ne persiste pas entre les sessions. La [mémoire](#memory-system) est un concept distinct, ajouté par-dessus.

_Utilisation :_

« Puis-je simplement coller tout le monorepo dans le prompt ? »

« La fenêtre de contexte contient 200 000 jetons, soit peut-être un cinquième du dépôt. Choisissez les fichiers concernés par la tâche et laissez les autres derrière un appel d'outil. »

<a id="stateful"></a>
### Avec état

Conserve des informations d'une interaction à l'autre. Une [session](#session) est avec état entre les [tours](#turn) : le [contexte](#context) s'accumule au fil de son déroulement, ce qui explique que les longues sessions dérivent vers la [zone stupide](#smart-zone). Un [agent](#agent) peut être rendu avec état entre les **sessions** en ajoutant un [système de mémoire](#memory-system) qui inscrit les informations dans l'[environnement](#environment) et les recharge au début des sessions futures. Le [modèle](#model) n'est jamais avec état ; toute continuité apparente provient du [harnais](#harness) qui lui fournit à nouveau le contexte. Contraire de [sans état](#stateless).

Voici où réside l'état à chaque couche :

| Couche | Avec état ? | Comment |
| ------ | ----------- | ------- |
| Modèle | Jamais | Les [paramètres](#parameters) sont figés ; il ne voit que ce qui figure dans chaque requête |
| Session | Entre les tours | Le harnais ajoute chaque message et chaque [résultat d'outil](#tool-result) au contexte |
| Harnais | Entre les sessions | Fichiers de mémoire, [AGENTS.md](#agentsmd), [artefacts de passage de relais](#handoff-artifact), écrits puis rechargés ultérieurement |
| Environnement | Toujours | Les fichiers persistent, qu'une session soit en cours ou non |

L'état de chaque couche est construit en relisant un élément stocké dans la couche inférieure : la session semble continue parce que le harnais renvoie l'historique des messages au modèle sans état, et l'agent se souvient d'une session à l'autre parce que le harnais recharge des fichiers depuis l'environnement. Aucun état n'est jamais stocké dans le modèle lui-même.

L'état n'est pas toujours souhaitable. Tout ce qui est transmis influence la suite ; une hypothèse erronée formulée tôt dans une session est donc elle aussi transmise. La [réinitialisation](#clearing) consiste délibérément à abandonner l'état de la session pour repartir de ce qui a été écrit.

_Utilisation :_

« Il s'est souvenu de mes préférences d'hier : cela signifie-t-il que le modèle les a apprises ? »

« Non, l'agent est avec état parce que le harnais les a écrites dans un fichier de mémoire et l'a rechargé au début de la session. Le modèle lui-même n'a rien vu d'hier. »

<a id="agent"></a>
### Agent

Un [modèle](#model) entouré par un [harnais](#harness), avec des [outils](#tool), un [prompt système](#system-prompt) et une [fenêtre de contexte](#context-window), qui échange des [tours](#turn) avec un utilisateur. _Claude Code est un agent. Cursor est un agent. Claude.ai est un agent._ L'agent est ce à quoi vous parlez réellement : le modèle en action, configuré dans un but précis.

Contrairement à la plupart des termes de ce lexique, « agent » ne désigne pas une pièce mécanique. Le modèle est un fichier de [paramètres](#parameters) ; le harnais est un logiciel que l'on peut configurer. L'agent n'est ni l'un ni l'autre : c'est l'entité à laquelle vous vous adressez. Les humains anthropomorphisent constamment l'[IA](#ai), et l'agent est cette entité anthropomorphisée : ce à quoi vous déléguez une tâche, ce qui lit votre message et répond, le « il » dans « il a encore cassé la compilation ». Dire qu'un agent a fait quelque chose revient à dire que le modèle et le harnais l'ont fait, mais en considérant l'ensemble comme un seul acteur.

L'idée précède la vague actuelle de l'IA. Les agents logiciels, des programmes auxquels vous déléguez un objectif et qui agissent en votre nom, sont un concept aussi ancien que l'IA.

_À éviter :_ « l'IA », « le bot » : ces termes sont trop vagues et ne précisent pas si vous parlez des paramètres ou de l'ensemble formé avec le harnais.

_Utilisation :_

« Quel agent utilises-tu pour la migration ? »

« Claude Code en local, Cursor pour l'interface : même modèle sous-jacent, harnais différents. »

<a id="system-prompt"></a>
### Prompt système

Les instructions que le [harnais](#harness) ajoute au début de chaque [requête au fournisseur de modèles](#model-provider-request) : la feuille de route permanente de l'[agent](#agent), qui précise son identité, son comportement, les [outils](#tool) qu'il peut appeler et les conventions à suivre. Il reste généralement stable pendant une [session](#session).

Le prompt système est écrit par le fournisseur du harnais, non par vous. Dans les harnais de programmation, il est volumineux : souvent des dizaines de milliers de [jetons](#token) de règles de comportement, de descriptions d'outils et de traitement des cas limites, tous facturés comme [jetons d'entrée](#input-tokens) à chaque [tour](#turn). Vos propres instructions permanentes l'accompagnent : des fichiers comme [AGENTS.md](#agentsmd) sont chargés à côté du prompt système au début de la session, de sorte que le [modèle](#model) lit simultanément les consignes du fournisseur et les vôtres avant même de voir votre message.

Comme il est identique dans chaque requête, il constitue le début du [cache de préfixe](#prefix-cache). C'est notamment pour cela que les harnais le maintiennent fixe pendant toute une session plutôt que de le modifier progressivement.

Les modèles sont entraînés à donner priorité au prompt système plutôt qu'aux messages utilisateur. Lorsqu'un agent insiste sur une convention que vous n'avez jamais demandée ou met en forme sa réponse d'une manière impossible à changer, il obéit généralement à son prompt système, et votre message perd la discussion. Certains harnais sont personnalisables : ils donnent accès au prompt système complet, ce qui permet de lire les consignes réellement données à l'agent et de les modifier.

_Utilisation :_

« Deux harnais, le même modèle, un comportement totalement différent avec le même prompt. »

« Leurs prompts système diffèrent. L'un est réglé pour des modifications de code concises, l'autre pour l'explication : la divergence se produit là, avant même l'arrivée de votre message. »

<a id="session"></a>
### Session

Une séquence limitée d'interactions avec un [agent](#agent). Elle commence vide, accumule les messages, les [résultats d'outil](#tool-result) et les fichiers lus, puis s'achève lorsqu'elle est [réinitialisée](#clearing), fermée ou [compactée](#compaction) en une nouvelle session. La session est ce qui remplit la [fenêtre de contexte](#context-window) : si la fenêtre est la boîte, la session est le contenu qui s'y accumule peu à peu. Un travail trop grand pour une seule fenêtre de contexte doit être réparti entre plusieurs sessions.

L'historique des messages d'une session constitue la mémoire de travail de l'agent. Le [modèle](#model) est [sans état](#stateless), donc tout ce dont il semble se souvenir, ce que vous avez demandé, les résultats des tests ou une décision prise trois tours plus tôt, se trouve dans cet historique, renvoyé à chaque [requête au fournisseur de modèles](#model-provider-request). Ce qui n'est pas dans la session n'existe pas pour l'agent.

Cette mémoire s'arrête avec la session. Une nouvelle session recommence sans rien : l'agent qui connaissait très bien votre base de code à la fin de la session d'hier n'en sait plus rien ce matin. Ce qui perdure est le [système de fichiers](#filesystem) : les fichiers écrits durant une session peuvent être lus par la suivante, sur quoi reposent les [passages de relais](#handoff), les [systèmes de mémoire](#memory-system) et [AGENTS.md](#agentsmd).

Vous choisissez où une session s'arrête. Tout ce qu'elle contient influence les [tours](#turn) ultérieurs ; des tâches sans rapport, réalisées dans une même session, laissent donc des résidus qui colorent la réponse suivante. Une tâche par session maintient le contexte pertinent ; terminer une tâche est un moment naturel pour réinitialiser.

_Utilisation :_

« Combien de temps une session peut-elle durer avant de se dégrader ? »

« Cela dépend du travail : une refactorisation ciblée reste nette plus longtemps qu'une recherche ouverte. Quand la session devient trop volumineuse, faites un passage de relais ou compactez-la, n'insistez pas. »

<a id="turn"></a>
### Tour

Un message utilisateur et tout ce que l'[agent](#agent) fait en réponse, jusqu'à ce qu'il vous rende la main. Il contient une ou plusieurs [requêtes au fournisseur de modèles](#model-provider-request), et souvent beaucoup si l'agent appelle des [outils](#tool). Une question de clarification clôt le tour ; votre réponse ouvre le suivant. La hiérarchie est [session](#session) **> Tour > Requête au fournisseur de modèles**.

Ce qui rend utile de nommer le tour est que sa durée dépend de l'agent, non de vous. Vous lui transmettez un message ; il décide combien d'appels d'outil enchaîner avant de rendre la main. Un tour peut être une réponse d'une phrase ou vingt minutes de lecture, de modifications et d'exécution de tests. Cette propriété a deux faces : les longs tours rendent possible le travail [AFK](#afk), mais c'est aussi durant eux que les choses se dégradent sans supervision. Au moment où l'agent vous rend la main, il peut avoir largement dérivé de votre intention.

Le tour est aussi l'unité naturelle de pilotage. Tout ce qui s'y déroule se produit sans vous ; les intervalles entre les tours sont les moments où vous réorientez l'agent. La plupart des [harnais](#harness) atténuent cette séparation : vous pouvez interrompre l'agent en plein tour pour le rediriger, ou écrire un message pendant qu'il travaille, qui sera lu à la fin du tour. Si le résultat des tours vous déplaît régulièrement, la solution consiste généralement à demander des tours plus courts, avec un plan d'abord et une étape à la fois, en échangeant une part d'autonomie contre davantage d'occasions de réorienter.

_Utilisation :_

« Un tour a pris deux minutes ? »

« L'agent a effectué quatorze [appels d'outil](#tool-call) durant ce tour : chacun est une requête distincte au fournisseur de modèles. La latence s'accumule avant qu'il vous rende enfin la main. »

## Section 3 — Outils et environnement

<a id="environment"></a>
### Environnement

Le monde sur lequel agit l'[agent](#agent) : tout ce qui est hors du [harnais](#harness), que l'agent perçoit au moyen des [résultats d'outil](#tool-result) et modifie par des [appels d'outil](#tool-call). Le harnais _exécute_ l'agent ; l'environnement est ce dans quoi l'agent _travaille_. Un fichier comme [AGENTS.md](#agentsmd) vit dans l'environnement ; le harnais le charge dans la [fenêtre de contexte](#context-window). Un [système de fichiers](#filesystem) est la forme d'environnement la plus courante, mais pas la seule : une base de données, une API distante ou une session de navigateur peuvent aussi être des environnements.

L'agent ne voit l'environnement que lorsqu'il l'examine. Tout ce qu'il en sait lui est arrivé par un résultat d'outil ; son image est donc une collection d'instantanés, exacts au moment où ils ont été capturés. Si un fichier change après avoir été lu par l'agent, parce que vous le modifiez à la main ou qu'une étape de compilation le régénère, l'agent continue de raisonner à partir de sa copie périmée jusqu'à ce qu'il le relise. Lorsqu'un agent décrit avec assurance un fichier qui ne ressemble plus à cela, c'est généralement ce qui s'est passé : l'environnement a changé, pas l'instantané.

L'environnement est aussi la couche qui persiste, la seule qui soit toujours [avec état](#stateful). Le contexte d'une [session](#session) disparaît à sa fin, mais les fichiers écrits dans l'environnement restent disponibles pour la session suivante. C'est sur cela que reposent les [systèmes de mémoire](#memory-system), les [artefacts de passage de relais](#handoff-artifact) et `AGENTS.md`. Tout ce qu'un agent devra encore savoir demain doit aboutir dans l'environnement.

Vous décidez de la taille de l'environnement. Un [bac à sable](#sandbox) le réduit en limitant ce que l'agent peut atteindre ; ajouter un [outil](#tool) l'étend en mettant une base de données ou une API à sa portée. Ce qui est à l'intérieur de la frontière est ce que l'agent peut percevoir et modifier ; tout ce qui est à l'extérieur n'existe pas pour lui. La qualité de la préparation de l'environnement pour soutenir le travail de l'agent correspond à l'[AX](#ax) de la base de code.

_À éviter :_ employer « environnement » pour désigner le runtime ou le harnais lui-même : le harnais est l'enveloppe, l'environnement est l'espace de travail.

_Utilisation :_

« L'agent ne voit pas le schéma de la base de données de préproduction. »

« Intégrez-le à l'environnement : donnez-lui un outil `psql` limité à la lecture seule en préproduction. Le harnais est correct ; il n'a simplement rien sur quoi agir. »

<a id="filesystem"></a>
### Système de fichiers

Une arborescence de fichiers et de répertoires que l'[agent](#agent) lit, modifie et dans laquelle il exécute des commandes : la forme d'[environnement](#environment) par défaut d'un agent de programmation. [AGENTS.md](#agentsmd), les [compétences](#skill), le code source, les scripts de compilation et les configurations d'[outils](#tool) résident tous dans un système de fichiers. Lorsqu'un [harnais](#harness) « démarre dans votre projet », il oriente l'agent vers un système de fichiers.

L'agent n'y accède qu'au moyen d'[appels d'outil](#tool-call) : lire ou écrire un fichier, exécuter une commande shell. Rien de ce qui est sur le disque n'entre dans la [fenêtre de contexte](#context-window) avant qu'un appel d'outil ne le charge. C'est ce qui permet à l'agent de travailler dans un dépôt bien plus grand que la fenêtre : le système de fichiers contient tout, tandis que le contexte ne contient que ce que la tâche actuelle a lu. Certains harnais chargent par défaut les noms des fichiers du répertoire courant, mais non leur contenu, dans la fenêtre de contexte. Ils servent alors de [pointeurs de contexte](#context-pointer) : l'agent voit ce qui existe et lit les fichiers nécessaires.

Il est partagé avec vous. Les fichiers modifiés par l'agent sont les mêmes que vous ouvrez dans votre éditeur et comparez avec Git : le système de fichiers est l'espace de travail commun où vous examinez ce que l'agent a fait.

_Utilisation :_

« Pourquoi ne prend-il pas en compte mon AGENTS.md ? »

« Il s'exécute dans un autre système de fichiers : le [bac à sable](#sandbox) a monté le répertoire parent au lieu de la racine du projet. Reconfigurez le harnais. »

<a id="tool"></a>
### Outil

Une fonction que le [harnais](#harness) expose à l'[agent](#agent) : Read, Write, Bash ou Search, par exemple. Les outils permettent à l'agent de percevoir l'[environnement](#environment) et d'y agir : il ne peut le voir qu'au moyen des [résultats d'outil](#tool-result) ni le modifier autrement que par des [appels d'outil](#tool-call). Chaque appel d'outil entraîne une [requête au fournisseur de modèles](#model-provider-request) supplémentaire, car le résultat doit revenir au modèle avant qu'il décide de la suite.

Les outils livrés par la plupart des agents de programmation :

| Outil | Ce qu'il fait |
| ----- | ------------- |
| Read | Renvoie le contenu d'un fichier sous forme de résultat d'outil |
| Write | Crée ou modifie un fichier dans le [système de fichiers](#filesystem) |
| Bash | Exécute une commande shell et renvoie sa sortie |
| Search | Trouve dans la base de code les fichiers ou le texte correspondant à un motif |

Un outil se définit par trois éléments : un nom, une description de son rôle et un schéma de paramètres. Le harnais transmet ces définitions au [modèle](#model) avec chaque requête, et le modèle choisit un outil comme il produit tout le reste : en écrivant des [jetons](#token), ici un appel structuré avec des arguments. Le modèle n'exécute jamais rien lui-même ; le harnais lit l'appel, exécute la fonction et renvoie le résultat.

La liste des outils détermine ce que l'agent peut faire. Un modèle capable disposant d'un jeu d'outils étroit reste un agent limité : il fera tout passer par les moyens dont il dispose, d'où l'usage intensif de Bash par les agents, car un shell est un seul outil qui atteint la majeure partie du système. Pour donner proprement une capacité à un agent, ajoutez-lui un outil ; [MCP](#mcp) est la norme permettant d'intégrer des outils externes au harnais.

Les définitions d'outils occupent du [contexte](#context) à chaque requête ; un ensemble étendu entraîne donc un coût fixe avant le moindre appel, et de nombreux outils aux descriptions similaires rendent le modèle moins apte à choisir le bon.

_Utilisation :_

« L'agent peut-il interroger directement la préproduction ? »

« Ajoutez au harnais un outil `psql` limité à la lecture seule en préproduction. Sans outil adapté, l'agent est aveugle à tout ce qui se trouve hors du système de fichiers. »

<a id="tool-call"></a>
### Appel d'outil

La sortie du [modèle](#model) qui désigne un [outil](#tool) et ses arguments : simplement du texte structuré. Elle ne fait rien par elle-même ; le [harnais](#harness) doit la lire et l'exécuter. Elle est produite par le modèle au cours d'une [requête au fournisseur de modèles](#model-provider-request).

Le cycle de vie d'un appel d'outil :

| Étape | Acteur | Ce qui se produit |
| ----- | ------ | ----------------- |
| 1 | Modèle | Apprend les outils disponibles à partir des descriptions du [prompt système](#system-prompt) |
| 2 | Modèle | Émet un appel, nom de l'outil et arguments, généralement en JSON, puis s'arrête |
| 3 | Harnais | Analyse l'appel et le vérifie selon le [mode d'autorisation](#permission-mode) |
| 4 | Harnais | L'exécute s'il est autorisé |
| 5 | Harnais | Renvoie le résultat comme [résultat d'outil](#tool-result) dans la requête suivante |

Un [tour](#turn) de travail d'[agent](#agent) enchaîne généralement plusieurs de ces allers-retours.

Comme l'appel est produit par [prédiction du jeton suivant](#next-token-prediction), comme toute autre sortie, il peut se tromper de la même façon : chemin inexistant, option que la commande ne connaît pas, arguments plausibles plutôt qu'exacts. Le harnais exécute ce qui a été écrit, non ce qui était voulu : un chemin mal saisi ne provoque pas nécessairement une erreur élégante, il peut modifier le mauvais fichier.

_Utilisation :_

« Il a dit avoir lancé les tests, mais les horodatages des fichiers n'ont pas changé. »

« Regardez la transcription : a-t-il réellement émis un appel d'outil ou s'est-il seulement décrit en train de les lancer ? Le modèle produit l'appel, mais si le harnais ne l'a pas exécuté, rien ne s'est produit. »

<a id="tool-result"></a>
### Résultat d'outil

Ce que le [harnais](#harness) renvoie après l'exécution d'un [appel d'outil](#tool-call) : le contenu d'un fichier, la sortie d'une commande ou une erreur. C'est l'unique vue de l'[agent](#agent) sur l'[environnement](#environment). Le résultat revient au [modèle](#model) dans la [requête au fournisseur de modèles](#model-provider-request) _suivante_, où le modèle décide quoi en faire. L'appel et le résultat d'outil sont les deux extrémités d'un même échange, à l'intérieur d'un [tour](#turn).

Le cycle de vie d'un résultat d'outil :

| Étape | Acteur | Ce qui se produit |
| ----- | ------ | ----------------- |
| 1 | Harnais | Exécute l'appel d'outil : lance la commande ou lit le fichier |
| 2 | Harnais | Capture le résultat : sortie, contenu ou erreur |
| 3 | Harnais | L'ajoute au [contexte](#context) sous forme de message |
| 4 | Harnais | Envoie tout le contexte au fournisseur dans la requête suivante |
| 5 | Modèle | Lit le résultat et choisit un nouvel appel d'outil ou une réponse finale |

Le résultat reste dans le contexte pour le reste de la [session](#session). Les résultats d'outil constituent généralement l'essentiel du contexte d'une session de programmation : chaque fichier lu, chaque test exécuté et chaque recherche y arrivent intégralement et continuent d'occuper des [jetons](#token) longtemps après avoir cessé d'être utiles. Quelques résultats volumineux, un journal de test verbeux ou un fichier généré lu en entier, peuvent rapprocher une session du bord de la [fenêtre de contexte](#context-window) plus vite que la conversation elle-même.

Puisque le résultat est tout ce que voit le modèle, celui-ci ne peut pas vérifier l'environnement qui se trouve derrière. Si la sortie a été tronquée, que la commande a échoué silencieusement ou que le harnais a renvoyé une erreur à la place du contenu, le modèle raisonne à partir de ce qu'il a reçu. Lorsque la représentation de votre système par l'agent paraît erronée, les résultats d'outil sont le premier endroit à examiner : quelque part dans la transcription, un résultat affirme autre chose que ce que vous savez vrai.

_Utilisation :_

« Il raisonne sur le fichier comme s'il était vide. »

« Le résultat d'outil a renvoyé un refus d'autorisation, pas le contenu. Le modèle n'a vu que le message d'erreur ; il n'a aucun autre moyen de voir le fichier. »

<a id="mcp"></a>
### MCP

**Model Context Protocol.** Un protocole qui permet d'intégrer des serveurs d'outils externes à un [harnais](#harness), afin qu'un [agent](#agent) obtienne des [outils](#tool) au-delà de ceux fournis par le harnais. L'agent ne « appelle jamais MCP » : il appelle un outil que le harnais a obtenu d'un serveur MCP. Le protocole expose aussi des ressources, des données en lecture seule, et des prompts, des modèles réutilisables, mais son usage principal est de fournir des outils.

Le protocole résout un problème d'intégration. Sans norme, chaque harnais devrait disposer de sa propre intégration Linear, Slack ou base de données, écrite et maintenue séparément. Avec MCP, l'intégration est écrite une seule fois sous forme de serveur et tout harnais compatible MCP peut l'utiliser. Le harnais se connecte au serveur, le serveur annonce les outils qu'il propose et ces outils deviennent disponibles pour l'agent à côté des outils intégrés.

Le coût se paie en [contexte](#context). Chaque outil annoncé par un serveur arrive avec une définition, nom, description et schéma de paramètres, et le [modèle](#model) ne peut appeler que les outils qu'il connaît. L'approche naïve charge toutes les définitions dans la [fenêtre de contexte](#context-window) dès le départ : installez quelques serveurs généreux, et une [session](#session) commence avec des milliers de [jetons](#token) de schémas d'outils avant même que vous ayez saisi quoi que ce soit, consommant un [budget d'attention](#attention-budget) pour des outils que la tâche n'utilisera jamais.

De nombreux harnais atténuent désormais ce problème avec une recherche d'outils : au lieu des définitions complètes, le contexte contient un [pointeur de contexte](#context-pointer) vers les outils disponibles. L'agent cherche un outil par nom ou par objectif et ne charge sa définition qu'au moment où il en a besoin. Si votre harnais ne le fait pas, le coût initial reste présent ; il est alors préférable de n'activer que les serveurs réellement nécessaires au projet.

_Utilisation :_

« L'agent doit lire les tickets Linear. »

« Configurez le harnais pour utiliser le serveur MCP Linear : il expose l'API Linear comme des outils appelables par l'agent. Vous évitez ainsi d'écrire des adaptateurs d'outils sur mesure. »

<a id="permission-request"></a>
### Demande d'autorisation

Ce que le [harnais](#harness) montre à l'utilisateur avant d'exécuter un [appel d'outil](#tool-call) qui n'est pas préapprouvé. Le [modèle](#model) produit un appel d'outil ; au lieu de l'exécuter immédiatement, le harnais se met en pause et demande une décision. En cas d'approbation, l'appel est exécuté ; en cas de refus, le harnais rapporte le refus au modèle sous forme de [résultat d'outil](#tool-result). C'est le mécanisme par lequel un harnais place un humain dans la [boucle](#human-in-the-loop) pour les actions risquées ou sensibles.

Le cycle de vie d'une demande d'autorisation :

| Étape | Acteur | Ce qui se produit |
| ----- | ------ | ----------------- |
| 1 | Modèle | Produit un appel d'outil |
| 2 | Harnais | Le vérifie selon le [mode d'autorisation](#permission-mode) et les approbations enregistrées |
| 3 | Harnais | S'il est préapprouvé, l'exécute immédiatement ; sinon, se met en pause et affiche la demande |
| 4 | Utilisateur | Approuve une fois, approuve pour le reste de la [session](#session) ou refuse |
| 5 | Harnais | Exécute l'appel ou renvoie le refus comme résultat d'outil |

Refuser une demande permet de réorienter l'agent. Le modèle lit le refus comme n'importe quel autre résultat d'outil et réagit : il essaie une autre approche ou demande ce que vous préférez. La plupart des harnais permettent d'ajouter un message au refus, ce qui transforme la demande en point de pilotage : « pas comme ça, utilise plutôt le script de migration » arrive précisément au moment où le modèle décide de la suite.

Le coût est que chaque demande impose une attente synchrone de votre part. L'[agent](#agent) reste bloqué jusqu'à votre réponse, ce qui est acceptable tant que vous le surveillez et problématique lorsque ce n'est pas le cas. Un agent qui déclenche constamment des demandes ne peut pas être laissé à travailler [AFK](#afk). Le mode d'autorisation sert de réglage : quels appels sont libres, lesquels demandent d'abord une décision, idéalement avec un [bac à sable](#sandbox) qui rend plus sûre l'extension des appels libres.

_Utilisation :_

« Il est bloqué sur une demande d'autorisation depuis dix minutes : j'étais en réunion. »

« C'est le coût de l'humain dans la boucle. Préapprouvez les [outils](#tool) sûrs pour que la demande ne se déclenche que pour les appels réellement risqués. »

<a id="permission-mode"></a>
### Mode d'autorisation

La composante de contrôle des autorisations d'un [mode agent](#agent-mode) : elle détermine quels [appels d'outil](#tool-call) déclenchent une [demande d'autorisation](#permission-request) et lesquels s'exécutent automatiquement. C'était l'objectif originel des systèmes de modes avant que les [harnais](#harness) y ajoutent des instructions de comportement.

Les harnais proposent une échelle de ces modes :

| Mode | Lectures | Écritures et shell | Usage typique |
| ---- | -------- | ------------------ | ------------- |
| Lecture seule / plan | Automatiques | Bloquées | Recherche, planification, revue |
| Par défaut | Automatiques | Demandent une autorisation | Travail quotidien supervisé |
| Modification automatique | Automatiques | Modifications automatiques, shell sur demande | Dépôts fiables, changements mécaniques |
| « Yolo » / entièrement automatique | Automatiques | Automatiques | [Bacs à sable](#sandbox), exécutions [AFK](#afk) |

Choisir un niveau implique un compromis entre sécurité et interruptions, et les deux extrêmes ont un coût. Trop restrictif, vous devenez le goulot d'étranglement : l'[agent](#agent) s'arrête toutes les quelques secondes pour des lectures inoffensives, vous cliquez sur approuver machinalement et les approbations perdent tout leur sens. L'approbation automatique systématique cumule les défauts : toutes les interruptions sans aucune protection. Trop permissif, l'agent modifie des fichiers et exécute des commandes que vous auriez voulu examiner d'abord.

Le réglage permissif se défend surtout dans un bac à sable, où le rayon d'action d'un mauvais appel d'[outil](#tool) est contenu. Hors de ce cadre, la plupart des personnes approuvent automatiquement les lectures et maintiennent un [humain dans la boucle](#human-in-the-loop) pour tout ce qui est irréversible.

_Utilisation :_

« Il s'est arrêté sur chaque recherche `grep` : l'exécution AFK a été complètement gâchée. »

« Assouplissez le mode d'autorisation pour les outils en lecture seule, mais continuez à demander une confirmation pour les écritures et le shell. Dans une [session](#session) de recherche, la plupart des demandes d'autorisation sont du bruit. »

<a id="agent-mode"></a>
### Mode agent

Un préréglage qui définit le fonctionnement de l'[agent](#agent) à l'exécution : il associe un [mode d'autorisation](#permission-mode) à des instructions de comportement injectées dans le [prompt système](#system-prompt). Par exemple : un mode par défaut qui demande une confirmation pour les appels risqués, un **mode plan** qui bloque les modifications et oriente l'agent vers la recherche, un mode **accepter les modifications** qui les préapprouve, ou un mode **contourner les autorisations** appelé couramment **mode YOLO**, qui préapprouve tout. Il peut changer au cours d'une [session](#session).

Cette association distingue un mode d'un simple réglage d'autorisation. Un mode d'autorisation n'est qu'une barrière : il décide quels [appels d'outil](#tool-call) passent. Une barrière seule produit un agent qui souhaite modifier mais ne le peut pas : il propose l'écriture, est bloqué, puis essaie autrement. Les instructions injectées suppriment cette intention : le mode plan ne se contente pas de bloquer les modifications, il indique à l'agent qu'il est en phase de planification afin qu'il lise, pose des questions et propose une approche plutôt que de lutter contre la barrière. La barrière et l'orientation vont dans le même sens.

En pratique, vous changez de mode à mesure que votre confiance évolue au cours de la tâche. Une même tâche peut traverser plusieurs modes : le mode plan pendant que l'approche prend forme, le mode par défaut avec confirmation pour les premières modifications délicates, l'acceptation des modifications lorsque l'agent a montré qu'il comprend le changement, puis le contournement lors d'une exécution [AFK](#afk) dans un [bac à sable](#sandbox). Changer de mode ne coûte rien : la conversation continue exactement où elle en était, avec de nouvelles autorisations et instructions. Si vous approuvez chaque demande sans la lire, le mode est plus restrictif que votre confiance réelle ; si vous refusez constamment des modifications, il est trop permissif.

_Termes des fournisseurs :_ Claude Code appelle cela des « modes d'autorisation », Codex des « modes d'approbation » ; les deux expressions sont antérieures à l'ajout des consignes de comportement.

_Utilisation :_

« Il continue de modifier des fichiers alors que je veux seulement un plan. »

« Passez au mode plan : il bloquera les écritures et restera dans la recherche. »

« Et pour l'exécution AFK plus tard ? »

« Le mode contournement, mais uniquement dans le bac à sable. »

<a id="sandbox"></a>
### Bac à sable

Un [environnement](#environment) isolé dans lequel s'exécute l'[agent](#agent) : conteneur, machine virtuelle, [système de fichiers](#filesystem) éphémère ou shell aux autorisations restreintes. Il limite le rayon d'action des actes de l'agent : même s'il exécute des commandes destructrices ou récupère un contenu malveillant, les dégâts restent contenus. C'est le socle de sécurité qui rend le travail [AFK](#afk) praticable.

Le bac à sable et le [mode d'autorisation](#permission-mode) résolvent le même problème par deux voies opposées. Les autorisations demandent une décision avant l'exécution d'une action ; le bac à sable limite ce que l'action peut atteindre si elle est exécutée. Les autorisations vous imposent de rester dans la [boucle](#human-in-the-loop), chaque demande est une interruption, et une session qui en demande constamment n'est presque plus autonome. Un bac à sable mobilise de l'infrastructure plutôt que votre attention : plus l'isolation est forte, moins il faut poser de questions.

L'isolation se décline en plusieurs niveaux :

| Niveau | Ce que c'est | Ce que cela contient |
| ------ | ------------ | -------------------- |
| Shell restreint | Confinement au niveau du système d'exploitation autour de chaque commande | Écritures hors du projet, accès réseau |
| Conteneur | Système de fichiers neuf, sans identifiants montés, détruit ensuite | Tout ce que l'agent fait sur sa propre machine |
| VM / cloud | Machine entièrement séparée, souvent fournie par le harnais | Tout, y compris les sorties au niveau du noyau |

Ce qu'aucun bac à sable ne contient : les actions qui en sortent légitimement. Un agent doté de vos identifiants Git peut pousser du code ; un agent qui a accès au réseau peut appeler des API de production. Décidez ce qui franchit la frontière avant de choisir son niveau d'étanchéité.

_Utilisation :_

« Je veux le laisser s'exécuter toute la nuit en [contournant les autorisations](#agent-mode), mais je ne suis pas encore prêt à cela. »

« Placez-le dans un bac à sable : conteneur neuf, aucun identifiant monté, aucune sortie réseau. Au pire, il détruit son propre système de fichiers et vous jetez le conteneur. »

## Section 4 — Modes de défaillance

<a id="sycophancy"></a>
### Sycophantie

Une sortie de [modèle](#model) qui acquiesce avec assurance. Elle provient de l'[entraînement](#training) : le modèle a été façonné pour privilégier les réponses appréciées par les humains, et les humains préfèrent souvent l'accord au fait qu'on leur dise qu'ils ont tort. Le modèle a donc appris que l'approbation est récompensée, même lorsqu'elle est incorrecte.

_Se manifeste par :_

- _Céder face à une objection_ : abandonne une réponse correcte lorsque vous demandez « êtes-vous sûr ? ».
- _Faire l'éloge d'une mauvaise proposition_ : déclare votre plan défaillant excellent avant de l'analyser.
- _Cadrage biaisé_ : une revue devient positive lorsque vous indiquez en être l'auteur, négative lorsque vous dites que quelqu'un d'autre l'a écrite. Même artefact, verdict différent.
- _Mimétisme_ : répète vos erreurs pour vous les présenter comme une confirmation.

_Test de diagnostic :_ le modèle aurait-il dit cela sans votre influence ? Si seul votre ton ou votre cadrage a changé, il s'agit de sycophantie, non d'un véritable changement d'analyse.

_Correction :_ cachez vos préférences. Formulez les prompts de façon neutre : « examine ce code » plutôt que « ce code est-il bon ? ».

_À éviter :_ employer « sycophantie » pour toute mauvaise réponse qui vous plaît. Sans le test de diagnostic, ce terme n'a pas plus de valeur que « faux ».

_Utilisation :_

« Il a dit que mon plan de refactorisation était excellent, puis j'ai demandé “êtes-vous sûr ?” et il a entièrement changé d'avis. »

« C'est de la sycophantie classique : il a d'abord approuvé parce que vous paraissiez sûr de vous, puis il a cédé parce que vous sembliez douter. La qualité du plan n'a pas changé, seulement votre ton. [Réinitialisez](#clearing) et reposez la question sans orienter la réponse. »

<a id="hallucination"></a>
### Hallucination

Une sortie de [modèle](#model) assurée mais erronée. Elle prend deux formes aux causes et aux corrections différentes :

| Forme | Ce qui échoue | Cause | Correction |
| ----- | ------------- | ----- | ---------- |
| _Exactitude factuelle_ | Faits inventés ou faux sur le monde : fonction inexistante, signature d'API erronée, citation fictive | Lacunes de [connaissance paramétrique](#parametric-knowledge), souvent au-delà de la [date limite des connaissances](#knowledge-cutoff) | Charger la bonne [connaissance contextuelle](#contextual-knowledge) |
| _Fidélité_ | La sortie dérive des connaissances contextuelles chargées, des instructions utilisateur ou du raisonnement antérieur du modèle | [Dégradation de l'attention](#attention-degradation), aggravée dans la [zone stupide](#smart-zone) | [Réinitialiser](#clearing) ou [compacter](#compaction) |

La [prédiction du jeton suivant](#next-token-prediction) produit un texte fluide, que le fait sous-jacent soit réel ou non. Le modèle ne dispose d'aucun signal interne lui indiquant qu'il ignore quelque chose ; une méthode inventée est donc formulée avec la même assurance qu'une méthode correcte. Le code halluciné est plausible par construction : c'est l'apparence qu'aurait l'API si elle existait, ce qui lui permet de passer une revue superficielle et de n'échouer qu'à l'exécution.

Il faut déterminer quelle forme est en cause, car la correction de l'une aggrave l'autre. Un problème d'exactitude indique une connaissance manquante : il faut ajouter du contexte, la documentation, les définitions de types ou le fichier. Un problème de fidélité indique que la connaissance est présente mais perd la concurrence de l'attention : il faut retirer du contexte. Diagnostiquer la fidélité comme un problème d'exactitude conduit à coller davantage de documentation, ce qui augmente le contexte et aggrave la dérive. Lorsqu'un agent se trompe, vérifiez d'abord si l'information correcte était déjà dans le contexte.

_À éviter :_ employer « hallucination » comme simple synonyme de « faux ». Sans préciser la forme, le terme n'a aucune valeur de diagnostic.

_Utilisation :_

« Il a halluciné une méthode `parseAsync` sur le schéma. »

« Problème d'exactitude ou de fidélité ? »

« La méthode figure dans la documentation que j'ai collée, mais il a cessé de la lire après le quarantième [tour](#turn). »

« C'est donc un problème de fidélité. Compactez et rechargez, n'ajoutez pas davantage de documentation. »

<a id="parametric-knowledge"></a>
### Connaissance paramétrique

Ce que le [modèle](#model) « sait » grâce à l'[entraînement](#training), stocké dans ses [paramètres](#parameters). Cette connaissance est figée lors de l'entraînement : le modèle ne peut ni voir ses propres paramètres ni les mettre à jour. Les détails se perdent dans la compression : des milliards de faits sont condensés dans un nombre fixe de paramètres et les faits rares deviennent flous. Elle explique la fluidité sur les sujets courants et les inventions sur les sujets peu fréquents. C'est le pendant de la [connaissance contextuelle](#contextual-knowledge).

La connaissance paramétrique n'est pas stockée sous forme de faits. L'entraînement ne donne jamais au modèle une base de données dans laquelle chercher ; il ajuste les paramètres jusqu'à ce que le modèle prédise bien le texte, et un modèle qui prédit bien le texte d'un sujet se comporte comme s'il connaissait ce sujet. La fiabilité dépend de la fréquence d'apparition dans les données d'entraînement : un sujet avec des millions d'exemples est reproduit correctement, tandis que pour un sujet avec seulement quelques exemples, le modèle devine à partir de l'apparence de sujets similaires. Reproduire et deviner sont le même processus pour le modèle, qui ne peut pas savoir lequel il effectue. Une réponse inventée est aussi fluide qu'une réponse correcte. Une [hallucination](#hallucination) est simplement une erreur de devinette du modèle.

La connaissance paramétrique vieillit également. Les paramètres cessent de changer à la [date limite des connaissances](#knowledge-cutoff) ; une bibliothèque publiée ou renommée après cette date n'y existe donc pas et une API modifiée y est mémorisée sous son ancienne forme.

Pour les deux lacunes, trop rare ou trop récent, la correction est la même : la connaissance ne peut pas être ajoutée aux paramètres et doit être fournie sous forme de connaissance contextuelle.

_Utilisation :_

« Il écrit du React impeccable, mais invente des méthodes sur notre SDK interne. »

« React est très présent dans la connaissance paramétrique, avec des millions d'exemples d'entraînement. Votre SDK ne l'est pas ; le modèle complète donc avec des structures plausibles. Chargez la documentation du SDK dans le [contexte](#context). »

<a id="knowledge-cutoff"></a>
### Date limite des connaissances

La date au-delà de laquelle un [modèle](#model) ne possède plus de [connaissance paramétrique](#parametric-knowledge). Les bibliothèques, API et événements postérieurs à cette limite sont propices aux inventions, à moins que leur documentation ne soit chargée comme [connaissance contextuelle](#contextual-knowledge). Chaque version d'un modèle possède sa propre date limite.

Cette limite existe du fait de la fabrication des modèles : l'[entraînement](#training) incorpore un instantané de texte dans les [paramètres](#parameters) du modèle, qui restent ensuite figés. Le modèle ne sait pas que ses connaissances ont une frontière : interrogé sur un élément postérieur, il ne refuse pas, il extrapole depuis l'élément le plus proche qu'il connaît. C'est ce qui rend le piège discret : un code écrit pour une ancienne version d'une bibliothèque paraît plausible, compile souvent et échoue dans les parties qui ont changé.

La correction est toujours la même : placer l'information actuelle dans le [contexte](#context). Chargez le journal des modifications, indiquez les définitions de types de la version installée ou faites lire la documentation web à l'agent. Toute information présente dans le contexte l'emporte sur l'absence d'information dans les paramètres.

_Utilisation :_

« Il continue d'écrire la syntaxe du SDK v3, alors que nous utilisons la v5. »

« La v5 est sortie après la date limite des connaissances. Chargez son journal des modifications comme connaissance contextuelle, sinon il continuera d'inventer à partir de la version paramétrique plus ancienne. »

<a id="contextual-knowledge"></a>
### Connaissance contextuelle

Les faits que l'[agent](#agent) peut lire directement dans le [contexte](#context) à cet instant : la tâche de l'utilisateur, les fichiers lus par l'agent, les [résultats d'outil](#tool-result) et le contenu d'[AGENTS.md](#agentsmd) chargé au début de la [session](#session). C'est le pendant de la [connaissance paramétrique](#parametric-knowledge) : la première est _rappelée_ depuis les paramètres, la seconde est _lue_ dans la [fenêtre](#context-window). Les [hallucinations](#hallucination) sont bien moins fréquentes lorsque l'agent travaille à partir de connaissances contextuelles : la réponse se trouve devant lui, au lieu d'être extraite d'un souvenir flou.

Parmi les deux formes de connaissance, seule la connaissance contextuelle est sous votre contrôle. Les paramètres sont figés ; l'unique moyen de donner au [modèle](#model) une information qui lui manque, SDK interne, bibliothèque sortie après la [date limite des connaissances](#knowledge-cutoff) ou décision prise hier, est de la placer dans le contexte. Une grande part du travail pratique de programmation avec l'[IA](#ai) revient à mettre les bons faits devant le modèle au moment où il en a besoin.

Lorsque connaissance contextuelle et connaissance paramétrique se contredisent, la première l'emporte généralement. Collez la documentation actuelle d'une API et le modèle la suivra plutôt que son souvenir périmé de l'ancienne API, même si cette ancienne version peut encore ressurgir, surtout au cœur d'une longue session. Si l'agent revient constamment à un motif obsolète malgré le chargement de la documentation, la connaissance paramétrique déborde sur la contextuelle ; répéter la correction ou la rapprocher du travail aide.

À la différence de la connaissance paramétrique, la connaissance contextuelle a un coût d'utilisation. Tout ce qui est chargé dans la fenêtre consomme des [jetons](#token) et entre en concurrence pour le [budget d'attention](#attention-budget) du modèle ; charger davantage n'est donc pas automatiquement meilleur. L'objectif est de placer les faits pertinents dans la fenêtre, non tous les faits.

_Employez ce terme_ uniquement pour le distinguer de la connaissance paramétrique ; sinon, dites simplement **contexte**.

_À éviter :_ « mémoire de travail » : la connaissance contextuelle est ce qui se trouve dans la fenêtre _maintenant_, tandis qu'un [système de mémoire](#memory-system) y place le contenu qui traverse les sessions. Les échelles sont différentes ; ne les confondez pas.

_Utilisation :_

« Pourquoi maîtrise-t-il l'API quand je colle la documentation et l'invente-t-il quand je ne le fais pas ? »

« Avec la documentation, il s'agit de connaissance contextuelle : il lit la réponse. Sans elle, il s'appuie sur la connaissance paramétrique, et les points de terminaison rares deviennent flous. »

<a id="attention-relationship"></a>
### Relation d'attention

Lorsqu'il prédit chaque [jeton](#token), le [modèle](#model) prend en compte tous les autres jetons du [contexte](#context), certains fortement, d'autres à peine. Le couplage entre deux jetons est une **relation d'attention** ; les paires significatives, comme « elle » et « Sarah » ou un appel `getUser()` et la définition `function getUser`, s'influencent davantage que les paires sans rapport. Un contexte de N jetons comporte de l'ordre de N² relations.

Ces couplages sont le lieu de la compréhension apparente du modèle. Lorsqu'il résout un pronom, c'est parce que la relation d'attention entre « elle » et « Sarah » est forte. Lorsqu'il appelle une fonction avec les bons arguments, la relation entre le site d'appel et la définition lue auparavant effectue le travail. Rien n'est recherché : tout est calculé à nouveau, pour chaque paire, dans chaque [requête au fournisseur de modèles](#model-provider-request).

La valeur N² mérite attention, car elle croît plus vite que ne le suggère l'intuition :

| Taille du contexte | Couplages (~N²) |
| ------------------ | --------------- |
| 1 000 jetons | ~1 million |
| 10 000 jetons | ~100 millions |
| 100 000 jetons | ~10 milliards |

Chaque couplage est calculé plus d'une fois. Les modèles possèdent plusieurs têtes d'attention, dont le nombre exact pour les modèles de pointe n'est pas publié, mais dont une estimation de cinquante à cent est raisonnable ; chaque tête calcule sa propre version de chaque relation. Chaque couplage du tableau précédent est donc dupliqué dans chaque tête. Cela représente beaucoup de couplages.

Seul un petit nombre de ces relations compte pour une tâche donnée. La relation entre votre instruction et le code qu'elle régit fait partie de celles qui importent ; presque tout le reste du bassin est du bruit. Or les deux ensembles ne croissent pas au même rythme : les relations importantes restent à peu près constantes, tandis que le volume total augmente quadratiquement avec la taille du contexte. Avec 1 000 jetons, la relation qui vous importe est une parmi un million ; avec 100 000 jetons, une parmi dix milliards. C'est l'arithmétique sous-jacente au [budget d'attention](#attention-budget), et la [dégradation de l'attention](#attention-degradation) est ce qui se produit lorsque les relations importantes reçoivent une part trop faible.

_Utilisation :_

« Il confond constamment les deux symboles `user` dans le diff : on dirait que nous sommes dans la [zone stupide](#smart-zone). »

« Oui, la relation d'attention entre chaque site d'appel et sa déclaration est en concurrence avec l'autre : même forme de jeton, liaisons différentes. Renommez l'un des deux et les relations deviendront plus nettes. »

<a id="attention-budget"></a>
### Budget d'attention

Chaque [jeton](#token) dispose d'une quantité finie d'influence à répartir sur le reste du [contexte](#context). Une forte influence sur [une relation](#attention-relationship) en laisse moins aux autres. Le budget est propre à chaque jeton et ne croît pas avec le contexte, ce qui explique la dilution dans les longues [sessions](#session).

On peut l'imaginer comme un rapport signal-bruit. Votre instruction est un signal de volume fixe ; tous les autres jetons de la [fenêtre de contexte](#context-window) sont des sons concurrents. L'instruction ne devient jamais plus faible, elle est toujours présente caractère pour caractère, mais à mesure que le contexte grandit, la pièce devient plus bruyante et le rapport signal-bruit diminue. Une instruction qui dominait un contexte de 10 000 jetons devient un bruit de fond à 150 000. C'est le mécanisme de la [dégradation de l'attention](#attention-degradation) : le modèle n'oublie pas, le signal se perd dans le bruit.

Le symptôme ressemble à de la désobéissance : l'agent accepte une contrainte au début puis s'en éloigne, et recoller la contrainte ne l'aide que brièvement. La cause n'est pas l'instruction, mais tout ce qui entre en concurrence avec elle dans la fenêtre.

Ce que vous maîtrisez est ce qui entre dans le contexte. Un contenu qui ne sert pas la tâche n'est pas neutre : il ajoute du bruit par-dessus ce qui la sert. Gardez la fenêtre réduite, [réinitialisez](#clearing) lorsque le contexte accumulé ne compense plus son coût et reformulez les contraintes importantes plutôt que de compter sur le fait qu'elles aient été exprimées tôt.

_Utilisation :_

« Pourquoi continue-t-il d'ignorer le schéma que j'ai collé au début ? »

« Nous sommes déjà bien dans la [zone stupide](#smart-zone) : le budget d'attention de chaque jeton est fixe, mais le contexte a continué de grandir. Le signal du schéma est maintenant en concurrence avec des milliers de jetons plus récents. »

<a id="attention-degradation"></a>
### Dégradation de l'attention

À mesure qu'une [session](#session) grandit, le [budget d'attention](#attention-budget) de chaque [jeton](#token) se répartit entre davantage de concurrents. Le signal porté par une [relation significative](#attention-relationship) donnée faiblit, tandis que le bruit d'un [contexte](#context) non pertinent s'impose. Même [modèle](#model), mêmes [paramètres](#parameters), mais davantage d'éléments à nourrir avec les mêmes ressources. C'est la cause de l'effet des [zones](#smart-zone) intelligente et stupide.

Elle se manifeste par une dégradation du modèle au cours de la session : des contraintes respectées pendant une heure commencent à être oubliées, il redemande des choses qui lui ont été dites ou écrit du code qui ignore un fichier lu précédemment. Rien dans le modèle n'a changé ; la seule variable est le volume de contexte auquel il doit maintenant prêter attention.

Le phénomène est progressif, ce qui rend sa détection difficile de l'intérieur d'une session. Il n'existe ni erreur ni seuil : chaque [tour](#turn) est à peine moins bon que le précédent et, quand les écarts deviennent évidents, vous êtes déjà dans la zone stupide depuis un moment.

La récupération passe par le retrait de contexte, non par son ajout. Recoller l'instruction ignorée ajoute un concurrent dans la même fenêtre surchargée et n'aide que brièvement. Ce qui fonctionne : [réinitialiser](#clearing) et ne recharger que ce dont la tâche a besoin, [compacter](#compaction) ou faire un [passage de relais](#handoff) vers une session neuve. Interprétez le recul du suivi des instructions comme un signal sur la longueur du contexte, pas sur le modèle.

_Utilisation :_

« Il est profondément dans la zone stupide : il invente des génériques qui n'existent pas dans le fichier de types. »

« C'est de la dégradation de l'attention. Les définitions de types sont toujours dans le contexte, mais leur signal est enfoui sous tout ce que nous avons ajouté depuis. Réinitialisez et rechargez. »

<a id="smart-zone"></a>
### Zone intelligente

Au début d'une [session](#session), l'[agent](#agent) se trouve dans une « zone intelligente » : il est vif, concentré et se rappelle bien les éléments pertinents. À mesure que la session grandit, il dérive vers une « zone stupide » : il devient moins rigoureux, oublie davantage, fait plus d'erreurs et produit plus d'[hallucinations](#hallucination) de fidélité. Même [modèle](#model), même [harnais](#harness), seulement davantage de [contexte](#context). C'est l'effet ressenti de la [dégradation de l'attention](#attention-degradation). Pour les modèles de pointe, la zone stupide commence souvent autour de 125 000 à 150 000 [jetons](#token), même si cette estimation est discutée. [Réinitialisez](#clearing) ou [compactez](#compaction) lorsque la session enfle ; n'insistez pas.

La dégradation est graduelle, donc facile à manquer. Aucun message d'erreur ni frontière visible n'apparaît ; l'agent commence simplement à être un peu moins performant, puis nettement moins performant. Les signes courants sont l'oubli d'une instruction donnée vingt tours plus tôt, la répétition d'une erreur déjà corrigée ou l'affirmation assurée d'une chose contredite par le contexte. Comme la pente est douce, la réaction habituelle est de continuer et de réexpliquer, ce qui ajoute du contexte et aggrave le problème.

Les zones ne suivent pas la limite de la [fenêtre de contexte](#context-window). Une session peut être profondément dans la zone stupide alors que la majeure partie de la fenêtre est encore disponible : la limite est le point où le harnais refuse de continuer, mais la qualité diminue bien avant. Planifiez selon la zone intelligente, non selon la fenêtre. Le budget pratique d'une tâche est le nombre de jetons dans lequel l'agent travaille bien, pas celui qu'il peut techniquement contenir.

La zone intelligente est un budget, et le travail sans rapport le dépense. Chaque tâche effectuée dans une session consomme des jetons ; commencer une seconde tâche dans cette session revient donc à la commencer plus près de la zone stupide. Une tâche par session donne à chacune la partie la plus vive de la session. Lorsqu'une seule tâche dépasse la taille d'une zone intelligente, découpez-la : faites un [passage de relais](#handoff) ou compactez à une frontière naturelle, puis laissez une session neuve traiter la suite.

_Utilisation :_

« Il a parfaitement réussi les trois premiers composants et a complètement raté le quatrième. »

« Vous avez quitté la zone intelligente : c'est le même modèle, mais il est maintenant profond dans la zone stupide. Compactez et rechargez le plan ; le composant suivant sera mieux traité. »

## Section 5 — Passages de relais

<a id="clearing"></a>
### Réinitialisation

Terminer la [session](#session) actuelle et en démarrer une nouvelle. Le message suivant commence avec une session et une [fenêtre de contexte](#context-window) vides. C'est généralement une action de l'utilisateur.

La réinitialisation est le remède à un contexte pollué. Une session accumule tout : tentatives échouées, fausses pistes, [résultats d'outil](#tool-result) périmés et plans abandonnés. Le [modèle](#model) relit cet ensemble à chaque [tour](#turn), et un mauvais historique pèse sur le travail nouveau. Dans une longue session, l'[agent](#agent) devient moins précis et moins obéissant : les instructions clairement données sont ignorées, la qualité diminue, et lui demander de faire mieux n'aide pas car le bruit dans lequel il raisonne reste dans son [contexte](#context). La réinitialisation retire ce bruit.

Elle n'efface pas la conversation. La plupart des [harnais](#harness) conservent l'historique de session sur votre ordinateur ; la transcription peut donc toujours être lue ou reprise. Ce qui disparaît est l'état de travail de l'agent : le modèle est [sans état](#stateless), donc la nouvelle session ignore tout ce que savait l'ancienne. Si la session contient des décisions ou une progression nécessaires à la suivante, demandez d'abord à l'agent d'écrire un [artefact de transfert](#handoff-artifact), puis démarrez la nouvelle session en le lui indiquant.

Comparez avec le [compactage](#compaction), qui résume la session dans le nouveau contexte plutôt que de repartir vide. La réinitialisation est l'outil le plus direct : rien ne passe, y compris les éléments inutiles.

_Utilisation :_

« Il tourne en boucle sur le test en échec. »

« Réinitialisez simplement : démarrez une session neuve avec le document de planification et le fichier de test. Il est inutile de lutter contre le contexte actuel. »

<a id="handoff"></a>
### Passage de relais

Le transfert du [contexte](#context) d'un [agent](#agent) d'une [session](#session) à une autre. Le mécanisme de transmission varie : [artefact de transfert](#handoff-artifact) écrit, résumé en mémoire par [compactage](#compaction) ou autre moyen. Il se distingue de la [réinitialisation](#clearing), qui ne transmet rien. Les raisons varient : changement de rôle, du planificateur vers l'implémenteur, lancement d'un travail [AFK](#afk), répartition vers des sessions parallèles ou libération d'espace dans la [fenêtre de contexte](#context-window).

La session qui reçoit le relais commence sans contexte : le [modèle](#model) est [sans état](#stateless), et rien de l'ancienne session n'est visible dans la nouvelle. Ce dont la session suivante a besoin doit être transmis explicitement ; le reste est perdu. L'absence de chemin de retour est la contrainte qui façonne ce transfert : la nouvelle session ne peut demander à l'ancienne ce qu'elle voulait dire, le contenu transmis doit donc se suffire à lui-même.

| Mécanisme | Forme | Propriétés |
| --------- | ----- | ---------- |
| Artefact de transfert | Fichier dans l'[environnement](#environment) | Vous pouvez le lire et le corriger avant qu'un travail n'en dépende ; il est réutilisable par plusieurs sessions |
| Compactage | Résumé dans la fenêtre de contexte | Automatique et peu coûteux ; plus difficile à examiner ; alimente un seul successeur |

L'échec visible d'un mauvais passage de relais est la rediscussion : la nouvelle session rouvre des décisions que l'ancienne avait tranchées, car le transfert a enregistré ce qui avait été décidé mais pas pourquoi. Évaluez un passage de relais selon ce qu'une session sans aucun contexte pourrait faire avec lui.

_Utilisation :_

« La session de planification devient lourde : dois-je simplement continuer ? »

« Faites un passage de relais. Écrivez les décisions dans un document, réinitialisez, puis démarrez l'implémentation dans une session neuve qui le lit. »

<a id="primary-source"></a>
### Source primaire

Une source de vérité dans sa forme originale : le code, la transcription d'une conversation, le journal brut ou la véritable réponse d'une API. Ce n'est pas le récit de la chose, c'est la chose elle-même. C'est le pendant de la [source secondaire](#secondary-source).

Pour savoir ce que fait une base de code, le code est la source primaire. La documentation, le diagramme d'architecture et le README en sont des descriptions, exactes lorsqu'elles ont été écrites, puis mises à jour selon leur propre rythme. Lorsqu'un [agent](#agent) affirme avec assurance une chose fausse sur votre projet, demandez-vous de quelle source il est parti : un agent qui a lu une documentation hérite de son obsolescence ; celui qui a lu le code lit la vérité actuelle.

Le coût empêche les sources primaires d'être la solution par défaut. En charger une dans la [fenêtre de contexte](#context-window) est coûteux : fichier complet, transcription complète, chaque [jeton](#token) facturé comme [entrée](#input-tokens) et en concurrence pour le [budget d'attention](#attention-budget). En échange, vous obtenez l'exhaustivité : rien n'a été préfiltré selon le jugement d'une autre personne sur ce qui importait. Un résumé écrit le mois dernier ne peut pas contenir le détail devenu important aujourd'hui ; la source primaire le contient encore.

Préférez la source primaire lorsque la précision importe : la signature exacte, l'erreur réelle ou la ligne qui lève l'exception. Une grande part de la gestion du [contexte](#context) consiste à décider quand payer le coût de la source primaire et quand une source secondaire suffit.

_Utilisation :_

« L'agent affirme que la logique de nouvelle tentative applique un délai exponentiel, mais je la vois marteler le point de terminaison. »

« Il l'a lu dans le document de conception. Orientez-le vers le véritable module de nouvelles tentatives : travaillez à partir de la source primaire lorsque le comportement importe. »

<a id="secondary-source"></a>
### Source secondaire

Le récit d'une [source primaire](#primary-source), avec un niveau d'éloignement : une documentation décrivant du code, un résumé décrivant une transcription ou un rapport décrivant des résultats de recherche. Elle coûte moins cher à charger dans la [fenêtre de contexte](#context-window) que la source qu'elle décrit, mais perd nécessairement de l'information : son auteur a décidé ce qui importait et tout ce qu'il a omis est invisible au lecteur qui ne possède que le résumé.

Une grande part de l'ingénierie de [contexte](#context) consiste à produire des sources secondaires. Le [compactage](#compaction) transforme l'historique d'une [session](#session) en résumé qui amorce la session suivante. Un [sous-agent](#subagent) consomme son propre contexte dans une recherche bruyante et renvoie un rapport court. Un [artefact de transfert](#handoff-artifact) condense les décisions d'une session dans un document lu par la suivante. Les [systèmes de mémoire](#memory-system) distillent ce qu'une session a appris en notes. Tous effectuent le même compromis : fidélité contre espace disponible.

Les sources secondaires échouent de deux façons. Elles perdent de l'information : résumé de compactage qui a perdu la décision de schéma, rapport qui ne mentionne pas le cas limite. Elles dérivent aussi : la source primaire change sans que le récit la suive, et la documentation décrit l'architecture du trimestre précédent avec l'assurance de ce trimestre. Lorsqu'un [agent](#agent) agit à partir d'une source secondaire défaillante d'une de ces deux manières, il travaille avec assurance sur des informations fausses ; la correction est de le renvoyer à la source primaire.

Aucun de ces échecs ne fait des sources secondaires une erreur. La fenêtre de contexte est limitée et les sources primaires coûteuses ; sans résumés, rapports et documents de transfert, rien de volumineux ne tient. La compétence consiste à savoir quels détails peuvent survivre à la perte et à vérifier auprès de la source primaire ceux qui ne le peuvent pas. Une source secondaire bien conçue transporte un [pointeur de contexte](#context-pointer) vers son original, le résumé qui nomme la transcription dont il provient ou le document qui nomme le fichier décrit, afin que le lecteur puisse suivre ce pointeur lorsque le récit ne suffit plus.

_Utilisation :_

« Le document de transfert dit que l'authentification est terminée, mais la nouvelle session continue de trouver un rafraîchissement de jeton défaillant. »

« Le document est une source secondaire : la dernière session y a consigné ce qu'elle croyait, non la vérité. Faites exécuter les tests d'authentification par la nouvelle session et faites confiance à la source primaire. »

<a id="handoff-artifact"></a>
### Artefact de transfert

A document used as the carry mechanism for a [handoff](#handoff) — written to the [environment](#environment) by one [session](#session) to be read by another. [Specs](#spec), [tickets](#ticket), and plan docs are all handoff artifacts.

The reason to write one: the [model](#model) is [stateless](#stateless), so nothing in a session survives [clearing](#clearing) it. Decisions, constraints, half-finished plans — all gone with the [context](#context) that held them. The environment persists. Writing the important state into a file moves it somewhere the next session can read it back from.

The artifact is a [secondary source](#secondary-source) — an account of the session's work, not the work itself. That's what makes it small enough to brief a fresh session, and also why it can mislead one: it records what the writing session believed, and anything it left out or got wrong is invisible to the reader. Where a claim matters, the next session should verify it against the [primary source](#primary-source) — the code, the tests — rather than inherit it.

A good artifact is written to be read into a session that has zero context. Concrete file paths rather than "the file we discussed". What was decided and why, so the next session doesn't relitigate it. What's done and what's left. It helps to tell the writing session where the artifact is headed: "write a handoff doc for a fresh session that knows nothing about this work".

The alternative carry mechanism is [compaction](#compaction), which summarises in-memory. The artifact has two advantages: it lives on disk where you can read and correct it before anything depends on it, and it can be reused — the same spec can brief five parallel sessions.

_Usage:_

"How do I split this between the planning [agent](#agent) and the implementing one?"

"Have the planner write a handoff artifact — file paths, decisions, constraints. The implementer's session opens with a pointer to the artifact and works from it as its brief."

<a id="spec"></a>
### Spécification

A [handoff artifact](#handoff-artifact) describing a multi-[session](#session) piece of work — what's being built, not how each session does its share. Mutates as work progresses. Made of [tickets](#ticket).

The spec exists because sessions are disposable and big work isn't. Anything that takes more than one [context window](#context-window) of effort needs a home outside the [context](#context) — somewhere in the agent's [environment](#environment) that survives [clearing](#clearing), whether that's a file in the repo, a GitHub issue, or an issue tracker the agent can reach. The spec is that home: the goal, the constraints, the decisions made so far, and the list of tickets with their status. Any fresh session can read it and know where the work stands without inheriting the previous session's accumulated noise.

Specs come in recognisable styles, mostly inherited from how teams already write things down. A _product requirements document_ (PRD) leans toward the user-facing what and why — features, behaviour, acceptance criteria. A _design doc_ or _RFC_ leans technical — the chosen approach, the alternatives rejected, the trade-offs. At the small end, a plain `plan.md` with a checklist of tickets does the same job for a multi-session feature. The style matters less than the role: for the [agent](#agent), each of these is the same thing — the durable statement of intent it reads at the start of every session.

_Usage:_

"Should this all be one session?"

"No, write it up as a spec — break it into tickets, run each one in its own session. Trying to do the whole thing in a single context will hit the [dumb zone](#smart-zone) before you're halfway."

<a id="ticket"></a>
### Ticket

A [handoff artifact](#handoff-artifact) scoping one [session](#session) of work. Stands alone, or hangs off a [spec](#spec) as one of its children. Tickets can block or be blocked by sibling tickets, so the order of work falls out of their dependency graph rather than a linear plan.

The defining constraint is the size: one session. A ticket should be completable before the session drifts out of the [smart zone](#smart-zone) — and that constraint is testable. If sessions on your tickets routinely degrade before the work is done, the tickets are too big; split them. If each session spends most of its [context](#context) on setup before doing five minutes of work, they're too small; merge them.

A good ticket is written for a reader with no other context. The goal, the acceptance criteria, and [context pointers](#context-pointer) to the relevant files and decisions — enough that the session can start working without re-deriving what the last one knew.

The dependency graph is also what unlocks parallelism. Independent tickets — the leaves of the graph — can each run in their own session at the same time. This is an effective way of running multiple agents at once.

_Usage:_

"Where do I start on the migration spec?"

"Look at the ticket graph — the schema change blocks the backfill, the backfill blocks the API switch. Pick a leaf and run a session on it."

<a id="compaction"></a>
### Compactage

A [handoff](#handoff) done in-memory: the previous [session](#session)'s history is summarised, and the summary seeds a fresh session. Lossy by design: the transcript is a [primary source](#primary-source), the summary a [secondary source](#secondary-source) — detail traded for headroom. Triggered manually by the user, or automatically via [autocompact](#autocompact).

The mechanism: the [context window](#context-window) is finite, and a long session fills it — every [tool result](#tool-result), every file read, every wrong turn stays in history. When it gets heavy, the [harness](#harness) asks the [model](#model) to summarise the session, throws the original history away, and seeds a fresh session with the summary. Whatever didn't make it into the summary is gone from the context. Some harnesses soften this by keeping the old transcript on disk and leaving a [context pointer](#context-pointer) to it in the summary — the secondary source links back to its primary source, so a detail the summary lost can be recovered by re-reading the original.

The summary is written by the model, so it can be prompted. "Preserve the schema decisions" makes the generated artifact more deliberate. Timing matters too — compact at a phase boundary, after the plan is settled, not mid-task.

Contrast with [clearing](#clearing), which drops everything and starts cold: compaction tries to carry the essentials across; clearing bets they're already written down somewhere better.

_Usage:_

"[Context](#context)'s getting heavy and I still have the test pass to do."

"Compact before you start — write what must survive into the summary prompt so the new session keeps the schema decisions and drops the exploration."

<a id="autocompact"></a>
### Compactage automatique

[Compaction](#compaction) triggered automatically by the [harness](#harness) when the [context window](#context-window) approaches full.

The harness watches how full the context window is. When it crosses a threshold — often around 80% — it pauses, asks the [model](#model) to summarise the [session](#session) so far, and seeds a fresh session with the summary. Work then continues as if nothing happened.

Except something did happen. Compaction is lossy, and autocompact is lossy at a moment you didn't choose. A manual compact happens at a phase boundary, when you can tell the model what to preserve. Autocompact fires mid-task, whenever the threshold is hit — possibly halfway through a refactor, with the summary deciding for itself which of your decisions were worth keeping. The classic symptom: the [agent](#agent) carries on confidently but has quietly forgotten a constraint you established an hour ago, and you only notice when its work starts contradicting it.

The defence is to not let it fire. Watch the context indicator and compact manually at a natural boundary, or write decisions into a plan doc or [handoff artifact](#handoff-artifact) on disk, where no summary can lose them. Most harnesses also let you customise the buffer — moving the threshold earlier or later, or turning autocompact off entirely — so you can tune how much headroom you keep before it fires.

_Usage:_

"It doesn't seem to remember what we decided about the schema earlier."

"Autocompact fired between [turns](#turn) — the early decisions got summarised and we must have lost something. Reload the plan doc, or compact manually next time so you control what gets kept."

## Section 6 — Mémoire et pilotage

<a id="memory-system"></a>
### Système de mémoire

A system that attempts to make an [agent](#agent) [stateful](#stateful) across [sessions](#session). Persists information into the [environment](#environment) during a session and reloads it into the [context window](#context-window) at the start of future ones, so the agent carries continuity beyond the user [clearing](#clearing) the session.

A memory system has two halves. The write path: during a session, the agent records what it learned — a preference you stated, a fact about the project — as files in the environment. The read path: at session start, the [harness](#harness) loads those files, or an index of them, back into the context window. Many harnesses ship their own memory system — Claude Code's `/memory` is one — but you can also build one yourself: a directory of notes plus an instruction in [AGENTS.md](#agentsmd) to consult it.

The same trade-offs as any always-loaded content apply. Memories accumulate, so most systems load a one-line index and leave the bodies behind [context pointers](#context-pointer) rather than inlining everything. And memories are [secondary sources](#secondary-source), so they drift: a fact recorded in March is loaded with equal confidence in June, after the project has moved on. A memory system needs pruning, the same way AGENTS.md does.

_Usage:_

"I keep having to re-tell it I'm on Postgres, not MySQL."

"Wire up a memory system — write what it learns to the [filesystem](#filesystem) on the first [turn](#turn), reload it at session start. The [model](#model) itself is [stateless](#stateless); the memory layer fakes continuity."

<a id="agentsmd"></a>
### AGENTS.md

A file in the [environment](#environment) that the [harness](#harness) loads into the [context window](#context-window) at [session](#session) start — the project's standing brief to the [agent](#agent). Cross-harness convention; some harnesses also have their own variant (Claude Code's is CLAUDE.md).

Because it loads automatically, it's one way to avoid repeating yourself across sessions. The [model](#model) is [stateless](#stateless) — a correction you give in one session is gone in the next, and you end up telling every fresh session that the project uses pnpm, that tests run with a particular flag, that a directory is generated and shouldn't be touched. When you've corrected the agent for the same thing twice, that correction is a candidate line for AGENTS.md.

Suitable content is whatever the agent can't derive from the code: build and test commands, conventions the codebase doesn't make obvious, hard constraints ("never edit the generated client"). Short and declarative — it's a brief, not documentation.

The trade-off is that everything in it is always loaded. Instructions accumulate, most of them irrelevant to any given task, and a long AGENTS.md both costs tokens and dilutes itself — the more instructions in context, the less reliably the model follows any one of them.

_Avoid:_ using AGENTS.md for content that should be [progressively disclosed](#progressive-disclosure) — anything in it pays a [token](#token) cost every [turn](#turn), in every session, whether or not that session needs it. A style guide can go behind a [skill](#skill) or a [context pointer](#context-pointer) instead; keep AGENTS.md for the lines that apply everywhere.

_Usage:_

"Why is every session starting with 4k tokens already burned?"

"Check AGENTS.md — someone pasted the entire style guide in there instead of putting it behind a skill."

<a id="progressive-disclosure"></a>
### Divulgation progressive

Loading only the [context](#context) an [agent](#agent) needs right now, with [context pointers](#context-pointer) to the rest. Borrowed from UI design, where it means showing users only the controls relevant to their current task and hiding the rest behind a click.

The technique exists because context is a cost twice over. Every [token](#token) loaded up front is billed as [input tokens](#input-tokens) on every [turn](#turn), and every token spends [attention budget](#attention-budget) whether the agent needs it or not. An [AGENTS.md](#agentsmd) stuffed with the full style guide, deployment runbook, and database conventions makes the agent worse at all of them — the instructions that matter for the current task are diluted by the ones that don't. The tell is an agent that ignores rules you know are in its context: they're in there, but buried.

Progressive disclosure inverts this. Keep the always-loaded layer small — a sentence per topic and a pointer to where the detail lives. The agent reads the style guide when it's writing a component, the deployment runbook when it's deploying, and neither when it's fixing a test. [Skills](#skill) are the pattern built into the [harness](#harness): a short description loaded every [session](#session), the full instructions only when triggered.

_Usage:_

"Should I dump the entire style guide into AGENTS.md?"

"No — progressive disclosure. Reference the style guide as a skill the agent loads when it actually needs to write a component. AGENTS.md pays the token cost every turn."

<a id="context-pointer"></a>
### Pointeur de contexte

A mention in one document that points to another, so the [agent](#agent) can pull it into the [context window](#context-window) only when the task calls for it. The unit [progressive disclosure](#progressive-disclosure) is built from.

The reason to use a pointer (instead of inlining the content) is cost. A pointer is one line in the context window. The document behind it might be thousands of [tokens](#token), but those tokens cost nothing until the agent actually follows the pointer. Inline a 2,000-token runbook in [AGENTS.md](#agentsmd) and every [session](#session) pays for it; replace it with "deploy process: see `internal/deploy.md`" and only the sessions that deploy ever load it. The agent follows the pointer with a [tool call](#tool-call) when the task matches.

A pointer needs two parts to work: a stable path, and enough description for the agent to know when following it is worth it. A bare path is a pointer the agent has no reason to follow; "see `internal/deploy.md`" with no hint of what's inside gets skipped by a session that needed it. Write the line so it matches how tasks present: "release, deploy, or rollback — read `internal/deploy.md` first".

Pointers are everywhere once you look: lines in AGENTS.md, [skill](#skill) descriptions (the harness loads the description; the skill body waits behind it), filenames in a directory listing, links between docs.

A pointer can also tie a [secondary source](#secondary-source) back to the [primary source](#primary-source) it was derived from — the compaction summary that names the original transcript, the doc that names the source file it describes. This makes the secondary source's lossiness recoverable: when the summary turns out not to be enough, the agent follows the pointer and reads the original, instead of working from whatever the summary kept.

_Avoid:_ "reference" — too dry; doesn't convey that following it pulls more context in. "Portal" — too florid.

_Usage:_

"AGENTS.md is getting huge."

"Most of it should be context pointers, not content. Keep the always-on rules inline; turn the deploy runbook and the style guide into skills and leave a context pointer behind."

<a id="skill"></a>
### Compétence

A teachable capability bundled as a unit — instructions and resources for doing one task well, kept in the [environment](#environment) until a [context pointer](#context-pointer) pulls it into the [context window](#context-window) for the task at hand. The unit of [progressive disclosure](#progressive-disclosure) in a [harness](#harness).

Skills are an open standard, defined at [agentskills.io](https://agentskills.io) — originally developed by Anthropic and since adopted by most major harnesses, so a skill written once works across them. The format is a folder containing:

- A `SKILL.md` file — metadata (a name and description, at minimum) plus the instructions themselves
- Optionally, scripts the [agent](#agent) can run
- Optionally, templates and reference material the instructions point to

Only the name and description sit in [context](#context) by default. When the agent's task matches, it loads the rest. Until then, the skill takes up almost no room — a sentence or two of [tokens](#token), however large its full instructions are.

This distinguishes skills from [AGENTS.md](#agentsmd), which is loaded into every [session](#session) regardless of the task. A skill is read when a particular kind of work comes up — releasing, scaffolding a new service, writing a migration — and ignored the rest of the time.

_Avoid:_ "[tool](#tool)" — a tool is what the agent _calls_; a skill is instructions it _reads_.

_Usage:_

"Where should I put the deploy runbook?"

"As a skill — the agent loads it only when the task involves deploys. In AGENTS.md it'd burn tokens on every [turn](#turn) for something we use weekly."

<a id="subagent"></a>
### Sous-agent

An [agent](#agent) spawned by another agent via a [tool call](#tool-call). Runs in its own [session](#session) with its own [context window](#context-window), and reports a single [tool result](#tool-result) back. Distinct from a [handoff](#handoff) — the parent specifically expects a return; a handoff has no return path. **Cannot spawn further subagents** — the tree is one level deep. Subagents exist to isolate [context](#context), not to compose hierarchies.

The point is to keep noisy work out of the parent's context. A broad search or a long file-reading expedition produces pages of tool results, most of which matter only long enough to find the answer. Run inside the parent and all of it stays in the parent's context for the rest of the session. Run inside a subagent and the noise fills a disposable window instead — only the final report lands in the parent's context. The report is a [secondary source](#secondary-source): the parent gets the subagent's account of what it found, not the raw results, so anything the report leaves out is invisible to the parent.

Subagents also run concurrently — a parent can fan several out at once over independent pieces of work.

_Usage:_

"The grep results are blowing out my context."

"Spawn a subagent to do the search — it'll burn its own context window on the noise and report back the two file paths you actually need."

## Section 7 — Modes de travail

<a id="human-in-the-loop"></a>
### Humain dans la boucle

A working pattern where one or more humans pair with the [agent](#agent) during a [session](#session) — reviewing, redirecting, or collaborating in real time. The human is present and engaged, not just gating individual actions.

The contrast is with [AFK](#afk) work, where the agent runs unattended and you judge the result afterwards. Human-in-the-loop means catching problems while they're still cheap: you see the agent reach for the wrong file, misread the requirement, or start down a dead end, and you redirect it in one sentence — rather than discovering twenty minutes of confident work built on that mistake. Agents don't reliably know when they're off track; left alone, they tend to push forward rather than stop and ask.

Which pattern fits depends on the work. Well-specified, low-risk, easy-to-verify tasks suit AFK. Tasks that are ambiguous, irreversible, or where you'd struggle to review the finished result — a schema migration, a tricky design decision, anything touching production — suit staying in the loop. The judgement call is essentially: how expensive is a wrong turn, and how late would you catch it?

Some work is in-the-loop by nature, because your reactions are the input. [Grilling](#grilling) only works with you there to answer the questions; [prototyping](#prototyping) only works with you there to react to the artifact.

Staying in the loop costs your attention, which is the scarce resource. Part of getting better with agents is moving more work safely out of the loop — with plans, [automated checks](#automated-check), and [human review](#human-review) at the end instead of supervision throughout.

_Usage:_

"Run this AFK overnight?"

"No, schema migration — keep it human-in-the-loop. I want to see each step and steer if it picks the wrong column to backfill from."

<a id="afk"></a>
### AFK

Away from keyboard. A working pattern where the user kicks off a [session](#session) and leaves the [agent](#agent) to run unattended. The throughput multiplier of [AI](#ai) coding — many AFK sessions can run in parallel while you sleep, eat, or work on something else. Usually requires a permissive [permission mode](#permission-mode) plus [sandboxing](#sandbox) to be safe.

When you're not there, the agent handles ambiguity differently. While you're watching, an ambiguous decision surfaces as a question and you answer it; once you've walked away, the agent picks a default and keeps going, and every later decision builds on that guess. The characteristic failure is coming back to hours of finished, confident work built on a wrong call made in the first ten minutes. The work isn't sloppy — it's coherent, just coherent about the wrong thing.

Since you can't give input during the run, give it before and after instead. Before: resolve the ambiguity up front — a [grilling](#grilling) session, a written [spec](#spec) — so there are fewer gaps for the agent to fill alone. During: [automated checks](#automated-check) and [automated review](#automated-review) stand in for the attention you're not giving, failing fast on what can be caught mechanically. After: the run ends in something reviewable — a PR, not changes already merged. AFK doesn't remove [human review](#human-review); it defers all of it to the end, which is why what arrives at the end has to be worth reviewing. This is also why [AX](#ax) matters most in AFK runs — with no one watching, the environment is the only support the agent gets.

_Avoid:_ "background agent" — centers the machine ("running in the background") rather than the human pattern ("user has walked away"). AFK names the fact that matters: the user isn't watching.

_Usage:_

"I'm running this AFK — three sandboxed agents on the refactor, reviewing the PRs in the morning."

"[Bypass permissions](#agent-mode)?"

"Yeah, read-only [filesystem](#filesystem), no network."

<a id="automated-check"></a>
### Vérification automatisée

A deterministic verification that runs in the [environment](#environment) — tests, type checks, lints, build, pre-commit hooks. Pass/fail, no judgement. The signal an [agent](#agent) can self-correct from without involving anyone else. A flaky test is a broken check, not a non-check; automated checks are deterministic _by design_.

Self-correction works as a loop. The agent makes a change, runs the check as a [tool call](#tool-call), and the failure output lands in its [context window](#context-window) — a type error with a file and line, a failing assertion with expected and actual values. That's enough for the agent to fix the problem and run the check again, around and around until it passes, with no human in the loop. Determinism is what makes the loop trustworthy: the same code always produces the same verdict, so a pass means something. A flaky check poisons this — the agent "fixes" code that was fine, or retries past a real failure.

This is why good checks are a large part of a codebase's [AX](#ax). An agent in a repo with strict types, a fast test suite, and a linter catches most of its own mistakes before you see them; an agent in a repo with none of those ships whatever it produces. The difference matters most in [AFK](#afk) runs, where checks are the only verification happening during the run. But a check only catches what it asserts — green checks mean the asserted properties hold, not that the code is right. The judgement-shaped gaps are what [automated review](#automated-review) and [human review](#human-review) are for.

_Avoid:_ "feedback loop" / "backpressure" — both lump checks together with review. _Avoid:_ "test" — tests are automated checks, but not all automated checks are tests.

_Usage:_

"The agent keeps shipping broken code in the AFK runs."

"What automated checks are wired into the [sandbox](#sandbox)?"

"Just the unit tests."

"Add typecheck and lint — it'll self-correct from those before the PR ever lands."

<a id="automated-review"></a>
### Revue automatisée

An [agent](#agent) reviewing another agent's work, often with a different [model](#model) or [system prompt](#system-prompt). Non-deterministic: it forms a judgement. Runs anywhere — pre-merge on a PR, post-hoc on commit history, mid-session as a [subagent](#subagent). An LLM-as-judge in CI is automated review, not an [automated check](#automated-check); what the assertion _does_ decides the category, not where it runs.

The separation from the working agent is what makes it work. Asking the agent that wrote the code to review its own work gets you very little — the [session](#session) that produced the bug also contains the reasoning that produced it, and the agent reads its own conclusions back as confirmation. A reviewer with a fresh [context window](#context-window) has none of that attachment: it sees the diff the way a stranger would, which is what review depends on. A different model or a review-specific system prompt sharpens this further — different blind spots, and a system prompt scoped to what you actually care about (security, API contracts, performance) rather than a vague "look for problems".

It slots between the other review layers. Automated checks are deterministic and catch what can be asserted mechanically; [human review](#human-review) is expensive and scales worst. Automated review sits in the middle: it catches judgement-shaped problems — a misleading function name, a missed edge case — at machine cost. Because it's non-deterministic, it can miss things and flag non-issues; treat it as a filter that raises the floor before a human looks, not a gate that replaces one.

_Avoid:_ "AI review" / "agent review" — too vague to distinguish from the working agent itself.

_Usage:_

"We're getting too many bad PRs from the [AFK](#afk) runs."

"Add an automated review step before merge — different model, separate system prompt, scoped to security and contract changes."

<a id="human-review"></a>
### Revue humaine

The user reading the code the [agent](#agent) produced and forming a judgement on it. Reading the diff or the changed files counts; reading the agent's _description_ of what it did does not — narration is not the artifact. The description is a [secondary source](#secondary-source), written by the party being reviewed; the diff is the [primary source](#primary-source), and review means reading it.

Agents raise the volume of code produced, so review becomes the bottleneck. One useful idea is layering different review strategies. [Automated checks](#automated-check) catch the mechanical failures, [automated review](#automated-review) catches the describable ones, and human review is reserved for what only you can judge — whether the change is the right change, whether the approach fits the codebase, whether this should exist at all.

Review is also cheaper earlier. Reading a plan before work starts, or a small diff mid-flight, takes minutes; excavating a finished branch after an [AFK](#afk) run takes longer. Where you place the review checkpoint is a [human-in-the-loop](#human-in-the-loop) decision, not an afterthought.

_Avoid:_ "code review" alone — ambiguous between human and automated.

_Usage:_

"I human-reviewed the AFK output."

"You read the diff or just the summary?"

"Diff. The summary said it deleted dead code — turned out the function was called from a generated file."

<a id="vibe-coding"></a>
### Programmation au feeling

A working pattern where the user accepts the [agent](#agent)'s code without [human review](#human-review). The diff is treated as opaque — what matters is whether the program behaves, not what's inside. [Automated review](#automated-review) and [automated checks](#automated-check) may still run; vibe coding is silent on both.

The term comes from Andrej Karpathy, who [coined it in early 2025](https://x.com/karpathy/status/1886192184808149383): you "fully give in to the vibes" and "forget that the code even exists" — describe what you want, accept what comes back, and judge it by running it.

Vibe coding trades inspection for speed. Reading diffs is usually the slowest step in agent-driven work, so dropping it removes the main bottleneck. For code whose failures are cheap — [prototypes](#prototyping), one-off scripts, internal tools — that's a reasonable trade. The risk scales with the code's lifespan and stakes.

The cost arrives later. Vibe-coded changes accumulate into a codebase nobody has read, and behaviour was the only thing checked — so anything behaviour doesn't surface, like a secret written to logs, a missing edge case, or quietly wrong data handling, ships unseen. The first time someone debugs the system is the first time anyone reads the code. With human review gone, whatever automated verification still runs — tests, types, automated review — is the only gate the code passes through.

_Avoid:_ "vibe coding" as a synonym for "low-quality AI coding" — the term names the review stance, not the resulting code.

_Usage:_

"Did you read what it changed in the auth flow?"

"Vibe coded it — login still works, that's all I checked."

"Read the diff before you push, vibing on auth is how secrets leak into logs."

<a id="design-concept"></a>
### Concept de conception

The shared understanding of what's being built, held in common between user and [agent](#agent) but separate from any asset. Brooks' term (_The Design of Design_): the conversation, [handoff artifacts](#handoff-artifact), and the code are all assets that try to capture or reach the design concept, but none of them _are_ it. Quality of the design concept is felt through the quality of the conversation that built it.

The term names the gap behind a familiar frustration: the agent writes exactly what you asked for and it's still wrong. The usual cause is that you hadn't fully figured out what you wanted. The design concept wasn't finished in your own head — your prompt captured the parts you'd worked out, and was silent on the parts you hadn't. The agent filled those silences with its own assumptions, because there was nothing to align with. Nothing malfunctioned. There was no shared design concept, because there wasn't yet a whole one to share.

You can tell a design concept is shared the same way you can with a colleague: the other party starts answering questions you haven't asked yet the way you would. Until then, the work is conversation — [grilling](#grilling) is the deliberate version — and writing a [spec](#spec) too early just captures the misalignment in a more durable asset. The design concept also moves as you learn; assets lag it, which is why a spec faithful to last week's understanding can still mislead this week's session.

_Usage:_

"It's writing exactly what I asked for and it's still wrong."

"You don't share a design concept yet — it's filling gaps with assumptions. Keep talking until cancellation, refunds, and partial fulfilment all line up between you before you let it write a spec."

<a id="grilling"></a>
### Questionnement approfondi

A technique for developing a [design concept](#design-concept) with an [agent](#agent): the agent interviews the user Socratically, one decision at a time, proposing a recommended answer for each. Slows the rush to a finished plan — no [handoff artifact](#handoff-artifact) is written until the concept stabilises.

The technique exists because agents fill gaps silently. Asked to write a [spec](#spec) from a two-line prompt, the agent doesn't stop at the decisions you haven't made — it picks defaults and writes them in. The result looks complete, and the guesses are indistinguishable from the choices, so you discover them late: at review, or when the built feature handles an edge case in a way you never chose. Grilling inverts this — instead of guessing, the agent has to ask.

It's a [human-in-the-loop](#human-in-the-loop) technique: your answers are the input. When a question can't be answered in conversation — you'd have to see the thing — switch to [prototyping](#prototyping).

_Usage:_

"It went straight to writing the spec and got the cancellation logic wrong."

"Grill it first — make it ask you about partial cancels, refunds, and timing before it commits anything to the doc. Cheaper to resolve in conversation than in code."

<a id="prototyping"></a>
### Prototypage

Having the [agent](#agent) build a quick, rough version of something, for when conversation is too low-fidelity and you need a real artifact to talk about.

[Grilling](#grilling) resolves design decisions in conversation. Conversation is cheap, but it's low-fidelity: some questions can't be answered in words — how an interaction feels, whether an API shape is ergonomic in real calling code, whether the layout works at real data sizes. The interview hits a question and your honest answer is "I don't know, I'd have to see it." Past that point the discussion circles. Instead, have the agent build the thing, look at it, and come back to the conversation with an answer.

Agents lower the cost of building, which is what makes this practical. A rough version that used to take a day to mock up now takes minutes, so it's worth doing routinely. It's a [human-in-the-loop](#human-in-the-loop) technique: the prototype is there for you to react to.

You usually don't stop at one look. Iterate with the prototype — react, ask for a change, react again — so each round resolves another decision against the real artifact, at a higher fidelity than conversation allows.

A prototype doesn't have to be all-scrappy. You can build the pieces you're actually evaluating to production quality, so when the decision lands, the component or API you reacted to can transfer into the real codebase. This makes prototyping essential material for the [spec](#spec) to reference.

_Usage:_

"We've spent half an hour arguing about whether the wizard should be one page or three steps."

"Words won't settle it — have the agent prototype both. We'll click through them and know in five minutes."

<a id="dx"></a>
### DX

Developer experience — how easy a codebase and its toolchain make it for humans to do good work. Good DX is fast feedback, clear error messages, documentation that answers the question you actually have, and setup that works on the first try. The term long predates AI coding; it's in this dictionary mainly as the contrast for [AX](#ax).

DX is the interaction between the human and the codebase — nothing more. The main difference between the two audiences is that humans are [stateful](#stateful) and agents are [stateless](#stateless). A human learns the codebase once and carries that knowledge into every day after, which is why poor DX is survivable: they route around slow CI by batching their pushes, around missing docs by asking in Slack once, around confusing structure by remembering where things live. The workarounds accumulate, and a team ends up productive in a codebase that fights them.

[Agents](#agent) face the same codebase with none of that accumulation. Stateless across [sessions](#session), an agent re-learns the codebase from scratch every time — it benefits from the fast test suite and the clear error messages, but anything it figured out yesterday is gone unless it was written into the [environment](#environment), which the agent only perceives through [tool results](#tool-result). That's the gap AX names: the parts of DX that survive when the developer is an agent, plus concerns humans don't have, like keeping the [context window](#context-window) free.

The overlap means DX investment often improves AX for free — strict types, fast tests, and predictable structure help both. The divergence means it doesn't always: a beautiful onboarding doc helps a human for a week and an agent not at all unless it's reachable from [AGENTS.md](#agentsmd).

_Usage:_

"Our DX is fine — new hires are productive in a week."

"Productive because someone sits with them for that week. The agent doesn't get that week; check the AX separately."

<a id="ax"></a>
### AX

Agent experience — how well the [environment](#environment) is set up for an [agent](#agent) to do good work in a codebase. The agent-facing counterpart to [DX](#dx). When the same agent performs well in one repo and badly in another — same [model](#model), same [harness](#harness) — the difference is usually AX. The instinct is to blame the model or rewrite the prompt; the fix is more often in the repo.

Good AX has three main dimensions:

| Dimension        | What good AX looks like                                                                                                                                                                                                                              |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Automated checks | Fast, deterministic [automated checks](#automated-check) — types, tests, lints — that the agent can self-correct from without a human                                                                                                          |
| Architecture     | A codebase the agent can navigate without reading everything: predictable structure, a lot of behaviour behind small interfaces, names that say what things do                                                                                       |
| Free context     | [AGENTS.md](#agentsmd), [skills](#skill), and [tools](#tool) kept lean, so most of the [context window](#context-window) is available for the task and the agent stays in the [smart zone](#smart-zone) instead of drowning |

AX and DX overlap — good checks and clean architecture help both audiences — but they diverge. Humans tolerate tribal knowledge, slow CI, and "ask Sarah about the billing module"; agents can't. Agents don't benefit from IDE tooltips or pretty dashboards; they need failures as text in a [tool result](#tool-result). A codebase can have good DX and poor AX.

_Avoid:_ treating AX as a synonym for DX — the audiences need different investments.

_Usage:_

"The agent writes great code in the API repo and garbage in the frontend."

"The API repo has strict types and a fast test suite; the frontend has neither and forty always-loaded skills. That's an AX gap, not a model problem."