FROM jenkins/jenkins:alpine-jdk17

USER root

# Install prerequisites
RUN apk update && \
    apk add --no-cache \
        ca-certificates \
        curl && \
    rm -rf /var/cache/apk/*

# Add Docker's GPG key and set up Docker repository
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.11.tgz | tar xz -C /tmp && \
    mv /tmp/docker/* /usr/local/bin && \
    rm -rf /tmp/docker

# Install Docker Compose
RUN curl -fsSL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Add docker group and user
RUN addgroup docker && \
    adduser jenkins docker

# Switch back to the Jenkins user
USER jenkins
