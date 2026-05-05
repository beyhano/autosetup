- **Özet:** Docker Engine'i resmi paket depolarından kurar. Dağıtıma özgü repo yapılandırması, GPG anahtarı ekleme, paket kurulumu ve servis yönetimi içerir.
- **Kütüphaneler:** Bash, `apt`/`apk`/`pacman`, `systemctl`/`rc-update`
- **Bağlantılar:** [[Installer]], [[OS_Detection]], [[Utilities]]

# Docker

## Kurulum Detayları

| Parametre | Değer |
|-----------|-------|
| Yöntem | Resmi repo (apt/apk/pacman) |
| Servis | `docker` |
| Grup | `docker` |

## Dağıtıma Göre Kurulum

### Debian/Ubuntu (`apt`)

1. **Ön Koşullar:** `ca-certificates curl gnupg`
2. **GPG Anahtarı:**
   ```bash
   curl -fsSL https://download.docker.com/linux/<ID>/gpg | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg
   ```
   > `--batch --yes` bayrakları sayesinde dosya zaten varsa üzerine yazma onayı sormadan devam eder (non-interactive).
3. **Repo:** `https://download.docker.com/linux/<ID> <VERSION_CODENAME> stable`
4. **Paketler:** `docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

### Alpine Linux (`apk`)
- Paketler: `docker docker-cli-compose`
- Servis: `rc-update add docker boot`

### Arch Linux (`pacman`)
- Paketler: `docker docker-compose`
- Servis: `systemctl enable --now docker`

## Servis Yönetimi

| İşlem | systemd | OpenRC (Alpine) |
|-------|---------|-----------------|
| Enable | `systemctl enable docker` | `rc-update add docker boot` |
| Start | `systemctl start docker` | `service docker start` |

## Kullanıcı Grubu
- `$USER` `docker` grubuna eklenir (`usermod -aG docker $USER`).
- Değişiklik oturum yeniden başlatılınca geçerli olur.

## Referanslar
- [[docker.md]] — Docker Engine kurulum rehberi (özet)
- [[Docker_Ubuntu]] — Docker Docs Ubuntu kurulumu
- [[Docker_Debian]] — Docker Docs Debian kurulumu
