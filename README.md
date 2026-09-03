<div align="center">

# Docker Blueprint - Ubuntu 22.04 Container

A lightweight **Docker Blueprint** built on **Ubuntu 22.04 LTS**, pre-configured with SSH, Supervisor, Logging, Cron, SSH Key Authentication, and optional on-demand environment setups (Python 3, Node.js) managed via Environment Variables.

</div>

---

## 📌 Features
* **Base OS**: Ubuntu 22.04 LTS.
* **Process Manager**: Managed by `supervisord` to handle background processes (`sshd`, `rsyslog`, `cron`).
* **Graceful Init**: Integrated with `tini` as the init process for reliable signal handling.
* **SSH Server**: Pre-configured OpenSSH Server supporting custom ports, root password configuration, and PubKey/Password authentication.
* **On-Demand Runtimes**:
  * Automatically installs **Python 3** (`python3`, `pip`, `venv`) on startup when `INSTALL_PYTHON=true`.
  * Automatically installs **Node.js** (LTS) on startup when `INSTALL_NODE=true`.
* **Pre-installed Utilities**: `git`, `curl`, `wget`, `zip`, `unzip`, `vim`, `htop`, `sudo`, `openssl`, `ca-certificates`, `rsyslog`, `cron`.

---

## 🛠 Environment Variables
Configure the container dynamically at launch using runtime flags (`-e`):

| Variable | Description | Default Value |
| --- | --- | --- |
| `PORT` | SSH service port inside the container | `22` |
| `PASSWD` | Password for the `root` user | *(Not set)* |
| `SSH_KEY` | Public SSH key injected into `/root/.ssh/authorized_keys` | *(Not set)* |
| `INSTALL_PYTHON` | Set to `true` to auto-install Python 3 & pip | `false` |
| `INSTALL_NODE` | Set to `true` to auto-install Node.js LTS | `false` |

---

## 🚀 Quick Start & Installation

### Option 1: Direct Build from Git (Zero Disk Junk)
Build the Docker image directly from GitHub without cloning repo files or creating temporary directories on your host machine:
```bash
docker build -t docker-img https://github.com/karasu-devteam/docker-blueprint.git#main
```

---

### Option 2: Build via Temporary Directory
Clone into a temporary directory created by system `mktemp`, build the image, and automatically purge all temporary files afterwards:
```bash
TMP_DIR=$(mktemp -d) && \
git clone https://github.com/karasu-devteam/docker-blueprint.git "$TMP_DIR" && \
docker build -t docker-img "$TMP_DIR" && \
rm -rf "$TMP_DIR"
```

---

### 2. Run Container

#### Password Authentication:
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

#### SSH Key Authentication:
```bash
docker run -d \
  --name x404x \
  --hostname karasu \
  -p 2222:22 \
  -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" \
  docker-img
```

---

### 3. Connect via SSH
```bash
# Connect using password
ssh root@localhost -p 2222

# Connect using SSH Key
ssh -i ~/.ssh/id_rsa root@localhost -p 2222
```

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
This project is licensed under the [GNU Affero General Public License v3.0 (AGPL-3.0)](./LICENSE).
