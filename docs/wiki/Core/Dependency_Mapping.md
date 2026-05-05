- **Özet:** Debian tabanlı paket adlarını Alpine (`apk`) ve Arch (`pacman`) karşılıklarına çevirir. Araç kurulumlarının çoklu dağıtımda çalışmasını sağlar.
- **Kütüphaneler:** Bash (case pattern matching)
- **Bağlantılar:** [[OS_Detection]], [[Installer]], [[System_Dependencies]]

# Dependency Mapping (map_pkg)

## Eşleştirme Tablosu

| Debian Paketi | Alpine (`apk`) | Arch (`pacman`) |
|---------------|----------------|-----------------|
| `pkg-config` | `pkgconfig` | `pkgconf` |
| `libvips-dev` | `vips-dev` | `libvips` |
| `build-essential` | `build-base` | `base-devel` |
| `python3-virtualenv` | `py3-virtualenv` | `python-virtualenv` |
| `python3-dev` | `python3-dev` | `python` |
| `php-cli` | `php83-cli` | `php` |
| `ca-certificates` | (aynı) | `ca-certificates` |
| `gnupg` | (aynı) | `gnupg` |
| Diğer tümü | (aynı) | (aynı) |

## Kullanım

```bash
local mapped_pkgs=()
for p in "${pkgs[@]}"; do
    mapped_mkgs+=("$(map_pkg "$p")")
done
```

## Önemli Noktalar
- `apt` için hiçbir dönüşüm yapılmaz; paket adları olduğu gibi bırakılır.
- Eşleşmeyen paketler `*` wildcard case'i sayesinde aynen döndürülür.
