# Neo4j Docker Setup

This repository contains instructions and files to set up a Neo4j environment using Docker.

### Prerequisites

- Docker Desktop installed on your machine. You can download it from [Docker's official website](https://www.docker.com/products/docker-desktop).

### Steps to Run

1. **Clone the Repository**
   Clone this repository to your local machine:

   ```bash
   git clone https://github.com/GiannisKarampinis/neo4j-demo
   cd neo4j-demo
   ```

2. **Build the Docker Image**
   docker build -t neo4j-demo .

3. **Run Neo4j container**
   docker run -d --name neo4j-container -p 7474:7474 -p 7687:7687 neo4j-demo

4. **Access Neo4j Browser App**
   Open a web browser and go to http://localhost:7474

5. **Initialize Database**
   Execute :play movies and run the 2nd command for initializing the database

6. **Run the queries**
