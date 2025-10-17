FROM eclipse-temurin:25-jdk-jammy
ADD https://trialpucn28.jfrog.io/artifactory/javaapp-libs-release/spring-petclinic-4.0.0-SNAPSHOT.jar javaapp.jar
WORKDIR /springpet
EXPOSE 8080
CMD ["java", "-jar", "javaapp.jar"]
