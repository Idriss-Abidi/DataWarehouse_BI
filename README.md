## Data Warehousing Project Documentation

This documentation provides detailed steps for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. The project involves installing these components, creating sources and destinations in Airbyte, and setting up dbt to transform and load data into a PostgreSQL database.

![Interface](./images/workflow.png?raw=true "Title")

### 1. Installing Docker

**Step 1: Download and Install Docker**
1. Visit the [Docker website](https://www.docker.com/products/docker-desktop) and download Docker Desktop for your operating system (Windows, macOS, or Linux).
2. Follow the installation instructions for your OS:
   - **Windows**: Run the Docker Desktop Installer executable, follow the prompts, and restart your computer.
   - **macOS**: Open the downloaded .dmg file, drag Docker to your Applications folder, and launch Docker.
   - **Linux**: Follow the instructions specific to your distribution, which typically involve using package managers like `apt`, `yum`, or `snap`.

**Step 2: Verify Docker Installation**
1. Open a terminal or command prompt.
2. Run the command: `docker --version`. You should see the Docker version installed.

### 2. Installing PostgreSQL

#### Option 1: Using Docker

**Step 1: Pull the PostgreSQL Docker Image**
```sh
docker pull postgres:latest
```

**Step 2: Run a PostgreSQL Container**
```sh
docker run --name my_postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```
Replace `mysecretpassword` with a secure password.

**Step 3: Verify PostgreSQL Container**
```sh
docker ps
```

#### Option 2: Installing Locally

**Step 1: Download PostgreSQL Installer**
1. Visit the [PostgreSQL download page](https://www.postgresql.org/download/) and choose your operating system.

**Step 2: Run the Installer**
2. Follow the prompts in the installer to complete the installation, configuring your password and other settings as needed.

**Step 3: Verify PostgreSQL Installation**
1. Open a terminal or command prompt.
2. Run the command: `psql --version`. You should see the PostgreSQL version installed.

### 3. Installing Airbyte

#### Option 1: Using Docker

**Step 1: Download and Run Airbyte Docker**
```sh
docker run -d --name airbyte -p 8000:8000 airbyte/airbyte:latest
```

**Step 2: Access Airbyte UI**
1. Open a web browser and navigate to `http://localhost:8000`.

#### Option 2: Installing Locally

**Step 1: Download Airbyte**
1. Visit the [Airbyte GitHub repository](https://github.com/airbytehq/airbyte) and follow the instructions to clone the repository.

**Step 2: Start Airbyte**
1. Follow the instructions in the repository to start the Airbyte server and UI.

### 4. Installing dbt

We're gonna use dbt core for the 'Transform' phase. You can install [dbt Core]("https://docs.getdbt.com/docs/core/installation-overview") on the command line by using one of these methods:
- Use pip to install dbt
- Use a Docker image to install dbt
- Install dbt from source


**Step 1: Install dbt CLI**

In this case i installed it using pip with [vierual environement]("https://docs.getdbt.com/docs/core/pip-install#using-virtual-environments") so check the documentation for details!

**Step 2: Verify dbt Installation**
1. Open a terminal or command prompt.
2. Run the command: `dbt --version`. You should see the dbt version installed.

### 5. Initializing a dbt Project

**Step 1: Create a New dbt Project**
```sh
dbt init my_dbt_project
```

**Step 2: Configure the dbt Profiles File**
1. Navigate to the `~/.dbt` directory and open the `profiles.yml` file.
2. Add the following configuration for your PostgreSQL database:
```yaml
my_dbt_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: your_username
      password: your_password
      dbname: your_database
      schema: destination_schema #NB: default is public
```
Replace `your_username` and `your_password` with your PostgreSQL credentials. Also `your_database` name and `destination_schema`.

### ELT Process

#### Airbyte

**Step 1: Create Sources in Airbyte**

1. Open the Airbyte UI (`http://localhost:8000`).
2. Navigate to the `Sources` tab and create sources for MySQL, MariaDB, PostgreSQL, and CSV files. Ensure each database is related to a specific schema, not the `destination_schema` schema, in the `your_database` database.

**Step 2: Create Destination in Airbyte**

1. Navigate to the `Destinations` tab and create a destination for your PostgreSQL database using the `result` database and `public` schema.

**Step 3: Connect Sources to Destination and Sync**

1. Navigate to the `Connections` tab and create connections between each source and the destination.
2. Run the sync process to transfer data from the sources to the destination.

#### dbt

**Step 1: Initialize dbt Project**

1. Open a terminal or command prompt.
2. Navigate to your dbt project directory.
3. Run the command: `dbt init`.

**Step 2: Configure `profiles.yml` File**

1. Open the `profiles.yml` file located in the `~/.dbt` directory.
2. Ensure it has the necessary configuration for your PostgreSQL database as shown in the initialization step.

**Step 3: Define Schemas in `schema.yml`**

1. In your dbt project directory, navigate to the `models` folder.
2. Create a `schema.yml` file and define the schemas for your project:
```yaml
version: 2

models:
  - name: my_model
    description: "A description of my model"
    columns:
      - name: column_name
        description: "A description of the column"
```

**Step 4: Create New Tables in `models/examples`**

1. In the `models/examples` folder, create new SQL files to define the tables based on the schemas needed.
2. Ensure these tables insert data into the `destination_schema` schema in your database.

Example SQL file:
```sql
-- models/examples/my_new_table.sql

with source_data as (
  select * from {{ ref('source_table') }}
)

select
  column1,
  column2
from source_data
```

### Conclusion

This documentation provides a step-by-step guide for setting up a data warehousing project using Docker, PostgreSQL, Airbyte, and dbt. Follow the instructions to install and configure each component, create sources and destinations in Airbyte, and set up dbt to transform and load data into your PostgreSQL database.
