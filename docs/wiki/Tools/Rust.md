- **Özet:** Rust programlama dilini `rustup` aracılığıyla kurar. `rustup.rs` resmi scripti kullanılır ve `~/.cargo/bin` PATH'e eklenir.
- **Kütüphaneler:** Bash, `curl`
- **Bağlantılar:** [[Installer]], [[Utilities]], [[System_Dependencies]]

# Rust

## Kurulum Detayları

| Parametre | Değer |
|-----------|-------|
| Yöntem | `rustup` (resmi installer) |
| Script | `https://sh.rustup.rs` |
| Args | `-s -- -y` (non-interactive) |
| PATH | `~/.cargo/bin` |

## Akış

1. `rustup` yüklü mü kontrol edilir.
   - Yüklü değilse: `curl ... | sh -s -- -y` ile kurulur.
   - Yüklüyse: `rustup update` çalıştırılır.
2. `update_bash_path` ile `~/.cargo/bin` PATH'e eklenir.
3. `export PATH=$PATH:~/.cargo/bin` ile mevcut oturuma uygulanır.
4. `rustc --version` ile doğrulanır.

## Önemli Notlar
- `rustup` kurulumu sırasında PATH yapılandırması otomatik yapılmaya çalışılır, ancak platform farklılıkları nedeniyle betik `~/.bashrc`'ye manuel ekleme yapar.

## Referans
- [[rust.md]] — Orijinal rust-lang.org kurulum dökümanı
