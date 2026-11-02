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

## Documentation

- [init.md](init.md) : architecture, commandes, validation et règles de contribution.
  À lire avant toute modification.
- [docs/README.md](docs/README.md) : index de la documentation, outils IA et infrastructure.

## Licence

Le mod est sous licence « All Rights Reserved ». Les fichiers issus du template
NeoForge sont sous licence MIT ([TEMPLATE_LICENSE.txt](TEMPLATE_LICENSE.txt)).
Les noms de mappings Mojang sont soumis à leur
[propre licence](https://github.com/NeoForged/NeoForm/blob/main/Mojang.md).
