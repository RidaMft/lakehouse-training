# 🏞️ Lakehouse Training

## 🌟 Objectif
L’objectif est de structurer les données en schéma en étoile pour faciliter les analyses :

### Dimensions :

- dim_drivers : à partir de drivers.csv
- dim_trucks : à partir de trucks.csv
- dim_trailers : à partir de trailers.csv
- dim_customers : à partir de customers.csv
- dim_facilities : à partir de facilities.csv
- dim_routes : à partir de routes.csv

### Faits : 

- fact_loads : à partir de loads.csv (niveau réservation)
- fact_trips : à partir de trips.csv (niveau exécution)
- fact_delivery_events : à partir de delivery_events.csv (timestamps)
- fact_fuel_purchases : coûts carburant
- fact_maintenance_records : coûts maintenance
- fact_safety_incidents : incidents sécurité

### Tables agrégées

- agg_driver_monthly_metrics
- agg_truck_utilization_metrics

### Relations clés

- fact_trips → dim_drivers, dim_trucks, dim_trailers
- fact_loads → dim_customers, dim_routes
- fact_delivery_events → dim_facilities
- fact_fuel_purchases et fact_maintenance_records → fact_trips (via trip_id)


## Stockage dans Iceberg

Chaque table est créée dans le namespace lakehouse.silver :

- lakehouse.silver.dim_drivers
- lakehouse.silver.fact_trips
- lakehouse.silver.agg_driver_monthly_metrics


Format : Parquet avec partitionnement :

- Faits : partition par year, month (basé sur date)
- Dimensions : partition par status ou location si pertinent

## Configuration dans Superset

Superset se connecte à Trino qui lit Iceberg.

### Étapes

#### Ajouter la source de données :

Connexion : trino://admin@trino:8080/lakehouse
Catalog : iceberg
Schema : lakehouse

#### Importer les tables :

dim_drivers, dim_trucks, fact_trips, etc.

#### Créer des datasets Superset :

Exemple : fact_trips avec jointures sur dim_drivers et dim_trucks.

### Dashboards à créer
#### Dashboard 1 : Performance Opérationnelle

KPI : Total Loads, Total Trips, On-Time Delivery %
Graphiques :

Heatmap : Trips par route et mois
Bar Chart : Revenue par client
Line Chart : Miles vs Fuel Cost par mois

#### Dashboard 2 : Coûts & Maintenance

KPI : Coût carburant, Coût maintenance, Downtime
Graphiques :
- Pie Chart : Répartition des coûts par type
- Trend : Maintenance events par mois

#### Dashboard 3 : Sécurité & Incidents

KPI : Nombre d’incidents, Coût total, % at-fault
Graphiques :
- Map : Incidents par localisation
- Table : Top 10 drivers avec incidents