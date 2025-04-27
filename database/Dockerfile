FROM mcr.microsoft.com/mssql/server:2022-latest

# Criar diretório para scripts de inicialização
RUN mkdir -p /docker-entrypoint-initdb.d

# Copiar scripts de inicialização
COPY ./scripts/ /docker-entrypoint-initdb.d/

# Copiar script de inicialização personalizado
COPY ./entrypoint.sh /

# Tornar o script executável
RUN chmod +x /entrypoint.sh

# Definir variáveis de ambiente
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express

# Expor porta
EXPOSE 1433

# Iniciar SQL Server com script personalizado
CMD /bin/bash /entrypoint.sh
