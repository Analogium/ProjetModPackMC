# Création et génération de structures

Recommandations pour le mod `moddevarpg`, sous Minecraft Java **1.21.11** et
NeoForge **21.11.48**. Recherche documentaire effectuée le 2 novembre 2026 ;
aucune installation ni validation en jeu n'a été effectuée pour ce guide.
Le cadrage et les validations de [init.md](../../../init.md) restent applicables.

## Choix recommandé

Utiliser **WorldEdit pour construire**, les **blocs de structure pour exporter
en NBT**, puis le **système natif de structures et Jigsaw pour la génération**.
Commencer sans bibliothèque supplémentaire.

- **WorldEdit 7.4.2** dispose d'une distribution NeoForge/Fabric pour Minecraft
  1.21.11. Choisir le mod NeoForge, pas le plugin Bukkit/Paper. Le réserver à
  l'environnement de construction ; le mod final utilise les ressources exportées.
  Voir la [version publiée](https://modrinth.com/plugin/worldedit/version/7.4.2?dep=1)
  et les [instructions d'installation](https://worldedit.enginehub.org/en/latest/install/).
- **Jigsaw natif** permet d'assembler des pièces NBT à partir de pools définis
  en JSON. Un bâtiment simple peut aussi être défini avec des ressources, sans
  classe Java supplémentaire. Le
  [tutoriel StructureTutorialMod pour NeoForge 1.21.11](https://github.com/TelepathicGrunt/StructureTutorialMod/blob/1.21.11-Neoforge-Jigsaw/README.md)
  fournit des exemples à étudier et adapter.
- **Lithostitched** est une option si le projet doit enrichir des pools existants
  ou modifier les conditions de génération et les processeurs. Voir ses
  [modificateurs](https://github.com/Apollounknowndev/lithostitched/wiki/Worldgen-Modifier-Types)
  et ses [versions publiées](https://www.curseforge.com/minecraft/mc-mods/lithostitched).
- **Moog's Structure Lib** est une alternative à évaluer pour ses types de
  structures et systèmes de placement. Voir la
  [présentation](https://modrinth.com/mod/moogs-structure-lib) et le
  [guide 1.21.11](https://github.com/FinnSetchell/MoogsStructureLib/blob/1.21.11/docs/wiki/Getting-Started.md).
- **Axiom** propose un éditeur visuel avancé, mais sa plateforme annoncée est
  Fabric. Il conviendrait à un atelier séparé ; WorldEdit est plus direct pour
  construire avec les blocs de notre mod NeoForge. Voir sa
  [page officielle](https://modrinth.com/mod/axiom).

L'ajout d'une dépendance vers un autre mod demande l'accord du responsable du
projet. Cette recommandation ne vaut pas décision d'ajouter une bibliothèque.
Avant toute installation, vérifier les exigences exactes du fichier choisi,
y compris sa version minimale de NeoForge.

## Processus de création

1. **Préparer un monde créatif dédié.** Utiliser Minecraft 1.21.11, le mod et
   WorldEdit compatible. Conserver une sauvegarde de ce monde de construction.
2. **Construire un premier bâtiment fixe.** Valider son échelle, ses accès et
   son implantation avant de concevoir un ensemble modulaire.
3. **Exporter avec un bloc de structure au format `.nbt`.** Les fichiers
   `.schem` de WorldEdit servent au travail de construction et aux échanges ;
   ne pas les renommer en `.nbt`. Les formats sont distincts. Voir les
   [formats WorldEdit](https://worldedit.enginehub.org/en/latest/usage/clipboard/)
   et les [modèles NBT documentés par NeoForge](https://docs.neoforged.net/docs/1.21.11/misc/gametest/).
4. **Intégrer les ressources dans le mod**, avec des identifiants sous le
   namespace `moddevarpg`. Définir le modèle, le pool de départ, la structure,
   sa répartition et les biomes autorisés. Ajouter des processeurs uniquement
   si une transformation des blocs est nécessaire.
5. **Valider le placement du bâtiment**, puis la génération naturelle sur
   plusieurs graines et terrains dans des mondes de test neufs.
6. **Passer à Jigsaw modulaire si nécessaire.** Séparer les entrées, salles,
   couloirs, embranchements et terminaisons ; tester chaque raccord avant
   d'augmenter la taille ou la diversité de l'ensemble.

Organisation proposée sous `src/main/resources/data/moddevarpg/` :

```text
structure/                    Modèles .nbt
worldgen/structure/           Définitions JSON des structures
worldgen/structure_set/       Répartition et espacement
worldgen/template_pool/       Pièces disponibles et pools de départ
worldgen/processor_list/      Transformations optionnelles
tags/worldgen/biome/          Groupes de biomes autorisés
```

En 1.21.11, le dossier des modèles NBT est **`structure/` au singulier**, distinct
de `worldgen/structure/` qui contient les définitions JSON. Ne pas reprendre
aveuglément les chemins d'anciens tutoriels.

## Bonnes pratiques

- **Garder une première version simple.** Un bâtiment fonctionnel suffit pour
  valider la chaîne construction, export, intégration et génération.
- **Normaliser les raccords Jigsaw.** Définir des dimensions et hauteurs de
  passage cohérentes. Prévoir des terminaisons et des pools de secours pour
  fermer les passages lorsqu'une extension ne peut pas être placée.
- **Tester les rotations et les collisions.** Vérifier les portes, escaliers,
  passages, limites des pièces et chevauchements sur plusieurs assemblages.
- **Contrôler l'intégration au terrain.** Examiner les fondations, entrées
  enterrées, parties flottantes et rencontres avec l'eau ou les pentes.
- **Vérifier les données exportées.** Contrôler les coffres et leur butin, les
  entités voulues et l'absence d'éléments temporaires de construction.
- **Maîtriser la génération.** Ajuster les biomes, l'espacement et la taille des
  assemblages progressivement ; surveiller le coût de génération des chunks.
- **Séparer architecture et gameplay.** Pour un éventuel donjon ARPG, traiter
  la progression, les boss, les récompenses et la réinitialisation comme des
  besoins distincts de l'assemblage des salles. Ne pas les ajouter sans demande.
- **Versionner les ressources.** Conserver les NBT et JSON dans Git, avec des
  noms stables et descriptifs. Garder séparément une sauvegarde du monde source,
  sans versionner le dossier de lancement `run/`.
- **Valider côté client et serveur dédié.** Pour une implémentation, lancer
  `./gradlew build`, contrôler le résultat avec `runClient`, puis `runServer`
  pour la génération serveur, et lire les logs. L'acceptation de l'EULA revient
  à l'utilisateur. Un build réussi ne prouve pas que les structures se génèrent.

Pour ce guide documentaire seul, la validation requise est une relecture.
