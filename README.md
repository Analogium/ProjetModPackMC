# ModDevARPG

Mod NeoForge pour Minecraft 1.21.11 (Java 21) : un ARPG mêlant gestion et
hack and slash. Le projet est en début de développement.

## Démarrer

Prérequis : JDK 21 (Gradle peut aussi le télécharger automatiquement).

```sh
./gradlew build      # produit build/libs/moddevarpg-<version>.jar
./gradlew runClient  # lance le jeu avec le mod
```

Sous PowerShell : `.\gradlew <tâche>`.

`runClient` utilise un pseudo de développement sans compte : il ne peut pas
rejoindre le serveur de dev, qui vérifie les comptes Minecraft.

## Jouer avec CurseForge

1. Une seule fois : dans l'application CurseForge, onglet Minecraft,
   **Create Custom Profile** avec le nom `ModDevARPG`, Minecraft **1.21.11** et
   le loader **NeoForge 21.11.48** (sinon une version 21.11 plus récente).
2. À chaque nouvelle version du mod, jeu fermé :

   ```sh
   ./gradlew installClient
   ```

   La tâche compile le mod et copie `ModDevARPG.jar` dans le dossier `mods` du
   profil, en remplaçant la version précédente ; les autres mods du profil ne
   sont pas touchés. Sans profil `ModDevARPG`, elle échoue sans rien créer.
3. Lancer le profil depuis CurseForge et rejoindre le serveur de dev (adresse
   communiquée par l'équipe, jamais dans ce dépôt public).

Autre launcher ou autre emplacement : `./gradlew installClient -PclientModsDir=<dossier mods>`,
ou `clientModsDir=<dossier mods>` dans `~/.gradle/gradle.properties`.
Le dossier doit déjà exister.

Le mod installé doit être la même version que celle du serveur : après un
déploiement (tag `v*`), récupérer `main` puis relancer `installClient`.

## Documentation

- [init.md](init.md) : architecture, commandes, validation et règles de contribution.
  À lire avant toute modification.
- [docs/README.md](docs/README.md) : index de la documentation, outils IA et infrastructure.

## Licence

Le mod est sous licence « All Rights Reserved ». Les fichiers issus du template
NeoForge sont sous licence MIT ([TEMPLATE_LICENSE.txt](TEMPLATE_LICENSE.txt)).
Les noms de mappings Mojang sont soumis à leur
[propre licence](https://github.com/NeoForged/NeoForm/blob/main/Mojang.md).
