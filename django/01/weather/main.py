import click
import requests

API_ENDPOINT = "http://api.openweathermap.org/data/2.5/weather"
API_KEY = "96ec1c513612947553e8887d7c173e8c"

@click.command()
@click.argument('city')
def get_weather(city):
    params = {
        'q': city,
        'appid': API_KEY,
        'units': 'metric'
    }
    response = requests.get(API_ENDPOINT, params=params)
    data = response.json()
    print(f"Weather in {city}: {data['weather'][0]['description']}, Temperature: {data['main']['temp']}°C")

if __name__ == "__main__":
    get_weather()
