# General Tool Installer

Bu proje, Linux sistemlerde çeşitli yazılım araçlarını (Go, Node.js, vb.) hızlı ve modüler bir şekilde kurmak için tasarlanmış genel amaçlı bir Bash betiğidir.

## Özellikler

- **Modüler Yapı:** İndirme, çıkarma ve PATH güncelleme işlemleri için ayrı fonksiyonlar kullanılır.
- **Sistem Bağımlılıkları:** `linux.md` ve ek gereksinimlere göre `libvips-dev`, `pkg-config`, `git`, `curl`, `wget`, `build-essential`, `python3`, `python3-dev`, `python3-virtualenv` ve `supervisor` gibi paketleri otomatik kurar.
- **Akıllı İndirme:** Dosya zaten indirilmişse tekrar indirmez.
- **Güvenli PATH Güncelleme:** `~/.bashrc` dosyasını kontrol eder, eğer yol zaten ekliyse tekrar eklemez.
- **Renkli Çıktılar:** İşlem adımlarını görsel olarak takip etmeyi kolaylaştırır.
- **Bağımlılık Kontrolü:** Çalışmadan önce `wget`, `tar` ve `sudo` gibi araçların varlığını kontrol eder.

## Kullanım

1.  **Betiği İndirin/Oluşturun:** `installer.sh` dosyasının sisteminizde olduğundan emin olun.
2.  **Çalıştırma İzni Verin:**
    ```bash
    chmod +x installer.sh
    ```
3.  **Betiği Çalıştırın:**
    ```bash
    ./installer.sh
    ```
    *(Not: Sistem güncellemeleri ve kurulumlar için sudo şifresi istenecektir.)*
4.  **PATH Güncellemesini Uygulayın:** Kurulum bittikten sonra değişikliklerin geçerli olması için:
    ```bash
    source ~/.bashrc
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
- `linux.md`: Gerekli sistem paketlerinin listesi.
- `README.md`: Bu bilgilendirme dosyası.
