# Stage 1: Build GraphHopper fork
FROM maven:3.9-eclipse-temurin-17 AS graphhopper-build

WORKDIR /app

# Clone the specific GraphHopper fork and branch
RUN git clone https://github.com/geofabrik/graphhopper.git . && \
    git checkout osm-reader-callbacks

# Build GraphHopper
RUN mvn clean install -DskipTests

# Stage 2: Build OpenRailRouting
FROM maven:3.9-eclipse-temurin-17 AS openrailrouting-build

WORKDIR /app

# Copy the local maven repository from the previous stage to make the custom GraphHopper available
COPY --from=graphhopper-build /root/.m2 /root/.m2

# Install Node.js and npm for the frontend build
RUN apt-get update && apt-get install -y nodejs npm

# Copy OpenRailRouting source
COPY . .

# Build OpenRailRouting
# We need to ensure it uses the local repository where we installed the forked GraphHopper
RUN mvn clean package -DskipTests

# Stage 3: Runtime
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built jar
COPY --from=openrailrouting-build /app/target/railway_routing-*.jar app.jar

# Copy configuration
COPY config-docker.yml config.yml

# Create directories for data and graph cache
RUN mkdir -p /data /graph-cache

# Expose ports
EXPOSE 8991 8992

# Entrypoint
# Expects OSM file path to be passed via environment variable or command line
ENTRYPOINT ["java", "-Xmx2500m", "-Xms50m", "-Ddw.graphhopper.graph.location=/graph-cache", "-jar", "app.jar", "server", "config.yml"]
