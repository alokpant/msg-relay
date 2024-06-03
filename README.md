# msg-relay
Tech Stack:
- backend: Rails as API, Sidekiq to create CSV
- frontend: react

## Pre-requisits

1. Docker and Docker Compose
2. Ruby ruby-3.2.4
3. Node 20
4. Postgres16

## Getting Started

1. Clone the repository 

```
git clone git@github.com:alokpant/msg-relay.git
```

2. Change database.yml
Update database.yml and .env file to match postgres server username and password

3. Run docker compose
```
docker-compose up --build
```

### Accesing the API

The API can be accessed at `http://localhost:3000`.
Apart from web, API can also be accessed through insomnia or postman.

All available APIs are:

1. Users LIST endpoint
```
url: GET http://localhost:3000/users
params:
  limit: number
```
By default it only returns first 10 results sorted by id.

2. Users POST endpoint
```
url: POST http://localhost:3000/users
params: 
  email: string
```

3. Message LIST endpoint

For all message endpoints, authentication is required.
`Authentication: <token>` should be passed as part of header if an API client is used.

```
url: GET http://localhost:3000/messages
params:
  limit: number
  user_id: number
headers:
  Authorization: string

Example to return messages for user with id 4:
http://localhost:3000/messages?user_id=4
```

4. Message SHOW endpoint

```
url: GET http://localhost:3000/messages/:id
headers:
  Authorization: string
```

4. Message POST endpoint

```
url: POST http://localhost:3000/messages/
params:
  title: string
  body: string
headers:
  Authorization: string
```

5. Message PUT endpoint

```
url: PUT http://localhost:3000/messages/:id
params:
  title: string
  body: string
headers:
  Authorization: string
```

### Accessing the Frontend

Frontend is available at: `http://localhost:5173`. Some of the functionalities include:
- Accessing all users
Default page shows all users
- Create new users
There is a button to create new users. json_web_token are automatically populated so only passing email should suffice.
- Message for single users
Clicking on a row, displays all messages for that particular user
- Create/Update message for single user
Clicking on a message row, enables to edit that message. Only title and body for the message can be changed.
Clicking on Add new message allows to create new message from the user.
