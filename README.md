# Shorty Challenge
Rack Application to shorten urls
# Architecture
There are 3 different modules in the app
  - Shorty App: Pure ruby application hold all aplication objects(Enities), use cases, exceptions
  - Data Stores: Implementations for Different Data stores logic (In memory, Redis) and can be expanded easily
  - Rack app: Implementation for web logic interface (Controllers, Presentation layer, and Dispatcher logic)

The idea is to separate the business logic away from impelmentation details(Web, Data store) for easy expansion and design flexability, so simply that app can wrap CLI interface or a new data store (like postgres) can be added without changing without touching the business logic

# Run
To Run the app locally
```sh
$ rackup
```
To Run the app through docker
```sh
$ docker-compose up --build
```

# Run Tests (100% Test coverage)
To run the app tests
```sh
$ rspec
```
# Curl Requests
### Create random shorten code for url
```sh
$ curl -X POST http://localhost:9292/shorten -d '{"url": "google.com"}' -H 'content-type: application/json'
```
Or you can set a certain short code to use (if available)

```sh
$ curl -X POST http://localhost:9292/shorten -d '{"url": "google.com", "shortcode": "1234"}' -H 'content-type: application/json'
```
Possible responses
  - if url is not present
```sh
{"errors":"url is not present"}
```
  - if short code is present but not in correct format
```sh
{"errors":"The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."}
```
  - if short code is present but is not avaibale to use
```sh
{"errors":"The the desired shortcode is already in use"}
```
  - if added successfully
```sh
{"shortcode":"1234"}
```

  2- Query for URL with a short code
```sh
$ curl http://localhost:9292/1234
```
Possible responses
  - if short code is not exists
```sh
{"errors":"he shortcode cannot be found in the system"}
```
  - if retrieved successfully
```sh
{"url":"google.com"}
```
  3- Query for stats about a short code
```sh
$ curl http://localhost:9292/1234/stats
```
Possible responses
  - if short code is not exists
```sh
{"errors":"he shortcode cannot be found in the system"}
```
  - if retrieved successfully but has no visits yet
```sh
{"startDate":"2018-08-19T21:38:03+03:00","redirectCount":0}
```
  - if retrieved successfully and already visited before
```sh
{"startDate":"2018-08-19T21:38:03+03:00","redirectCount":3,"lastSeenDate":"2018-08-20T17:35:43+03:00"}
```
