datos = read.csv('student-mat.csv', sep = ';')

head(datos)

any(is.na(datos))

install.packages('ggplot2')
install.packages('ggthemes')
install.packages('dplyr')

library(ggplot2)
library(ggthemes)
library(dplyr)


# Con esto generamos un filtro de las columnas que son numeros
columnas.numericas = sapply(datos, is.numeric)

head(columnas.numericas)

# Aplicamos el filtro de "solo numericos" sobre los datos
datos.solo.numericos = datos[,columnas.numericas]

datos.correlacion = cor(datos.solo.numericos)
print(datos.correlacion)

install.packages('corrgram')
install.packages('corrplot')

library(corrgram)
library(corrplot)

grafico = corrplot(datos.correlacion, method='color')
corrgram(datos)

ggplot(datos, aes(x=G3)) + geom_histogram(bins=20, alpha=0.5, fill='blue')

install.packages('caTools')
library(caTools)
set.seed(80)

# Partimos la muestra de datos para entrenar
ejemplo = sample.split(datos$G3, SplitRatio = 0.7)

# ejemplo es un filtro TRUE/FALSE aleatorio para G3
# entrenamiento cogemos los que sean TRUE
entrenamiento = subset(datos, ejemplo == TRUE)
# pruebas cogemos los que sean FALSE
pruebas = subset(datos, ejemplo == FALSE)

modelo = lm(G3 ~. ,entrenamiento)
print(summary(modelo))


residuos = residuals(modelo)
class(residuos)

residuos = as.data.frame(residuos)
head(residuos)

ggplot(residuos, aes(residuos)) + geom_histogram(fill='blue', alpha=0.5)
       
       