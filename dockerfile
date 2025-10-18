FROM eclipse-temurin:25-jdk-jammy
ADD https://trialpucn28.jfrog.io/artifactory/java-app-libs-release/spring-petclinic-3.5.0-SNAPSHOT.jar javaapp.jar
WORKDIR /springpet
EXPOSE 8080
CMD ["java", "-jar", "javaapp.jar"]
