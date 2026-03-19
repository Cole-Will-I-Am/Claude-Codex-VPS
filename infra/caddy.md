# Caddy — Reverse Proxy + Auto-SSL

## Config

- **File**: `/etc/caddy/Caddyfile`
- **Service**: `systemctl status caddy`

## Current Caddyfile

```
195518.online, www.195518.online {
    root * /opt/manticode/apps/landing/public
    encode gzip
    file_server

    handle_errors {
        rewrite * /404.html
        file_server
    }
}
```

## What It Serves

- `https://195518.online` — Landing page (static HTML)
- `https://195518.online/app` — Telegram Mini App (static)
- Auto HTTP→HTTPS redirect
- Auto Let's Encrypt certificate provisioning and renewal

## Operations

```bash
caddy validate --config /etc/caddy/Caddyfile   # check syntax
systemctl restart caddy                          # apply changes
systemctl status caddy                           # check health
journalctl -u caddy -f                           # tail logs
```
