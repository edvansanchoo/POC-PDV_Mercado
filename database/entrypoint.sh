#!/bin/bash

# Iniciar o serviço SQL Server
/opt/mssql/bin/sqlservr &

# Aguardar o SQL Server iniciar
sleep 30

# Executar scripts de inicialização
for script in /docker-entrypoint-initdb.d/*.sql
do
    echo "Executando script $script"
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i $script
done

# Manter o container em execução
tail -f /dev/null
