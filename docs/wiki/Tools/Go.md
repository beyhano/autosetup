- **Özet:** Go programlama dilinin tarball ile `/usr/local/go` dizinine kurulumunu sağlar. PATH'e `/usr/local/go/bin` eklenir ve kurulum doğrulanır.
- **Kütüphaneler:** Bash, `tar`, `wget`/`curl`
- **Bağlantılar:** [[Installer]], [[Utilities]], [[System_Dependencies]]

# Go

## Kurulum Detayları

| Parametre | Değer |
|-----------|-------|
| Versiyon | `1.26.2` |
| Arch | `linux-amd64` |
| URL | `https://go.dev/dl/go1.26.2.linux-amd64.tar.gz` |
| Hedef Dizin | `/usr/local/go` |
| PATH | `/usr/local/go/bin` |

## Akış

1. `download_tool` ile tarball indirilir.
2. `install_tarball` ile `/usr/local/go` altına çıkarılır (eski kurulum varsa silinir).
3. `update_bash_path` ile `~/.bashrc`'ye PATH eklenir.
4. `export PATH=$PATH:/usr/local/go/bin` ile mevcut oturuma uygulanır.
5. `go version` ile doğrulanır.

## Referans
- [[go.md]] — Orijinal go.dev kurulum dökümanı
