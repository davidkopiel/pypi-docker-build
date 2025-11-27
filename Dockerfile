FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install JFrog CLI via official script
RUN curl -fL https://install-cli.jfrog.io | sh

# Create working directory and copy source
WORKDIR /app
COPY . .

# Set build metadata
ENV BUILD_NAME=mypkg-build
ENV BUILD_NUMBER=1

# Configure JFrog CLI securely (no ENV for password)
RUN jf config add artifactory-server \
      --url=http://172.16.12.226 \
      --user=admin \
      --password=Password1! \
      --interactive=false
      ENV JFROG_CLI_LOG_LEVEL=DEBUG
# Global pip config for JFrog CLI (more reliable in Docker)
RUN jf pip-config  --global --repo-resolve=davidko-pypi-remote --server-id-resolve=artifactory-server
# Associate build context
RUN jf rt bce $BUILD_NAME $BUILD_NUMBER

# Install dependencies (tracked in build-info)
COPY requirements.txt .
RUN jf pip install -r requirements.txt --build-name=$BUILD_NAME --build-number=$BUILD_NUMBER --trusted-host 172.16.12.226

# Build the Python package
#RUN python setup.py sdist

# Upload the built artifact to Artifactory and attach to build-info
#RUN jf rt u "dist/*.tar.gz" "python-builds/mypkg/" \
#      --build-name=$BUILD_NAME --build-number=$BUILD_NUMBER

# Publish build-info
RUN jf rt bp $BUILD_NAME $BUILD_NUMBER
