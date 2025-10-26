# 1. Aşama: Maven ile Derleme
# Projeyi derlemek için JDK ve Maven içeren bir imaj kullanıyoruz.
FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -Dmaven.test.skip=true

# 2. Aşama: Çalıştırma
# Sadece çalışmak için gereken hafif JRE imajını kullanıyoruz.
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

# Derlenen JAR dosyasını, 'build' aşamasından kopyalıyoruz.
# JAR dosyasının adını target klasörünüzdeki dosyaya göre kontrol ettim:
COPY --from=build /app/target/LibraryManagementProject-0.0.1-SNAPSHOT.jar app.jar

# Uygulama portu
EXPOSE 8080

# Çalıştırma komutu
CMD ["java", "-jar", "app.jar"]