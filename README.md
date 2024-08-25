## Data Warehousing Project Documentation

### Design and Implementation of an ELT Pipeline Based on DBT and Airbyte Technologies and Implementation of the BI Component via Metabase
This documentation provides detailed steps for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. The project involves installing these components, creating sources and destinations in Airbyte, and setting up dbt to transform and load data into a PostgreSQL database.

![Interface](./images/pipeline.png?raw=true "Title")
## Table of Contents

1. [Airbyte Installation and Configuration](#airbyte-installation-and-configuration)
2. [dbt Installation and Project Setup](#dbt-installation-and-project-setup)
3. [Dagster Integration](#dagster-integration)
4. [Metabase Installation and Configuration](#metabase-installation-and-configuration)

## Airbyte Installation and Configuration

### 1. Install Airbyte using Docker

1. **Pull Airbyte Docker Image:**

#### Option 1: Using Docker

**Step 1: Download and Run Airbyte Docker**
 ```sh
   docker pull airbyte/airbyte
```

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
Database Name: rawDatabase
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
Database Name: ourDatabase
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



### Conclusion

This documentation provides a step-by-step guide for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. Follow the instructions to install and configure each component, create sources and destinations in Airbyte, and set up dbt to transform and load data into your PostgreSQL database.
