@echo off
setlocal enabledelayedexpansion

REM Capturar la hora de inicio
set start_time=%time%

REM Ruta de la carpeta principal
set "folder_path=C:\Escribir la ruta de la carpeta donde buscar la informacion\"

REM Archivo de texto con los títulos de archivo
set "filename=C:\escribe la ruta del archivo que contiene los nombre del titulo de tus archivos.txt"

REM Nombre del archivo de texto que contiene los nombres de los archivos encontrados
set "output_file=C:\escribe la ruta donde se guardaran los titulos que encontro el bat\encontrados.txt"

REM Declarar matriz para almacenar los títulos de archivo
set "num_files=0"

REM Leer el archivo de texto y agregar títulos a la matriz
for /f "usebackq delims=" %%t in ("%filename%") do (
  set "array[!num_files!]=%%~nt"
  set /a "num_files+=1"
)
echo "La matriz contiene %num_files% títulos de archivo"

REM Crear el archivo de texto de salida
echo Archivos encontrados: > "%output_file%"

REM Buscar archivos PDF en la carpeta principal
for /r "%folder_path%" %%i in (*.pdf) do (
  REM Obtener el título del archivo PDF
  set "title=%%~ni"

  REM Buscar el título del archivo en la matriz
  for /l %%j in (0,1,%num_files%) do (
    if /i "!title!" == "!array[%%j]!" (
      REM El título del archivo se encuentra en la matriz
      echo "Se encontró el archivo %%~ni"
      REM Copiar el archivo a la carpeta del escritorio
      copy "%%i" "C:\Escribe la ruta donde guardara los archivos que encuentre en la carpeta principal"
      REM Agregar el título del archivo encontrado al archivo de texto de salida
      echo %%~ni >> "%output_file%"
      REM Eliminar el título del archivo de la matriz
      set "array[%%j]="
    )
  )
)

REM Informar si hay títulos de archivo que no se encontraron
for /l %%j in (0,1,%num_files%) do (
  if defined array[%%j] (
    echo "No se encontró el archivo !array[%%j]!"
  )
)

REM Capturar la hora de finalización y calcular la duración de la búsqueda
set end_time=%time%
call :TimeDiff start_time end_time diff
echo La búsqueda tardó %diff% segundos.

REM Esperar a que el usuario presione una tecla antes de salir
pause>nul

exit /b

:TimeDiff start end diff
setlocal
set /a "start=((%1:~,2%*3600)+(%1:~3,2%*60)+(%1:~6,2%))*100+%1:~9,2%"
set /a "end=((%2:~,2%*3600)+(%2:~3,2%*60)+(%2:~6,2%))*100+%2:~9,2%"
set /a "diff=end-start"
if %diff% lss 0 set /a "diff+=240000"
set /a "diff=diff/10000*3600+diff/100%%60*60+diff%%100"
end
