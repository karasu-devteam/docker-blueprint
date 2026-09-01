<div align="center">

# Docker Blueprint - Ubuntu 22.04 Container

A lightweight **Docker Blueprint** built on **Ubuntu 22.04 LTS**, pre-configured with SSH, Supervisor, Logging, Cron, and optional on-demand environment setup (Python, Node.js) controlled via Environment Variables.
</div>

---

## 📌 Features
* **Base OS**: Ubuntu 22.04 LTS.
* **Process Manager**: Managed by `supervisord` to run background services (`sshd`, `rsyslog`, `cron`).
* **Graceful Init**: Integrated with `tini` as the init process for reliable signal handling.
* **SSH Server**: Pre-configured OpenSSH Server supporting custom ports, root password configuration, and PubKey/Password authentication.
* **On-Demand Runtimes**:
  * Automatically installs **Python 3** (`python3`, `pip`, `venv`) on startup when setting `INSTALL_PYTHON=true`.
  * Automatically installs **Node.js** (LTS) on startup when setting `INSTALL_NODE=true`.
* **Pre-installed Utilities**: `git`, `curl`, `wget`, `zip`, `unzip`, `vim`, `htop`, `sudo`, `openssl`, `ca-certificates`, `rsyslog`, `cron`.

---

## 🛠 Environment Variables
Configure the container dynamically at launch using runtime flags (`-e`):

| Variable | Description | Default Value |
| --- | --- | --- |
| `PORT` | SSH service port inside the container | `22` |
| `PASSWD` | Password for the `root` user | *(Not set)* |
| `INSTALL_PYTHON` | Set to `true` to auto-install Python 3 & pip | `false` |
| `INSTALL_NODE` | Set to `true` to auto-install Node.js LTS | `false` |

---

## 🚀 Quick Start & Installation

### 1. Clone Repository & Build Image
Clone the project repository from GitHub, navigate into the project directory, and build the Docker image:
```bash
# Create temporary working directory and enter it
mkdir docker-build.tmp && cd docker-build.tmp

# Clone the repository
git clone https://github.com/karasu-devteam/docker-blueprint.git .

# Build Docker image named 'docker-img'
docker build -t docker-img .

# Clean up temporary directory
cd .. && rm -rf docker-build.tmp
```

---

### 2. Run Container
Create and run your first container with custom hostname, root password, and pre-installed Python & Node.js runtimes:
```bash
docker run -d \
  --name x404x \
  --hostname karasu \
  -p 2222:22 \
  -e PASSWD="123" \
  -e INSTALL_PYTHON=true \
  -e INSTALL_NODE=true \
  docker-img
```

---

### 3. Connect via SSH
Once the container is running, access it via SSH:
```bash
ssh root@localhost -p 2222
```

*(Use the password specified in `PASSWD`, e.g., `123`)*

---

## ⚙️ Repository Structure
```text
docker-blueprint/
├── Dockerfile          # Ubuntu 22.04 base build configuration & essential tools
├── entrypoint.sh       # Dynamic SSH setup, runtime installers, & supervisor launcher
├── supervisord.conf    # Process management config for rsyslog, sshd, and cron
└── LICENSE             # Open-source license (AGPL-3.0)
```

---

## 📜 License
This project is licensed under the [AGPL-3.0 License](./LICENSE).
