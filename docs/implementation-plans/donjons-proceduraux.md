# Donjons procéduraux

## Suivi d'implémentation

| Champ | Valeur |
|---|---|
| Statut | `todo` |
| Branche d'implémentation | Non attribuée — aucune implémentation commencée |
| Dernière mise à jour | 2026-11-02 |
| Validation réalisée | Relecture du plan ; aucun test de gameplay |

Statuts : `todo` = non commencé ; `active` = en cours, avec le nom exact de
la branche ; `done` = périmètre réalisé et validations effectuées. À la
clôture, conserver la branche, ajouter le commit ou la PR et les résultats
de validation. Le statut décrit la fonctionnalité, pas ce document.

Ce plan est préliminaire. Les choix proposés restent à confirmer avant
l'implémentation. Le code examiné lors de la planification initiale contient
seulement le template NeoForge. Le cadre de [init.md](../../init.md)
s'applique : Minecraft 1.21.11, NeoForge 21.11.48, Java 21, client et serveur
dédié. Vérifier les API dans les sources de cette version avant de coder ;
aucune nouvelle dépendance n'est décidée ici.

## Objectif et premier jalon

Produire des donjons variés à partir de salles conçues à la main, avec un
parcours accessible et une taille bornée. Premier prototype proposé : une
entrée, deux variantes de salle, un couloir et une terminaison, assemblés
dans un monde de test. La génération naturelle vient après ce jalon.

## Étapes et critères de réussite

| Étape | Travail prévu | Critère de réussite |
|---|---|---|
| 1. Pièces | Exporter les modèles NBT et normaliser raccords, hauteur de passage et orientation. | Chaque raccord reste traversable dans les rotations prévues. |
| 2. Assemblage | Évaluer les pools Jigsaw natifs avec limites de profondeur et d'emprise, variantes et terminaisons. | Plusieurs assemblages différents restent bornés, connectés et sans passages débouchant dans un mur. |
| 3. Intégration au monde | Définir les biomes, l'altitude et l'espacement après validation du prototype. | Les entrées sont accessibles sur un échantillon de graines et de terrains documenté. |
| 4. Contenu jouable | Choisir un objectif simple et des rencontres utilisant d'abord le contenu existant. | Le parcours peut être terminé ; les récompenses respectent les règles choisies. |
| 5. Validation | Contrôler assemblage, coût de génération, multijoueur et sauvegarde. | Aucun donjon testé ne bloque le serveur ni ne se régénère au rechargement. |

## Choix techniques proposés

Suivre les [recommandations de structures](../recommandations/structure/README.md) :
modèles NBT et données Jigsaw avant tout générateur personnalisé. Garder les
paramètres et pièces versionnés ; conserver les graines des cas défaillants.
Un test doit vérifier le chemin d'accès, pas seulement la présence des pièces.

Le placement manuel décrit dans le [plan de placement](placement-structures.md)
peut partager les conventions NBT, mais ne constitue pas un prérequis.
Séparer la génération des règles de rencontre et des récompenses.
N'ajouter un état persistant de donjon que si un objectif ou une récompense
unique le nécessite. Définir alors l'identité du donjon et empêcher un second
paiement lors d'une reconnexion ou d'une activation concurrente.

## Décisions encore ouvertes

- Donjons dans l'Overworld ou instances séparées ? Proposition initiale :
  génération dans de nouveaux chunks de l'Overworld.
- Objectif, difficulté, taille maximale, biomes et fréquence.
- Récompense par joueur, groupe ou donjon ; réinitialisation éventuelle.
- Salles obligatoires : vérifier d'abord si les contraintes choisies sont
  satisfaites par Jigsaw avant de retenir cet outil définitivement.

Les dimensions instanciées, boss personnalisés, remise à zéro et génération
rétroactive dans des chunks existants sont différés.

## Validation prévue

Tester plusieurs graines, rotations, limites de taille, terrain aquatique et
pentu, passages entre chunks, accès à l'objectif et rechargement du monde.
Exécuter `./gradlew build`, `runClient`, `runServer` et lire les logs ;
vérifier avec deux joueurs les objectifs et récompenses retenus. L'EULA
reste à accepter par l'utilisateur. Consigner les résultats avant `done`.
Pour ce document seul : relecture.
