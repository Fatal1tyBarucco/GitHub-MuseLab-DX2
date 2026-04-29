# Base controlada (evitar latest para builds reprodutíveis)
FROM ghcr.io/muselab-d2x/d2x:latest

# Garantir shell consistente
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Usar usuário correto
USER d2x
WORKDIR /home/d2x

# Copiar configuração antes para melhor uso de cache
COPY --chown=d2x:d2x .devcontainer/pureline.conf /home/d2x/.pureline.conf

# Clonar pureline de forma determinística (sem histórico desnecessário)
RUN git clone --depth 1 https://github.com/chris-marsh/pureline.git ~/pureline \
    && cd ~/pureline \
    && git fetch --depth 1 origin 9940906e824aae3a6f4bd0ee4dac2ea423d31089 \
    && git checkout 9940906e824aae3a6f4bd0ee4dac2ea423d31089

# Configurar bash de forma segura (sem escape quebrado)
RUN printf '%s\n' \
    'if [ "$TERM" != "linux" ]; then' \
    '  source ~/pureline/pureline ~/.pureline.conf' \
    'fi' \
    >> ~/.bashrc

# Retornar diretório padrão
WORKDIR /home/d2x