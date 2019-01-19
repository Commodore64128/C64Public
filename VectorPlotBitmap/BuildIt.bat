rem @echo off
del VectorPlotBitmap.prg
rmdir /S /Q bin
mkdir bin

rem java -DZbdd6502.trace=true -DZcom.replicanet.cukesplus.server.featureEditor -DZcom.replicanet.ACEServer.debug.requests= --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.text=ALL-UNNAMED --add-opens java.desktop/java.awt.font=ALL-UNNAMED -jar ..\..\BDD6502\target\BDD6502-1.0.9-SNAPSHOT-jar-with-dependencies.jar --tags ~@ignore --monochrome --plugin pretty --plugin html:target/cucumber --plugin json:target/report1.json --glue TestGlue features >t.txt
rem java -Dbdd6502.trace=true -DZcom.replicanet.cukesplus.server.featureEditor -DZcom.replicanet.ACEServer.debug.requests= -jar ..\..\BDD6502\target\BDD6502-1.0.9-SNAPSHOT-jar-with-dependencies.jar --tags ~@ignore --monochrome --plugin pretty --plugin html:target/cucumber --plugin json:target/report1.json --glue TestGlue features >t.txt
rem IF ERRORLEVEL 1 goto error

rem Enable this line to stop any main code build
rem exit /B 0

rem No extra Ultimax boot, so use a simple empty address switch as placeholder for the command line
set CART_BOOT_TYPE=-tg
set CART_BOOT_TYPE_HI=-a $8000
rem Using Ultimax boot, so create the high bank with the reset vector
set CART_BOOT_TYPE=-te
set CART_BOOT_TYPE_HI=-a $a000 -b 0 -c $1ffc 2 4 -w

echo CART_BOOT_TYPE = %CART_BOOT_TYPE%


echo ;This file is automatically generated by BuildIt.bat >FingerPrint.a
echo !scr "%TIME% %DATE% %COMPUTERNAME% %USERNAME%" >>FingerPrint.a

..\acme.exe -v3 --msvc VectorPlotBitmap.a
if not exist VectorPlotBitmap.prg goto error
goto end
:error
type t.txt
echo VectorPlotBitmap.prg not created!
exit /B -1
:end


echo ;This file is automatically generated by BuildIt.bat >AutoDefs_Span.a

rem Extract all the required variables from this list to a separate file
for %%x in (
	Bitmap_SpanRet
	SpanPlot_MaskEnds
	kSpanPlot_maxLen
	ZPBitmap_CurrentPos
	ZPBitmap_ColourMasked
	ZPBitmap_Colour
	SpanConfig
	SpanTable_IsInCart
) do (
	..\ExternalTools\Gnu\bin\sed.exe -n "/%%x/p" VectorPlotBitmap.map >>AutoDefs_Span.a
)

..\acme --msvc -f plain -o bin\SpanDraw_p0_0.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p0.a SpanConfig_0.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p1_0.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p1.a SpanConfig_0.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p2_0.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p2.a SpanConfig_0.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p3_0.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p3.a SpanConfig_0.a SpanMacros.a SpanDrawGenerate.a

..\acme --msvc -f plain -o bin\SpanDraw_p0_1.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p0.a SpanConfig_1.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p1_1.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p1.a SpanConfig_1.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p2_1.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p2.a SpanConfig_1.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p3_1.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p3.a SpanConfig_1.a SpanMacros.a SpanDrawGenerate.a

..\acme --msvc -f plain -o bin\SpanDraw_p0_2.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p0.a SpanConfig_2.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p1_2.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p1.a SpanConfig_2.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p2_2.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p2.a SpanConfig_2.a SpanMacros.a SpanDrawGenerate.a
..\acme --msvc -f plain -o bin\SpanDraw_p3_2.bin ..\stdlib\stdlib.a AutoDefs_Span.a SpanTableInCart.a SpanConfig_p3.a SpanConfig_2.a SpanMacros.a SpanDrawGenerate.a

SET OTHER_FILES=bin\SpanDraw_p0_0.bin+! bin\SpanDraw_p0_1.bin+! bin\SpanDraw_p0_2.bin+! bin\SpanDraw_p1_0.bin+! bin\SpanDraw_p1_1.bin+! bin\SpanDraw_p1_2.bin+! bin\SpanDraw_p2_0.bin+! bin\SpanDraw_p2_1.bin+! bin\SpanDraw_p2_2.bin+! bin\SpanDraw_p3_0.bin+! bin\SpanDraw_p3_1.bin+! bin\SpanDraw_p3_2.bin+!
SET NUM_FILES=12

rem Get the final cart data offsets and link them in to the base code
..\bin\MakeCart.exe -tg -n -a $8000 -b 7 -f $2000 %NUM_FILES% %OTHER_FILES% %SCROLLER_SPEED_CODE_FILES%

del VectorPlotBitmap.prg
..\acme.exe -v3 --msvc VectorPlotBitmap.a
if not exist VectorPlotBitmap.prg goto error
..\bin\LZMPi.exe -c64b VectorPlotBitmap.prg VectorPlotBitmap.prg $4000 >tf.txt
..\bin\MakeCart.exe %CART_BOOT_TYPE% -n -a $8000 -b 0 -r ..\Citadel2\Citadel2Cart_8K.prg -c 0 2 $ffff -w %CART_BOOT_TYPE_HI% -r VectorPlotBitmap.prg -a $8000 -b 1 -c 0 $0001 $ffff -w -a $8000 -b 2 -c 0 $2001 $ffff -w -a $8000 -b 3 -c 0 $4001 $ffff -w -a $8000 -b 4 -c 0 $6001 $ffff -w -a $8000 -b 5 -c 0 $8001 $ffff -w -a $8000 -b 6 -c 0 $a001 $ffff -w -a $8000 -b 7 -f $2000 %NUM_FILES% %OTHER_FILES% -o VectorPlotBitmap.crt >>tf.txt
