# 📊 Portable Observability Stack

A production-grade, Infrastructure-as-Code observability boilerplate for Docker and Docker Compose. Clone it, set a password, and get a fully functional monitoring platform in under 60 seconds — complete with pre-provisioned dashboards, self-monitoring, and log aggregation.

Designed for homelab environments, small self-hosted deployments, and anyone who wants a sane starting point for monitoring their infrastructure without rebuilding the same Grafana/Prometheus/Loki stack from scratch every time.

---

## 🏗️ Architecture

| Component | Role | Port |
| :--- | :--- | :--- |
| [**Grafana**](https://grafana.com/) | Visualization and dashboards | `3000` |
| [**Prometheus**](https://prometheus.io/) | Metrics collection and time-series storage | `9090` |
| [**Loki**](https://grafana.com/oss/loki/) | Log aggregation and querying | `3100` |
| [**Uptime Kuma**](https://uptime.kuma.pet/) | Synthetic monitoring and status pages | `3001` |
| [**Node Exporter**](https://github.com/prometheus/node_exporter) | Host metrics (self-monitoring) | `9100` |
| **JSON Exporter** *(optional)* | Scrapes custom JSON APIs into Prometheus | `7979` |

All services communicate over an isolated `obs-net` Docker bridge network. Data persists through named Docker volumes, so `docker compose down` and `up` are safe — only `down -v` wipes state.

---

## 🚀 Quick Start

**Requirements:** Docker Engine 20.10+ and Docker Compose v2.

```bash
# 1. Clone the repository
git clone https://github.com/potemkinhr/nix-homelab.git
cd nix-homelab/observability-stack

# 2. Create your environment file
cp .env.example .env

# 3. Set a secure Grafana password (edit .env)
nano .env

# 4. Start the stack
docker compose up -d

# 5. Access the interfaces
#    Grafana:       http://localhost:3000  (admin / your .env password)
#    Prometheus:    http://localhost:9090
#    Uptime Kuma:   http://localhost:3001  (create admin on first visit)