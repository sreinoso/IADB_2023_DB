## Compilación
`docker build -t "hadoophue" . --no-cache`

## Requisitos
- Debemos tener el fichero `access_log`, para ello, desde nuestra máquina podemos pasarlo con `scp access_log hadoop@localhost:/home/hadoop`
- Debemos tener el fichero `ContarPalabras.java`, para ello, desde nuestra máquina podemos pasarlo con `scp ContarPalabras.java hadoop@localhost:/home/hadoop`
- Debemos tener el fichero `cite75_99.txt`, para ello, desde nuestra máquina podemos pasarlo con `scp cite75_99.txt hadoop@localhost:/home/hadoop`
- Debemos tener el fichero `MyJob.java`, para ello, desde nuestra máquina podemos pasarlo con `scp MyJob.java hadoop@localhost:/home/hadoop`