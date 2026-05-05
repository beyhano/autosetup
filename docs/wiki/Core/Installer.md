- **Özet:** Ana kurulum betiği olan `installer.sh`'in yapısını ve akışını açıklar. Bootstrap, argüman parse etme, OS tespiti, bağımlılık kurulumu ve araç kurulumlarını yönetir.
- **Kütüphaneler:** Bash, POSIX sh (bootstrap)
- **Bağlantılar:** [[OS_Detection]], [[Utilities]], [[Dependency_Mapping]], [[Go]], [[Rust]], [[NodeJS]], [[Docker]], [[System_Dependencies]]

# Installer (installer.sh)

## Dosya Yapısı

1. **Bootstrap (POSIX sh)**
   - `bash` yoksa otomatik kurulur (`apk`, `apt-get`, `pacman`).
   - Betik `bash` ile yeniden çalıştırılır (`exec bash "$0" "$@"`).

2. **OS Tespiti**
   - `detect_os()` çağrılır. `[[OS_Detection]]` sayfasına bakın.

3. **Bağımlılık Kontrolü**
   - `bootstrap_dependencies()`: `tar`, `grep`, `wget`, `curl`, `sudo` eksikse kurar.

4. **Ana Akış**
   ```
   install_system_deps
   install_go
   install_rust
   install_nodejs
   install_docker
   ```

5. **PATH Yenileme**
   - Kurulum sonrası `$PROFILE_FILE` (`~/.bashrc`) `source` edilir.

## Global Değişkenler

| Değişken | Varsayılan | Açıklama |
|----------|-----------|----------|
| `PKG_MANAGER` | — | `apt`, `apk`, `pacman` |
| `PKG_UPDATE` | — | Güncelleme komutu |
| `PKG_INSTALL` | — | Kurulum komutu |
| `PKG_INSTALL_ARGS` | — | Ek argümanlar (`--no-cache` vb.) |
| `PROFILE_FILE` | `~/.bashrc` | PATH kaydetme dosyası |
| `SUDO_CMD` | `sudo` | Root yetkisi komutu |
| `DRY_RUN` | `false` | `--dry-run` ile `true` olur |

## Komut Satırı Argümanları

| Argüman | Açıklama |
|---------|----------|
| `--dry-run` / `-n` | Komutları çalıştırmaz, sadece gösterir. |
| `--help` / `-h` | Yardım mesajını yazdırır. |

## Önemli Not
- Betik `source ./installer.sh` olarak çalıştırılmalıdır ki PATH değişiklikleri anında yansısın.
