######### Build Stage
FROM openjdk:17-alpine as build

WORKDIR /app

COPY gradle gradle

COPY build.gradle settings.gradle gradlew ./

COPY src src

RUN ./gradlew bootJar

RUN mkdir -p build/libs/dependency && (cd build/libs/dependency; jar -xf ../*.jar)

###### Run Stage

FROM openjdk:17-alpine

VOLUME /tmp

ARG DEPENDENCY=/app/build/libs/dependency

COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib

COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF

COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","hello.hellospring.HelloSpringApplication"]