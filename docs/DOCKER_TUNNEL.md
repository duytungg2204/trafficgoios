# Docker backend and temporary tunnel

The Compose stack runs PostgreSQL, the FastAPI backend, and a Cloudflare Quick
Tunnel. The existing `postgres_data` volume is retained across container
recreation. PostgreSQL is published only on `127.0.0.1:5433`; the tunnel forwards
HTTP requests to the backend container on the private Compose network.

## First setup

1. Copy `.env.example` to `.env` and set `POSTGRES_PASSWORD` to an alphanumeric
   random value. For an existing database volume, use its current PostgreSQL
   password instead of changing this value; changing the Compose variable does
   not change a password already stored in PostgreSQL.
2. Copy `backend/.env.example` to `backend/.env`. Set `APP_ACCESS_TOKEN` and
   `GEOAPIFY_API_KEY`; keep this file local and untracked.
3. Start PostgreSQL and the backend from the repository root:

   ```powershell
   docker compose up --build -d
   ```

   The backend applies Alembic migrations before starting. Local API access is
   available at `http://localhost:8001`; PostgreSQL administration can connect
   to `localhost:5433`.

4. Start the public development tunnel only when you need it:

   ```powershell
   docker compose --profile tunnel up -d
   ```

## Get the temporary URL

The Quick Tunnel URL is printed in the `cloudflared` logs:

```powershell
docker compose logs cloudflared
```

It is a temporary `https://….trycloudflare.com` address. In the app's backend
connection settings, use that URL and the `APP_ACCESS_TOKEN` from
`backend/.env`. The address changes when the tunnel container is recreated and
has no uptime guarantee. This is for development; use a named Cloudflare Tunnel
with a domain for a stable deployment.

Do not tunnel or publish PostgreSQL. Keep provider keys in the backend `.env`;
the API key must not be placed in the Flutter build.
