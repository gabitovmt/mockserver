# Для сборки проекта
FROM maven:3.6.3-jdk-8-openj9 as build
WORKDIR /app
RUN apt-get install -y git
RUN git clone https://github.com/gabitovmt/mockserver.git
WORKDIR /app/mockserver
RUN mvn -B -f ./pom.xml clean package -DskipTests

# Для запуска приложения
FROM java:8-jdk-alpine as application
WORKDIR /app
# *.jar файл MockServer со всеми зависимостями
COPY --from=build /app/mockserver/mockserver-netty/target/mockserver-netty-5.10.1-SNAPSHOT-jar-with-dependencies.jar ./mockserver-netty.jar
# Настройки MockServer. Подробности здесь https://www.mock-server.com/mock_server/configuration_properties.html
COPY --from=build /app/mockserver/mockserver.properties ./mockserver.properties
# Указываем, где искать настройки MockServer
ARG mockserver_properties_path=/app/mockserver.properties
# При запуске MockServer ищет где искать файл настроек с помощью переменной окружения "MOCKSERVER_PROPERTY_FILE"
ENV MOCKSERVER_PROPERTY_FILE=$mockserver_properties_path
EXPOSE 1080
# Дашборды приложения можно посмотреть здесь http://host:1080/mockserver/dashboard
CMD ["java", "-jar", "mockserver-netty.jar", "-serverPort", "1080"]