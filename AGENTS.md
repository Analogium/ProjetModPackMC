# Consignes communes à Codex et Claude

Lire [init.md](init.md) avant toute modification et respecter ses règles, son
cadrage et ses niveaux de validation. La documentation du projet est en français.

## Prise de contexte documentaire obligatoire

Au début de chaque tâche dans ce projet :

1. Lire [init.md](init.md) et l'[index documentaire](docs/README.md).
2. Consulter les [guidelines](docs/guidelines/README.md), puis suivre les liens
   de l'index vers les recommandations pertinentes pour la tâche.
3. Tenir compte de ces documents dans les décisions et les modifications.
   Distinguer la vision, les recommandations et les fonctionnalités réellement
   implémentées ; ne pas transformer une recommandation en décision implicite.

Les documents déjà lus dans le contexte courant peuvent être réutilisés s'ils
n'ont pas changé. Après une reprise sans ce contexte, les relire. Si la tâche
change de périmètre, consulter les entrées correspondantes avant de poursuivre.

L'index `docs/README.md` sert à découvrir la documentation ; CodeGraph sert à
explorer le code. Un résultat CodeGraph vide ne signifie pas qu'aucune
documentation n'existe : lire directement les fichiers Markdown liés par
l'index. Lors de l'ajout, du déplacement ou de la suppression d'un document,
mettre à jour son entrée dans l'index ou dans un sous-index accessible depuis
celui-ci.

## Outils et fichiers partagés

- Les dossiers `.claude` et `.codex` partagent les mêmes fichiers ; modifier
  `.claude`, le dossier de référence. Ne pas créer de liens réciproques.
- La documentation partagée est dans [docs/](docs/), également accessible par
  `.claude/docs/` et `.codex/docs/`. Modifier les originaux dans `docs/`.
- Utiliser CodeGraph en priorité dès qu'il est disponible : `codegraph_explore`
  via MCP, ou la CLI (`query`, `node`, `impact`) si le serveur MCP est indisponible.
  Ne jamais utiliser `grep`, `rg` ou un équivalent de recherche textuelle tant
  que CodeGraph est disponible. Pour les fichiers non indexés (documentation,
  configuration), lire directement les fichiers concernés. Recourir à la
  recherche textuelle uniquement si CodeGraph est indisponible. Vérifier le
  code source avant de le modifier.
- Utiliser Ponytail autant que possible pour les tâches de code : conception,
  implémentation, correction, refactorisation et revue. Charger le skill adapté
  lorsqu'il est disponible ; sinon, appliquer ses principes : solution minimale
  fonctionnelle, réutilisation de l'existant, bibliothèque standard et fonctions
  natives avant toute nouvelle dépendance, aucune abstraction spéculative.
  Conserver les validations requises et utiliser CodeGraph pour examiner les
  appelants, même si un skill suggère `grep`.
- Ne pas committer, pousser, déployer ni agir sur Minestrator sans autorisation
  explicite. Ne pas accepter l'EULA Minecraft à la place de l'utilisateur.

Installation et vérification : [docs/README.md](docs/README.md).
