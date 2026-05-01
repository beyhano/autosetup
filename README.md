# General Tool Installer

Bu proje, **Ubuntu, Debian ve türevleri** (apt paket yöneticisi kullanan sistemler) üzerinde çeşitli yazılım araçlarını (Go, Rust, Node.js, vb.) hızlı ve modüler bir şekilde kurmak için tasarlanmış genel amaçlı bir Bash betiğidir.

> **Not:** Şu an için sadece `apt` tabanlı dağıtımlar desteklenmektedir.


## Özellikler

- **Modüler Yapı:** İndirme, çıkarma ve PATH güncelleme işlemleri için ayrı fonksiyonlar kullanılır.
- **Dil Desteği:** Go ve Rust dillerini otomatik olarak kurar ve yapılandırır.
- **Sistem Bağımlılıkları:** `linux.md` ve ek gereksinimlere göre `libvips-dev`, `pkg-config`, `git`, `curl`, `wget`, `build-essential`, `python3`, `python3-dev`, `python3-virtualenv`, `supervisor` ve `php-cli` gibi paketleri otomatik kurar.

- **Akıllı İndirme:** Dosya zaten indirilmişse tekrar indirmez.
- **Güvenli PATH Güncelleme:** `~/.bashrc` dosyasını kontrol eder, eğer yol zaten ekliyse tekrar eklemez.
- **Renkli Çıktılar:** İşlem adımlarını görsel olarak takip etmeyi kolaylaştırır.
- **Bağımlılık Kontrolü:** Çalışmadan önce `wget`, `curl`, `tar` ve `sudo` gibi çekirdek araçları kontrol eder; eksik olanları otomatik kurmayı dener.
- **Dry-Run Desteği:** `--dry-run` ile sistemi değiştirmeden hangi komutların çalışacağını gösterir.

## Kullanım

1.  **Betiği İndirin/Oluşturun:** `installer.sh` dosyasının sisteminizde olduğundan emin olun.
2.  **Çalıştırma İzni Verin:**
    ```bash
    chmod +x installer.sh
    ```
3.  **Betiği Çalıştırın:**
    Değişikliklerin anında mevcut terminalinize yansıması için `source` ile çalıştırmanız önerilir:
    ```bash
    source ./installer.sh
    ```
    Veya normal şekilde çalıştırıp sonra manuel source yapabilirsiniz:
    ```bash
    ./installer.sh
    source ~/.bashrc
    ```

4.  **Dry-Run Kullanımı:**
    Gerçek kurulum yapmadan hangi adımların çalışacağını görmek için:
    ```bash
    ./installer.sh --dry-run
    ```

## Yeni Bir Araç Ekleme

Yeni bir araç eklemek için `installer.sh` içerisine aşağıdaki yapıda bir fonksiyon ekleyebilir ve ana bölümde çağırabilirsiniz:

```bash
install_example() {
    local version="1.0.0"
    local tarball="tool-v${version}.tar.gz"
    local url="https://example.com/dl/${tarball}"
    local target="/usr/local/tool"
    local bin_dir="/usr/local/tool/bin"

    log_info "--- Installing Example Tool ---"
    
    download_tool "$url" "$tarball" || return 1
    install_tarball "$tarball" "$target" true || return 1
    update_bash_path "$bin_dir"
}
```

## Dosyalar

- `installer.sh`: Ana kurulum betiği.
- `go.md`: Go kurulumu için temel alınan orijinal dökümantasyon.
- `rust.md`: Rust kurulumu için temel alınan orijinal dökümantasyon.
- `linux.md`: Gerekli sistem paketlerinin listesi.
- `README.md`: Bu bilgilendirme dosyası.
