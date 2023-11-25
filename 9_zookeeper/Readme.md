## Compilación
`docker build -t "hadoozookeeper" . --no-cache`

Rerun all
`docker-compose down && docker image rm hadoozookeeper && docker build -t "hadoozookeeper" . --no-cache && docker-compose up -d`

## Atención
Esta practica se tiene que ir ejecutando comando a comando (En el script están comentados), si no se hace así, no funcionará