## Compilación
`docker build -t "hbase" . --no-cache`

Rerun all
`docker-compose down && docker image rm hbase && docker build -t "hbase" . --no-cache && docker-compose up -d`

## Atención
Esta practica se tiene que ir ejecutando comando a comando (En el script están comentados), si no se hace así, no funcionará

## Dependencias
https://dlcdn.apache.org/hbase/2.5.6/hbase-2.5.6-bin.tar.gz