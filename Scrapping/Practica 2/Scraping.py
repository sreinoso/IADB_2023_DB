import requests
from lxml import html
from bs4 import BeautifulSoup

url = 'https://stackoverflow.com/questions'

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
}

respuesta = requests.get(url, headers=headers)

soup = BeautifulSoup(respuesta.text)

contenedor_preguntas = soup.find(id='questions')

print(contenedor_preguntas.prettify())

lista_preguntas = soup.find_all('div', class_='s-post-summary')

for pregunta in lista_preguntas:
    contenedor_pregunta = pregunta.find('h3')
    texto_pregunta = contenedor_pregunta.text

    descripcion_pregunta = contenedor_pregunta.find_next_sibling('div')

    texto_descripcion_pregunta = pregunta.find(class_='s-post-summary--content-excerpt').text
    texto_descripcion_pregunta = texto_descripcion_pregunta.replace('\n', '').replace('\r', '').strip()
    print(f"{texto_pregunta}\n{texto_descripcion_pregunta}\n{descripcion_pregunta}")
    print('------------------------')