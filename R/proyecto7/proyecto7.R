##### Decission Tree
install.packages('rpart')

library(rpart)

datos = kyphosis
str(datos)

arbol = rpart(kyphosis, datos)

printcp(arbol)

plot(arbol, uniform=TRUE, main="Decission tree" )
text(arbol, use.n = TRUE, all=TRUE)


install.packages('rpart.plot')
library(rpart.plot)

prp(arbol)

##### Random forest
install.packages("randomForest")
library(randomForest)

modelo = randomForest(Kyphosis ~ . , data=datos)

print(modelo)

print(modelo$predicted)

##### SVM
install.packages('e1071')
library(e1071)
library(ISLR)
datos = iris
print(str(datos))

help('svm')

model <- svm(Species ~ ., data = iris)
predicciones = predict(model, datos[1:4])

print(predicciones)

tabla = cbind(datos, predicciones)
print(tabla)

# K-mean
install.packages("ggplot2")
library(ggplot2)
datos = iris
print(str(datos))
grafico = ggplot(datos, aes(Petal.Length, Petal.Width, color=Species))
grafico = grafico + geom_point(size=5)
print(grafico)

set.seed(90)
conjuntos = kmeans(datos[,1:4], 3, nstart = 20)
print(conjuntos)

table(conjuntos$cluster, datos$Species)

library(cluster)

clusplot(datos, conjuntos$cluster, color=TRUE, shade=TRUE, labels=0, lines=0)

help('kmeans')
