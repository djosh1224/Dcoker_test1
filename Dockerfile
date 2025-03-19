# Base image that is outdated (Debian 8, which no longer receives updates)
FROM debian:8

# Set hardcoded secrets in environment variables (dangerous practice)
ENV API_KEY="supersecretapikey12345"
ENV DB_PASSWORD="password123"

# Install vulnerable 3rd-party libraries (old versions with known CVEs)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    openssh-server \
    # Installing old versions of libraries (e.g., openssl with CVE vulnerabilities)
    openssl=1.0.1t-1+deb8u9 \
    && rm -rf /var/lib/apt/lists/*

# Install vulnerable 3rd-party software like Node.js (old, outdated version with known security issues)
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && apt-get install -y nodejs

# Add a known vulnerable app (e.g., old Express.js app with known flaws)
COPY vulnerable-app/ /home/vulnerable-app

# Install old dependencies in the vulnerable app (known insecure versions of packages)
RUN cd /home/vulnerable-app && npm install --production

# Expose a port that is commonly targeted (no TLS, just HTTP)
EXPOSE 8080

# Use root to run the app (no least privilege)
USER root

# Run a vulnerable app (e.g., an old version of an Express.js app)
CMD ["node", "/home/vulnerable-app/app.js"]
