FROM openjdk:8

WORKDIR /app

COPY jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]