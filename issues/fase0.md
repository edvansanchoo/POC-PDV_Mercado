Fase 0: Configuração do Ambiente

## Descrição
Configurar o ambiente de desenvolvimento completo para o projeto PDV Mercado, incluindo Docker, estrutura de diretórios e repositório Git.

## Tarefas
- [x] Inicializar repositório Git
- [x] Configurar .gitignore para .NET, Angular e Docker
- [ ] Criar Dockerfile para frontend (Angular)
- [ ] Criar Dockerfile para backend (.NET 8)
- [ ] Criar Dockerfile para SQL Server
- [ ] Criar docker-compose.yml para orquestrar todos os serviços
- [ ] Criar arquivo .env para variáveis de ambiente
- [ ] Preparar estrutura de diretórios conforme arquitetura definida

## Detalhes Técnicos

### Estrutura de Diretórios
```
PDV-Mercado/
├── frontend/
├── backend/
│   ├── PDV.API/
│   ├── PDV.Domain/
│   ├── PDV.Infrastructure/
│   └── PDV.Tests/
├── database/
│   └── scripts/
└── docker/
```

### Docker Compose
O arquivo docker-compose.yml deve configurar:
- Serviço frontend (Angular)
- Serviço backend (.NET 8)
- Serviço database (SQL Server)
- Rede interna para comunicação entre serviços
- Volumes para persistência de dados
- Variáveis de ambiente para configuração

### Variáveis de Ambiente (.env)
- SQL_PASSWORD: Senha para o SQL Server
- ASPNETCORE_ENVIRONMENT: Ambiente de desenvolvimento
- JWT_SECRET: Chave secreta para tokens JWT

## Critérios de Aceitação
- Todos os serviços devem iniciar corretamente com `docker-compose up`
- Frontend deve ser acessível em http://localhost:4200
- Backend deve ser acessível em http://localhost:5000
- SQL Server deve estar disponível na porta 1433
- Volumes devem persistir dados entre reinicializações
- Hot-reload deve funcionar para desenvolvimento
