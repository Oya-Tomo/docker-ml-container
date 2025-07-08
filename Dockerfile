FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    wget \
    git \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install cuda toolkit

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
RUN mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.0-570.86.10-1_amd64.deb
RUN cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
RUN apt-get update
RUN apt-get -y install cuda-toolkit-12-8 nvidia-open

# Install uv

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# Sync the project
WORKDIR /workspace
RUN git config --global --add safe.directory /workspace

CMD ["sh", "-c", "uv sync --locked && uv run src/train.py"]