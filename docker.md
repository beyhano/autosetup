# Docker Engine Installation

## Debian/Ubuntu (apt)

### Prerequisites
```bash
sudo apt-get install -y ca-certificates curl gnupg
```

### Add Docker's official GPG key
```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### Set up Docker repository
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Install Docker Engine
```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Enable and start Docker
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### Add user to docker group
```bash
sudo usermod -aG docker $USER
# Note: Log out and log back in for group changes to take effect
```

## Alpine Linux (apk)

### Install Docker
```bash
sudo apk add --no-cache docker docker-cli-compose
```

### Enable and start Docker
```bash
sudo rc-update add docker boot
sudo service docker start
```

### Add user to docker group
```bash
sudo usermod -aG docker $USER
# Note: Log out and log back in for group changes to take effect
```

## Arch Linux (pacman)

### Install Docker
```bash
sudo pacman -S --noconfirm --needed docker docker-compose
```

### Enable and start Docker
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### Add user to docker group
```bash
sudo usermod -aG docker $USER
# Note: Log out and log back in for group changes to take effect
```

## Verify Installation
```bash
docker --version
```

## Reference
- Docker Official Documentation: https://docs.docker.com/engine/install/
