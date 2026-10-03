# PasarGuard Node – Railway Deploy

Deploys PasarGuard Node from https://github.com/PasarGuard/node as a separate Railway service.

## Setup

1. Deploy this repository as a second service in the same Railway project as the panel.
2. The Docker image already defines these non-secret defaults:
   - `NODE_HOST=0.0.0.0`
   - `SERVICE_PORT=62050`
3. In Railway service **Variables**, set `API_KEY` to a newly generated UUID. This is a secret and must not be committed to GitHub or placed in the Dockerfile.
4. In **Settings → Networking**, enable TCP Proxy and set the target port to `62050`. Use the public host and port Railway assigns.
5. Deploy. The entrypoint creates/maintains the node TLS certificate. Read its contents from `/app/certs/ssl_cert.pem` using the service shell when configuring the node in the panel.
6. In the panel dashboard → Nodes → Add Node, enter the TCP proxy host, assigned port, the same secret API key, and the certificate contents as Server CA.

## Security

Do not reuse a previously exposed API key. Rotate it and update both the node service variable and panel node configuration. Railway Variables are required for secret values; a public Git repository cannot securely provision them automatically.
