# Documentation GOLD Tables - Transport/Logistique

---

# 🟡 Table GOLD : `driver_efficiency`

### Objectif
Analyser la performance des conducteurs et leur efficacité carburant sur l’ensemble des trajets.

### Calculs réalisés
- Jointure `fact_trips` × `dim_drivers`.  
- Calcul par conducteur : nombre de trajets, distance totale, consommation moyenne MPG, carburant total et coût carburant.  
- Filtrage des conducteurs avec moins de 50 trajets.  
- Calcul du rang d’efficacité (`mpg_rank`).

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `driver_id` | Identifiant du conducteur |
| `first_name` | Prénom du conducteur |
| `last_name` | Nom du conducteur |
| `trips` | Nombre de trajets réalisés |
| `total_miles` | Distance totale parcourue (miles) |
| `avg_mpg` | Consommation moyenne en miles par gallon |
| `fuel_gallons` | Total carburant utilisé (gallons) |
| `fuel_cost` | Coût total du carburant |
| `mpg_rank` | Rang par efficacité carburant |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Top 10 conducteurs les plus efficaces (bar chart ou table)  
- Histogramme des MPG moyens  
- Scatter plot : total miles vs fuel cost  
- KPI global : moyenne MPG, total fuel cost

---

# 🚛 Table GOLD : `truck_efficiency`

### Objectif
Évaluer l’utilisation et la performance des camions sur les trajets.

### Calculs réalisés
- Jointure `fact_trips` × `dim_trucks` × `agg_truck_utilization_metrics`.  
- Calcul par camion : nombre de trajets, distance totale, consommation moyenne MPG, carburant total et coût carburant.  
- Ajout des métriques d’utilisation (`utilization_rate`, `idle_hours`, `operating_hours`).

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `truck_id` | Identifiant du camion |
| `license_plate` | Plaque d’immatriculation |
| `trips` | Nombre de trajets réalisés |
| `total_miles` | Distance totale parcourue |
| `avg_mpg` | Consommation moyenne MPG |
| `fuel_gallons` | Total carburant utilisé |
| `fuel_cost` | Coût total carburant |
| `utilization_rate` | Taux d’utilisation du camion |
| `idle_hours` | Heures d’inactivité |
| `operating_hours` | Heures de fonctionnement |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Top 10 camions les plus performants  
- Scatter plot : utilisation vs fuel_cost  
- Histogramme des MPG moyens par camion  
- KPI : total miles, total fuel cost

---

# 💸 Table GOLD : `load_profitability`

### Objectif
Analyser la rentabilité par livraison.

### Calculs réalisés
- Jointure `fact_loads` × `fact_trips` × `dim_customers`.  
- Calcul du coût carburant (`fuel_cost = fuel_gallons_used * 3.80`)  
- Calcul de la marge (`margin = revenue - fuel_cost`).

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `load_id` | Identifiant de la livraison |
| `customer_id` | ID client |
| `customer_name` | Nom du client |
| `booking_date` | Date de réservation |
| `revenue` | Revenu de la livraison |
| `actual_distance_miles` | Distance parcourue |
| `fuel_gallons_used` | Carburant utilisé |
| `fuel_cost` | Coût carburant |
| `margin` | Marge générée |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Top 10 livraisons les plus rentables (bar chart)  
- Scatter plot : revenue vs fuel_cost  
- KPI : marge totale par jour ou client

---

# 🛠 Table GOLD : `maintenance_costs`

### Objectif
Suivre les coûts et la performance de maintenance des camions.

### Calculs réalisés
- Jointure `fact_maintenance_records` × `dim_trucks`.  
- Calcul par camion : nombre d’interventions, somme coûts pièces, main d’œuvre, total, downtime moyen.

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `truck_id` | Identifiant du camion |
| `license_plate` | Plaque d’immatriculation |
| `maintenance_events` | Nombre d’interventions |
| `parts_cost` | Coût pièces |
| `labor_cost` | Coût main d’œuvre |
| `total_cost` | Coût total |
| `avg_downtime` | Temps d’indisponibilité moyen |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Histogramme coûts par camion  
- KPI : downtime moyen par camion  
- Table des 10 camions les plus coûteux en maintenance

---

# 🛡 Table GOLD : `safety_summary`

### Objectif
Suivre les incidents et risques liés aux conducteurs.

### Calculs réalisés
- Jointure `fact_safety_incidents` × `dim_drivers`.  
- Calcul par conducteur : nombre total d’incidents, incidents graves, coûts moyens et totaux des dommages.

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `driver_id` | ID conducteur |
| `first_name` | Prénom |
| `last_name` | Nom |
| `incident_count` | Nombre total d’incidents |
| `high_risk_incidents` | Nombre incidents graves |
| `avg_damage_cost` | Coût moyen des dommages |
| `total_damage_cost` | Coût total des dommages |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Top conducteurs avec incidents graves (bar chart)  
- KPI : coût total des dommages  
- Heatmap ou tableau des incidents par conducteur

---

# 🏭 Table GOLD : `facility_geostats`

### Objectif
Analyser les KPI géospatiaux des installations.

### Calculs réalisés
- Jointure `dim_facilities` × `fact_delivery_events`.  
- Calcul du nombre d’événements, livraisons réussies ou retardées.

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `facility_id` | ID de l’installation |
| `facility_name` | Nom de l’installation |
| `latitude` | Latitude |
| `longitude` | Longitude |
| `events` | Nombre total d’événements |
| `delivered` | Nombre livraisons réussies |
| `delayed` | Nombre livraisons retardées |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Carte géographique avec markers par installation  
- KPI : taux de livraison réussie vs retardée  
- Bar chart : top installations par nombre d’événements

---

# 🚚 Table GOLD : `route_performance`

### Objectif
Analyser la performance et l’efficacité des routes.

### Calculs réalisés
- Jointure `dim_routes` × `fact_trips`.  
- Calcul par route : nombre de trajets, distance moyenne, MPG moyen, carburant utilisé, distance totale.

### Colonnes clés
| Colonne | Description |
|---------|------------|
| `route_id` | ID de la route |
| `origin` | Ville de départ |
| `destination` | Ville d’arrivée |
| `trips` | Nombre de trajets sur la route |
| `avg_miles` | Distance moyenne par trajet |
| `avg_mpg` | Consommation moyenne MPG |
| `fuel_used` | Carburant total utilisé |
| `total_miles` | Distance totale parcourue |
| `load_ts` | Timestamp de chargement |

### Visualisations possibles
- Bar chart : top routes par nombre de trajets  
- Scatter plot : avg_mpg vs total_miles  
- KPI : consommation moyenne carburant par route

