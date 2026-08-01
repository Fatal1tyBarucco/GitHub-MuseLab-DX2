# Base stage
FROM salesforce/cli:latest-full AS base

LABEL org.opencontainers.image.source="https://github.com/muselab-d2x/d2x"

# Install Python, venv, and GitHub CLI
RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y python3-pip python3-venv curl gnupg && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt-get update && apt-get install -y gh && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Create virtual environment for d2x
RUN python3 -m venv /opt/d2x-venv
ENV PATH="/opt/d2x-venv/bin:$PATH"

# Install d2x
COPY pyproject.toml /usr/local/d2x/
COPY d2x /usr/local/d2x/d2x

RUN cd /usr/local/d2x && \
  pip install --no-cache-dir poetry-core && \
  pip install --no-cache-dir .

# Install CumulusCI and dependencies
RUN pip install --no-cache-dir \
  git+https://github.com/muselab-d2x/CumulusCI@1ae7db2af \
  cookiecutter \
  keyrings.alt

# Copy devhub auth script
COPY devhub.sh /usr/local/bin/devhub.sh
RUN chmod +x /usr/local/bin/devhub.sh

# Create d2x user
RUN useradd -r -m -s /bin/bash -c "D2X User" d2x

# Set up PATH
RUN echo "export PATH=/opt/d2x-venv/bin:\$PATH" >> /root/.bashrc && \
  echo "export PATH=/opt/d2x-venv/bin:\$PATH" >> /home/d2x/.bashrc && \
  echo '/usr/local/bin/devhub.sh' >> /root/.bashrc && \
  echo '/usr/local/bin/devhub.sh' >> /home/d2x/.bashrc

# Verify installation
RUN cci version

# Stage for full browser support
FROM base AS browser

RUN apt-get update && apt-get install -y wget unzip && \
  wget -O /tmp/chromedriver.zip \
    https://chromedriver.storage.googleapis.com/$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip -d /usr/local/bin/ && rm /tmp/chromedriver.zip && \
  cci robot install_playwright && npx playwright install-deps && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Final stage for no browser automation support
FROM base AS no-browser

USER d2x
CMD ["bash"]
