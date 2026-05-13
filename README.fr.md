# Everything-Windsurf-Codex / EWC

<p align="center">
  <strong>Un workflow de collaboration multi-agent avec Windsurf / Cascade comme point d'entrée principal et Codex comme agent d'exécution délégué</strong>
</p>

<p align="center">
  <a href="./LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
  <img alt="Windsurf" src="https://img.shields.io/badge/Windsurf-main%20workspace-0EA5E9.svg">
  <img alt="Codex" src="https://img.shields.io/badge/Codex-MCP%20%2F%20CLI%20fallback-7C3AED.svg">
  <img alt="Validation" src="https://img.shields.io/badge/Validation-PASS-brightgreen.svg">
</p>

<p align="center">
  <a href="./README.md">简体中文</a> |
  <a href="./README.en.md">English</a> |
  <a href="./README.es-MX.md">Español (México)</a> |
  <strong>Français</strong>
</p>

## Présentation du projet

Everything-Windsurf-Codex / EWC est un workflow léger de collaboration multi-agent. Ce n'est pas un plugin Windsurf et il ne vise pas à remplacer Cascade par Codex dans Windsurf.

L'idée centrale est simple : l'utilisateur continue à travailler dans Windsurf, tandis que Cascade reste responsable de comprendre la demande, de découper la tâche, de choisir le canal d'exécution, de limiter les permissions, de relire les résultats et de livrer la réponse finale. Codex MCP et Codex CLI fallback agissent comme des agents d'exécution délégués pour les explorations légères, les tâches longues, les analyses à grande échelle, l'exécution par lots, le fallback réseau et les logs vérifiables.

Si ce projet vous aide d'une manière ou d'une autre, pensez à lui donner une Star pour m'encourager.

En bref :

- **Windsurf / Cascade** : point d'entrée principal côté utilisateur, orchestrateur, relecteur et couche de livraison finale.
- **Codex MCP** : agent d'exécution léger délégué par Cascade pour les petites tâches.
- **Codex CLI fallback** : agent d'exécution délégué par Cascade pour les tâches longues, les analyses à grande échelle, le fallback réseau, l'exécution par lots et les logs vérifiables.

## Abstraction de plus haut niveau : l'auteur l'appelle HAOP

Il est utile de préciser que l'idée centrale d'EWC n'est pas liée à Windsurf, et qu'elle n'est pas liée à Codex non plus.

Pour parler de cette méthode plus précisément, l'auteur appelle HAOP l'abstraction de plus haut niveau derrière EWC : Harness-Agent Orchestration Protocol. Dans ce document, HAOP est un nom introduit par l'auteur pour décrire ces limites de collaboration ; cela n'implique pas qu'il s'agisse déjà d'un standard établi dans l'industrie.

Ce dépôt utilise Windsurf / Cascade + Codex MCP / Codex CLI fallback comme implémentation de référence déjà validée, parce que c'est la combinaison d'outils que l'auteur utilise actuellement et qu'il a vérifiée en pratique.

À un niveau d'abstraction plus élevé, EWC se comprend mieux comme un modèle portable d'orchestration multi-agent pour l'AI coding :

- **Frontend AI coding harness** : responsable de l'interaction avec l'utilisateur, du découpage des tâches, du contrôle des permissions, de la relecture des résultats et de la livraison finale.
- **Backend CLI-capable agent** : responsable des tâches longues, des analyses à grande échelle, de l'exécution par lots, du fallback réseau et de la sortie des logs.
- **Périmètre d'autorisation explicite** : toute écriture doit être limitée à des fichiers ou répertoires précis.
- **Chaîne de logs vérifiable** : l'exécution backend doit laisser un prompt, un log et un résultat final afin que l'outil frontend et l'utilisateur puissent les relire.

Autrement dit, dès qu'une autre combinaison d'outils respecte ces mêmes limites, la méthode de collaboration EWC peut aussi y être transférée. Codex n'est qu'un des exemples d'exécution actuellement validés, et Windsurf / Cascade n'est qu'un des exemples de frontend harness actuellement validés.

## Prototype statique de HAOP Console

Ce dépôt contient également un prototype statique de **HAOP Console**, qui montre comment plusieurs agents en arrière-plan, profils de permission, modèles de délégation, historique d'exécution et chaînes de logs vérifiables pourraient être gérés à l'avenir.

Il est important de souligner que HAOP Console n'est pas un espace de travail quotidien pour coder. Il ne remplace pas Windsurf / Cascade, Cursor, Claude Code, VS Code Agent ni aucun autre foreground AI coding harness. Le travail quotidien reste dans l'agent de premier plan ; HAOP Console est seulement une interface de gestion compagnon pour la couche d'exécution.

Vous pouvez consulter le prototype ici :

```text
prototype/haop-console.html
```

## Pourquoi EWC

Beaucoup d'utilisateurs apprécient Windsurf parce que l'IDE, le panneau de chat, l'aperçu des fichiers et le rythme d'interaction restent au même endroit.

Mais en pratique, certaines tâches ne sont pas idéales à attendre dans le panneau de chat :

- Scanner un grand dépôt.
- Rédiger de longs documents ou brouillons.
- Effectuer des modifications par lots, du formatage ou une analyse de tests.
- Conserver un journal complet pour relecture ultérieure.
- Gérer des appels MCP trop longs ou sans retour de progression.
- Accéder directement depuis Windsurf / Cascade à GitHub ou à d'autres ressources étrangères de façon instable.

EWC ne remplace pas Windsurf et ne contourne pas Cascade. Il garde l'utilisateur dans Windsurf et permet à Cascade de déléguer à différents agents d'exécution, tandis que Codex traite comme agent backend délégué les tâches longues, répétitives, sensibles aux logs ou sensibles au réseau.

## Philosophie de conception : non intrusif et sans dépendance

EWC ne demande pas d'installer un nouveau plugin IDE, de déployer un service SaaS ni de déplacer votre projet vers une plateforme particulière.

Il est principalement composé de documents Markdown, de workflows, de skills et de règles de prompt. Il s'appuie sur une capacité que Windsurf / Cascade possède déjà : lire des documents, comprendre des règles et collaborer sous contraintes.

Cela fait d'EWC une méthode de collaboration portable plutôt qu'un système fermé qui enferme l'utilisateur dans une seule chaîne d'outils :

- **Non intrusif** : vous pouvez commencer par lire le README et copier un petit ensemble de règles.
- **Pas de verrouillage sur une seule plateforme** : les idées centrales sont la séparation des rôles, le choix du canal, les limites de sécurité et les logs vérifiables.
- **Pas de dépendance à un service d'arrière-plan** : aucun service supplémentaire à enregistrer, déployer ou maintenir.
- **Pas d'autorité illimitée pour l'IA** : le but n'est pas de donner plus de liberté à l'IA, mais de faire collaborer plusieurs agents dans des limites claires.

## Modèle de collaboration principal

```text
L'utilisateur continue à formuler ses demandes dans Windsurf
        
Cascade comprend l'intention, découpe la tâche et choisit un canal
        
Petites tâches : Cascade ou Codex MCP
Tâches longues / réseau / avec logs : Codex CLI fallback
        
Codex exécute dans un sandbox et un périmètre explicitement autorisé
        
Cascade relit les sorties, diffs, logs et résultats de validation
        
L'utilisateur valide le résultat dans Windsurf
```

## Choix du canal

| Scénario | Canal recommandé |
|---|---|
| Analyse rapide en lecture seule d'un ou deux fichiers locaux | Cascade ou Codex MCP |
| Petites modifications avec périmètre clair | Cascade ou Codex MCP + `workspace-write` |
| Grands scans, tâches longues, modifications par lots, analyse de tests | Codex CLI fallback |
| Tâches nécessitant des logs complets ou une revue de progression | Codex CLI fallback |
| MCP est trop long ou manque de retour de progression | Codex CLI fallback |
| GitHub / ressources étrangères instables | Codex CLI fallback |
| Décisions métier, arbitrages techniques, validation finale | Utilisateur + Cascade |

## Naturellement adapté au split-network

Dans les environnements où les ressources nationales sont accessibles directement tandis que les ressources étrangères passent par un proxy, ou dans tout autre contexte réseau complexe, EWC s'adapte naturellement à un mode split-network.

Il n'oblige pas tous les outils, toutes les tâches et tous les accès réseau à passer par un seul point d'entrée. Il sépare plutôt l'interaction, la répartition, l'exécution et l'accès réseau en canaux configurables indépendamment :

- **Windsurf / Cascade** : reste le point d'entrée principal pour l'interaction locale, la compréhension des demandes, la répartition des tâches, la relecture des résultats et la validation finale.
- **Codex MCP** : gère les petites tâches légères et peut fonctionner dans un environnement MCP indépendant si nécessaire.
- **Codex CLI fallback** : gère les tâches longues, les grands scans, l'accès à GitHub / ressources étrangères, l'exécution par lots et les logs complets.

Ainsi, même si l'accès direct de Windsurf / Cascade à certaines ressources étrangères est instable, il n'est pas nécessaire de forcer une modification de l'environnement réseau de Windsurf. Ces tâches peuvent être déléguées au canal le plus adapté : Codex CLI fallback.

Autrement dit, EWC ne considère pas l'instabilité réseau comme un problème à résoudre dans un seul outil. Grâce à la séparation multi-agent, il distingue naturellement l'interaction locale, l'accès direct national, l'accès étranger via proxy et l'exécution en arrière-plan.

## Chaîne de logs vérifiables

La valeur clé du CLI fallback est la vérifiabilité. Une exécution standard devrait conserver au moins :

```text
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.prompt.txt
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.log
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.last.md
```

Cela permet à l'utilisateur et à Cascade de relire :

- **Prompt** : ce qui a été demandé à Codex.
- **Log** : ce qui s'est passé pendant l'exécution.
- **Last answer** : la réponse finale produite par Codex.

## Limites de sécurité

- **Ne pas lire les secrets** : ne jamais lire ni afficher de secrets, tokens, `auth.json`, clés privées ou autres identifiants.
- **Pas de permission d'écriture par défaut** : Codex ne peut modifier des fichiers que si l'utilisateur ou Cascade l'autorise explicitement.
- **Le périmètre d'écriture doit être explicite** : le prompt doit lister les fichiers ou dossiers autorisés.
- **Pas de modification hors périmètre** : les fichiers hors du périmètre autorisé ne doivent pas être modifiés.
- **Relecture obligatoire** : Cascade relit les diffs, lance la validation et demande des corrections si nécessaire.
- **Ne pas remplacer les règles métier** : EWC est une couche d'orchestration et de validation, pas une source de règles métier.
- **Encodage cohérent** : README, workflows, skills et prompts devraient utiliser UTF-8 without BOM.

## Structure du dépôt

```text
.
 README.md
 README.en.md
 README.es-MX.md
 README.fr.md
 LICENSE
 NOTICE.md
 .gitignore
 ewc/
   README.md
   verify-ewc.ps1
 workflows/
   ewc.md
 global_workflows/
   codex-collab.md
 skills/
   ewc-maintenance/
     SKILL.md
   codex-delegation/
      SKILL.md
 examples/
    mcp_config.codex.json
 prototype/
   README.md
   haop-console.html
```

## Mode d'emploi

La façon la plus simple d'utiliser EWC n'est pas forcément de copier tous les fichiers à la main. Vous pouvez commencer par parler à l'IA dans Windsurf et lui donner le lien de ce projet pour qu'elle apprenne le modèle de collaboration EWC.

Vous pouvez dire ceci dans Windsurf / Cascade :

```text
Veuillez lire et apprendre le modèle de collaboration de ce projet :
https://github.com/LOrz-3/everything-windsurf-codex

Ensuite, veuillez collaborer avec moi selon le modèle EWC :
1. Garder Windsurf / Cascade comme point d'entrée principal, orchestrateur, relecteur et couche de livraison finale.
2. Utiliser Codex MCP seulement pour les petites tâches légères.
3. Utiliser Codex CLI fallback pour les tâches longues, grands scans, exécution par lots, fallback réseau ou tâches nécessitant des logs complets.
4. Avant que Codex écrive dans des fichiers, le périmètre autorisé doit être explicitement approuvé.
5. À la fin, expliquer le canal d'exécution, les fichiers modifiés, le résultat de validation et les risques.
```

Si votre IA peut accéder à GitHub, elle peut lire directement le README, les workflows, les skills et les règles de contribution. Si l'accès à GitHub est instable, clonez d'abord ce dépôt ou copiez les fichiers clés dans votre workspace Windsurf actuel avant de demander à l'IA de les lire.

## Démarrage rapide

### 1. Copier le workflow

Copiez le fichier workflow dans le dossier workflow de votre projet Windsurf :

```text
workflows/ewc.md -> <workspace>/.windsurf/workflows/ewc.md
```

### 2. Copier les skills

Copiez les fichiers de skills dans le dossier skills de Windsurf :

```text
skills/ewc-maintenance/SKILL.md
skills/codex-delegation/SKILL.md
```

### 3. Configurer Codex MCP

Utilisez ce modèle comme référence :

```text
examples/mcp_config.codex.json
```

Le modèle ne contient aucune vraie API key ni chemin local privé.

### 4. Lancer la validation

Depuis la racine du dépôt :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

Résultat attendu :

```text
Result: PASS
```

## Public cible

- Les utilisateurs qui aiment le workflow Windsurf et veulent continuer à formuler et valider le travail dans Windsurf.
- Les utilisateurs qui veulent utiliser Codex pour les tâches longues, les grands scans et l'exécution par lots.
- Les utilisateurs qui veulent que les tâches IA disposent de logs vérifiables et auditables.
- Les utilisateurs qui veulent des limites claires entre MCP et CLI fallback.
- Les utilisateurs qui veulent construire leur propre workflow léger Everything-Windsurf-Codex.

## Ce que ce projet n'est pas

- Un remplacement des règles métier du projet.
- Un moyen de contourner Cascade ou la relecture humaine.
- Un outil pour manipuler secrets, tokens ou clés privées.
- Une façon de traiter Codex comme un agent d'écriture illimité.
- Un modèle à copier dans tous les projets sans adapter les chemins locaux et permissions.

## Contribution et maintenance

Les Issues et Pull Requests sont les bienvenues pour les suggestions, corrections et améliorations de documentation.

Ce projet privilégie le positionnement suivant : Windsurf est le point d'entrée principal, Cascade gère la répartition et la relecture, et Codex MCP/CLI fallback effectue une exécution contrôlée. Les changements qui touchent au positionnement central, aux limites de permissions, à la stratégie de logs ou aux règles de sécurité doivent être discutés et validés avec soin.

Si vous contribuez régulièrement et comprenez les limites de sécurité et les principes de maintenance du projet, vous pouvez contacter l'auteur pour discuter d'une maintenance collaborative.

À lire avant de contribuer :

- [Guide de contribution](CONTRIBUTING.md)
- [Code de conduite](CODE_OF_CONDUCT.md)
- [Politique de sécurité](SECURITY.md)

## Topics GitHub suggérés

Si vous publiez ou forkez ce projet sur GitHub, les topics suggérés sont :

```text
windsurf
codex
cascade
mcp
workflow
ai-coding
cli-fallback
developer-tools
```

## Remerciements

EWC s'inspire des idées de collaboration multi-outils explorées dans [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code).

Merci au projet `everything-claude-code` pour son exploration des workflows entre différents AI coding harnesses, des règles partagées, de l'accumulation de skills et des modèles d'adaptation d'outils. EWC reprend l'idée de conventions de collaboration partagées avec des adaptateurs propres à chaque outil, et la réorganise indépendamment pour le scénario Windsurf + Cascade + Codex MCP/CLI fallback.

Un remerciement spécial à [@why41bg](https://github.com/why41bg) pour son soutien dans l'exploration de ce projet et pour m'avoir donné l'occasion d'expérimenter et de valider le workflow Codex GPT-5.4.

Ce projet est un système indépendant de workflow Windsurf + Cascade + Codex MCP/CLI fallback. Il n'est pas affilié, approuvé ni maintenu par les auteurs originaux d'ECC.

Si vous copiez ou redistribuez du code, des scripts, des modèles ou de la documentation de tiers, conservez les mentions de copyright et les textes de licence correspondants.

## Licence

MIT License. Voir [LICENSE](LICENSE).
