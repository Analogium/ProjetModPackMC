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

Le projet sort du template NeoForge MDK et **ne contient encore aucun gameplay** : seulement les exemples du template (un bloc, un item, un onglet créatif, une config de démonstration). Le [README.md](README.md) est lui aussi celui du template ; il ne décrit pas ce projet.

| Point vérifié | Résultat |
|---|---|
| `./gradlew build` en local | OK, produit `build/libs/moddevarpg-1.0.0.jar` |
| Workflow `Build` sur GitHub | OK sur `84340a2` |
| Client de développement | Démarre et charge le mod d'après les logs ; le comportement en monde n'est pas documenté |
| Serveur dédié | Aucune trace de lancement local (pas de `run/eula.txt`) |
| Déploiement | Jamais exécuté : aucun passage de `Deploy dev server` dans GitHub Actions |
| Tests automatisés | Aucun (ni test unitaire, ni gametest) |

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
├── .claude/                    Configuration IA de référence, avec docs/ lié à ../docs/
├── .codex/                     Lien vers .claude/ (recréé après un clone)
├── .mcp.json                   Serveur MCP CodeGraph pour Claude Code
├── scripts/setup-ai.ps1         Recrée et vérifie les liens des dossiers IA
├── build.gradle                Configuration du build et des lancements
├── gradle.properties           Versions et identité du mod
├── .github/workflows/
│   ├── build.yml               Compilation à chaque push et pull request
│   └── deploy-dev.yml          Envoi du jar et redémarrage du serveur de dev
└── src/main/
    ├── java/com/example/moddevarpg/
    │   ├── ModDevARPG.java        Point d'entrée commun, registres
    │   ├── ModDevARPGClient.java  Point d'entrée client uniquement
    │   └── Config.java            Options de configuration
    ├── resources/assets/moddevarpg/lang/en_us.json   Traductions
    └── templates/META-INF/neoforge.mods.toml         Métadonnées du mod
```

**Ne pas modifier à la main ni committer** (générés, ignorés par Git) : `build/`, `bin/`, `.gradle/`, `run/`, `.vscode/`.

Le dossier `src/generated/resources/` n'existe pas encore. Il recevra la sortie de `runData` : il faudra le committer, mais changer le générateur plutôt que ses fichiers.

**Outils IA.** Les deux agents partagent `.claude/` et la documentation racine
`docs/` via des liens de dossiers (jonctions sous Windows). CodeGraph fournit
un index local du code, ignoré par Git dans `.codegraph/`. Après un clone,
exécuter `.\scripts\setup-ai.ps1`, puis suivre [docs/README.md](docs/README.md)
pour installer CodeGraph et charger le serveur MCP. Aucun réglage de déploiement
ni aucune dépendance du mod ne sont modifiés par cette installation.

Les [recommandations sur les structures](docs/recommandations/structure/README.md)
décrivent les outils de construction, l'export NBT et la génération Jigsaw ;
elles ne constituent pas une fonctionnalité déjà implémentée.

## 5. Fonctionnement du code

**Démarrage.** NeoForge instancie les classes annotées `@Mod`.

1. Le constructeur de [ModDevARPG.java](src/main/java/com/example/moddevarpg/ModDevARPG.java) branche les registres et les écouteurs, et déclare la config. Il s'exécute côté client et côté serveur.
2. Le constructeur de [ModDevARPGClient.java](src/main/java/com/example/moddevarpg/ModDevARPGClient.java) (`dist = Dist.CLIENT`) ajoute l'écran de configuration. Il ne s'exécute que sur le client.
3. `FMLCommonSetupEvent`, puis `FMLClientSetupEvent` sur le client, servent au reste de l'initialisation.

**Séparation client/serveur.** Le code commun ne doit jamais référencer `net.minecraft.client.*` : un serveur dédié planterait au chargement. Ce code va dans `ModDevARPGClient` ou dans des classes appelées uniquement depuis celle-ci.

**Registres.** Blocs, items et onglets sont déclarés par des `DeferredRegister` (`BLOCKS`, `ITEMS`, `CREATIVE_MODE_TABS`), eux-mêmes branchés sur le bus du mod dans le constructeur. L'identifiant complet prend la forme `moddevarpg:<nom>`.

**Événements.** Deux bus coexistent :

- le bus du mod (`IEventBus` reçu par le constructeur) pour le chargement et l'enregistrement ;
- le bus du jeu (`NeoForge.EVENT_BUS`) pour les événements en cours de partie.

`@EventBusSubscriber` enregistre automatiquement les méthodes statiques annotées `@SubscribeEvent` d'une classe.

**Configuration.** [Config.java](src/main/java/com/example/moddevarpg/Config.java) définit une config de type `COMMON`, écrite dans `config/moddevarpg-common.toml`. Chaque côté garde son propre fichier : il n'y a pas de synchronisation entre serveur et client.

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
| `runGameTestServer` | Lance les gametests ; plante tant qu'aucun n'est enregistré (voir [build.gradle](build.gradle)) |
| `clean` | Supprime `build/` sans toucher au code |
| `--refresh-dependencies` | Option à ajouter à une tâche si des bibliothèques manquent dans l'IDE |

- Toutes les configurations de lancement partagent le dossier `run/`. Les logs sont dans `run/logs/`.
- Au premier `runServer`, le serveur s'arrête tant que `eula=true` n'est pas écrit dans `run/eula.txt`. Cette acceptation revient à la personne qui lance le serveur.
- Sous VS Code, les lancements Client, Server, Data et GameTestServer se trouvent dans `.vscode/launch.json`, un fichier local à chaque machine.
- `disableRecompilation = false` dans [build.gradle](build.gradle) rend les sources de Minecraft disponibles, mais demande de la mémoire. Sur une machine limitée (Codespace de 8 Go, par exemple), passer à `true` localement sans committer ce changement.
- L'avertissement de fin de build sur Gradle 10 ne bloque rien aujourd'hui.

## 7. Intégration et déploiement

| Workflow | Déclencheur | Action |
|---|---|---|
| [build.yml](.github/workflows/build.yml) | Chaque push et pull request | `./gradlew build` avec Temurin 21 |
| [deploy-dev.yml](.github/workflows/deploy-dev.yml) | Push sur `master`, ou lancement manuel | Build, envoi SFTP vers `mods/ModDevARPG.jar`, redémarrage par l'API Minestrator |

- **Un workflow `Build` vert prouve seulement que le mod compile**, faute de tests automatisés.
- Le déploiement redémarre un vrai serveur, ce qui coupe les joueurs connectés.
- Le jar garde un nom fixe sur le serveur pour éviter d'y accumuler les versions.
- Secrets GitHub attendus : `SFTP_HOST`, `SFTP_PORT`, `SFTP_USER`, `SFTP_PASS`, `MINESTRATOR_SERVER_ID`, `MINESTRATOR_API_KEY`. Leur présence n'a pas pu être vérifiée.
- Le dépôt est public : aucun secret, mot de passe, adresse de serveur ni identifiant Minestrator dans les fichiers versionnés, y compris ici.

## 8. Modifier le projet

Cette procédure s'applique à toute modification.

1. **Comprendre** : lire ce fichier, l'[index documentaire](docs/README.md), les
   [guidelines](docs/guidelines/README.md), les recommandations pertinentes
   liées par l'index et le code concerné. Appliquer les règles de prise de
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
| Nouveau bloc ou item | Le déclarer via le `DeferredRegister` ; ajouter la traduction, un onglet créatif et les ressources sous `assets/moddevarpg/` (`blockstates/`, `items/`, `models/`, `textures/`) ; pour un bloc, ajouter la loot table sous `data/moddevarpg/loot_table/blocks/` |
| Texte visible en jeu | Passer par une clé de traduction (`Component.translatable`) dans `en_us.json`, seule langue existante |
| Option de config | La définir dans `Config.java` ; ajouter la clé `moddevarpg.configuration.<option>` dans `en_us.json` |
| Métadonnées du mod | Modifier le template `neoforge.mods.toml`, jamais la copie dans `build/` ; toute nouvelle variable `${...}` va dans `gradle.properties` et dans `replaceProperties` |
| Dépendance vers un autre mod | Avec accord : `dependencies` et `repositories` dans `build.gradle`, bloc `[[dependencies.${mod_id}]]` dans le template ; `localRuntime` si elle ne sert qu'à l'exécution en développement |
| Mixin ou access transformer | Le déclarer dans le template (blocs `[[mixins]]` et `[[accessTransformers]]`, en commentaire aujourd'hui) |
| Version du mod | Modifier `mod_version` en respectant SemVer |
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
- **Vérifier toute API sur cette version.** Les exemples plus anciens sont souvent faux pour la 1.21.11 : `ResourceLocation`, par exemple, s'appelle ici `Identifier` (voir `Config.java`). En cas de doute, le code du projet et les sources de Minecraft font foi, puis la documentation NeoForge.
- **Annoncer ce qui a été testé et ce qui ne l'a pas été.** Un build réussi ne vaut pas validation en jeu.
- Signaler toute divergence entre ce fichier et le dépôt, et la corriger dans le cadre de la modification en cours.

## 10. Problèmes connus

1. **Le déploiement automatique ne se déclenche jamais.** [deploy-dev.yml](.github/workflows/deploy-dev.yml) écoute `master`, alors que la seule branche est `main`. Passer à `main` ferait redémarrer le serveur à chaque push : le choix revient au responsable du projet.
2. **Le mod porte encore des valeurs du template** : package et groupe `com.example.moddevarpg`, description « Example mod description », onglet « Example Mod Tab », bloc, item et options de démonstration. À remplacer lors de l'ajout du vrai contenu.
3. **Le bloc et l'item d'exemple n'ont ni modèle ni texture**, et le bloc n'a pas de loot table : un affichage de texture manquante est attendu.
4. **Le fonctionnement sur serveur dédié n'est pas vérifié** (voir [§ 2](#2-état-actuel)).
5. **Il n'existe aucun test automatisé** : seule la compilation est contrôlée par la CI.

## 11. Références

- Documentation NeoForge : <https://docs.neoforged.net/>
- Discord NeoForged : <https://discord.neoforged.net/>
- Versions de NeoForge : <https://projects.neoforged.net/neoforged/neoforge>
- ModDevGradle : <https://github.com/neoforged/ModDevGradle>
- Parchment : <https://parchmentmc.org/docs/getting-started>
- Licence des mappings Mojang : <https://github.com/NeoForged/NeoForm/blob/main/Mojang.md>
