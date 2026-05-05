- **Özet:** `installer.sh` içinde kullanılan yardımcı fonksiyonları bir araya getirir. İndirme, çıkarma, PATH güncelleme, dry-run modu ve loglama işlemlerini kapsar.
- **Kütüphaneler:** Bash, `wget`, `curl`, `tar`
- **Bağlantılar:** [[Installer]], [[Go]], [[Rust]], [[NodeJS]], [[Docker]]

# Utilities

## Loglama

| Fonksiyon | Çıktı | Amaç |
|-----------|-------|------|
| `log_info "mesaj"` | `[INFO] mesaj` (yeşil) | Bilgi mesajı |
| `log_error "mesaj"` | `[ERROR] mesaj` (kırmızı, stderr) | Hata mesajı |

## Dry-Run Modu

- `DRY_RUN=true` olduğunda `run_cmd` ve `run_shell_cmd` komutları çalıştırmaz, sadece `[DRY-RUN]` önekiyle yazdırır.
- `--dry-run` veya `-n` argümanı ile etkinleştirilir.

## İndirme (download_tool)

| Özellik | Davranış |
|---------|----------|
| `wget` öncelikli | Var ise `wget -q` kullanır. |
| `curl` yedek | Yok ise `curl -fsSL` kullanır. |
| Önbellek kontrolü | Dosya zaten varsa indirmez. |
| Hata kontrolü | İndirme başarısız olursa `return 1`. |

## Çıkarma (install_tarball)

```bash
install_tarball <tarball> <target_dir> <remove_old>
```

- `remove_old=true`: Hedef dizin önce `rm -rf` ile silinir.
- `tar -C <parent> -xzf <tarball>` ile çıkarılır.
- Hedef dizinin üst klasörü `mkdir -p` ile oluşturulur.

## PATH Güncelleme (update_bash_path)

| Özellik | Davranış |
|---------|----------|
| Çift ekleme önleme | `grep -q` ile kontrol eder; zaten varsa eklemez. |
| Profil oluşturma | Dosya yoksa `touch` ile oluşturur. |
| Format | `export PATH=$PATH:<bin_path>` |

## Kabuk Komutu Çalıştırma (run_shell_cmd)

- `eval` kullanarak string olarak komut çalıştırır.
- Dry-run modunda sadece yazdırır.
