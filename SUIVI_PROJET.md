# Suivi du projet VehicleCheck

Mis à jour le 17 novembre 2026. État basé sur le dépôt et les vérifications disponibles dans cet environnement.

## Ajouts effectués

- `vehiclecheck/fxmanifest.lua` : manifeste FiveM de la ressource, version prototype 0.1.0.
- `vehiclecheck/shared/config.lua` : configuration centralisée (framework, commande, objet, métier et grade).
- `vehiclecheck/server/main.lua` : détection ESX Legacy, détection automatique avec refus des conflits, contrôle serveur de l'accès et vérification facultative de l'objet via ox_inventory.
- `vehiclecheck/client/main.lua` : commande `/vehiclecheck` et retour utilisateur explicite pour ce prototype.
- README principal actualisé pour différencier le cahier des charges et l'état réellement implémenté.

## Fonctionnel à ce stade

- La ressource possède une structure FiveM minimale cohérente.
- ESX Legacy est le seul adaptateur actuellement implémenté.
- Le mode `framework = 'auto'` refuse zéro ou plusieurs frameworks, et ne prétend pas supporter QBCore/Qbox.
- Les demandes d'ouverture passent par le serveur. Le métier/grade sont vérifiés côté serveur.
- La vérification de la tablette ox_inventory est disponible mais désactivée par défaut (`requireTablet = false`) pour faciliter le premier démarrage.
- Les refus d'accès sont renvoyés au client.

## Non implémenté / non validé

- La tablette, la NUI, les animations, le prop et le diagnostic ne sont pas réalisés : le message d'ouverture est volontairement informatif et n'affiche pas une fausse interface.
- Aucun adaptateur QBCore ou Qbox, aucun inventaire ESX/qb-inventory.
- Aucun rapport, historique, inspection, SQL/oxmysql, cooldown ou localisation.
- L'objet `vehicle_tablet` n'est pas enregistré automatiquement. Il faut le configurer dans ox_inventory avant d'activer `requireTablet`.
- FXServer, ESX, ox_inventory et MySQL ne sont pas installés/démarrés ici. L'exécution réelle en jeu n'a donc pas pu être testée.
- Le serveur n'a pas pu vérifier la présence proche d'un véhicule, l'état vivant, ou l'ouverture réelle d'une interface.

## Vérifications et limites

- Inspection du manifeste et des fichiers Lua effectuée.
- Aucun test automatisé ni test en jeu n'a pu être exécuté : aucun interpréteur Lua/FXServer ou environnement de test configuré n'est disponible dans le dépôt.
- Aucun résultat ci-dessus ne doit être interprété comme une validation de compatibilité runtime.

## Prochaines étapes recommandées

1. Suivre `dev-server/README.md`, démarrer la pile ESX + oxmysql + ox_lib + ox_inventory et valider chaque point de sa porte de démarrage.
2. Lancer la ressource avec `ensure vehiclecheck`, observer les journaux, tester l'autorisation mécanicien et les refus (joueur sans métier/grade).
3. Ajouter l'enregistrement/documentation de `vehicle_tablet`, puis activer `requireTablet` et vérifier le comptage ox_inventory.
4. Construire la phase tablette : ouverture/fermeture, contrôle de vie et véhicule, prop/animation et nettoyage garanti.
5. Ajouter l'identification véhicule et un scan progressif annulable; valider les natives GTA en jeu.
6. Ajouter ensuite inspection, persistance SQL et rapports, avec validation serveur et tests d'abus.
7. N'annoncer ESX/QBCore/Qbox ni les inventaires comme compatibles avant test sur chaque pile réelle.

## Points à corriger ou décider

- Le cahier des charges annonce plusieurs frameworks et inventaires, mais le prototype n'en implémente qu'un : garder l'annonce explicitement au statut « prévu », pas « pris en charge ».
- Décider si l'ouverture doit être réservée au métier `mechanic` et si les administrateurs ont une exception; régler `allowedJobs` et le minimum de grade en conséquence.
- Confirmer la syntaxe d'accès à l'export ESX pour la version ESX Legacy réellement installée.
- Choisir une stratégie d'identification persistante et de plaque dupliquée avant de concevoir les rapports.
- Le README d'environnement contient une porte de validation de la pile qui reste à passer sur une machine avec FXServer/Cfx.re et base de données. Les versions des dépendances doivent être pinnées lors de cette mise en place.
