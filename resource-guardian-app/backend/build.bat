@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-24
echo Setting JAVA_HOME to %JAVA_HOME%
echo Building Resource Guardian Backend...
.\mvn.cmd clean package -DskipTests
pause
