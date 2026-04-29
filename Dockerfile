FROM python:3.14.0-slim

LABEL org.opencontainers.image.source="https://github.com/Fatal1tyBarucco/GitHub-MuseLab-DX2"

# Evita prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Shell robusto
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# -----------------------------
# System dependencies
# -----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    wget \
    curl \
    git \
    ca-certificates \
    jq \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Node.js (oficial - estável)
# -----------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && node -v && npm -v

# ❌ NÃO atualizar npm via npm (removido)

# -----------------------------
# Global npm packages (válidos)
# -----------------------------
RUN npm install -g \
    commander \
    @salesforce/cli@latest

# Salesforce plugins
RUN sf plugins install @salesforce/sfdx-scanner

# -----------------------------
# GitHub CLI
# -----------------------------
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------
# Python tooling
# -----------------------------
RUN python -m pip install --no-cache-dir --upgrade pip pip-tools && \
    pip install --no-cache-dir cumulusci cookiecutter

# -----------------------------
# DevHub script
# -----------------------------
COPY devhub.sh /usr/local/bin/devhub.sh
RUN chmod +x /usr/local/bin/devhub.sh

# -----------------------------
# User setup
# -----------------------------
RUN useradd -m -s /bin/bash d2x

# PATH config
ENV PATH="/home/d2x/.local/bin:${PATH}"

# Bash init
RUN echo '/usr/local/bin/devhub.sh' >> /root/.bashrc && \
    echo '/usr/local/bin/devhub.sh' >> /home/d2x/.bashrc

# Permissões
RUN chown -R d2x:d2x /home/d2x

USER d2x
WORKDIR /home/d2x

CMD ["bash"]