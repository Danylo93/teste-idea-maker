#!/bin/bash

# Comandos para implantar a aplicação na instância EC2
# Por exemplo, copiar arquivos de código para a instância, iniciar o servidor, etc.
# Substitua esses comandos pelos comandos reais necessários para implantar sua aplicação

# Exemplo:
scp -i /path/to/key.pem -r /path/to/local/files ec2-user@<instance-public-ip>:/path/to/remote/directory
ssh -i /path/to/key.pem ec2-user@<instance-public-ip> "sudo systemctl restart nginx"
