- **Özet:** Node.js'i `nvm` (Node Version Manager) üzerinden kurar ve yönetir. v24 kurulur, varsayılan yapılır ve `~/.bashrc`'ye nvm init kodu eklenir.
- **Kütüphaneler:** Bash, `curl`, `nvm`
- **Bağlantılar:** [[Installer]], [[Utilities]], [[System_Dependencies]]

# NodeJS

## Kurulum Detayları

| Parametre | Değer |
|-----------|-------|
| nvm Versiyon | `v0.40.4` |
| nvm URL | `https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh` |
| Node Versiyon | `24` |

## Akış

1. `nvm` yüklü mü kontrol edilir (`$HOME/.nvm` dizini).
   - Yoksa: curl ile installer indirilir ve çalıştırılır.
2. `nvm.sh` source edilerek kabuğa yüklenir.
3. `nvm install 24` çalıştırılır.
4. `nvm use 24` ve `nvm alias default 24` yapılır.
5. `~/.bashrc`'ye nvm init satırları eklenir:
   ```bash
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   ```
6. `node --version` ve `npm --version` ile doğrulanır.

## Önemli Notlar
- `\.` (backslash-dot) kullanımı betik içinde POSIX uyumluluğu için `.` (source) yerine tercih edilmiştir.

## Referans
- [[node.md]] — nvm GitHub kurulum rehberi
