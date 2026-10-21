# potemkinhr / nix-homelab

A collection of projects maintained by Nikola Pecik.

## 📂 Projects

### 📊 [Portable Observability Stack](./observability-stack)
A production-grade, Infrastructure-as-Code monitoring stack running on Docker Compose. Designed to be cloned and deployed in under 60 seconds.

*   **Stack:** Grafana, Prometheus, Loki, Uptime Kuma, Node Exporter.
*   **Features:** Pre-provisioned dashboards, host self-monitoring, log aggregation, reverse-proxy ready.
*   **Use Case:** Drop-in boilerplate for monitoring Linux/Windows nodes or locally hosted applications without rebuilding the stack from scratch.

👉 **[View the full documentation here](./observability-stack/README.md)**

### ⚙️ [Infrastructure & Automation Scripts](./scripts)
A collection of custom Bash, PowerShell, and Python scripts used to automate system administration tasks, fix edge-case OS issues, and streamline daily workflows.

*   **Environment:** Tested primarily on immutable Linux distributions (Aurora/uBlue), desktop Windows and enterprise systems.
*   **Use Case:** Quick, idempotent fixes for complex Linux quirks and routine sysadmin automation.

👉 **[View the full documentation here](./scripts/README.md)**

### 🛡️ [Nyx uBlock Origin Filter List](./filterlists/nyx-ubo-filterlist.txt)
A custom filter list for uBlock Origin, maintained to block unwanted ads, elements and trackers.

**Installation:** Add the following URL to your uBlock Origin "Custom" filter lists:
`https://cdn.jsdelivr.net/gh/potemkinhr/nix-homelab@main/filterlists/nyx-ubo-filterlist.txt`

## 🚀 About Me
I am a DevOps and Cloud Infrastructure Engineer with a focus on automation, observability, and Linux systems. You can find more about my professional background on [LinkedIn](https://linkedin.com/in/nikolapecik).

## 📄 License
This repository is licensed under the MIT License – see the [LICENSE](./LICENSE) file for details.