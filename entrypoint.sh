#!/bin/bash

# Iniciar o serviço Docker
sudo service docker start

# Permitir que o usuário atual use Docker sem sudo
sudo usermod -aG docker $USER

# Executar o comando padrão
exec "$@"