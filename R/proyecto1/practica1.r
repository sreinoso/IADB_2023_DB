# Imprimir por pantalla
print("Hola que tal estas")

# Asignación de variable con <- como con =
numero <- 4
texto = "Hola"
print(numero)

# Esto es un comentario

# Operaciones
## Suma y resta
5+2
3-4
100-200+500
(200-300)-(400-300)

## Multiplicacion y division
5*4
3*2*4
2*3/4
3*4*5

## Potencia
2^2
10^3
10^(2*3)

## Módulo
10/3
10%%3
10/5
10%%5

# Asignación
numero <- 4
numero2 <- 10 + 5

numero2 <- numero2 + 10 
texto.corto <- 'hola'
texto_corto <- 'hola'
textoCorto <- 'hola'

# Tipos de variables

class(5)
class(6.7)
class(numero)

class(TRUE)
class(T)
class(FALSE)
class(F)

texto="Hola que tal estas"
class(texto)

texto2 = 'hola que tal'
class(texto2)

# Vectores
vector = c(1,2,3,4)
class(vector)

vector2 = c(TRUE, FALSE, T, F, TRUE)
class(vector2)

vector3 = c('a','b','c','d')
class(vector3)

vector4 = c(T, 10, 30)
class(vector4)

vector5 = c(10,15,30,"hola")
class(vector5)

vector6 = c(T,10,20,"adios")
class(vector6)

# Nombres de columnas

meses = c('enero', 'febrero', 'marzo')
ventas = c(100,120,80)
names(ventas) = meses
ventas
ventas['enero']
