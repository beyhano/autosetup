- **Özet:** Docker Engine'in Ubuntu üzerinde resmi `apt` reposu ile kurulumuna ilişkin orijinal Docker Docs referansı.
- **Kütüphaneler:** Docker
- **Bağlantılar:** [[Docker]], [[Docker_Debian]]

# Docker Ubuntu Referansı

## Desteklenen Versiyonlar
- Ubuntu Resolute 26.04 (LTS)
- Ubuntu Questing 25.10
- Ubuntu Noble 24.04 (LTS)
- Ubuntu Jammy 22.04 (LTS)

## Mimari Desteği
`x86_64` (amd64), `armhf`, `arm64`, `s390x`, `ppc64le`

## Çakışan Paketler (Kaldırılmalı)
- `docker.io`
- `docker-compose`
- `docker-compose-v2`
- `docker-doc`
- `podman-docker`

## GPG & Repo Kurulumu
```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

## Yükseltme
Adım 2'yi (paket kurulum) daha yeni versiyon seçerek tekrar çalıştırın.

> **Kaynak:** https://docs.docker.com/engine/install/ubuntu/
