datos = read.csv('titanic.csv')
head(datos)

str(datos)

library(ggplot2)
ggplot(datos, aes(Survived)) + geom_bar()

ggplot(datos, aes(Pclass)) + geom_bar(aes(fill=factor(Pclass)))

ggplot(datos, aes(Sex)) + geom_bar(aes(fill=factor(Sex)))

ggplot(datos, aes(Age)) + geom_histogram(bins=20, alpha=0.5, fill='green')

grafico.base = ggplot(datos, aes(Pclass, Age))

grafico = grafico.base + geom_boxplot(aes(group=Pclass, fill=factor(Pclass), alpha=0.5))
print(grafico)                                      

install.packages('Amelia')

library(Amelia)


missmap(datos, main="Verificar valores nulos", col=c('red', 'black'))

limpiar.edad <- function(edad, clase) {
  salida = edad
  for( i in 1:length(edad)){
    if(is.na(edad[i])){
      if(clase[i] == 1 ){
        salida[i] = 38
      }else if(clase[i] == 2){
        salida[i] = 29
      }else{
        salida[i] = 23
      }
    }else{
      salida[i] = edad[i]
    }
  }
  return(salida)
}

edades = limpiar.edad(datos$Age, datos$Pclass)
datos$Age = edades

missmap(datos, main="Verificar valores nulos", col=c('red', 'black'))

library(dplyr)
head(datos)

datos = select(datos, -PassengerId, -Name, -Ticket, -Cabin)
head(datos)

datos$Survived = factor(datos$Survived)
datos$Pclass = factor(datos$Pclass)
datos$Parch = factor(datos$Parch)
datos$SibSp = factor(datos$SibSp)
str(datos)

library(caTools)
set.seed(90)

division = sample.split(datos$Survived, SplitRatio = 0.7)
entrenamiento = subset(datos, division == TRUE)
pruebas = subset(datos, division == FALSE)

head(entrenamiento)
head(pruebas)

modelo = glm(Survived ~. , family=binomial(link='logit'), data = entrenamiento)

summary(modelo)


predicciones = predict(modelo, pruebas, type='response')
head(predicciones)

resultados = ifelse(predicciones > 0.5, 1, 0)
head(resultados)
head(datos)

error = mean(resultados != pruebas$Survived)
error
precision = 1 - error
precision
