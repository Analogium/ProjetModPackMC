# Système monétaire

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

Fournir une monnaie de jeu pour recevoir des récompenses et payer des actions.
Prototype proposé : une seule monnaie virtuelle, un compte par UUID de joueur,
un solde consultable et des opérations administratives contrôlées.
Ajouter ensuite une source et une dépense de gameplay définies explicitement.

## Étapes et critères de réussite

| Étape | Travail prévu | Critère de réussite |
|---|---|---|
| 1. Règles | Définir unité, plafond, solde initial et propriété du compte. | Les règles des montants et des soldes sont explicites. |
| 2. Comptes | Sauvegarder les soldes côté serveur par UUID. | Le compte survit à une reconnexion, un changement de nom et un redémarrage. |
| 3. Opérations | Centraliser crédit et dépense, avec contrôles de permission et de montant. | Une dépense impossible laisse le solde inchangé ; aucun solde négatif ou débordement. |
| 4. Boucle de jeu | Brancher une récompense et une dépense dont les règles sont approuvées. | Un déclenchement répété ne paie pas deux fois ; aucun paiement sans contrepartie. |
| 5. Affichage et validation | Afficher le solde au joueur et tester les opérations concurrentes. | Le serveur garde l'autorité et le client reçoit le résultat réel. |

## Choix techniques proposés

Stocker des montants entiers en unité minimale, jamais des nombres flottants.
Définir un plafond et contrôler les additions avant de modifier le compte.
Conserver les comptes au niveau du monde pour éviter un solde différent selon
la dimension. Aucun montant, prix ou bénéficiaire fourni par le client ne
fait autorité : le serveur retrouve les règles de l'action demandée.

Une dépense doit vérifier toutes ses conditions avant mutation. Le paiement
et sa contrepartie nécessitent une politique explicite en cas d'échec :
appliquer ensemble lorsque possible, sinon prévoir reprise ou compensation.
Tester aussi la répétition après redémarrage pour les récompenses persistantes.

Le [donjon](donjons-proceduraux.md) ou le [convoi](flotte-convois.md) peut fournir
une future récompense ; commencer avec les opérations de test sans rendre
ces systèmes obligatoires. Aucune banque externe ou dépendance économique.

## Décisions encore ouvertes

- Monnaie virtuelle ou pièces physiques ? Le prototype propose virtuelle.
- Nom, unité minimale, plafond et solde initial.
- Sources, dépenses et rythme économique ; perte éventuelle à la mort.
- Comptes individuels ou partagés ; échanges entre joueurs.

Les monnaies multiples, marchés dynamiques, taxes, banques et transferts
entre serveurs sont différés. Les échanges entre joueurs nécessiteront une
opération indivisible débit/crédit s'ils sont retenus.

## Validation prévue

Tester montants nuls et négatifs, fonds insuffisants, plafond, débordement,
permissions, requêtes répétées, achats concurrents, reconnexion et redémarrage.
Vérifier l'échec de la contrepartie et l'absence de double récompense.
Exécuter `./gradlew build`, `runClient`, `runServer` et lire les logs.
L'EULA reste à accepter par l'utilisateur. Documenter les résultats avant
`done`. Pour ce document seul : relecture.
