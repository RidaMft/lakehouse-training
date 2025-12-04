# 🏞️ Lakehouse Project

## 🌟 Objectif

Ce projet met en place un **Lakehouse** complet pour le traitement et l’analyse de données à grande échelle, en combinant :

- ⚡ **Apache Spark** : traitement distribué  
- 🧊 **Apache Iceberg** : format de table transactionnel  
- 🧬 **Nessie** : versionnement des tables Iceberg  
- 🔍 **Trino** : moteur SQL interactif  
- 📊 **Apache Superset** : visualisation et reporting BI  
- 🧪 **DbEaver** : interface SQL web interactive  
- ☁️ **MinIO** : stockage S3 compatible  
- 🐳 **Docker & Docker Compose** : orchestration locale

🎯 L’objectif est de fournir un environnement **modulaire, scalable et reproductible** pour tester et déployer des pipelines data.

---

## 🏗️ Architecture

```text
+-------------------+       +-------------------+
| Jupyter Notebook  | <-->  |      Spark        |
+-------------------+       +-------------------+
                                        |
                                        v
                                +-------------------+
                                |     Iceberg       |
                                +-------------------+
                                        |
                                        v
                                +-------------------+         +-------------------+
                                |      Trino        |  <-->   |       DbEaver     |
                                +-------------------+         +-------------------+
                                        |
                                        v
                                +-------------------+        
                                |     Superset      |
                                +-------------------+      

+-------------------+        
|      MinIO        |         
+-------------------+       
```

---

## ⚙️ Prérequis

- Docker & Docker Compose  
- Python ≥ 3.10  

---

## 🚀 Installation

### 1. Lancement des services Docker

```bash
docker-compose -f docker-compose.yaml up -d
```

---

### 2. Accès aux interfaces

| Interface         | URL                          | Identifiants par défaut     |
|-------------------|------------------------------|-----------------------------|
| 📓 Jupyter         | http://localhost:8888        | -                           |
| 🔍 Trino UI        | http://localhost:8080        | `trino`                     |
| 📊 Superset        | http://localhost:8088        | `admin` / `admin`           |
| 🧪 DbEaver         | http://localhost:8881        | -                           |
| ☁️ MinIO Console   | http://localhost:9001        | `minio` / `minio123`        |

> Remplace `localhost` par l’IP publique de ton serveur si tu déploies à distance.

---

## 📚 Utilisation

### 🔬 Notebooks

- `notebooks/SparkSQL.ipynb` : requêtes SQL sur Iceberg  

### 🔗 Exemple Spark + Iceberg + Nessie

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("IcebergExample").getOrCreate()

# Lecture d'une table Iceberg
df = spark.sql("SELECT * FROM iceberg.my_table")
df.show()

# Écriture dans Iceberg
new_data = [(1, 'Alice'), (2, 'Bob')]
df_new = spark.createDataFrame(new_data, ["id", "name"])
df_new.write.format("iceberg").mode("append").saveAsTable("iceberg.my_table")
```

### ⚙️ Configuration

- `trino/iceberg.properties` : configuration Trino  
- `superset/` : configuration Superset (optionnelle)  

### 🔗 Connexion Superset

- **SQLAlchemy URI** :

```bash
trino://trino@trino:8080/iceberg/
```

- **Ajout dans Superset** :
  1. Ouvre http://localhost:8088  
  2. Va dans **Data → Databases → +**  
  3. Colle l’URI ci-dessus  

---

## 📈 Avantages

- Environnement reproductible  
- Scalable avec Spark & Trino  
- Versionnement des tables avec Nessie  
- Visualisation et gouvernance intégrées  
- Compatible AWS & S3 local  
- Intégration de données automatisée  

---

## 📎 Commandes utiles

| 📦 Composant        | 🛠️ Commande                                      |
|---------------------|--------------------------------------------------|
| Démarrer les services | `docker-compose up --build -d`                |
| Arrêter les services  | `docker-compose down`                         |
| Voir les conteneurs   | `docker ps`                                   |
| Logs en direct        | `docker-compose logs -f`                      |
| Rebuild complet       | `docker-compose up --build --force-recreate -d` |

