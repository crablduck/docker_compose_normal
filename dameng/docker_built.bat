@echo off

set IMAGE_NAME=dameng-db
set CONTAINER_NAME=dameng-db-container
set DATA_PATH=%~dp0\data
set SYSDBA_PWD=Dameng123

echo Cleaning up previous container and data volume...

rem Stop and remove the container if it exists
docker stop %CONTAINER_NAME% >nul 2>&1
docker rm %CONTAINER_NAME% >nul 2>&1

rem Recreate the data directory
if exist "%DATA_PATH%" (
    rmdir /s /q "%DATA_PATH%"
)
mkdir "%DATA_PATH%"

echo Building the Docker image...
docker build -t %IMAGE_NAME% .

echo Running the container...
docker run -d -p 5236:5236 --name %CONTAINER_NAME% -v "%DATA_PATH%:/opt/data" -e SYSDBA_PWD=%SYSDBA_PWD% %IMAGE_NAME%

echo.
echo Container is running. To view logs, use: docker logs %CONTAINER_NAME%
echo To access the database, connect to localhost:5236
