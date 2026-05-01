# bimg uses CGO and needs libvips headers while building.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    pkg-config \
    libvips-dev
    
sudo apt install build-essential python3-dev supervisor python3 python3-virtualenv


virtualenv venv -p python3