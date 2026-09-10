# Using ubuntu:22.04 for testing quickly, the gitlab runner uses docker:24-dind(apline)
FROM ubuntu:22.04
# FROM node:25-alpine 
# FROM docker:24-dind

# Install some pkgs (unoptimized)
RUN apt-get update && apt-get  install -y \
    curl git jq libicu-dev sudo unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/runner

# Instructions from GitHub Add new self-hosted runner
# Create a folder
RUN mkdir actions-runner && cd actions-runner
# Download the latest runner package
RUN curl -o actions-runner-linux-x64-2.337.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.337.0/actions-runner-linux-x64-2.337.0.tar.gz
# Optional: Validate the hash
RUN echo "70920811a4f8ad4328818682bca5c6469c1c942fab52448868071d0063816613  actions-runner-linux-x64-2.337.0.tar.gz" | shasum -a 256 -c
# Extract the installer
RUN tar xzf ./actions-runner-linux-x64-2.337.0.tar.gz
    

# Copy our startup script into the container
COPY start.sh /home/runner/start.sh
RUN chmod +x /home/runner/start.sh \
    && chown -R runner:runner /home/runner

# Create the runner and start the configuration experience
# RUN ./config.sh --url https://github.com/VitorChng/Test-Runner --token A5I5MUK26ZD5I2K3YEPM7SLKUKIXW

USER runner

# When the container starts, run start.sh
ENTRYPOINT ["/home/runner/start.sh"]