## Data Warehousing Project Documentation

### Design and Implementation of an ELT Pipeline Based on DBT and Airbyte Technologies and Implementation of the BI Component via Metabase
This documentation provides detailed steps for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. The project involves installing these components, creating sources and destinations in Airbyte, and setting up dbt to transform and load data into a PostgreSQL database.

![Interface](./images/gda_pipeline.png?raw=true "Title")
## Table of Contents

1. [Airbyte Installation and Configuration](#airbyte-installation-and-configuration)
2. [dbt Installation and Project Setup](#dbt-installation-and-project-setup)
3. [Dagster Integration](#dagster-integration)
4. [Metabase Installation and Configuration](#metabase-installation-and-configuration)

## Airbyte Installation and Configuration

### 1. Install Airbyte using Docker

1. **Pull Airbyte Docker Image:**

**Step 1: Download Airbyte Docker**
[Setup & launch Airbyte](https://docs.airbyte.com/deploying-airbyte/docker-compose)

**Step 2: Run Airbyte with Docker:**
```sh
docker run -d --name airbyte -p 8000:8000 airbyte/airbyte:latest
```

**Step 3: Access Airbyte UI**
 Open a web browser and navigate to `http://localhost:8000`.
 
#### For Other Installation Options:
Visit the [Airbyte Documentation](https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart) and follow the instructions to clone the repository.

### 2. Configure MySQL as Source

1. **Create a Dedicated Read-Only MySQL User:**
Run the following SQL commands in your MySQL database to create a dedicated read-only user:
```sh
CREATE USER <user_name> IDENTIFIED BY 'your_password_here';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO <user_name>;
```
Replace <user_name> and your_password_here with your desired username and password.

2. **Create a New MySQL Source in Airbyte:**

Go to the "Sources" tab in Airbyte's UI.
Search for "MySQL" and create a new MySQL source.
Fill in the required information:
```yaml
Hostname: The hostname of your MySQL server (depends on your installation method).
Port: 3306
Database Name: rawDatabase #Your_database_name
Username: The username you created in Step 1.
Password: The password you created in Step 1.
```
For more detailed instructions, visit [the Airbyte MySQL Source Documentation](https://docs.airbyte.com/integrations/sources/mysql).

3. **Set Up MySQL Replication Modes:**
When configuring the connection, choose the "Scan Changes with User Defined Cursor" replication mode.
Select the lastModificationDate column to ensure that each operation will be detected.

### 3. Configure PostgreSQL as Destination

1. **Create a Dedicated Read-Only MySQL User:**
Ensure you have a PostgreSQL server version 9.5 or above running. If needed, create a dedicated user for Airbyte:
```sh
CREATE USER airbyte_user WITH PASSWORD '<password>';
GRANT CREATE, TEMPORARY ON DATABASE <database> TO airbyte_user;
Replace <password> and <database> with the desired password and database name.
```

2. **Create a New PostgreSQL Destination in Airbyte:**
Go to the "Destinations" tab in Airbyte's UI.
Search for "PostgreSQL" and create a new PostgreSQL destination.
Fill in the required information:
```yaml
Host: The hostname of your PostgreSQL server.
Port: 5432
Username: airbyte_user (or the user you created).
Password: The password you created.
Database Name: ourDatabase #Your_database_name
Default Schema Name: public (or your desired schema).
```
For more detailed instructions, visit [the Airbyte PostgreSQL Destination Documentation]("https://docs.airbyte.com/integrations/destinations/postgres") .

### 4. Automate and Schedule Airbyte Connection

1. **Set Up Scheduling:**
Go to the "Connections" tab.
Select your connection and click on "Edit."
Set the sync frequency according to your needs.

2. **Use Last Modification Date Field as Trigger:**
In the sync settings, enable incremental sync and configure the "Last Modification Date" field as the trigger for updates.




## dbt Installation and Project Setup

### 1. Install dbt
1. **Install dbt Core:**
   ```sh
   pip install dbt-core
   pip install dbt-postgres
   ```
### 2. Create a dbt Project
1. **Initialize the Project:**
```sh
dbt init my_project
```
2. **Configure dbt Profiles:**
Navigate to the profiles.yml file, typically located in the ~/.dbt/ directory.

Configure the PostgreSQL connection:
```yaml
our_database:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: <your_postgres_username>
      password: <your_postgres_password>
      port: 5432
      dbname: ourDatabase
      schema: public
```

### 3. Create dbt Models
1. **Copy Model Files:**

Place your SQL model files in the models/ directory within your dbt project.

source: This folder will contain models that directly mirror tables from the rawDatabase.
dimension: This folder will contain models that create dimension tables, usually derived from the source models.
fact: This folder will contain models that create fact tables, used in analytical queries.

Copy all the contents of the models folder in this repository to the appropriate folders (source, dimension, fact) in your dbt project. Ensure that the models are organized correctly:

Source models go into the models/src folder.
Dimension models go into the models/dim folder.
Fact models go into the models/fact folder.

2. **Modify schema.yml:**

Update the schema.yml file in your dbt project to include all tables from the rawDatabase. The schema.yml should reflect the structure and columns of the tables in your source folder.

3. **Modify profiles.yml:**

Update the profiles.yml file in your /.dbt folder to include your postgres database as destination.

```yaml
dbt_proj:
  outputs:
   dev:
     type: "postgres"
     host: "localhost"
     user:  your_user
     password: your_password
     port: 5432
     dbname: "ourDatabase" #your database name
     schema: "public" #or other schema
     threads: 4
  target: "dev"
```


## Dagster Integration
1. **Initialize a Dagster Project:**
Using [dbt (dagster-dbt)](https://docs.dagster.io/_apidocs/libraries/dagster-dbt#dagster-dbt-project-scaffold)
```sh
pip install dagster dagster-dbt dagster-webserver 
dagster-dbt project scaffold --project-name my_dagster_project --dbt-project-dir <Path to dbt project>
```
This will create a new Dagster project directory my_dagster_project.

2. **Running Dagster locally:**
Change the port to 5000 to avoid metabase port (3000)
```sh
cd my_dagster_project
dagster dev -p 5000
```

## Metabase Installation and Configuration

1. **Install Metabase using Docker**
Run it using [metabase.db folder](https://github.com/Idriss-Abidi/DataWarehouse_BI/tree/main/dashboard) from this project to get the same dashboard directly.
```sh
docker pull metabase/metabase
docker run -d --name metabase_test3 -p 3000:3000 <Path to DashBoard folder>:/metabase.
```
example : 
```sh
docker pull metabase/metabase
docker run -d --name metabase_test3 -p 3000:3000 -v /mnt/c/Users/ADMIN/Desktop/dashboard:/metabase.
```
This will start Metabase and make it accessible on http://localhost:3000.

2. **Add PostgreSQL Database to Metabase**

Go to "Admin" settings.
Click on "Databases" and then "Add Database."
Choose "PostgreSQL" and configure it with the following details:
Database Name: ourDatabase
Host: localhost
Port: 5432
Username: <your_postgres_username>
Password: <your_postgres_password>

3. **Create Dashboards:**

Use Metabase's interface to create and manage dashboards based on your ourDatabase schema.


### Conclusion

This documentation provides a step-by-step guide for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. Follow the instructions to install and configure each component, create sources and destinations in Airbyte, and set up dbt to transform and load data into your PostgreSQL database.
