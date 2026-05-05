- **Özet:** İşletim sistemini ve paket yöneticisini otomatik olarak tespit eder. Alpine (`apk`), Arch (`pacman`) ve Debian/Ubuntu (`apt`) desteklenir.
- **Kütüphaneler:** Bash
- **Bağlantılar:** [[Installer]], [[Dependency_Mapping]], [[System_Dependencies]]

# OS Detection

## Tespit Mantığı

| Kontrol | Sonuç | Paket Yöneticisi |
|---------|-------|-----------------|
| `/etc/alpine-release` var mı? | Evet | `apk` |
| `pacman` komutu var mı? | Evet | `pacman` |
| `apt-get` komutu var mı? | Evet | `apt` |
| Hiçbiri | — | Hata: Desteklenmiyor |

## Yapılandırma Haritası

Her dağıtım için farklı yapılandırma değişkenleri atanır:

### Alpine Linux (`apk`)
- `PKG_UPDATE="apk update"`
- `PKG_INSTALL="apk add"`
- `PKG_INSTALL_ARGS="--no-cache"`
- `PROFILE_FILE="$HOME/.profile"`
- `SUDO_CMD`: `sudo` yoksa boş (root konteyner varsayımı)

### Arch Linux (`pacman`)
- `PKG_UPDATE="pacman -Sy --noconfirm"`
- `PKG_INSTALL="pacman -S --noconfirm --needed"`
- `PROFILE_FILE="$HOME/.bashrc"`
- `SUDO_CMD="sudo"`

### Debian/Ubuntu (`apt`)
- `PKG_UPDATE="apt-get update"`
- `PKG_INSTALL="apt-get install -y --no-install-recommends"`
- `PROFILE_FILE="$HOME/.bashrc"`
- `SUDO_CMD="sudo"`

## Sudo Davranışı
Alpine Linux'ta `sudo` komutu bulunmayabilir (özellikle Docker konteynerlerinde). Bu durumda `SUDO_CMD` boş string olarak ayarlanır ve komutlar doğrudan root olarak çalışır.
