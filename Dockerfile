# Base stage
FROM salesforce/cli:latest-full AS base

LABEL org.opencontainers.image.source="https://github.com/muselab-d2x/d2x"

# Install Python and basic tools
RUN apt-get update && \
    apt-get install -y python3-pip python3-venv python3-full git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install CumulusCI using venv
# NOTE: Using official CumulusCI from PyPI (supports pydantic>=2)
# The fork muselab-d2x/CumulusCI requires pydantic<2 which conflicts with d2x
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir cumulusci cookiecutter

# Copy devhub auth script and make it executable
COPY devhub.sh /usr/local/bin/devhub.sh
RUN chmod +x /usr/local/bin/devhub.sh

# Create d2x user
RUN useradd -r -m -s /bin/bash -c "D2X User" d2x

# Setup PATH for both root and d2x
RUN echo 'export PATH=/opt/venv/bin:~/.local/bin:$PATH' >> /root/.bashrc && \
    echo 'export PATH=/opt/venv/bin:~/.local/bin:$PATH' >> /home/d2x/.bashrc && \
    echo '/usr/local/bin/devhub.sh' >> /root/.bashrc && \
    echo '/usr/local/bin/devhub.sh' >> /home/d2x/.bashrc

# Stage for browser support
FROM base AS browser

RUN cci robot install_playwright && \
    npx playwright install-deps

# Final stage for no browser automation support
FROM base AS no-browser

USER d2x
CMD ["bash"]
