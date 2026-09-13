# Docker Deployment — PT Des Teknologi Informasi

Konfigurasi Docker Compose untuk deploy ekosistem **MyMember** + **SSO Engine**.

## Quick Start

```bash
# 1. Clone repo ini
git clone https://github.com/Farrell-zcx/docker-deployment.git
cd docker-deployment

# 2. Clone kedua project
git clone https://github.com/Farrell-zcx/MyMember.git mymember
git clone https://github.com/Farrell-zcx/SSO-Engine.git sso-engine

# 3. Setup environment
cp .env.example .env
# Edit .env sesuai kebutuhan

# 4. Build dan jalankan
docker compose up --build -d

# 5. Migrate database
docker exec desnet-sso-engine php spark migrate
docker exec desnet-mymember-app php spark migrate
```

## Struktur

```
docker-deployment/
├── docker-compose.yml    # Orkestrator 7 container
├── .env.example          # Template environment variables
├── .env                  # Environment variables (JANGAN commit)
├── init-db.sql           # Auto-create database
├── nginx/
│   └── default.conf      # Reverse proxy config
├── mymember/             # (git clone terpisah)
└── sso-engine/           # (git clone terpisah)
```
