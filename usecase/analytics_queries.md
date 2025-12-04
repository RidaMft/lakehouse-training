# Exemples de requêtes SQL pour cas d'usage analytiques

## 1. Performance chauffeur : taux ponctualité, MPG, revenu/mile
```sql
SELECT driver_id,
       AVG(on_time_rate) AS avg_on_time_rate,
       AVG(mpg) AS avg_mpg,
       SUM(revenue) / SUM(miles) AS revenue_per_mile
FROM lakehouse.silver.agg_driver_monthly_metrics
GROUP BY driver_id
ORDER BY avg_on_time_rate DESC;
```

## 2. Rentabilité routes : revenu vs coûts par itinéraire
```sql
SELECT r.route_id,
       SUM(l.revenue) AS total_revenue,
       SUM(fp.total_cost + mr.labor_cost + mr.parts_cost) AS total_cost,
       (SUM(l.revenue) - SUM(fp.total_cost + mr.labor_cost + mr.parts_cost)) AS profit
FROM lakehouse.silver.fact_loads l
JOIN lakehouse.silver.dim_routes r ON l.route_id = r.route_id
LEFT JOIN lakehouse.silver.fact_trips t ON t.load_id = l.load_id
LEFT JOIN lakehouse.silver.fact_fuel_purchases fp ON fp.trip_id = t.trip_id
LEFT JOIN lakehouse.silver.fact_maintenance_records mr ON mr.truck_id = t.truck_id
GROUP BY r.route_id
ORDER BY profit DESC;
```

## 3. Utilisation flotte : miles par camion, revenu par actif
```sql
SELECT truck_id,
       SUM(miles) AS total_miles,
       SUM(revenue) AS total_revenue,
       AVG(utilization_rate) AS avg_utilization
FROM lakehouse.silver.agg_truck_utilization_metrics
GROUP BY truck_id
ORDER BY total_miles DESC;
```

## 4. Analyse maintenance : coût/mile, impact downtime
```sql
SELECT truck_id,
       SUM(maintenance_cost) AS total_maintenance_cost,
       SUM(downtime) AS total_downtime,
       SUM(maintenance_cost) / SUM(miles) AS cost_per_mile
FROM lakehouse.silver.agg_truck_utilization_metrics
GROUP BY truck_id
ORDER BY cost_per_mile DESC;
```

## 5. Efficacité carburant : tendances MPG, coût carburant par route
```sql
SELECT r.route_id,
       AVG(mpg) AS avg_mpg,
       SUM(fp.total_cost) AS fuel_cost
FROM lakehouse.silver.fact_trips t
JOIN lakehouse.silver.dim_routes r ON t.load_id = r.route_id
LEFT JOIN lakehouse.silver.fact_fuel_purchases fp ON fp.trip_id = t.trip_id
GROUP BY r.route_id
ORDER BY avg_mpg DESC;
```

## 6. Analyse client : revenu par client, niveaux de service
```sql
SELECT c.customer_id,
       c.name,
       SUM(l.revenue) AS total_revenue,
       AVG(on_time_rate) AS avg_on_time_rate
FROM lakehouse.silver.fact_loads l
JOIN lakehouse.silver.dim_customers c ON l.customer_id = c.customer_id
LEFT JOIN lakehouse.silver.fact_trips t ON t.load_id = l.load_id
LEFT JOIN lakehouse.silver.agg_driver_monthly_metrics m ON t.driver_id = m.driver_id
GROUP BY c.customer_id, c.name
ORDER BY total_revenue DESC;
```

## 7. Sécurité : taux incidents, accidents évitables
```sql
SELECT driver_id,
       COUNT(incident_id) AS incident_count,
       SUM(CASE WHEN at_fault THEN 1 ELSE 0 END) AS preventable_incidents,
       SUM(cost) AS total_incident_cost
FROM lakehouse.silver.fact_safety_incidents
GROUP BY driver_id
ORDER BY incident_count DESC;
```

## 8. Saisonnalité : volume de chargements, fluctuations tarifaires
```sql
SELECT YEAR(booking_date) AS year,
       MONTH(booking_date) AS month,
       COUNT(load_id) AS load_count,
       AVG(revenue) AS avg_revenue
FROM lakehouse.silver.fact_loads
GROUP BY YEAR(booking_date), MONTH(booking_date)
ORDER BY year, month;
```
