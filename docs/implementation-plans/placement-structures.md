# Placement des structures inspiré de MineColonies

## Suivi d'implémentation

| Champ | Valeur |
|---|---|
| Statut | `todo` |
| Branche d'implémentation | Non attribuée — aucune implémentation commencée |
| Dernière mise à jour | 2026-11-02 |
| Validation réalisée | Relecture du plan ; aucun test de gameplay |

Mettre à jour ce tableau au démarrage et à la fin de l'implémentation :

- `todo` : implémentation non commencée.
- `active` : implémentation en cours ; renseigner le nom exact de la branche.
- `done` : périmètre réalisé et validations requises effectuées ; conserver
  la branche d'implémentation et ajouter la référence du commit ou de la PR,
  ainsi que les résultats de validation.

Le statut concerne la fonctionnalité, pas la rédaction de ce document.
Ce plan reste préliminaire : les propositions ci-dessous ne sont pas des
fonctionnalités déjà implémentées ni des décisions de gameplay définitives.

## Objectif et état initial

Parcours proposé : **sélectionner un bâtiment → prévisualiser → ajuster sa
position et sa rotation → confirmer un emplacement persistant**.
L'inspiration est le [Build Tool de MineColonies](https://minecolonies.com/wiki/tutorials/getting-started/).

Lors de l'exploration initiale via CodeGraph, le code ne contenait que le
template NeoForge : aucun système de placement, de réseau métier ou de
sauvegarde métier. Le cadre reste Minecraft 1.21.11, NeoForge 21.11.48 et
Java 21, conformément à [init.md](../../init.md).

## Périmètre proposé

Premier prototype : un petit bâtiment fourni avec le mod, utilisable en
créatif, avec une emprise rectangulaire. Le premier jalon permet de positionner
le bâtiment test, tourner son aperçu et enregistrer son emplacement sans poser
ses blocs. Il valide le cœur du système avant de définir les chantiers.

À préciser avant de finaliser le comportement :

- La confirmation réserve-t-elle un chantier ou construit-elle immédiatement ?
- La construction progressive par des PNJ fait-elle partie d'une étape suivante ?
- Quelles règles de terrain et de remplacement des blocs appliquer ?

Les coûts, niveaux de bâtiment, PNJ, terraformation et assemblages modulaires
restent hors du premier prototype proposé.

## Étapes et critères de réussite

| Étape | Travail prévu | Critère de réussite |
|---|---|---|
| 1. Modèle et coordonnées | Un bâtiment NBT asymétrique, un point d'ancrage explicite, déplacements sur la grille et quatre rotations de 90°. | L'ancrage reste fixe pendant la rotation ; entrée et limites sont correctement positionnées. |
| 2. Validation serveur | Vérifier modèle autorisé, permissions, distance, limites du monde, chunks chargés, terrain et chevauchements. | Toute demande invalide est refusée avec une raison précise, sans modifier le monde. |
| 3. Prévisualisation client | Sélection, contour d'emprise puis aperçu des blocs ; déplacement X/Y/Z, rotation, confirmation et annulation. | Le joueur peut inspecter le bâtiment en se déplaçant ; annuler ne laisse aucune modification. |
| 4. Confirmation et sauvegarde | Envoyer la demande au serveur, revérifier l'emplacement, enregistrer le placement et retourner le résultat. | Deux joueurs ne peuvent pas réserver le même espace ; le placement survit au redémarrage. |
| 5. Validation complète | Tests de géométrie, validation en jeu et serveur dédié avec deux joueurs. | Aperçu, emprise validée et position enregistrée concordent. |

## Choix techniques proposés

- Utiliser les modèles NBT natifs sous
  `src/main/resources/data/moddevarpg/structure/`, conformément aux
  [recommandations sur les structures](../recommandations/structure/README.md).
  Évaluer Jigsaw seulement si plusieurs pièces doivent être assemblées.
- Partager une transformation commune pour l'ancrage, les blocs et l'emprise
  afin d'éviter les décalages entre aperçu et résultat.
- Confier l'aperçu au client et la décision au serveur. La requête contient
  l'identifiant du modèle et la transformation, jamais une liste arbitraire
  de blocs à écrire. Utiliser les
  [payloads NeoForge 1.21.11](https://docs.neoforged.net/docs/1.21.11/networking/payload/).
- Enregistrer les placements par dimension : identifiant unique, propriétaire,
  modèle, ancrage et rotation. Le mécanisme
  [Saved Data](https://docs.neoforged.net/docs/1.21.11/datastorage/saveddata/)
  couvre cette persistance.
- Garder le rendu et les interfaces dans le code client ; aucune référence
  à `net.minecraft.client.*` dans le code commun.
- Commencer sans dépendance supplémentaire. Vérifier les API exactes dans
  les sources de la version cible avant de coder.

## Validation prévue

- Vérifier les quatre rotations avec un bâtiment asymétrique, notamment
  l'ancrage, l'entrée, les coins de l'emprise et les coordonnées négatives.
- Vérifier les refus : modèle inconnu, permissions insuffisantes, emplacement
  hors limites, chunks non chargés et chevauchement.
- Vérifier l'annulation, les confirmations concurrentes et la persistance
  après redémarrage.
- Exécuter `./gradlew build`, puis contrôler le comportement avec `runClient`
  et `runServer`, deux joueurs et lecture des logs. L'acceptation de l'EULA
  reste à la charge de l'utilisateur.
- Consigner les résultats et toute validation non réalisée dans le suivi.

Pour l'ajout documentaire de ce plan, seule une relecture est requise.
