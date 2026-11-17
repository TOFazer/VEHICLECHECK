# Environnement de développement FiveM

Ce dossier documente l'environnement de test local. Les binaires FXServer, les ressources téléchargées, les configurations réelles et les secrets ne doivent pas être ajoutés au dépôt : ils sont ignorés par Git.

## État actuel

- Le dépôt GitHub `TOFazer/VEHICLECHECK` existe déjà et `origin` pointe dessus ; il n'est pas nécessaire d'en créer un second (la casse du nom n'a pas d'effet sur GitHub).
- Git est initialisé, le remote `origin` et l'identité Git sont déjà configurés.
- Le dossier de ressource `vehiclecheck/` est réservé et volontairement vide.
- Pile de test retenue : **ESX Legacy + MySQL/MariaDB + oxmysql + ox_lib + ox_inventory**.
- La phase de préparation n'est **pas encore validée** dans cet environnement : aucun FXServer, serveur MySQL/MariaDB ou VS Code n'y est installé, aucune clé Cfx.re n'y est configurée et aucun serveur n'a pu être démarré. Ne pas commencer les fonctionnalités avant d'avoir passé les contrôles de validation ci-dessous.

## Pré-requis

1. Installer un artefact FXServer Linux et terminer l'assistant txAdmin sur la machine de développement. Utiliser les instructions officielles Cfx.re : [mise en place d'un serveur](https://docs.fivem.net/docs/server-manual/setting-up-a-server/) et [artefacts Linux](https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/).
2. Créer une clé serveur dans le portail Cfx.re. La clé est un secret : la garder uniquement dans le `server.cfg` local, jamais dans Git ni dans une conversation.
3. Installer et démarrer MySQL ou MariaDB.
4. Installer Git et Visual Studio Code sur la machine de développement. Les extensions recommandées sont déclarées dans [`.vscode/extensions.json`](../.vscode/extensions.json).

Placer les artefacts dans `dev-server/FXServer/` et les données du serveur dans `dev-server/server-data/` si l'on souhaite utiliser cette arborescence. Ces contenus locaux sont ignorés par Git.

## Installer la pile de test

1. Dans txAdmin, déployer **ESX Legacy** à l'aide de sa recette officielle : [esx-framework/esx_core](https://github.com/esx-framework/esx_core). Conserver les versions et la configuration générées par la recette.
2. Installer les versions compatibles des ressources officielles suivantes dans le dossier `resources` du serveur :
   - [`oxmysql`](https://github.com/overextended/oxmysql/releases) — accès MySQL/MariaDB côté serveur ;
   - [`ox_lib`](https://github.com/overextended/ox_lib/releases) — bibliothèque requise par ox_inventory ;
   - [`ox_inventory`](https://github.com/overextended/ox_inventory/releases) — inventaire de test ;
   - `es_extended` — fourni par la recette ESX Legacy.
3. Installer/paramétrer MySQL ou MariaDB, puis créer une base et un compte de développement (adapter le mot de passe localement) :

   ```sql
   CREATE DATABASE vehiclecheck_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'vehiclecheck'@'127.0.0.1' IDENTIFIED BY 'CHOOSE_A_LOCAL_PASSWORD';
   GRANT ALL PRIVILEGES ON vehiclecheck_dev.* TO 'vehiclecheck'@'127.0.0.1';
   FLUSH PRIVILEGES;
   ```

4. Copier [`server-data/vehiclecheck.cfg.example`](server-data/vehiclecheck.cfg.example) vers `dev-server/server-data/vehiclecheck.cfg` (par exemple avec `cp dev-server/server-data/vehiclecheck.cfg.example dev-server/server-data/vehiclecheck.cfg`), puis remplacer la clé Cfx.re et le mot de passe uniquement dans cette copie locale. Ajouter `exec vehiclecheck.cfg` au `server.cfg` produit par txAdmin, avant les démarrages des ressources. Le fichier de configuration réel est ignoré par Git.
5. Vérifier que les ressources démarrent dans cet ordre : `oxmysql`, `ox_lib`, `es_extended`, puis `ox_inventory`. Éviter les `ensure` en double si la recette txAdmin les a déjà ajoutés. Garder les ressources système générées par txAdmin ; l'extrait fourni n'est pas un `server.cfg` complet.

Les versions de développement doivent être conservées/pinnées pour que les essais soient reproductibles. Ne pas ajouter les répertoires téléchargés au dépôt.

## Démarrage et validation — porte obligatoire

Depuis le dossier de données, démarrer FXServer avec la commande adaptée à l'installation locale. Pour l'arborescence proposée sous Linux :

```bash
cd dev-server/server-data
../FXServer/run.sh +exec server.cfg
```

La phase de préparation est validée seulement lorsque les points suivants sont tous vrais :

- FXServer démarre sans erreur et le serveur est joignable depuis un client FiveM de test ;
- txAdmin indique que `oxmysql`, `ox_lib`, `es_extended` et `ox_inventory` sont démarrés ;
- les journaux confirment une connexion réussie à la base de données, sans erreur SQL ou de configuration ;
- VS Code ouvre le dépôt et propose l'extension Lua ;
- Git fonctionne et les fichiers locaux/secrets restent ignorés (`git status` ne doit pas les afficher).

**Tant que cette validation n'est pas obtenue, ne pas commencer le développement fonctionnel de VehicleCheck.** Le dossier `vehiclecheck/` restera donc sans manifest ni code métier. Après validation, commencer la phase de fondations du cahier des charges et seulement alors ajouter `ensure vehiclecheck`.
