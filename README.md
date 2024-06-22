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
   Execute :play movies (1st Set of queries) or :play northwind-graph (2nd set of queries)

<br>
<br>
<br>
<br>
<br>

# 1st Set of Neo4j Cypher Queries

1. **Find actors who have acted in movies released after 2000 and whose name starts with "M" or played the role of "Neo":**

   ```cypher
   MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
   WHERE m.released > 2000 AND (p.name STARTS WITH "M" OR "Neo" IN r.roles)
   RETURN p
   ```

2. **Find people who have both acted in and directed the same movie, showing their names and the movie title:**

   ```cypher
   MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
   WHERE (p)-[:DIRECTED]->(m)
   RETURN p.name, m.title
   ```

   ```cypher
   MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(p:Person) RETURN p.name, m.title
   ```

   ```cypher
   MATCH (p:Person)-[:ACTED_IN]->(m:Movie), (p)-[:DIRECTED]->(m) RETURN p.name, m.title
   ```

3. **Find directors who have never acted in any movie:**

   ```cypher
   MATCH (p:Person)-[:DIRECTED]->(m:Movie)
   WHERE NOT (p)-[:ACTED_IN]->()
   RETURN DISTINCT p.name
   ```

   ```cypher
   MATCH (p:Person)-[:DIRECTED]->(m:Movie)
   WHERE NOT (p)-[:ACTED_IN]->(:Movie)
   RETURN DISTINCT p
   ```

4. **Display the number of movies each actor who acted in "The Matrix" has played in, sorted in descending order:**

   ```cypher
   MATCH (:Movie { title: "The Matrix" })<-[:ACTED_IN]-(actor)-[:ACTED_IN]->(movie)
   RETURN actor.name, COUNT(*) AS count
   ORDER BY count DESC
   ```

   ```cypher
   MATCH (p:Person)-[:ACTED_IN]->(:Movie {title: "The Matrix"}),
   (p)-[:ACTED_IN]->(m:Movie)
   RETURN p.name, COUNT(*) AS count
   ORDER BY count DESC
   ```

5. **Count actors born between 1955 and 1975 per movie:**

   ```cypher
   MATCH (p)-[:ACTED_IN]->(m)
   WHERE p.born >= 1955 AND p.born <= 1975
   RETURN m.title, COUNT(*) AS count
   ```

6. **Find the movie with the most actors:**

   ```cypher
   MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
   WITH m, COUNT(p) AS played
   RETURN m.title, played
   ORDER BY played DESC
   LIMIT 1
   ```

   ```cypher
   MATCH (p:Person)-[:ACTED_IN]->(m:Movie) RETURN m.title, COUNT (*) AS cnt ORDER BY cnt DESC LIMIT 1
   ```

7. **Actors who have acted in "Snow Falling on Cedars" or "The Green Mile", including the movies they acted in:**

   ```cypher
   MATCH (p)-[:ACTED_IN]->(m)
   WHERE m.title="Snow Falling on Cedars" OR m.title="The Green Mile"
   RETURN m, p
   ```

8. **Movies in which both Keanu Reeves and Hugo Weaving have acted:**

   ```cypher
   MATCH (p1:Person { name: "Keanu Reeves" })-[:ACTED_IN]->(m)<-[:ACTED_IN]-(p2:Person { name: "Hugo Weaving" }) RETURN p1, p2, m
   RETURN m
   ```

9. **Actors who have never acted in any movie that Keanu Reeves or Tom Hanks have acted in:**

   ```cypher
   MATCH (p:Person)
   WHERE NOT (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(:Person { name:"Keanu Reeves" })
     AND NOT (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(:Person { name:"Tom Hanks" })
   AND p.name <> "Keanu Reeves" AND p.name <> "Tom Hanks"
   RETURN DISTINCT p.name
   ```

10. **Actors who have acted in at least 3 movies, sorted by the number of movies:**

    ```cypher
    MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
    WITH p, COUNT(*) AS played
    WHERE played >= 3
    RETURN p.name, played
    ORDER BY played DESC
    ```

11. **Number of actors in each movie where at least one actor has acted in "A Few Good Men", ordered by the number of actors:**

    ```cypher
    MATCH (:Movie { title:"A Few Good Men" })<-[:ACTED_IN]-(p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p1:Person)
    RETURN m.title, COUNT(DISTINCT p1) AS played
    ORDER BY played DESC
    ```

12. **Pairs of actors who have acted together in at least two movies:**

    ```cypher
    MATCH (m1)<-[:ACTED_IN]-(p:Person)-[:ACTED_IN]->(m)<-[:ACTED_IN]-(p1:Person)-[:ACTED_IN]->(m1)
    WHERE p.name < p1.name
    RETURN DISTINCT p.name, p1.name
    ```

13. **Shortest path length from Tom Hanks to each actor:**

    ```cypher
    MATCH p=shortestPath((tom:Person { name:"Tom Hanks" })-[*]-(p1:Person))
    WHERE p1 <> tom
    RETURN p1.name, length(p)
    ```

14. **Pairs of people and movies where a person is connected with at least two different types of relationships with the movie:**

    ```cypher
    MATCH (p:Person)-[relatedTo]-(m:Movie)
    WITH p, m, COUNT(DISTINCT TYPE(relatedTo)) AS types
    WHERE types >= 2
    RETURN p.name, m.title, types
    ```

15. **All nodes of type Person:**

    ```cypher
    MATCH (n:Person)
    RETURN n
    ```

16. **Movies in which Tom Hanks has acted with either Meg Ryan or Kevin Bacon:**

    ```cypher
    MATCH (p:Person { name:'Tom Hanks' })-[:ACTED_IN]->(m)<-[:ACTED_IN]-(:Person { name:'Meg Ryan' })
    RETURN m
    UNION
    MATCH (:Person { name:'Tom Hanks' })-[:ACTED_IN]->(m)<-[:ACTED_IN]-(:Person { name:'Kevin Bacon' })
    RETURN m
    ```

17. **People who have never acted in any movie:**

    ```cypher
    MATCH (p:Person)
    WHERE NOT (p)-[:ACTED_IN]->(:Movie)
    RETURN p
    ```

18. **Nodes that are at most 3 hops away from both Tom Hanks and Keanu Reeves:**

    ```cypher
    MATCH (p2 { name:'Keanu Reeves' })-[*1..3]-(p)-[*1..3]-(p1 { name:'Tom Hanks' })
    RETURN p
    ```

    ```cypher
    MATCH (p2 { name:'Keanu Reeves' })-[*1..3]-(p), (p1 { name:'Tom Hanks' })-[*1..3]-(p)
    RETURN p
    ```

19. **People who have either written or directed a movie released after 1970, including the movies:**

    ```cypher
    MATCH (p:Person)-[:DIRECTED|WROTE]->(m:Movie)
    WHERE m.released > 1970
    RETURN p, m
    ```

20. **Count and titles of movies each actor has played in, as a list:**
    ```cypher
    MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
    RETURN p.name, COUNT(*), COLLECT(m.title)
    ```

<br>
<br>
<br>
<br>
<br>

# 2nd Set of Neo4j Cypher Queries
