# init.md : comprendre et modifier le projet

Point d'entrée du projet, pour les humains comme pour les agents.
**À lire avant toute modification, à mettre à jour après** (voir [§ 8](#8-modifier-le-projet)).

Dernière vérification de l'état décrit ici : 2026-11-01, commit `84340a2`.

## 1. Fiche du projet

| | |
|---|---|
| Nature | Un seul mod Minecraft (pas un modpack, malgré le nom du dépôt) |
| Nom / identifiant | ModDevARPG / `moddevarpg` |
| Minecraft | 1.21.11 uniquement (plage stricte `[1.21.11]`) |
| NeoForge | 21.11.48 |
| Java | 21 |
| Build | Gradle 9.2.1, ModDevGradle 2.0.148 |
| Noms du code | Mappings officiels Mojang, Parchment 2025.12.20 pour les paramètres |
| Dépôt | <https://github.com/Analogium/ProjetModPackMC> (public), branche `main` |
| Licence | All Rights Reserved pour le mod ; MIT pour les fichiers du template ([TEMPLATE_LICENSE.txt](TEMPLATE_LICENSE.txt)) |
| Hébergement | Serveur de développement chez Minestrator |

Les versions et l'identité du mod sont définies dans [gradle.properties](gradle.properties). C'est la référence en cas de désaccord avec ce fichier.

## 2. État actuel

Le projet **ne contient encore aucun gameplay** : une classe de mod vide et un gametest de chargement. Les exemples du template NeoForge MDK (bloc, item, onglet créatif, config de démonstration) ont été retirés. Le [README.md](README.md) présente brièvement le projet et renvoie vers ce fichier.

| Point vérifié | Résultat |
|---|---|
| `./gradlew build` en local | OK, produit `build/libs/moddevarpg-1.0.0.jar` |
| Workflow `Build` sur GitHub | OK sur `84340a2` |
| Client de développement | `runClient` sous Windows le 2026-11-02, avec les exemples du template : mod chargé, monde solo créé, rejoint, sauvegardé et quitté sans erreur. Non relancé depuis leur retrait |
| `gradlew.bat build` sous Windows | OK le 2026-11-02, après retrait des exemples |
| Serveur dédié | `runServer` sous Windows le 2026-11-02, avec les exemples : mod chargé, monde prêt, aucune erreur liée au mod ; aucune connexion de joueur testée. Après leur retrait, chargement sur serveur couvert par le gametest |
| Déploiement | Tag `v1.0.0` le 2026-11-02 : workflow réussi, `mods/ModDevARPG.jar` présent sur le serveur DEV, mod chargé et serveur démarré d'après la console. Aucune connexion de joueur testée (voir [infrastructure](docs/infrastructure/README.md)) |
| Tests automatisés | Gametest `moddevarpg:mod_loads` (chargement du mod sur serveur de test) : `runGameTestServer` OK sous Windows le 2026-11-02 ; un échec volontaire donne bien `BUILD FAILED`. Pas encore exécuté dans GitHub Actions |

## 3. Cadrage

**Dans le périmètre**

- Un seul mod NeoForge, `moddevarpg`, pour Minecraft 1.21.11 et Java 21.
- Le mod doit fonctionner sur le client et sur un serveur dédié.
- Déploiement sur le serveur de développement Minestrator.

**Sur décision du responsable du projet uniquement**

- Changer de version de Minecraft, de NeoForge ou de Java, ou ajouter un autre loader (Fabric, Forge).
- Gérer un modpack ou plusieurs mods dans ce dépôt.
- Changer le `mod_id`, la licence ou le mode de déploiement.
- Ajouter une dépendance vers un autre mod.

**Vision du gameplay**

Le but du projet est de concevoir un **ARPG avec des mécaniques de gestion et de
hack and slash** dans Minecraft. Les [guidelines de conception](docs/guidelines/README.md)
consignent cette orientation. Les systèmes précis restent à définir : ne pas
inventer de fonctionnalité et s'en tenir à la demande reçue.

- Objectif du mod : porter cette expérience ARPG, gestion et hack and slash.
- Public visé : à définir.
- Fonctionnalités prévues : à préciser pour chacun de ces axes.

## 4. Structure du dépôt

```text
├── init.md                     Ce fichier
├── AGENTS.md                   Consignes communes à Codex et Claude
├── CLAUDE.md                   Importe AGENTS.md
├── docs/                       Documentation partagée, dont l'installation IA
├── .claude/settings.json       Permissions de Claude Code
├── .codex/                     Configuration MCP et permissions de Codex
├── .mcp.json                   Serveurs MCP CodeGraph et Minestrator pour Claude Code
├── build.gradle                Configuration du build et des lancements
├── gradle.properties           Versions et identité du mod
├── .github/workflows/
│   ├── build.yml               Build, gametests et artefact à chaque push de branche
│   └── deploy-dev.yml          Déploiement sur le serveur de dev au push d'un tag v*
└── src/main/
    ├── java/com/analogium/moddevarpg/
    │   └── ModDevARPG.java        Point d'entrée commun (client et serveur)
    ├── resources/data/moddevarpg/test_instance/mod_loads.json   Gametest de chargement
    └── templates/META-INF/neoforge.mods.toml                    Métadonnées du mod
```

**Ne pas modifier à la main ni committer** (générés, ignorés par Git) : `build/`, `bin/`, `.gradle/`, `run/`, `.vscode/`.

Le dossier `src/generated/resources/` n'existe pas encore. Il recevra la sortie de `runData` : il faudra le committer, mais changer le générateur plutôt que ses fichiers.

**Outils IA.** Claude Code utilise `.claude/` et `.mcp.json`, Codex utilise
`.codex/` ; tous deux lisent les consignes d'`AGENTS.md` et la documentation
`docs/`. Tout est versionné : rien à recréer après un clone. CodeGraph fournit
un index local du code, ignoré par Git dans `.codegraph/` (`.codegraph-wsl/`
sous WSL) ; suivre [docs/README.md](docs/README.md) pour l'installer et charger
le serveur MCP. Aucun réglage de déploiement ni aucune dépendance du mod ne
sont modifiés par cette installation.

Les [recommandations sur les structures](docs/recommandations/structure/README.md)
décrivent les outils de construction, l'export NBT et la génération Jigsaw ;
elles ne constituent pas une fonctionnalité déjà implémentée.

Les plans de fonctionnalités sont conservés dans `docs/implementation-plans/`
et référencés depuis l'[index documentaire](docs/README.md). Chaque plan suit
son statut (`todo`, `active`, `done`) et sa branche d'implémentation ; un plan
documenté ne signifie pas que la fonctionnalité existe déjà.

Les permissions IA locales sont définies dans `.codex/rules/default.rules`
(Codex) et `.claude/settings.json` (Claude). Voir le
[guide des permissions](docs/permissions-ia.md) pour leur activation et leurs
limites. Elles conservent les confirmations pour les opérations sensibles.

## 5. Fonctionnement du code

**Démarrage.** NeoForge instancie les classes annotées `@Mod`.

1. [ModDevARPG.java](src/main/java/com/analogium/moddevarpg/ModDevARPG.java) est le point d'entrée commun, exécuté côté client et côté serveur. Il ne contient aujourd'hui que `MODID` et `LOGGER`. Son constructeur peut recevoir `IEventBus` et `ModContainer` pour brancher registres, écouteurs et config.
2. Le code propre au client va dans une classe annotée `@Mod(value = ModDevARPG.MODID, dist = Dist.CLIENT)`, qui ne s'exécute que sur le client. Elle n'existe pas encore.
3. `FMLCommonSetupEvent`, puis `FMLClientSetupEvent` sur le client, servent au reste de l'initialisation.

**Séparation client/serveur.** Le code commun ne doit jamais référencer `net.minecraft.client.*` : un serveur dédié planterait au chargement. Ce code va dans la classe client ou dans des classes appelées uniquement depuis celle-ci. Le gametest de chargement détecte ce type d'erreur en CI.

**Registres.** Blocs, items et onglets se déclarent par des `DeferredRegister` (par exemple `DeferredRegister.createBlocks(MODID)`), branchés sur le bus du mod dans le constructeur. L'identifiant complet prend la forme `moddevarpg:<nom>`.

**Événements.** Deux bus coexistent :

- le bus du mod (`IEventBus` reçu par le constructeur) pour le chargement et l'enregistrement ;
- le bus du jeu (`NeoForge.EVENT_BUS`) pour les événements en cours de partie.

`@EventBusSubscriber` enregistre automatiquement les méthodes statiques annotées `@SubscribeEvent` d'une classe.

**Configuration.** Aucune config n'existe. Une config se définit avec `ModConfigSpec` et s'enregistre par `modContainer.registerConfig(ModConfig.Type.COMMON, SPEC)` ; une config `COMMON` est écrite dans `config/moddevarpg-common.toml`, un fichier par côté, sans synchronisation entre serveur et client.

**Gametests.** Les tests sont des ressources `data/moddevarpg/test_instance/*.json`. [mod_loads.json](src/main/resources/data/moddevarpg/test_instance/mod_loads.json) utilise la fonction vanilla `minecraft:always_pass` et la structure `minecraft:empty` : il réussit dès que le serveur de test démarre avec le mod. Un test de comportement demandera une fonction enregistrée dans le registre `Registries.TEST_FUNCTION`.

**Ressources et métadonnées.**

- `src/main/resources/` et `src/generated/resources/` sont copiés dans le jar ; les fichiers `*.bbmodel` en sont exclus.
- La tâche `generateModMetadata` remplace les `${...}` de [neoforge.mods.toml](src/main/templates/META-INF/neoforge.mods.toml) à partir de `gradle.properties`, via la liste `replaceProperties` de [build.gradle](build.gradle). Une propriété absente fait échouer le build.

## 6. Commandes

Avec Git Bash, Linux ou macOS : `./gradlew <tâche>`. Avec PowerShell : `.\gradlew <tâche>`. Le JDK 21 est requis.

| Tâche | Effet |
|---|---|
| `build` | Compile et produit `build/libs/moddevarpg-<version>.jar` |
| `runClient` | Lance le jeu avec le mod |
| `runServer` | Lance un serveur dédié sans interface |
| `runData` | Lance la génération de données vers `src/generated/resources/` |
| `runGameTestServer` | Lance tous les gametests sur un serveur de test puis s'arrête ; échoue si un test requis échoue |
| `installClient` | Copie le jar en `ModDevARPG.jar` dans l'instance CurseForge `ModDevARPG` (ou `-PclientModsDir=...`), pour jouer sur le serveur de dev avec un vrai compte ; voir [README.md](README.md) |
| `clean` | Supprime `build/` sans toucher au code |
| `--refresh-dependencies` | Option à ajouter à une tâche si des bibliothèques manquent dans l'IDE |

- Toutes les configurations de lancement partagent le dossier `run/`. Les logs sont dans `run/logs/`.
- `runServer` ne demande pas l'EULA : en environnement de développement, NeoForge démarre le serveur sans `run/eula.txt`. Un vrai serveur (Minestrator, ou le jar lancé hors Gradle) l'exige ; son acceptation revient à la personne qui le lance.
- Les logs de lancement sont au niveau INFO ; passer `logLevel` en DEBUG ou ajouter des marqueurs dans [build.gradle](build.gradle) pour diagnostiquer, sans committer.
- Sous VS Code, les lancements Client, Server, Data et GameTestServer se trouvent dans `.vscode/launch.json`, un fichier local à chaque machine.
- `disableRecompilation = false` dans [build.gradle](build.gradle) rend les sources de Minecraft disponibles, mais demande de la mémoire. Sur une machine limitée (Codespace de 8 Go, par exemple), passer à `true` localement sans committer ce changement.
- [.gitattributes](.gitattributes) impose LF dans le dépôt et CRLF pour les `.bat` ; `gradlew` est versionné exécutable. Inutile de modifier `core.autocrlf`.

## 7. Intégration et déploiement

| Workflow | Déclencheur | Action |
|---|---|---|
| [build.yml](.github/workflows/build.yml) | Chaque push de branche | `./gradlew build runGameTestServer` avec Temurin 21 ; jar publié en artefact (14 jours) |
| [deploy-dev.yml](.github/workflows/deploy-dev.yml) | Push d'un tag `v*` (doit valoir `v` + `mod_version`), ou lancement manuel | Build et gametests, envoi SFTP via `.tmp` puis renommage, ancien jar gardé en `.prev`, redémarrage par l'API Minestrator ; job limité à 5 minutes, jamais annulé par un déploiement suivant |

- **Un workflow `Build` vert prouve que le mod compile et se charge sur un serveur de test**, pas que le gameplay fonctionne.
- Le déploiement redémarre un vrai serveur, ce qui coupe les joueurs connectés. Pousser un tag `v*` déclenche ce déploiement.
- Le jar garde un nom fixe sur le serveur pour éviter d'y accumuler les versions ; la version précédente reste en `ModDevARPG.jar.prev` pour un retour manuel.
- Secrets GitHub attendus : `SFTP_HOST`, `SFTP_PORT`, `SFTP_USER`, `SFTP_PASS`, `MINESTRATOR_SERVER_ID`, `MINESTRATOR_API_KEY`. Leur présence n'a pas pu être vérifiée.
- Le dépôt est public : aucun secret, mot de passe, adresse de serveur ni identifiant Minestrator dans les fichiers versionnés, y compris ici.

Les déploiements passent par GitHub Actions ou par le MCP Minestrator, après
autorisation explicite pour les actions d'un agent. La limite de cinq minutes
couvre le job Actions complet, build compris ; elle ne garantit pas la
disponibilité du serveur.
Voir la [documentation d'infrastructure](docs/infrastructure/README.md) pour
les prérequis, les vérifications et les limites de chaque voie. La configuration
locale a été relue le 2 novembre 2026 ; l'état historique du § 2 n'a pas été
revérifié sur GitHub ou Minestrator.

Le MCP Minestrator est configuré pour Codex dans `.codex/config.toml` et pour
Claude Code dans `.mcp.json`. La clé vient de `MINESTRATOR_API_KEY`, chargée
depuis un `.env` local ignoré par Git avant de lancer le client ; suivre la
[procédure MCP](docs/infrastructure/README.md#configuration-locale-du-mcp).
La configuration est reconnue par Codex. Le 2 novembre 2026, un test MCP HTTP
direct a validé l'authentification, découvert 107 outils et exécuté `list_servers`
en lecture seule. Aucun déploiement ni redémarrage n'a été effectué.

## 8. Modifier le projet

Cette procédure s'applique à toute modification.

1. **Comprendre** : lire ce fichier, les documents de l'[index documentaire](docs/README.md)
   utiles à la tâche et le code concerné. Appliquer les règles de prise de
   contexte d'[AGENTS.md](AGENTS.md).
2. **Situer** : vérifier que la demande entre dans le [cadrage](#3-cadrage). Sinon, obtenir l'accord du responsable du projet avant de commencer.
3. **Changer** : faire le plus petit changement utile, dans le style du code voisin. Identifiants en anglais, documentation du projet en français.
4. **Répercuter** : appliquer le tableau d'impact ci-dessous.
5. **Valider** : effectuer le niveau de validation requis et noter ce qui n'a pas pu être testé.
6. **Documenter** : mettre à jour ce fichier si le changement touche aux versions, à la structure, aux commandes, au déploiement, au cadrage ou aux problèmes connus. Mettre à jour la date et le commit de vérification si l'état du § 2 a été revérifié.
7. **Committer** : un sujet par commit, avec un message court en français. Après un push, contrôler le workflow `Build`.

### Tableau d'impact

| Changement | À faire aussi |
|---|---|
| Nouveau bloc ou item | Le déclarer via un `DeferredRegister` ; ajouter la traduction, un onglet créatif et les ressources sous `assets/moddevarpg/` (`blockstates/`, `items/`, `models/`, `textures/`) ; pour un bloc, ajouter la loot table sous `data/moddevarpg/loot_table/blocks/` |
| Texte visible en jeu | Passer par une clé de traduction (`Component.translatable`) dans `assets/moddevarpg/lang/en_us.json` (à créer au premier texte) |
| Option de config | La définir avec `ModConfigSpec` (voir § 5) ; ajouter la clé `moddevarpg.configuration.<option>` dans `en_us.json` |
| Comportement à protéger | Ajouter un gametest sous `data/moddevarpg/test_instance/` (voir § 5) |
| Métadonnées du mod | Modifier le template `neoforge.mods.toml`, jamais la copie dans `build/` ; toute nouvelle variable `${...}` va dans `gradle.properties` et dans `replaceProperties` |
| Dépendance vers un autre mod | Avec accord : `dependencies` et `repositories` dans `build.gradle`, bloc `[[dependencies.${mod_id}]]` dans le template ; `localRuntime` si elle ne sert qu'à l'exécution en développement |
| Mixin ou access transformer | Le déclarer dans le template (blocs `[[mixins]]` et `[[accessTransformers]]`, en commentaire aujourd'hui) |
| Version du mod | Modifier `mod_version` en respectant SemVer ; pour déployer, pousser ensuite le tag `v<mod_version>` (voir § 7) |
| Package Java ou `mod_group_id` | Les garder alignés : `mod_group_id` doit correspondre au package de base |
| `mod_id` ou identifiant de registre | Avec accord, car le contenu des mondes existants est perdu. Pour le `mod_id` : `gradle.properties`, constante `MODID`, dossier `assets/<mod_id>/`, clés de traduction |
| Version de Minecraft, NeoForge ou Java | Avec accord : propriétés de `gradle.properties`, toolchain de `build.gradle`, JDK des deux workflows, puis § 1 de ce fichier |
| Workflow de déploiement | Avec accord, car une erreur peut toucher le serveur réel |

### Niveaux de validation

| Type de changement | Validation minimale |
|---|---|
| Documentation seule | Relecture |
| Code ou ressources | `./gradlew build` |
| Comportement en jeu, textures, modèles | En plus : `runClient`, contrôle en jeu, lecture de `run/logs/latest.log` |
| Code commun, registres, événements serveur | En plus : `runServer` |
| Build ou workflows | En plus : contrôle de l'exécution dans GitHub Actions |

## 9. Règles pour les agents

- **Demander une autorisation explicite** avant de committer, de pousser, de lancer le workflow de déploiement, ou d'agir sur le serveur Minestrator.
- Ne pas accepter l'EULA de Minecraft à la place de l'utilisateur.
- **Vérifier toute API sur cette version.** Les exemples plus anciens sont souvent faux pour la 1.21.11 : `ResourceLocation`, par exemple, s'appelle ici `Identifier`. En cas de doute, le code du projet et les sources de Minecraft font foi, puis la documentation NeoForge.
- **Annoncer ce qui a été testé et ce qui ne l'a pas été.** Un build réussi ne vaut pas validation en jeu.
- Signaler toute divergence entre ce fichier et le dépôt, et la corriger dans le cadre de la modification en cours.

## 10. Problèmes connus

1. **Le déploiement n'a réussi qu'une fois** ([deploy-dev.yml](.github/workflows/deploy-dev.yml), premier envoi) : la rotation vers `.prev` sur Minestrator n'est vérifiée qu'en local. Aucun contrôle de disponibilité automatique ; le retour à `.prev` est manuel.
2. **Le serveur dédié n'est vérifié qu'au démarrage** (voir [§ 2](#2-état-actuel)) : aucune connexion de joueur ni lancement sur Minestrator.
3. **Le seul test automatisé vérifie le chargement du mod** : aucun comportement de gameplay n'est testé, faute de gameplay.
4. **Codex n'a pas été revérifié** depuis le passage de `.codex/` en dossier versionné.

## 11. Références

- Documentation NeoForge : <https://docs.neoforged.net/>
- Discord NeoForged : <https://discord.neoforged.net/>
- Versions de NeoForge : <https://projects.neoforged.net/neoforged/neoforge>
- ModDevGradle : <https://github.com/neoforged/ModDevGradle>
- Parchment : <https://parchmentmc.org/docs/getting-started>
- Licence des mappings Mojang : <https://github.com/NeoForged/NeoForm/blob/main/Mojang.md>
