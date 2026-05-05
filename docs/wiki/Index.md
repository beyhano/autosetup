- **Özet:** Autosetup projesinin ana bilgi haritası. Tüm modüller, araçlar ve referanslar arasındaki ilişkileri gösterir.
- **Kütüphaneler:** Bash, Obsidian Markdown
- **Bağlantılar:** [[Installer]], [[OS_Detection]], [[Dependency_Mapping]], [[Utilities]], [[Go]], [[Rust]], [[NodeJS]], [[Docker]], [[System_Dependencies]]

# Autosetup Wiki Index

## Mimari Genel Bakış

```
┌─────────────────────────────────────────────┐
│              installer.sh                    │
│  ┌──────────────┐  ┌──────────────────────┐  │
│  │ OS Detection │  │   Core Utilities     │  │
│  │  (apt/apk/   │  │ (download/extract/   │  │
│  │   pacman)    │  │   path/dry-run)      │  │
│  └──────────────┘  └──────────────────────┘  │
│           ┌────────────────────┐             │
│           │ Dependency Mapping │             │
│           │  (Debian→Distro)   │             │
│           └────────────────────┘             │
└─────────────────────────────────────────────┘
                     │
    ┌────────────────┼────────────────┐
    ▼                ▼                ▼
┌─────────┐   ┌──────────┐   ┌──────────────┐
│  Tools  │   │  Tools   │   │    Tools     │
│   Go    │   │   Rust   │   │   NodeJS     │
└─────────┘   └──────────┘   └──────────────┘
    │
    ▼
┌─────────┐   ┌──────────────┐
│  Tools  │   │    Tools     │
│ Docker  │   │ System Deps  │
└─────────┘   └──────────────┘
```

## Modüller

### Core (Çekirdek)
| Modül | Açıklama |
|-------|----------|
| [[Installer]] | Ana kurulum betiği. Bootstrap, argüman parse etme ve tüm araçları sırayla kurar. |
| [[OS_Detection]] | İşletim sistemini ve paket yöneticisini tespit eder (apt, apk, pacman). |
| [[Dependency_Mapping]] | Debian paket adlarını Alpine/Arch karşılıklarına eşler. |
| [[Utilities]] | İndirme, çıkarma, PATH güncelleme, dry-run ve log fonksiyonları. |

### Tools (Kurulan Araçlar)
| Araç | Versiyon / Yöntem | Açıklama |
|------|-------------------|----------|
| [[Go]] | 1.26.2 | `/usr/local/go` altına tarball ile kurulum. |
| [[Rust]] | rustup (latest) | `rustup.rs` scripti ile kurulum. `~/.cargo/bin` PATH'e eklenir. |
| [[NodeJS]] | v24 (via nvm) | `nvm` aracılığıyla kurulum ve yönetim. |
| [[Docker]] | latest (repo) | Resmi Docker apt/apk/pacman reposundan kurulum. |
| [[System_Dependencies]] | - | `ca-certificates`, `git`, `libvips-dev`, `build-essential`, `python3`, `supervisor`, `php-cli` vb. |

### Referanslar
| Dosya | Kaynak |
|-------|--------|
| [[Docker_Ubuntu]] | Docker Docs — Ubuntu kurulum rehberi |
| [[Docker_Debian]] | Docker Docs — Debian kurulum rehberi |
| [[linux.md]] | Sistem paket listesi (libvips, ca-certificates vb.) |
| [[go.md]] | go.dev resmi kurulum dökümanı |
| [[rust.md]] | rust-lang.org resmi kurulum dökümanı |
| [[node.md]] | nvm GitHub — Node.js kurulum rehberi |
| [[docker.md]] | Docker Engine resmi kurulum adımları |

### Proje Kuralları
| Dosya | Açıklama |
|-------|----------|
| [[wiki_schema]] | Wiki oluşturma ve güncelleme kuralları (Obsidian formatı). |
| [[cursorrules]] | AI agent kuralları: Kod değişikliği sonrası wiki senkronizasyonu zorunluluğu. |

## Sürüm ve Durum
- **Son Güncelleme:** 2026-05-05
- **Durum:** INGEST tamamlandı — Temel mimari dokümante edildi.
