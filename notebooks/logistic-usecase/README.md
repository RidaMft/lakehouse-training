# Formation : Data Lakehouse avec Apache Iceberg, Trino et Superset

## 🎯 Objectifs pédagogiques
Cette formation vous permettra de :
- Comprendre l’architecture **Data Lakehouse** basée sur Apache Iceberg.
- Mettre en place un environnement complet avec **MinIO (S3)**, **Spark**, **Trino**, et **Superset**.
- Ingestion des données brutes (raw), transformation en tables **silver** et exploitation analytique via **dashboards**.

## 🏗️ Architecture
```
RAW (CSV dans MinIO) → Iceberg Tables (raw) → Silver Layer (dimensions & faits) → Gold Layer (agrégats & vues analytiques)
```

- **Stockage** : MinIO (S3-compatible)
- **Format** : Apache Iceberg (tables transactionnelles sur S3)
- **Compute** : Spark pour ingestion & transformation
- **Query Engine** : Trino pour interroger Iceberg
- **BI** : Superset pour visualisation et dashboards

## 📦 Étapes pratiques
1. **Déploiement Docker Compose** :
   - Services : MinIO, Spark, Trino, Superset, PostgreSQL (catalogue Iceberg)
   - Buckets : `raw`, `iceberg-lakehouse`

2. **Ingestion des données brutes** :
   - Téléchargement du ZIP Kaggle
   - Décompression et copie dans MinIO (`raw`)

3. **Transformation avec Spark + Iceberg** :
   - Création des tables raw → silver via notebook `iceberg_raw_to_silver.ipynb`
   - Partitionnement automatique sur colonnes date

4. **Visualisation avec Superset** :
   - Connexion à Trino
   - Import du fichier `superset_import.json` pour dashboards préconfigurés

## 📚 Schéma de la base Logistics Database

### Tables principales
1. **drivers** (PK: driver_id) : infos chauffeur
2. **trucks** (PK: truck_id) : flotte camions
3. **trailers** (PK: trailer_id) : remorques
4. **customers** (PK: customer_id) : clients
5. **facilities** (PK: facility_id) : terminaux
6. **routes** (PK: route_id) : itinéraires

### Tables transactionnelles
7. **loads** (PK: load_id, FK: customer_id, route_id) : réservations
8. **trips** (PK: trip_id, FK: load_id, driver_id, truck_id, trailer_id) : exécution
9. **fuel_purchases** (PK: fuel_purchase_id, FK: trip_id, truck_id) : carburant
10. **maintenance_records** (PK: maintenance_id, FK: truck_id) : maintenance
11. **delivery_events** (PK: event_id, FK: load_id, trip_id, facility_id) : livraisons
12. **safety_incidents** (PK: incident_id, FK: trip_id, truck_id, driver_id) : incidents

### Tables agrégées
13. **driver_monthly_metrics** (driver_id, month) : performance chauffeur
14. **truck_utilization_metrics** (truck_id, month) : utilisation flotte

### Relations clés
- loads → customers, routes
- trips → loads, drivers, trucks, trailers
- fuel_purchases → trips
- maintenance_records → trucks
- delivery_events → trips
- safety_incidents → trips

## 🔍 Cas d’usage analytiques
1. **Performance chauffeur** : taux ponctualité, MPG, revenu/mile
2. **Rentabilité routes** : revenu vs coûts par itinéraire
3. **Utilisation flotte** : miles par camion, revenu par actif
4. **Analyse maintenance** : coût/mile, impact downtime
5. **Efficacité carburant** : tendances MPG, coût carburant par route
6. **Analyse client** : revenu par client, niveaux de service
7. **Sécurité** : taux incidents, accidents évitables
8. **Saisonnalité** : volume de chargements, fluctuations tarifaires

## ▶️ Exécution des notebooks
- `iceberg_ingestion.ipynb` : ingestion des fichiers CSV en tables raw
- `iceberg_raw_to_silver.ipynb` : transformation raw → silver avec partitionnement

## 📊 Dashboards Superset
- **Performance Opérationnelle** : KPI, revenus, volumes
- **Coûts & Maintenance** : carburant, maintenance, downtime
- **Sécurité & Incidents** : incidents par localisation, top chauffeurs

---
**Prérequis** : Docker, Docker Compose, accès Kaggle API (pour téléchargement initial)
**Technologies** : Apache Iceberg, Spark, Trino, Superset, MinIO
