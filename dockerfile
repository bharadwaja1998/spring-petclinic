FROM eclipse-temurin:17-jdk-jammy
ADD https://trialpucn28.jfrog.io/artifactory/javaapp-libs-release/spring-petclinic-4.0.0-SNAPSHOT.jar /springpet/*.jar
WORKDIR /springpet
EXPOSE 8080
CMD ["java", "-jar", "spring.jar"]
