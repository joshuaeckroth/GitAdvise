
Creating a Windows build:

- Install SWI Prolog 64-bit 7.2
- Copy c:\program files\swipl\bin\* and swipl\lib\jpl.jar to your own folder (bunch of dll's & jar file)
- Modify run configuration in Elegit/IntelliJ so that Environment Variables has PATH set to location of those dll's
- Modify line of code in Main.java to refer to location of gitplanner.pl
- Clone gitplanner repo, in GitPlanner folder run: 'mvn install'
    - OR: copy gitplanner.jar from gitplanner repo and save in C:\Users\[your name]\.m2\repository\stetsonuniversity\mathcs\gitplanner\1.0-SNAPSHOT



build:

```
mvn clean dependency:copy-dependencies package
```

run on linux:

```
LD_PRELOAD=../libswipl.so java -Djava.library.path=../linux_x86_64/ -jar target/gitplanner-1.0-SNAPSHOT.jar src/main/resources/gitplanner.pl
```

run on mac:

```
java -Djava.library.path=../macos/ -jar target/gitplanner-1.0-SNAPSHOT.jar src/main/resources/gitplanner.pl
```

