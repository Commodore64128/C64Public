@echo off
pushd %~dp0
del bin\main.prg
del bin\main.cmp.prg
if not exist tmp mkdir tmp
if not exist bin mkdir bin

echo ;This file is automatically generated by BuildIt.bat >tmp\FingerPrint.a
echo !scr "%TIME% %DATE% %COMPUTERNAME% %USERNAME%" >>tmp\FingerPrint.a

..\acme.exe -v3 --lib ../ --lib ../../ --lib ../../../ --msvc asm/main.a
if not exist bin\main.prg goto error
rem ..\bin\LZMPi.exe -c64 bin\main.prg bin\main.cmp.prg $200 >tmp\t.txt
..\bin\LZMPi.exe -c64mr bin\main.prg bin\main.cmp.prg $200 >tmp\t.txt
if not exist bin\main.cmp.prg goto error

rem --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.text=ALL-UNNAMED --add-opens java.desktop/java.awt.font=ALL-UNNAMED
rem -Xmx256M -Xms256M
rem -DZbdd6502.trace=true
java -Xmx256M -Xms256M -jar ..\..\BDD6502\target\BDD6502-1.0.9-SNAPSHOT-jar-with-dependencies.jar --monochrome --plugin pretty --plugin html:target/cucumber --plugin json:target/cucumber.json --glue TestGlue features

goto end
:error
echo main.cmp.prg not created!
exit /B -1
:end
popd