# Index documentaire et outils IA

Le point d'entrée du projet reste [init.md](../init.md) : architecture, versions,
commandes Gradle, validation et règles de contribution.
Les consignes communes sont dans [AGENTS.md](../AGENTS.md) ; Claude les importe
depuis [CLAUDE.md](../CLAUDE.md).

## Utilisation de l'index par les agents

Cet index est le point d'accès à la documentation du projet. Au début d'une
tâche, lire `init.md`, puis seulement les documents ci-dessous utiles à la
tâche, avant de prendre des décisions ou de modifier le projet, selon les
règles d'`AGENTS.md`.

CodeGraph complète cette lecture pour l'exploration du code ; il ne remplace
pas l'index documentaire. Lire directement les fichiers Markdown référencés.
Tout nouveau document doit être accessible depuis cet index, directement ou
via un sous-index ; maintenir les liens lors des déplacements et suppressions.

## Guidelines

- [Vision du projet](guidelines/README.md) : un ARPG avec des mécaniques de
  gestion et de hack and slash.

## Recommandations

- [Création et génération de structures](recommandations/structure/README.md) :
  outils, processus de construction et bonnes pratiques pour Minecraft 1.21.11.

## Plans d'implémentation

- [Placement des structures inspiré de MineColonies](implementation-plans/placement-structures.md) :
  périmètre proposé, étapes, critères de validation et suivi du statut
  (`todo`, `active`, `done`) avec la branche d'implémentation.

- [Donjons procéduraux](implementation-plans/donjons-proceduraux.md) : assemblage,
  intégration au monde et validation des parcours.
- [Évolution de base de l'Overworld](implementation-plans/evolution-overworld.md) :
  paliers, transitions et état persistant.
- [Système monétaire](implementation-plans/systeme-monetaire.md) : comptes,
  opérations et cohérence des paiements.
- [Flotte maritime et convois](implementation-plans/flotte-convois.md) : navires,
  trajets et conservation des cargaisons.

## Infrastructure

- [Hébergement, CI et déploiement](infrastructure/README.md) : Git/GitHub,
  serveur Minestrator, déploiement GitHub Actions par tag de version, limité à cinq minutes, et
  voie alternative par le MCP Minestrator.
- [Configuration locale du MCP Minestrator](infrastructure/README.md#configuration-locale-du-mcp) :
  clé dans `.env` ignoré par Git, chargement PowerShell et vérification.

## Dossiers des outils IA

- [Permissions locales de Codex et Claude](permissions-ia.md) : listes
  d'autorisation des commandes courantes, confirmations et activation.

```text
AGENTS.md                 Consignes communes (lu nativement par Codex)
CLAUDE.md                 Importe AGENTS.md pour Claude Code
.claude/settings.json     Permissions de Claude Code
.mcp.json                 Serveurs MCP de Claude Code
.codex/config.toml        Serveurs MCP et mode d'approbation de Codex
.codex/rules/             Permissions de Codex
docs/                     Documentation partagée
```

Tous ces fichiers sont versionnés : aucun lien ni script n'est nécessaire
après un clone. Les réglages personnels vont dans `.claude/settings.local.json`,
ignoré par Git. Un ancien clone qui contient encore les jonctions `.codex` ou
`.claude/docs` créées par l'ancien script doit les supprimer avant de récupérer
cette version (`rmdir .codex` et `rmdir .claude\docs` sous Windows : supprime
le lien, pas sa destination).

## CodeGraph

Outil : [@colbymchenry/codegraph](https://github.com/colbymchenry/codegraph),
version vérifiée **1.6.2**. Le programme est installé sur le compte utilisateur ;
les configurations MCP et l'index restent propres à ce projet.

Installation sur une nouvelle machine, avec Node.js/npm disponibles
(sous PowerShell, écrire `npm.cmd` au lieu de `npm`) :

```sh
npm install --global @colbymchenry/codegraph@1.6.2
# Ouvrir un nouveau terminal si codegraph n'est pas encore dans le PATH.
codegraph init --yes
codegraph status --json
codegraph query ModDevARPG --json
```

Les configurations livrées sont identiques sur tous les systèmes : `node`
lance `codegraph serve --mcp` via le shell du système (`cmd` sous Windows,
`sh` ailleurs), ce qui résout le script npm `codegraph.cmd` sous Windows.
Seuls `node` et `codegraph` doivent être dans le PATH ; aucune adaptation
par système n'est nécessaire.

Redémarrer Claude Code et Codex pour charger le serveur MCP. Dans Claude,
approuver le serveur du projet lorsqu'il le demande, puis vérifier `/mcp`.
Codex ne charge `.codex/config.toml` que pour un projet approuvé ; vérifier
`codex mcp list` depuis ce dépôt et `/mcp` dans une nouvelle session.

L'index généré `.codegraph/` (`.codegraph-wsl/` sous WSL) est ignoré par Git. Pendant une session MCP, le
serveur surveille les changements. Hors session, `codegraph sync` actualise
l'index ; `codegraph index` le reconstruit. Aucun accès au serveur Minecraft
n'est nécessaire.

Références : [installation CodeGraph](https://colbymchenry.github.io/codegraph/getting-started/installation/),
[configuration MCP Codex](https://developers.openai.com/codex/mcp/).

## Vérification de l'installation

Le 2 novembre 2026 : liens vérifiés depuis les trois chemins, script relancé
deux fois sans modification des liens, serveur reconnu par `codex mcp list`,
index complet de 7 fichiers (dont les 3 fichiers Java), 78 nœuds et 100 relations.
Une connexion MCP a listé `codegraph_explore` et obtenu `ModDevARPG.java` par
une requête réelle. Claude Code n'est pas installé sur cette machine : sa
configuration JSON a été contrôlée et sa commande de lancement testée via MCP.
Le build Gradle et le jeu n'ont pas été lancés pour cette modification de
documentation et d'outillage.

Le 2 novembre 2026, sous WSL (Linux) avec Claude Code : CodeGraph 1.6.2
installé, index de 7 fichiers, 78 nœuds et 100 relations dans `.codegraph-wsl/`.
Le lanceur `node` commun a répondu à `initialize`, exposé `codegraph_explore`
et s'est arrêté à la fermeture de stdin sans processus orphelin.

Le même jour, sous Windows natif (Node 22.14 portable, CodeGraph 1.6.2) : index
`.codegraph/` créé, lanceur `node` de `.mcp.json` validé (`initialize`,
`codegraph_explore` listé, appel réel trouvant `ModDevARPG.java`).
Sous Windows, le processus serveur de CodeGraph reste actif après la
déconnexion du client, avec l'ancien lanceur `cmd /d /c` comme avec le
nouveau : c'est un comportement de CodeGraph, pas du lanceur.
`gradlew.bat build` réussit après le passage de `gradlew.bat` en CRLF.

Ces vérifications concernent l'ancienne organisation : jonctions `.codex` et
`.claude/docs`, script `setup-ai.ps1` et trois fichiers Java. Le passage aux
dossiers `.claude/` et `.codex/` versionnés n'a pas été revérifié dans Codex.
