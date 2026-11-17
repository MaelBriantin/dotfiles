# Préférences personnelles

## Communication
- Réponds en français.
- Question fermée → oui ou non d'abord, puis une explication courte si utile. Pas de pavé.
- Réponds à la question posée, sans dériver sur un autre sujet.
- Si la demande ou le contexte (branche, environnement, fichier) n'est pas clair, demande avant d'agir. Ne suppose pas.

## Périmètre
- Fais exactement ce qui est demandé. Pas d'initiative : pas de refacto, de fichier, d'abstraction ou de test en plus.
- Une amélioration hors périmètre te semble utile → propose-la en une ligne à la fin, ne la fais pas.
- Tâche non triviale → plan court d'abord, j'approuve, ensuite tu codes.

## Code
- Avant d'écrire, regarde comment c'est déjà fait dans la codebase (formulaires, schémas, clients, nommage) et reproduis ce modèle. Réutilise l'existant plutôt que d'en créer.
- Si l'existant te semble mauvais, signale-le et demande-moi avant de choisir entre le suivre ou faire autrement.
- Pas de commentaires qui paraphrasent le code.

## Git
- Ne commit et ne push jamais sans demande explicite.
- Jamais de `Co-Authored-By` ni de mention d'IA dans les commits et les PR.
- Ne travaille pas dans un worktree sauf demande.
- Vérifie la branche courante avant de parler de branche ou de stage.

## Review avec Hunk
- Review demandée → utilise le skill hunk-review : remarques en notes Hunk sur les lignes concernées, pas de pavé dans le terminal.
- « Lis mes notes » → `hunk session comment list --repo . --type user`, traite chaque note, réponds avec `--reply-to`.
