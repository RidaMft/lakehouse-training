# 📊 Guide de Création des Dashboards Superset — Retail Medallion

> ✅ Basé sur les tables :  
> - `retail.silver.clean_sales_enriched`  
> - `retail.gold.agg_daily_sales_by_store`  
> - `retail.gold.daily_kpi_dashboard`  
> 
> ✅ Connexion Trino → Catalogue `retail`

---

## 🔌 Étape 0 : Configuration Trino dans Superset

1. **Data → Databases → + Database**
2. Sélectionne **Trino**
3. Remplis :
   - **Database name** : `Retail (Trino)`
   - **SQLAlchemy URI** :  
     ```
     trino://trino:8080/retail
     ```
4. Clique **Test Connection** → ✅ *OK*
5. Sauvegarde

→ Vérifie que les tables apparaissent dans **Data → Datasets**

---

## 📈 Dashboard 1 : `🚀 Vue Exécutive Quotidienne`

### 🔧 Étapes

#### 1. Créer le dataset
- **Data → Datasets → + Dataset**
- Database : `Retail (Trino)`
- Schema : `gold`
- Table : `daily_kpi_dashboard`
- Save

#### 2. Créer les visualisations

| Nom | Type | Paramètres |
|-----|------|------------|
| **CA hier** | Big Number | - Metric : `SUM(revenue_yesterday)` <br> - Format : `€` |
| **Marge brute** | Big Number | - Metric : `AVG(gross_margin_yesterday)` <br> - Format : `.1%` <br> - Threshold : `0.25` (vert si ≥, rouge si <) |
| **Évolution vs semaine** | Big Number with Trendline | - Metric : `AVG(revenue_vs_last_week_pct)` <br> - Format : `+.1%` <br> - Time column : `reporting_date` |
| **Alertes J-1** | Big Number | - Metric : `SUM(n_alerts_yesterday)` <br> - Format : `0` <br> - Color : rouge si > 0 |

#### 3. Créer le dashboard
- **Dashboards → + Dashboard**
- Nom : `🚀 Vue Exécutive Quotidienne`
- Layout : 2×2 grid
- Glisse les 4 KPI
- Ajoute un **Header** (via *Edit CSS* ou Markdown component) :

📅 Données du {{ reporting_date }}
Mise à jour quotidienne à 8h

✅ **Résultat attendu** :
┌─────────────┬───────────────┐
│ CA hier │ Marge brute │
│ 3 926 € │ 40.5% ▲ │
├─────────────┼───────────────┤
│ Évol. semaine│ Alertes J-1 │
│ +12.3% ▲ │ 0 ✅ │
└─────────────┴───────────────┘


---

## 🏪 Dashboard 2 : `🏪 Performance Magasins`

### 🔧 Étapes

#### 1. Dataset
- Schema : `gold`
- Table : `agg_daily_sales_by_store`

#### 2. Visualisations

| Nom | Type | Paramètres |
|-----|------|------------|
| **CA par magasin (7j)** | Time-series Line | - X : `sale_date` <br> - Y : `SUM(total_revenue)` <br> - Group by : `store_name` <br> - Rolling window : `7 days` |
| **Classement magasins** | Table | - Group by : `store_name`, `city` <br> - Metrics : <br>   • `SUM(total_revenue) AS CA` <br>   • `AVG(gross_margin_pct) AS Marge` <br>   • `SUM(n_loss_transactions) AS Pertes` <br> - Order by : `CA DESC` <br> - Conditional formatting : `Pertes > 0 → rouge` |
| **Panier vs Marge** | Scatter | - X : `AVG(avg_basket_size)` <br> - Y : `AVG(gross_margin_pct)` <br> - Size : `SUM(n_transactions)` <br> - Color : `city` <br> - Reference lines : X=140, Y=0.25 |
| **Alertes magasins** | Bar | - X : `store_name` <br> - Y : `SUM(n_loss_transactions)` <br> - Filter : `SUM(n_loss_transactions) > 0` |

#### 3. Dashboard
- Nom : `🏪 Performance Magasins`
- Layout : 2 colonnes
  - Colonne 1 (66%) : Time-series + Scatter
  - Colonne 2 (33%) : Table + Bar
- Ajoute un **Filter Box** en haut :
  - `sale_date` (date range)
  - `city` (multiselect)
  - `gross_margin_pct < 0.2` (toggle)

✅ **Insight clé** :  
→ Le magasin *Saint Jeannenec* a le plus haut panier (136 €) mais 3 ventes à perte → audit pricing nécessaire.

---

## 🔍 Dashboard 3 : `🔍 Audit Pricing & Qualité`

### 🔧 Étapes

#### 1. Dataset
- Schema : `silver`
- Table : `clean_sales_enriched`

#### 2. Visualisations

| Nom | Type | Paramètres |
|-----|------|------------|
| **Répartition alertes** | Pie Chart | - Group by : `alert_flag` <br> - Metric : `COUNT(*)` |
| **Pertes : distribution** | Histogram | - X : `gross_profit` <br> - Bins : 30 <br> - Filter : `margin_status = 'Perte'` |
| **Top 10 produits en perte** | Table | - Group by : `product_name`, `category` <br> - Metrics : <br>   • `SUM(gross_profit) AS Marge_totale` <br>   • `COUNT(*) AS Nb_ventes` <br> - Filter : `margin_status = 'Perte'` <br> - Order : `Marge_totale ASC` |
| **Remises par magasin** | Time-series | - X : `sale_date` <br> - Y : `AVG(discount_applied_pct)` <br> - Group by : `store_name` <br> - Reference line : Y=25 |

#### 3. Dashboard
- Nom : `🔍 Audit Pricing & Qualité`
- Layout : vertical
- Ajoute un **Filter Box** avec :
  - `alert_flag` (multiselect)
  - `margin_status`
  - `store_name`
  - `sale_date`

✅ **Cas d’usage** :  
→ Filtre `alert_flag = 'Prix anormalement bas'` + `store_name = 'Magasin Sainte Étienneboeuf'` → identifie les vendeurs à former.

---

## 🚀 Bonnes Pratiques Superset

| Thème | Recommandation |
|-------|----------------|
| **Performance** | - Ajoute `WHERE sale_date >= CURRENT_DATE - INTERVAL '30' DAY` dans les datasets <br> - Utilise *Row limit* = 10 000 pour les tables |
| **Sécurité** | - Crée des rôles : `Retail_Manager`, `Store_Manager` <br> - Restreins l’accès à `city` par rôle |
| **Maintenance** | - Dans *Dataset → Edit → Advanced*, coche **Expose in SQL Lab** pour debug |
| **Partage** | - Utilise **Share → Public URL** pour les comités <br> - Export PNG hebdomadaire via API |

---

## 📥 Prochaines étapes

1. ✅ Créer les 3 dashboards
2. ⏱️ Planifier un refresh quotidien (Airflow → `spark-submit refresh_gold.py`)
3. 📢 Partager avec les métiers :
   - Direction : `Vue Exécutive`
   - Responsables magasins : `Performance Magasins`
   - Pricing Manager : `Audit Pricing`