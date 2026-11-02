# Index documentaire et outils IA

Le point d'entrée du projet reste [init.md](../init.md) : architecture, versions,
commandes Gradle, validation et règles de contribution.
Les consignes communes sont dans [AGENTS.md](../AGENTS.md) ; Claude les importe
depuis [CLAUDE.md](../CLAUDE.md).

## Utilisation de l'index par les agents

Cet index est le point d'accès à la documentation du projet. Au début d'une
tâche, consulter `init.md`, les guidelines ci-dessous, puis les recommandations
pertinentes. Suivre les liens et lire les documents concernés avant de prendre
des décisions ou de modifier le projet, selon les règles d'`AGENTS.md`.

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
  serveur Minestrator, déploiement GitHub Actions limité à cinq minutes et
  voie alternative par le MCP Minestrator.
- [Configuration locale du MCP Minestrator](infrastructure/README.md#configuration-locale-du-mcp) :
  clé dans `.env` ignoré par Git, chargement PowerShell et vérification.

## Dossiers partagés

```text
.claude/                  Dossier de référence pour les deux agents
  config.toml             Configuration MCP de Codex
  docs/ -> ../docs/       Documentation partagée
.codex/ -> .claude/        Même contenu, sans copie ni lien réciproque
docs/                     Originaux de la documentation partagée
.mcp.json                 Configuration MCP de Claude Code
```

Sous Windows, les liens sont des **jonctions de dossiers**, car les liens
symboliques demandent ici des privilèges administrateur. Les jonctions ne sont
pas versionnées : après un clone, exécuter depuis la racine du dépôt :

```powershell
.\scripts\setup-ai.ps1
```

Le script peut être relancé ; il vérifie les destinations et ne remplace aucun
dossier existant. Il doit aussi être relancé après déplacement du dépôt ; dans
ce cas, un ancien lien qui pointe ailleurs doit d'abord être retiré manuellement
sans supprimer sa destination.

Modifier les documents dans `docs/` : ils sont immédiatement visibles dans
`.claude/docs/` et `.codex/docs/`. Les fichiers propres à un agent peuvent
coexister dans `.claude/` ; chaque agent lit son format de configuration.

## CodeGraph

Outil : [@colbymchenry/codegraph](https://github.com/colbymchenry/codegraph),
version vérifiée **1.6.2**. Le programme est installé sur le compte utilisateur ;
les configurations MCP et l'index restent propres à ce projet.

Installation sur une nouvelle machine Windows, avec Node.js/npm disponibles :

```powershell
npm.cmd install --global @colbymchenry/codegraph@1.6.2
# Ouvrir un nouveau terminal si codegraph n'est pas encore dans le PATH.
codegraph init --yes
codegraph status --json
codegraph query ModDevARPG --json
```

Les configurations livrées utilisent `cmd /d /c codegraph serve --mcp` pour
lancer correctement le programme npm sous Windows. Sur Linux/macOS, utiliser
`command = "codegraph"` et `args = ["serve", "--mcp"]` dans le TOML, et les
valeurs équivalentes dans `.mcp.json`.

Redémarrer Claude Code et Codex pour charger le serveur MCP. Dans Claude,
approuver le serveur du projet lorsqu'il le demande, puis vérifier `/mcp`.
Codex ne charge `.codex/config.toml` que pour un projet approuvé ; vérifier
`codex mcp list` depuis ce dépôt et `/mcp` dans une nouvelle session.

L'index généré `.codegraph/` est ignoré par Git. Pendant une session MCP, le
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
