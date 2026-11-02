# Flotte maritime et convois de navires

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

Le périmètre maritime a été confirmé par l'utilisateur : gérer une flotte
et organiser des convois de navires. Proposition de distinction : la flotte
désigne les navires disponibles ; un convoi affecte certains navires à un trajet.

Premier jalon proposé : un convoi entre deux points maritimes définis pour le
test, avec une cargaison, un départ et une arrivée uniques. Choisir d'abord
le mode de déplacement : simulation de trajet ou navires visibles naviguant
dans le monde. Ce choix conditionne l'implémentation et reste ouvert.

## Étapes et critères de réussite

| Étape | Travail prévu | Critère de réussite |
|---|---|---|
| 1. Règles maritimes | Définir flotte, propriété, capacité, points de départ/arrivée et mode de déplacement. | Un trajet et ses conditions de réussite sont entièrement décrits. |
| 2. Flotte | Enregistrer les navires, leur propriétaire et leur disponibilité. | Un navire ne peut appartenir à deux convois actifs. |
| 3. Départ | Vérifier accès, trajet, capacité et cargaison avant affectation des navires. | Un départ refusé ne retire aucun objet ; un départ accepté ne duplique rien. |
| 4. Voyage | Gérer les états préparé, en route, arrivé et annulé selon les règles choisies. | Le convoi reprend correctement après sauvegarde, sans dépendre d'une interface ouverte. |
| 5. Arrivée | Livrer une seule fois ; définir le cas où la destination est indisponible ou pleine. | Aucun objet perdu ou livré deux fois lors d'une reconnexion ou d'un redémarrage. |
| 6. Validation | Tester deux joueurs, concurrence et interruptions de trajet. | Propriété, navires et cargaison restent cohérents. |

## Choix techniques proposés

Conserver les identités et états côté serveur. Le client demande une action ;
le serveur vérifie propriétaire, navires, destination et capacité. Stocker
explicitement qui détient la cargaison à chaque étape : inventaire source,
convoi, puis destination. Définir reprise ou compensation en cas d'échec.

Pour une simulation de trajet, utiliser un temps de jeu serveur et décider
si le voyage progresse hors connexion. Pour une navigation visible, réaliser
d'abord un essai sur une courte voie d'eau ; examiner obstacles, rivages,
chunks déchargés et limites des entités disponibles dans la version cible.
Ne pas promettre de navires multiblocs ni ajouter de bibliothèque sans décision.
Aucun chargement permanent de chunks à grande échelle dans le prototype.

Tester une cargaison sans monnaie au départ. L'intégration au
[système monétaire](systeme-monetaire.md) pourra ensuite couvrir frais ou
récompenses, avec des paiements uniques. Un port construit avec le
[système de placement](placement-structures.md) reste une extension possible,
pas un prérequis du premier trajet.

## Décisions encore ouvertes

- Navires visibles, pilotables, autonomes ou trajet simulé ?
- Définition et construction des ports ; trajets libres ou routes établies ?
- Types de navires, capacités et règles d'affectation.
- Annulation en route, destruction, perte de cargaison et destination détruite.
- Escortes, attaques, commerce et progression hors connexion.

Combat naval, navires multiblocs, commerce automatique et itinéraires océaniques
complexes sont différés jusqu'à validation du premier trajet.

## Validation prévue

Tester propriété, double affectation, capacité dépassée, double départ,
double arrivée, destination pleine ou supprimée, annulation et redémarrage
à chaque étape. Contrôler la conservation de la cargaison. Si le déplacement
est visible, vérifier obstacles et déchargement des chunks.
Exécuter `./gradlew build`, `runClient`, `runServer` et lire les logs avec
deux joueurs. L'EULA reste à accepter par l'utilisateur. Documenter les
résultats avant `done`. Pour ce document seul : relecture.
