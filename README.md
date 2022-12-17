# Weather-Expedyte
Weather-Expedyte is an iOS based application, which provides services ranging from the current weather forecast, daily weather summary, future weather to air quality data as well as maps displaying the current and future forecast of any specific location.


**OPENWEATHER API**

GET Current weather
https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API}

GET Hourly Forecast
https://pro.openweathermap.org/data/2.5/forecast/hourly?lat={lat}&lon={lon}&appid={API}

POST Weather Maps
http://maps.openweathermap.org/maps/2.0/weather/{op}/{z}/{x}/{y}?appid={API}

PUT Relief maps
http://maps.openweathermap.org/maps/2.0/relief/{z}/{x}/{y}

GET/POST Ultraviolet Index
http://api.openweathermap.org/data/3.0/triggers

GET/PUT Air Pollution
http://api.openweathermap.org/data/2.5/air_pollution?lat={lat}&lon={lon}&appid={API}

PATCH Weather stations
http://api.openweathermap.org/data/3.0/stations

GET Direct geocoding
http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API}
