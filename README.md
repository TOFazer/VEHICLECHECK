# VEHICLECHECK
# OVERX — VEHICLECHECK
## Cahier des charges technique et plan d'implémentation
**Version :** 1.0.0  
**Statut :** Cahier des charges + fondations techniques 0.1.0 (prototype non testé en jeu)
**Produit :** FiveM Automotive Diagnostic System

> **Environnement de développement :** suivre [`dev-server/README.md`](dev-server/README.md).
> La pile FiveM n'est pas disponible dans cet environnement : le code livré constitue uniquement les fondations statiques et doit être validé sur un FXServer avant toute fonctionnalité métier. Voir [`SUIVI_PROJET.md`](SUIVI_PROJET.md) pour l'état détaillé.

---

# 1. Présentation du projet

VehicleCheck est une ressource FiveM destinée aux serveurs Roleplay. Elle permet aux mécaniciens de réaliser des diagnostics automobiles, des inspections manuelles et de générer des rapports professionnels grâce à une tablette interactive.

L'objectif est de proposer un outil immersif, facile à installer, performant et compatible avec les principaux frameworks FiveM.

### Objectifs principaux

- Proposer une véritable expérience de diagnostic automobile.
- Améliorer le Roleplay des mécaniciens.
- Fournir une interface moderne et intuitive.
- Fonctionner sur ESX, QBCore et Qbox.
- Prendre en charge plusieurs systèmes d'inventaire.
- Conserver les rapports dans une base de données.
- Être commercialisable sur Tebex.

### Positionnement commercial

VehicleCheck doit être une ressource accessible aux petits et grands serveurs.

Prix de lancement envisagé : 5,99 €.

Prix normal : 7,99 €.

# 2. Fonctionnement général

Le joueur doit pouvoir ouvrir VehicleCheck de deux manières :

1. Utiliser l'objet `vehicle_tablet` dans son inventaire.
2. Utiliser la commande `/vehiclecheck`.

Les deux méthodes doivent appeler le même système central.

### Conditions d'ouverture

- Le joueur doit posséder une tablette.
- Le joueur doit disposer des permissions nécessaires.
- Le joueur doit être vivant.
- Le joueur ne doit pas être dans un véhicule.
- Le système ne doit pas déjà être ouvert.

Le contrôle du métier et du grade doit être configurable.

### Déroulement

1. Vérification des autorisations.
2. Vérification de la tablette.
3. Recherche d'un véhicule à proximité.
4. Lecture de ses informations.
5. Création de l'animation.
6. Attachement de la tablette 3D.
7. Ouverture de la NUI.
8. Utilisation du système.
9. Fermeture et nettoyage des éléments temporaires.

# 3. Gestion de la tablette physique

La tablette doit être visible pendant toute la durée d'utilisation.

### Fonctionnalités

- Prop 3D attaché à la main.
- Animation de consultation.
- Animation de sortie.
- Animation de rangement.
- Ouverture de l'interface.
- Fermeture avec Échap.
- Nettoyage du prop lors de la fermeture.

### Gestion des interruptions

Le système doit automatiquement fermer l'interface et nettoyer l'animation lorsque :

- Le joueur meurt.
- Le joueur se déconnecte.
- Le joueur entre dans un véhicule.
- Le joueur perd ses autorisations.
- La ressource est arrêtée.
- Une situation empêche l'utilisation normale de la tablette.

Le système doit empêcher la création de plusieurs tablettes physiques simultanément pour un même utilisateur.

# 4. Gestion des frameworks

VehicleCheck doit utiliser une architecture multi-framework avec des adaptateurs indépendants.

### Frameworks supportés

- ESX Legacy.
- QBCore.
- Qbox.

### Détection automatique

Au démarrage :

1. Vérifier les frameworks actifs.
2. Identifier celui utilisé.
3. Charger l'adaptateur correspondant.
4. Vérifier les fonctions nécessaires.
5. Afficher une erreur claire si aucun framework compatible n'est disponible.

Le mode automatique doit refuser une configuration ambiguë lorsque plusieurs frameworks sont actifs.

### Fonctions communes des adaptateurs

Chaque adaptateur devra fournir :

- Récupération des informations du joueur.
- Récupération de l'identifiant persistant.
- Récupération du métier.
- Récupération du grade.
- Vérification du service.
- Vérification des permissions.
- Récupération du nom RP.

Le cœur de VehicleCheck ne devra jamais dépendre directement d'une API spécifique à ESX, QBCore ou Qbox.

# 5. Gestion des inventaires

### Inventaires prioritaires

1. ox_inventory.
2. Inventaire natif ESX.
3. qb-inventory.
4. Inventaire Qbox configuré sur le serveur.

Un adaptateur spécifique sera prévu pour chaque inventaire.

### Détection

La détection automatique devra identifier les ressources disponibles et choisir l'adaptateur correspondant.

En cas de conflit, l'administrateur pourra forcer le choix dans la configuration.

### Objet

Nom interne : `vehicle_tablet`.

Nom affiché : Tablette de diagnostic.

Propriétés :

- Objet utilisable.
- Non empilable.
- Poids configurable.
- Image personnalisée.
- Description personnalisable.

L'installation devra fournir les instructions d'enregistrement pour chaque inventaire.

L'objet ne devra pas être automatiquement distribué aux joueurs.

# 6. Diagnostic automobile

Le diagnostic automatique constitue le cœur du produit.

### Informations générales

- Modèle du véhicule.
- Plaque.
- Catégorie.
- Couleur lorsque disponible.
- Niveau de carburant.
- Date du diagnostic.

### Composants analysés

| Composant | Source |
|---|---|
| Moteur | Données natives GTA V |
| Carrosserie | Données natives GTA V |
| Réservoir | Données natives GTA V |
| Pneus | Santé et état des roues |
| Carburant | Native ou adaptateur carburant |
| Saleté | Données natives GTA V |
| Portes | État et dommages détectables |
| Vitres | État et dommages détectables |

### Normalisation

Les valeurs natives devront être transformées en indicateurs compréhensibles.

Chaque composant pourra avoir :

- Une valeur numérique.
- Un état.
- Un niveau de gravité.
- Une description.

Les valeurs indisponibles devront être signalées comme non mesurables, et non remplacées par des valeurs inventées.

Le kilométrage réel n'est pas inclus dans la V1.0.

### Classification

- Excellent.
- Bon.
- À surveiller.
- Défectueux.
- Non mesurable.

Le résultat global devra tenir compte des anomalies importantes et pas uniquement d'une moyenne arithmétique.

# 7. Système de scan progressif

Le scan devra être visuellement animé.

### Déroulement

1. Initialisation du diagnostic.
2. Identification du véhicule.
3. Analyse du moteur.
4. Analyse de la carrosserie.
5. Analyse du réservoir.
6. Analyse des pneus.
7. Analyse des autres composants.
8. Finalisation.
9. Affichage des résultats.

### Interface pendant le scan

- Barre de progression.
- Pourcentage.
- Nom de l'étape actuelle.
- Animation de scan.
- Indication de traitement.
- Possibilité d'annuler.

La durée sera configurable.

Valeur initiale proposée : 6 secondes.

Les résultats ne devront apparaître comme définitifs qu'après la fin du scan.

Les données du véhicule devront être relevées au moment approprié et contrôlées avant la finalisation du rapport.

Un scan annulé ne devra pas créer un rapport final.

# 8. Inspection manuelle

Le mécanicien pourra compléter le diagnostic automatique.

### Points de contrôle

- Pneus.
- Phares.
- Feux arrière.
- Vitres.
- Carrosserie.
- État visuel du moteur.
- Dégâts visibles.
- Observations complémentaires.

### États disponibles

- Conforme.
- À surveiller.
- Défectueux.
- Non vérifié.

Chaque point devra pouvoir recevoir un commentaire.

Le résultat manuel devra être conservé séparément des mesures automatiques.

# 9. Évaluation générale

VehicleCheck devra calculer un état général.

Les résultats possibles :

- Excellent.
- Bon.
- À surveiller.
- Défectueux.
- Non conforme.

Les règles seront configurables.

Une anomalie critique devra pouvoir imposer un résultat défavorable indépendamment de l'état des autres composants.

La classification devra rester cohérente entre deux diagnostics identiques.

# 10. Gestion des rapports

Chaque diagnostic finalisé pourra générer un rapport.

### Informations enregistrées

- Numéro unique.
- Modèle.
- Plaque.
- Identifiant du véhicule si disponible.
- Mécanicien.
- Client si disponible.
- Garage.
- Date.
- Données automatiques.
- Inspection manuelle.
- Commentaires.
- Résultat global.

### Fonctions

- Créer un rapport.
- Consulter un rapport.
- Rechercher par plaque.
- Rechercher par numéro.
- Consulter l'historique.
- Comparer deux rapports.
- Supprimer un rapport selon les permissions.

Un rapport enregistré devra être immuable concernant les résultats historiques. Une réparation ultérieure ne devra pas modifier les anciens résultats.

# 11. Base de données

Dépendance : oxmysql.

### Table vehiclecheck_reports

Contient les informations principales :

- id.
- report_number.
- vehicle_identifier.
- plate.
- model.
- mechanic_identifier.
- mechanic_name.
- customer_identifier.
- garage.
- status.
- created_at.

### Table vehiclecheck_report_items

Contient les détails :

- id.
- report_id.
- category.
- component.
- measured_value.
- result.
- comment.

### Exigences

- Clés étrangères.
- Index sur les plaques et dates.
- Requêtes paramétrées.
- Validation des données.
- Gestion des erreurs SQL.
- Limitation de la taille des commentaires.
- Pagination de l'historique.

L'historique devra pouvoir être limité par configuration.

L'identification des véhicules devra tenir compte des possibilités de plaques dupliquées ou modifiées.

# 12. Interface NUI

La NUI sera développée en HTML, CSS et JavaScript.

Aucun CDN obligatoire.

### Identité visuelle

Direction artistique OverX Forest :

- Noir profond.
- Vert forêt.
- Vert sauge.
- Gris foncé.
- Blanc cassé.
- Accents verts discrets.

### Pages

**Dashboard**
- Informations du mécanicien.
- Nom du garage.
- Derniers diagnostics.
- Nouveau diagnostic.

**Diagnostic**
- Identification du véhicule.
- Scan progressif.
- Résultats détaillés.
- Anomalies.

**Inspection**
- Checklist.
- Commentaires.
- Validation.

**Rapports**
- Liste des rapports.
- Recherche.
- Consultation.
- Comparaison.

**Paramètres**
- Préférences d'affichage.
- Langue si autorisée.
- Options utilisateur disponibles.

### Exigences ergonomiques

- Interface responsive.
- Navigation simple.
- Animations fluides.
- Fermeture avec Échap.
- Gestion correcte de la souris.
- Aucun débordement.
- Aucun écran bloqué.
- États de chargement et erreurs visibles.

# 13. Multilingue

Langues obligatoires :

- Français.
- Anglais.

Tous les textes de l'interface et messages système devront utiliser des fichiers de traduction.

Aucun texte utilisateur ne devra être codé en dur dans les modules métier.

La langue française sera sélectionnée par défaut.

L'administrateur pourra choisir la langue dans la configuration.

# 14. Architecture des fichiers

```text
vehiclecheck/
│
├── fxmanifest.lua
├── config.lua
├── README.md
├── LICENSE
│
├── shared/
│   ├── constants.lua
│   ├── utils.lua
│   └── validation.lua
│
├── bridge/
│   ├── init.lua
│   ├── esx.lua
│   ├── qbcore.lua
│   ├── qbox.lua
│   ├── inventory.lua
│   └── fuel.lua
│
├── client/
│   ├── main.lua
│   ├── tablet.lua
│   ├── animation.lua
│   ├── vehicle.lua
│   ├── diagnostic.lua
│   ├── inspection.lua
│   ├── reports.lua
│   └── nui.lua
│
├── server/
│   ├── main.lua
│   ├── framework.lua
│   ├── permissions.lua
│   ├── tablet.lua
│   ├── diagnostic.lua
│   ├── inspection.lua
│   ├── reports.lua
│   ├── database.lua
│   └── callbacks.lua
│
├── database/
│   └── install.sql
│
├── web/
│   ├── index.html
│   ├── css/
│   ├── js/
│   └── assets/
│
└── locales/
    ├── fr.lua
    └── en.lua
```

# 15. Configuration administrateur

Le fichier config.lua devra centraliser :

- Framework.
- Inventaire.
- Langue.
- Métier.
- Grades.
- Service obligatoire.
- Objet tablette.
- Commande.
- Animation.
- Distance.
- Durée du scan.
- Composants activés.
- Historique.
- Base de données.
- Permissions.
- Limites d'utilisation.
- Intégration carburant.

L'administrateur ne devra pas modifier les fichiers internes pour personnaliser le fonctionnement standard.

# 16. Sécurité

Les règles suivantes sont obligatoires :

- Vérification serveur des permissions.
- Vérification de la possession de la tablette.
- Vérification du métier et du grade.
- Contrôle de distance.
- Validation des véhicules.
- Limitation de fréquence.
- Validation des rapports.
- Protection contre les événements réseau abusifs.
- Requêtes SQL paramétrées.
- Contrôle des identifiants.
- Limitation des entrées utilisateur.

Les données natives provenant du client devront être considérées comme non fiables jusqu'à leur validation.

La création des rapports sera contrôlée côté serveur.

Aucune récompense financière ne devra dépendre uniquement d'un résultat de diagnostic fourni par le client.

# 17. Optimisation

Objectifs :

- Aucune boucle coûteuse lorsque la tablette est fermée.
- Pas de scan permanent.
- Pas de requête SQL inutile.
- Fermeture propre des interfaces.
- Nettoyage des entités temporaires.
- Historique paginé.
- Gestion des événements sans duplication.
- Consommation faible au repos.

Les performances seront mesurées en jeu, au repos et pendant les diagnostics.

# 18. Plan d'implémentation

## Phase 1 — Fondations

- Création de la ressource.
- Manifest.
- Configuration.
- Constantes.
- Détection des frameworks.
- Détection des inventaires.
- Système de logs.

Livrable : ressource démarrable et architecture validée.

## Phase 2 — Tablette

- Objet utilisable.
- Commande.
- Permissions.
- Animation.
- Prop 3D.
- Gestion des interruptions.
- Ouverture NUI.

Livrable : tablette entièrement utilisable.

## Phase 3 — Véhicules

- Détection du véhicule proche.
- Identification.
- Lecture des données.
- Normalisation.
- Gestion des valeurs indisponibles.

Livrable : identification et données automobiles fonctionnelles.

## Phase 4 — Diagnostic

- Analyse des composants.
- Scan progressif.
- Progression visuelle.
- Annulation.
- Résultats.
- Évaluation globale.

Livrable : diagnostic automatique complet.

## Phase 5 — Interface

- Dashboard.
- Diagnostic.
- Inspection.
- Rapports.
- Historique.
- Traductions.

Livrable : NUI finalisée.

## Phase 6 — Rapports SQL

- Schéma SQL.
- Enregistrement.
- Consultation.
- Recherche.
- Historique.
- Pagination.
- Gestion des erreurs.

Livrable : système de rapports persistant.

## Phase 7 — Sécurité

- Permissions.
- Validation serveur.
- Protection réseau.
- Cooldowns.
- Tests d'abus.

Livrable : version sécurisée.

## Phase 8 — Compatibilité

Tests sur :

- ESX Legacy.
- QBCore.
- Qbox.
- ox_inventory.
- Inventaire ESX.
- qb-inventory.
- Inventaires Qbox compatibles.

Livrable : compatibilité documentée.

## Phase 9 — Commercialisation

- Documentation FR/EN.
- Guide d'installation.
- Fichiers SQL.
- Images.
- Vidéo de présentation.
- Packaging.
- Licence.
- Version 1.0.0.

Livrable : produit prêt à la vente.

# 19. Critères de validation

VehicleCheck ne pourra être considéré comme terminé que si :

1. La ressource démarre sans erreur.
2. Les trois frameworks sont testés.
3. Les inventaires annoncés sont testés.
4. La tablette s'ouvre par les deux méthodes.
5. L'objet physique est correctement attaché.
6. L'animation est correctement nettoyée.
7. Le scan progresse visuellement.
8. Les résultats sont cohérents avec les natives utilisées.
9. Les inspections manuelles fonctionnent.
10. Les rapports sont sauvegardés.
11. L'historique est consultable.
12. Les permissions sont appliquées côté serveur.
13. Les deux langues sont complètes.
14. Les erreurs sont correctement gérées.
15. La documentation permet une installation autonome.

# 20. Évolutions après la V1.0

### VehicleCheck 1.1
- Comparaison avant/après réparation.
- Amélioration des rapports.
- Export Discord facultatif.

### VehicleCheck 1.2
- Contrôle technique RP.
- Certificats.
- Échéances de contrôle.

### VehicleCheck 1.3
- Devis.
- Facturation.
- Gestion des interventions.

### VehicleCheck 2.0
- Gestion de flotte.
- Historique avancé.
- Statistiques de garage.
- Intégrations avec d'autres ressources.

---

# 21. Définition finale du produit

VehicleCheck 1.0.0 est un système complet de diagnostic automobile Roleplay, reposant sur une architecture modulaire, une interface NUI immersive, une tablette physique, un système de rapports et une compatibilité multi-framework.

**Les priorités absolues sont :**

1. Fiabilité.
2. Compatibilité.
3. Simplicité d'installation.
4. Qualité visuelle.
5. Sécurité.
6. Performances.
7. Facilité de maintenance.

**Règle de développement :** chaque phase doit être terminée, testée et validée avant de passer à la suivante. Aucun module ne doit être considéré comme terminé simplement parce que son interface fonctionne.

**Statut final : CAHIER DES CHARGES VALIDÉ — PRÊT POUR LE DÉVELOPPEMENT.**
