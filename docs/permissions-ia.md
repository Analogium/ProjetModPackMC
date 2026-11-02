# Permissions locales de Codex et Claude

Les opérations courantes du projet disposent de listes d'autorisation
versionnées. Les deux outils demandent des formats distincts, chacun dans son
dossier :

| Outil | Fichier |
|---|---|
| Codex | [.codex/rules/default.rules](../.codex/rules/default.rules) |
| Claude Code | [.claude/settings.json](../.claude/settings.json) |

## Périmètre

Les listes couvrent la consultation Git, l'ajout à l'index, fetch, le changement
ordinaire de branche, les requêtes CodeGraph, toutes les tâches du wrapper
Gradle (`./gradlew`, `.\gradlew`, `gradlew.bat`) et les commandes PowerShell
de lecture. Le code exécuté par Gradle doit rester de confiance : autoriser
le wrapper autorise les scripts du build et leurs effets.

Les suppressions, réécritures Git, commits, pushes, lancements de workflows et
opérations système sensibles demandent confirmation. Les outils du serveur MCP
Minestrator restent soumis à confirmation dans Claude ; aucune autorisation
MCP globale n'est ajoutée à Codex. Les règles de [init.md](../init.md) restent
applicables : une permission technique ne constitue pas une demande de commit
ou de déploiement. L'EULA reste à accepter par l'utilisateur.

Ce sont des listes de commandes courantes, pas une détection exhaustive des
dangers. Les commandes inconnues gardent le traitement habituel de chaque
outil. Aucun interpréteur Python/Node, shell générique, `Bash(*)`, mode de
contournement ou accès total au système n'est autorisé globalement.

## Activation et limites

Redémarrer les clients dans ce dépôt approuvé. Codex charge les fichiers
`.rules` depuis les couches de configuration actives, dont `.codex/rules/` du
projet approuvé. Son réglage local conserve `workspace-write` et `on-request`.
Les règles concernent les préfixes des commandes ; une invocation PowerShell
complexe ou un chemin d'exécutable différent peut encore demander confirmation.
Les restrictions gérées par l'application ou l'administrateur restent prioritaires.

Claude charge les permissions du projet après approbation de celui-ci.
Les règles Bash et PowerShell sont séparées. Les règles `ask` sont prioritaires
sur `allow`. Aucun mode par défaut n'est imposé par le projet : chacun choisit
le sien dans `.claude/settings.local.json`, ignoré par Git, par exemple
`{"permissions": {"defaultMode": "acceptEdits"}}`. Vérifier les permissions
finales avec `/permissions`, car les réglages utilisateur ou locaux peuvent
les compléter.

## Vérification

Le JSON et les exemples de commandes doivent être vérifiés après modification.
Pour Codex, utiliser son vérificateur sans exécuter les commandes ciblées :

```powershell
codex execpolicy check --rules .codex/rules/default.rules -- git status --short
codex execpolicy check --rules .codex/rules/default.rules -- git add -- docs/README.md
codex execpolicy check --rules .codex/rules/default.rules -- git reset --hard
codex execpolicy check --rules .codex/rules/default.rules -- git push origin main
```

Résultats attendus : `allow`, `allow`, `prompt`, `prompt`.
Vérification du 2 novembre 2026 : ces quatre cas, le build Gradle, la suppression
PowerShell et `git switch --discard-changes` ont donné les décisions attendues
avec le vérificateur Codex 0.166.0. Le JSON Claude a été analysé sans erreur ;
Claude n'étant pas disponible dans le PATH, son chargement réel reste à vérifier.
Une modification de ces fichiers ne remplace pas les permissions de la session
déjà ouverte. Ne pas prétendre que toute demande de confirmation disparaîtra.

Références : [règles Codex](https://developers.openai.com/codex/rules),
[permissions Claude Code](https://code.claude.com/docs/en/permissions).
