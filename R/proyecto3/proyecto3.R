install.packages('ggplot2')

install.packages('ggplot2movies')

library(ggplot2)
library(ggplot2movies)

# Documentación https://diegokoz.github.io/intro_ds/fuentes/ggplot2-cheatsheet-2.1-Spanish.pdf

peliculas=movies
head(peliculas)

peliculas[c('title', 'year', 'rating')]

datos=ggplot(peliculas, aes(x=rating))
histograma = datos+geom_histogram()
print(histograma)

histograma = datos+geom_histogram(binwidth = 0.3)
print(histograma)

histograma = datos+geom_histogram(binwidth = 0.3, color='green')
print(histograma)

histograma = datos+geom_histogram(binwidth = 0.3, color='green', fill='red', alpha=0.3)
print(histograma)


histograma = histograma+xlab('Puntuacion')+ylab('Frecuencia')+ggtitle('Histograma')
print(histograma)


coches = mtcars
head(coches)


grafico = ggplot(coches, aes(x=disp, y=mpg))
grafico = grafico+geom_point()
print(grafico)

grafico = grafico+geom_point(size=8, alpha=0.4)
print(grafico)

grafico = grafico+geom_point(size=8, color='red')
print(grafico)

grafico = grafico+geom_point(size=8, color='#2717c4')
print(grafico)

grafico = grafico+geom_point(aes(size=wt))
print(grafico)

grafico = ggplot(coches, aes(x=disp, y=mpg))
grafico = grafico+geom_point(size=8, aes(color=hp))
grafico = grafico+scale_color_gradient(low='blue', high = 'red')
print(grafico)


datos = mpg
head(datos)
str(datos)

grafico = ggplot(datos, aes(x=class))
grafico = grafico + geom_bar()
print(grafico)

grafico = grafico + geom_bar(color='red', fill='blue')
print(grafico)

grafico = grafico + geom_bar(aes(fill=drv))
print(grafico)

