# Use the official Neo4j image from the Docker Hub
FROM neo4j:latest

# Set environment variables
ENV NEO4J_AUTH=none

# Expose the default Neo4j ports
EXPOSE 7474 7687

# Start Neo4j and import data from CSV
CMD ["neo4j"]
