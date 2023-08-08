# Python TODO API

## Setup

Requirements:

- Python (3.8+)

```bash
$ pip install -r requirements.txt
```

Or

```bash
$ poetry install
```

## Running

Before running, set the `MONGODB_CONNECTION_STRING` environment variable to the connection-string for mongo/cosmos.

Run the following common from the root of the api folder to start the app:

```bash
$ uvicorn todo.app:app --port 3100 --reload
```
