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




## DBT Installation and Project Setup

### 1. DBT Project Setup

1.**Create a New Folder and Clone the Repository**

```sh
mkdir new_project
cd new_project
git clone https://github.com/Idriss-Abidi/DataWarehouse_BI
```

2.**Create a New Folder and Clone the Repository**
```sh
python -m venv dbt_venv
```

Activate the Environment

```sh
{Path to new_project}\dbt_venv\Scripts\Activate.ps1
```

3.**Install dbt-core and dbt-postgres**
Make sure you're still in the new_project folder:
```sh
pip install dbt-core dbt-postgres
```

Move the [dashboard folder](https://github.com/Idriss-Abidi/DataWarehouse_BI/tree/main/dashboard) to the parent rep (in this case 'new_project'). 
Your folder structure should look like this:

```yml
new_project
├── DataWarehouse_BI
├── dbt_venv
└── dashboard 
```

### 2. DBT Configuration

1.**Create the .dbt Folder in the Admin Path**

```sh
mkdir {Path to ADMIN directory}\ADMIN\.dbt
```
Set Up Your Connection Profile

Go back to the new_project folder and run:
```sh
dbt init
```

**Or just keep the profiles.yml file in the DBT project rep**

Follow the prompts to configure the profiles.yml file:

```yml
Enter a name for your project (letters, digits, underscore):
>> choose a name
Which database would you like to use?
[1] postgres
Enter a number: 
>> 1
host (hostname for the instance): 
>> localhost
port [5432]: 
>> 5432
user (dev username): 
>> postgres
pass (dev password):
>> your password
dbname (default database that dbt will build objects in): 
>> Your database name
schema (default schema that dbt will build objects in): 
>> public or other schema
threads (1 or more) [1]:
>> 1
```

After running the setup, go to the ADMIN/.dbt folder and ensure the profiles.yml file is present and correctly configured.

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
     threads: 1
  target: "dev"
```

## PostgreSQL with Docker

### Pull the PostgreSQL Docker Image

```bash
docker pull postgres
```
Start a new PostgreSQL container with the following command:

```bash
docker run --name postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5433:5432 -d postgres
```

Note: This command starts a PostgreSQL container named postgres, sets the password for the postgres user to mysecretpassword, and maps port 5433 on your host machine to port 5432 in the container.

### Access the PostgreSQL Shell

Access the PostgreSQL shell as the postgres user to create a new database:
```bash

CREATE DATABASE res;
```

### Export the Schema Containing the GDA Raw Data Using res.sql File

To export the schema, copy the res.sql file to the PostgreSQL container and execute it:

```bash
# Copy the SQL file into the container
docker cp {Path to the sql file}/res.sql postgres:/tmp/res.sql

# Execute the SQL file inside the container
docker exec -it postgres psql -U postgres -d res -f /tmp/res.sql
```

### Update profiles.yml for dbt Configuration

After setting up PostgreSQL, update your profiles.yml in dbt to match your PostgreSQL configuration.

### 3. Debug and Run Your DBT Project

1.**Move to the DataWarehouse_BI Folder Inside Your new_project Folder**

```sh
cd DataWarehouse_BI
```

2.**Test the Database Connection**

```sh
dbt debug
```

3.**Compile SQL Model Files Against the Current Target Database**

```sh
dbt run
```

If everything went well, you should be able to see the results of the SQL models in your target schema in the PostgreSQL database.


## Metabase Installation and Configuration

1. **Install Metabase using Docker**

Run it using [metabase.db folder](https://github.com/Idriss-Abidi/DataWarehouse_BI/tree/main/dashboard) from this project to get the same dashboard directly.

```sh
docker pull metabase/metabase
docker run -d --name metabase_test3 -p 3000:3000 <Path to DashBoard folder>:/metabase.db metabase/metabase
```

example : 

```sh
docker pull metabase/metabase
docker run -d --name metabase_test3 -p 3000:3000 -v /mnt/c/Users/ADMIN/Desktop/dashboard:/metabase.db metabase/metabase
```

Note: If the installation doesn't work, try the following:

```sh
git config --global http.postBuffer 157286400
docker pull metabase/metabase
docker run -d --name metabase_test3 -p 3000:3000 <Path to DashBoard folder>:/metabase.db metabase/metabase
```

This will start Metabase and make it accessible on http://localhost:3000.

username/email : idrissabidi2020@gmail.com

pwd: test17

2. **Configure Metabase**

In the Metabase setup process:

Note: The host and port values should match those of your PostgreSQL setup, whether you’re using PostgreSQL locally or through Docker.

Go to "Admin" settings.
Click on "Databases" and then "Add Database."
Choose "PostgreSQL" and configure it with the following details:
Database Name: <database_name>
Host: host.docker.internal
Port: 5432
Username:Set the username to postgres (or your custom username).
Password: Set the password to the one you configured for PostgreSQL (mysecretpassword in this case).

3. **Create Dashboards:**

Use Metabase's interface to create and manage dashboards.


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

### Conclusion

This documentation provides a step-by-step guide for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. Follow the instructions to install and configure each component, create sources and destinations in Airbyte, and set up dbt to transform and load data into your PostgreSQL database.
