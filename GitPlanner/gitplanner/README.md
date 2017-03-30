build:

```
mvn clean dependency:copy-dependencies package
```

run:

```
LD_PRELOAD=../libswipl.so java -Djava.library.path=../ -jar target/gitplanner-1.0-SNAPSHOT.jar src/main/resources/gitplanner.pl
```
