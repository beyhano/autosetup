# Node.js Installation via nvm (Node Version Manager)

## Install nvm
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

## Load nvm (in lieu of restarting the shell)
```bash
\. "$HOME/.nvm/nvm.sh"
```

## Install Node.js
```bash
nvm install 24
```

## Verify Installation
```bash
node -v  # Should print "v24.15.0" or similar
npm -v   # Should print "11.12.1" or similar
```

## Reference
- nvm GitHub: https://github.com/nvm-sh/nvm