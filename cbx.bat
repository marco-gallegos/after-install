@echo off

echo creado por c-box ;)
goto inicio

:inicio
echo hola que vas a hacer :
echo 1=limpiar usb (accesos directos o virus recicler)
echo 2=borrar temporales 
echo 3=desfragmentar el disco duro
echo 4=salir
set /P opc= 
if %opc%==1 goto limpiarusb
if %opc%==2 goto temporales
if %opc%==3 goto defrag
if %opc%==4 exit
echo opcion no valida
pause
cls
goto inicio
exit


:limpiarusb
cls
echo 1=te pregunto para borrar un acceso directo 
echo 2=borro todo directamente sin preguntarte
set /p bor=
if %bor%==1 goto cpreg
if %bor%==2 goto spreg
echo opcion no valida
pause
cls
goto limpiarusb
exit

:cpreg
cls
attrib -r -s -h *.*
del /p *.lnk
echo listo tu usb ahora esta limpia :D
pause
exit

:spreg
cls
attrib -r -s -h *.*
del /q *.lnk
echo listo tu usb ahora esta limpia :D
pause
exit

:temporales
cls
for /f "tokens=*" %%h in ('dir %temp% /B') do rd /s /q %temp%\%%h
for %%a in (%temp%\) do del /q %%a
echo tus archivos temporales son historia ;)
pause
exit

:defrag
cls
echo Es la raiz C
echo 1 = si 
echo 2 = no 
set /P deff=
if %deff% == 1 goto defc
if %deff% == 2 goto defx
echo opcion invalida
goto defrag
cls
exit

:defc
cls
defrag c: /u 
pause
exit

:defx
cls
echo cual es la unidad raiz
set /P unid =
defrag %unid%: /u
pause
exit




















































::^
este script fue ceado por c-box