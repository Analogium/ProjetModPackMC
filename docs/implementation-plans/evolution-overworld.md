# Évolution de base de l'Overworld

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

Introduire une progression perceptible de l'Overworld au cours de la partie.
Le sens précis d'« évolution » reste à définir : difficulté, événements,
territoires ou transformations du terrain.

Hypothèse de prototype : une progression globale à deux paliers, déclenchée
par un événement explicite de jeu, avec un seul effet observable à choisir.
Une commande réservée aux opérateurs permettra de tester les paliers.
Le prototype évite de réécrire le terrain ou les constructions existantes.

## Étapes et critères de réussite

| Étape | Travail prévu | Critère de réussite |
|---|---|---|
| 1. Règles | Définir deux paliers, leur déclencheur et un effet mesurable. | Le passage et ses conséquences sont décrits sans ambiguïté. |
| 2. État serveur | Sauvegarder le palier et les informations nécessaires au déclencheur. | Redémarrer ne remet pas le monde au palier initial. |
| 3. Transition | Centraliser les conditions et l'application de la transition. | Deux événements simultanés ne produisent qu'une transition. |
| 4. Effet et information | Appliquer l'effet choisi et informer les joueurs, y compris à la connexion. | Tous les joueurs observent le même état ; les textes sont traduisibles. |
| 5. Validation | Tester transitions, reconnexions, changement de dimension et redémarrage. | L'évolution ne se répète pas au chargement et reste limitée au périmètre choisi. |

## Choix techniques proposés

Conserver un petit état persistant côté serveur, associé à l'Overworld.
Traiter les événements utiles au lieu de parcourir tous les chunks à chaque
tick. Synchroniser uniquement l'information nécessaire à l'affichage.
Définir explicitement le comportement pour les joueurs arrivant en cours de
progression et pour les autres dimensions.

Si le déclencheur devient la fin d'un [donjon](donjons-proceduraux.md),
utiliser un événement de réussite serveur ; ne pas déduire la réussite d'un
message client. Tester d'abord avec un déclencheur de développement pour
ne pas bloquer ce prototype sur les donjons.

## Décisions encore ouvertes

- Progression globale ou locale par région ? Le prototype propose globale.
- Déclenchement par temps de jeu, objectif accompli ou action du joueur ?
- Effet retenu : rencontre, difficulté, ressource ou autre changement ?
- Progression réversible ? Traitement des joueurs débutants dans un monde avancé ?
- Temps écoulé hors connexion et migration des mondes existants.

Corruption du terrain, saisons, factions, simulation régionale et changements
massifs de biomes ne sont pas inclus dans ce premier plan.

## Validation prévue

Vérifier l'état initial, les conditions non remplies, la transition unique,
les événements répétés, deux joueurs, reconnexion et redémarrage. Confirmer
que les chunks existants et les constructions ne sont pas réécrits.
Exécuter `./gradlew build`, `runClient`, `runServer` et lire les logs.
L'EULA reste à accepter par l'utilisateur. Documenter les résultats avant
`done`. Pour ce document seul : relecture.
