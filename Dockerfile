# Imagem base Ubuntu
FROM ubuntu:latest

# Evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências básicas
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    wget \
    git \
    vim \
    sudo

# Adicionar repositório Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Criar usuário com permissões de Docker
RUN groupadd -f docker
RUN useradd -m -s /bin/bash -G docker,sudo testuser
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Definir permissões do socket Docker
RUN mkdir -p /var/run/docker.sock
RUN chown root:docker /var/run/docker.sock
RUN chmod 666 /var/run/docker.sock

# Configurar entrada para permitir Docker in Docker
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Definir usuário padrão
USER root
WORKDIR /home/root

# Definir ponto de entrada
ENTRYPOINT ["/entrypoint.sh"]

# Manter contêiner rodando
CMD ["/bin/bash"]