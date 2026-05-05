- **Özet:** Docker Engine'in Debian üzerinde resmi `apt` reposu ile kurulumuna ilişkin orijinal Docker Docs referansı.
- **Kütüphaneler:** Docker
- **Bağlantılar:** [[Docker]], [[Docker_Ubuntu]]

# Docker Debian Referansı

## Desteklenen Versiyonlar
- Debian Trixie 13 (stable)
- Debian Bookworm 12 (oldstable)
- Debian Bullseye 11 (oldoldstable)

## Mimari Desteği
`x86_64` (amd64), `armhf` (arm/v7), `arm64`, `ppc64le`

## Çakışan Paketler (Kaldırılmalı)
- `docker.io`
- `docker-compose`
- `docker-doc`
- `podman-docker`

## GPG & Repo Kurulumu
```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

## Yükseltme
Adım 2'yi (paket kurulum) daha yeni versiyon seçerek tekrar çalıştırın.

> **Kaynak:** https://docs.docker.com/engine/install/debian/
