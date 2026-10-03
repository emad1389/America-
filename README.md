# PasarGuard Node – Railway Deploy (No VPS needed)

Deploys PasarGuard Node (https://github.com/PasarGuard/node) as a second Railway
service, with a self-signed certificate baked into the image at build time so
no external server is required to obtain the "Server CA" for the panel.

## Setup

1. Push this folder to its own GitHub repo.
2. In your Railway project, click **+ New** → **GitHub Repo** → select this repo.
   (Use the same Railway project as your PasarGuard panel, as a second service.)
3. In this new service's **Variables** tab, add:
   - `API_KEY` = a UUID you generate yourself (e.g. `uuidgen` or any UUID generator).
     Example: `6d183b56-361e-4f9b-be2d-c571cdebae23`
4. In this service's **Settings → Networking**, enable **TCP Proxy** and set the
   target port to `62050`. Railway will give you a public `host:port` pair.
5. Deploy. Once it's running, open this service's **Console/Shell** and run:
   ```
   cat /app/certs/ssl_cert.pem
   ```
   Copy the whole output (including the BEGIN/END lines).
6. Go to your PasarGuard panel dashboard → Nodes → Add Node:
   - Address: the TCP proxy host (without the port)
   - Port: the TCP proxy port
   - API Key: the same UUID you set in step 3
   - Server CA: paste the certificate from step 5
