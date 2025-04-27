# PDV Mercado - Sistema de Ponto de Venda

Este projeto é uma Prova de Conceito (POC) de um sistema de Ponto de Venda (PDV) para mercados, desenvolvido com Angular, .NET 8 e SQL Server.

## Visão Geral

O PDV Mercado é um sistema completo para gerenciamento de vendas em mercados, incluindo:

- Cadastro de produtos e categorias
- Cadastro de clientes
- Controle de estoque
- Processamento de vendas
- Múltiplos métodos de pagamento
- Relatórios e dashboards

## Tecnologias Utilizadas

- **Frontend**: Angular 17
- **Backend**: .NET 8 (C#)
- **Banco de Dados**: SQL Server
- **Containerização**: Docker e Docker Compose
- **Autenticação**: JWT

## Estrutura do Projeto

O projeto segue uma arquitetura em camadas com separação clara de responsabilidades:

- **Frontend**: Interface de usuário em Angular
- **Backend**: API RESTful em .NET 8
- **Banco de Dados**: SQL Server em container Docker

## Como Executar

### Pré-requisitos

- Docker e Docker Compose
- Git

### Passos para Execução

1. Clone o repositório:
   ```bash
   git clone <url-do-repositorio>
   cd PDV-Mercado
   ```

2. Execute o projeto com Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Acesse a aplicação:
   - Frontend: http://localhost:4200
   - API: http://localhost:5000
   - Swagger: http://localhost:5000/swagger

## Desenvolvimento

O projeto segue um plano de desenvolvimento incremental, com fases bem definidas para implementação e teste de cada componente. Consulte o arquivo `plano-desenvolvimento-incremental.md` para mais detalhes.

## Licença

Este projeto está licenciado sob a licença MIT - consulte o arquivo LICENSE para obter detalhes.
