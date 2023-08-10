# Experimentation runbook

1. Happiest path:
    - `cat-app` (py)
    - `cat-app-js` (js)
1. Happy path:
    - `node-mongo` (js)
    - `python-mongo` (py)

## Happy path

Python:

1. API: User needs to find `models.py` or `README.md` to know that `MONGODB_CONNECTION_STRING` is the connection string. Without renaming, the app will fail to start.
1. WEB: User needs to find `config/index.ts` or `README.md` to know that `REACT_APP_API_BASE_URL` is the variable to set.
1. The user might be able to use troubleshooting steps to recover after deploying to azure.
