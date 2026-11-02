# Infrastructure, CI et déploiement

## Périmètre et état

Le serveur de développement est hébergé chez **Minestrator**. Le projet est
versionné avec Git dans le dépôt GitHub public
[Analogium/ProjetModPackMC](https://github.com/Analogium/ProjetModPackMC), sur
la branche principale `main`. GitHub Actions assure l'intégration continue.
Le contenu hébergé est appelé « pack » ; ce dépôt produit actuellement un seul
mod, `moddevarpg`, et ne gère pas l'assemblage d'un modpack.

Les versions de référence restent dans [gradle.properties](../../gradle.properties)
et le cadrage dans [init.md](../../init.md) : Minecraft 1.21.11, NeoForge
21.11.48 et Java 21. Le serveur doit disposer d'un environnement compatible ;
le workflow ne provisionne ni Java ni NeoForge chez Minestrator.

Décision du 2 novembre 2026 : les déploiements passent par **GitHub Actions**,
avec un délai maximal de **cinq minutes pour le job**, ou par le **MCP
Minestrator**. Les opérations sur le serveur et les déclenchements par un agent
restent soumis à une autorisation explicite, conformément à `init.md`.

Cette page décrit la configuration versionnée. La présence des secrets,
l'état du serveur et le fonctionnement du MCP Minestrator n'ont pas été
vérifiés lors de sa rédaction. Aucun outil MCP Minestrator n'est disponible
dans la session de rédaction. Sa configuration locale est maintenant présente ;
l'authentification et la connexion restent à valider avec la clé utilisateur.

## Intégration continue

[Build](../../.github/workflows/build.yml) s'exécute à chaque push et pull
request : checkout, installation de Temurin 21, préparation de Gradle et
`./gradlew build`. Un résultat vert confirme le build ; aucun test automatisé
de gameplay n'est présent. La validation en jeu reste distincte.

## Déploiement par GitHub Actions

[Deploy dev server](../../.github/workflows/deploy-dev.yml) s'exécute sur un
push vers `main` ou manuellement avec `workflow_dispatch` :

1. Récupération de la révision et compilation avec Java 21 et Gradle.
2. Sélection du jar dans `build/libs/`, hors sources et Javadoc.
3. Installation de `lftp` et transfert SFTP vers `mods/ModDevARPG.jar`.
4. Demande de redémarrage par l'API Minestrator.

Le nom fixe remplace le jar précédent. Le workflow ne déploie pas les mondes,
les configurations ni d'autres mods. Il reconstruit le mod lui-même et ne
dépend pas du résultat du workflow `Build`, qui s'exécute séparément.

`jobs.deploy.timeout-minutes: 5` limite l'exécution du job complet, préparation,
build, transfert et demande de redémarrage compris. Le temps en file d'attente
n'est pas un temps d'exécution du job. À l'expiration, GitHub annule le job ;
ce mécanisme ne garantit pas que le serveur soit prêt à accueillir les joueurs
en cinq minutes. Voir la [référence GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#jobsjob_idtimeout-minutes).

La concurrence existante utilise le groupe `deploy-dev` avec
`cancel-in-progress: true` : un nouveau déploiement peut annuler le précédent.
Une annulation ou un timeout ne restaure pas le jar précédent et n'annule pas
une demande de redémarrage déjà envoyée. Le transfert actuel écrit directement
le fichier cible ; une interruption pendant l'envoi peut laisser un jar
incomplet. Il n'existe ni rollback ni contrôle automatique de disponibilité.

### Configuration GitHub

Renseigner ces secrets dans les paramètres Actions du dépôt, sans publier leurs
valeurs dans Git, la documentation ou les logs :

| Secret | Usage |
|---|---|
| `SFTP_HOST` | Hôte SFTP fourni par Minestrator |
| `SFTP_PORT` | Port SFTP |
| `SFTP_USER` | Utilisateur SFTP |
| `SFTP_PASS` | Mot de passe SFTP |
| `MINESTRATOR_SERVER_ID` | Serveur cible pour l'API |
| `MINESTRATOR_API_KEY` | Authentification de l'API |

Le compte SFTP doit pouvoir écrire dans `mods/`, et la clé API doit permettre
le redémarrage de la cible. L'EULA Minecraft doit avoir été acceptée par
l'utilisateur ; aucun agent ne l'accepte à sa place.

### Vérification et échec

Après un déploiement autorisé, contrôler le résultat et les étapes du run
GitHub Actions, puis l'état et les logs du serveur : absence d'erreur de
chargement, présence du mod et connexion avec un client compatible. Le succès
de la requête de redémarrage ne suffit pas à valider ces points.

En cas de timeout ou d'échec, relever l'étape atteinte et vérifier l'état du
jar et du serveur avant une nouvelle tentative. Ne pas basculer automatiquement
vers le MCP. Une reprise ou un retour à une révision connue doit utiliser une
des deux voies autorisées et être explicitement autorisé. Préserver les mondes
et configurations ; leur sauvegarde et leur restauration ne sont pas gérées
par le workflow actuel.

## Déploiement par le MCP Minestrator

Cette voie permet une intervention explicitement demandée via les outils MCP
Minestrator connectés. Avant toute écriture : identifier la cible, la révision
et le jar à déployer, vérifier les capacités réellement exposées et s'assurer
qu'aucun déploiement Actions ne s'exécute simultanément. La concurrence GitHub
ne verrouille pas les opérations MCP.

Utiliser les capacités disponibles pour transférer le jar et gérer le serveur,
puis contrôler son état et ses logs. Conserver une trace de la révision, du
résultat et des vérifications, sans secrets. Aucun nom d'outil ni procédure de
transfert MCP n'est présumé tant que le connecteur n'a pas été inspecté.
Si le MCP ne fournit pas les opérations nécessaires, utiliser le workflow
GitHub Actions autorisé ; ne pas improviser un déploiement SFTP local.

La limite de cinq minutes est imposée par le workflow GitHub Actions ; elle
n'est pas un timeout MCP configuré. La connexion du MCP et la validation d'un
déploiement réel restent à réaliser dans une intervention autorisée.

### Configuration locale du MCP

Le serveur officiel utilise `https://mcp.sttr.io/minestrator` en HTTP.
[.claude/config.toml](../../.claude/config.toml), également accessible par
`.codex/config.toml`, configure Codex avec `bearer_token_env_var`.
[.mcp.json](../../.mcp.json) configure Claude Code avec la même variable
`MINESTRATOR_API_KEY`. Aucun secret n'est enregistré dans ces fichiers.

Créer une clé dédiée dans l'espace client Minestrator. Copier
[.env.example](../../.env.example) vers `.env` à la racine si ce fichier
n'existe pas encore, puis remplir `MINESTRATOR_API_KEY=` dans un éditeur local.
Le fichier `.env` est ignoré par Git. Utiliser une valeur brute sans guillemets,
sans préfixe `Bearer` et sans syntaxe `export`.

Les clients MCP ne chargent pas automatiquement `.env`. Depuis la racine du
projet, dans le terminal PowerShell qui lancera le client :

```powershell
$minestratorSettings = Get-Content -Raw -Encoding UTF8 .env | ConvertFrom-StringData
if ([string]::IsNullOrWhiteSpace($minestratorSettings.MINESTRATOR_API_KEY)) {
    throw 'Renseigner MINESTRATOR_API_KEY dans .env avant de continuer.'
}
$env:MINESTRATOR_API_KEY = $minestratorSettings.MINESTRATOR_API_KEY
Remove-Variable minestratorSettings
codex mcp list
codex
# Ou, dans ce même terminal : claude
```

Ces commandes attendent uniquement le format simple `CLE=valeur` du modèle,
avec des commentaires `#` éventuels ; elles n'exécutent pas le contenu du fichier.
Si `codex` n'est pas dans le PATH, appeler l'exécutable installé par son chemin
complet. La variable est propre à ce terminal et aux processus lancés ensuite.
Une application déjà ouverte ne la reçoit pas : utiliser le client lancé depuis
ce terminal, puis vérifier `/mcp` dans sa nouvelle session. La configuration
Claude du projet peut demander une approbation au premier lancement.

`codex mcp list` confirme seulement la configuration, pas l'authentification.
Valider ensuite la connexion et la découverte des outils, sans déclencher de
déploiement ni de redémarrage. Les règles d'autorisation du projet restent
applicables aux actions sur le serveur.

Vérification du 2 novembre 2026 : JSON valide, configuration Minestrator reconnue
par `codex mcp list` avec authentification Bearer. Clé non fournie au moment de
cette vérification ; connexion authentifiée non testée.

Références : [connexion officielle Minestrator](https://minestrator.com/connect/your/ai),
[configuration MCP Codex](https://developers.openai.com/codex/mcp),
[variables dans Claude Code](https://code.claude.com/docs/en/mcp#environment-variable-expansion-in-mcpjson).
