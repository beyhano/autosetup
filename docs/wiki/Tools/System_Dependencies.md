- **Özet:** Tüm araçların çalışması için gerekli olan temel sistem paketlerini kurar. Dağıtıma göre `map_pkg` ile isimler çözülür.
- **Kütüphaneler:** Bash
- **Bağlantılar:** [[Installer]], [[OS_Detection]], [[Dependency_Mapping]]

# System Dependencies

## Kurulan Paketler

| Paket (Debian) | Amaç |
|----------------|------|
| `ca-certificates` | SSL/TLS sertifika doğrulama |
| `git` | Kaynak kontrolü |
| `pkg-config` | Derleme bağımlılıklarını çözümleme |
| `libvips-dev` | Görüntü işleme (CGO/bimg için) |
| `curl` | HTTP istemcisi |
| `wget` | İndirme aracı |
| `build-essential` | C/C++ derleyicileri |
| `python3` | Python yorumlayıcı |
| `python3-dev` | Python geliştirme başlıkları |
| `python3-virtualenv` | Python sanal ortamları |
| `supervisor` | Süreç yönetimi |
| `php-cli` | PHP komut satırı |
| `gnupg` | GPG anahtar yönetimi |

## Akış

1. `apt-get update` (veya dağıtıma özgü eşdeğeri).
2. `map_pkg` ile isimler dağıtıma uygun hale getirilir.
3. Tek seferde tüm paketler kurulur.

## Referans
- [[linux.md]] — Orijinal sistem paket listesi (libvips, ca-certificates vb.)
