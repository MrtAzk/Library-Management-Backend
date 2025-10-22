# FROM maven AS build

# WORKDIR /app

# COPY ./pom.xml /app
# COPY ./src /app/src

# RUN mvn clean package -Dmaven.test.skip=true

# FROM openjdk

# WORKDIR /app

# COPY --from=build /app/target/*.jar app.jar

# EXPOSE 8080

# CMD ["java", "-jar", "app.jar"]
# ---- Build stage ----
FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /app

# Bağımlılık cache'i
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Kod
COPY src ./src

# Derleme
RUN mvn clean package -DskipTests

# ---- Run stage ----
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Jar'ı kopyala (gerekirse *.jar yerine tam ad yaz)
COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
