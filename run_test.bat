@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-21
"C:\Program Files\NetBeans-27\netbeans\java\maven\bin\mvn.cmd" test > mvn_test_out.txt 2>&1
echo Exit: %ERRORLEVEL%
