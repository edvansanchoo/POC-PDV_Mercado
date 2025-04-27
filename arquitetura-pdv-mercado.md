# Arquitetura de POC - PDV para Mercado

## Visão Geral
Esta é uma arquitetura básica para uma Prova de Conceito (POC) de um sistema de Ponto de Venda (PDV) para mercado, utilizando Angular para o frontend, .NET 8 para o backend e SQL Server para o banco de dados.

## Estrutura do Projeto

```
PDV-Mercado/
├── frontend/                  # Aplicação Angular
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/    # Componentes reutilizáveis
│   │   │   ├── pages/         # Páginas da aplicação
│   │   │   ├── services/      # Serviços para comunicação com API
│   │   │   ├── models/        # Interfaces e modelos
│   │   │   └── shared/        # Recursos compartilhados
│   │   ├── assets/            # Recursos estáticos
│   │   └── environments/      # Configurações de ambiente
│   ├── angular.json           # Configuração do Angular
│   └── Dockerfile             # Configuração do container do frontend
│
├── backend/                   # API em .NET 8
│   ├── PDV.API/              # Projeto da API
│   │   ├── Controllers/      # Controladores da API
│   │   ├── Models/           # Modelos de domínio
│   │   ├── DTOs/             # Objetos de transferência de dados
│   │   ├── Services/         # Serviços de negócio
│   │   ├── Repositories/     # Repositórios para acesso a dados
│   │   ├── Configurations/   # Configurações da aplicação
│   │   └── Program.cs        # Ponto de entrada da aplicação
│   │
│   ├── PDV.Domain/           # Projeto de domínio
│   │   ├── Entities/         # Entidades de domínio
│   │   └── Interfaces/       # Interfaces
│   │
│   ├── PDV.Infrastructure/   # Projeto de infraestrutura
│   │   ├── Data/             # Contexto e configurações do EF Core
│   │   ├── Repositories/     # Implementações dos repositórios
│   │   └── Migrations/       # Migrações do banco de dados
│   │
│   ├── PDV.Tests/            # Testes unitários e de integração
│   │
│   └── Dockerfile            # Configuração do container do backend
│
├── database/                 # Scripts SQL e documentação do banco
│   ├── scripts/              # Scripts de criação e seed do banco
│   └── Dockerfile            # Configuração do container do SQL Server
│
└── docker/                   # Configurações Docker
    ├── docker-compose.yml    # Composição dos serviços
    └── .env                  # Variáveis de ambiente
```

## Componentes Principais

### Frontend (Angular)

1. **Módulos Principais:**
   - Autenticação e Autorização
   - Dashboard
   - Cadastro de Produtos
   - Cadastro de Clientes
   - PDV (Tela de Vendas)
   - Relatórios

2. **Componentes Essenciais:**
   - Login
   - Navegação/Menu
   - Lista de Produtos
   - Carrinho de Compras
   - Finalização de Venda
   - Impressão de Cupom

3. **Serviços:**
   - AuthService
   - ProductService
   - CustomerService
   - SaleService
   - ReportService

### Backend (.NET 8)

1. **API RESTful com os seguintes endpoints:**
   - /api/auth - Autenticação
   - /api/products - CRUD de produtos
   - /api/customers - CRUD de clientes
   - /api/sales - Registro e consulta de vendas
   - /api/reports - Geração de relatórios

2. **Camadas:**
   - Controllers - Recebem requisições HTTP
   - Services - Lógica de negócio
   - Repositories - Acesso a dados
   - DTOs - Objetos para transferência de dados
   - Domain Models - Entidades de domínio

3. **Recursos:**
   - JWT para autenticação
   - Entity Framework Core para ORM
   - Swagger para documentação da API
   - Logging e monitoramento
   - Validação de dados com FluentValidation

### Banco de Dados (SQL Server)

1. **Tabelas Principais:**
   - Users - Usuários do sistema
   - Products - Cadastro de produtos
   - Categories - Categorias de produtos
   - Customers - Clientes
   - Sales - Vendas
   - SaleItems - Itens de venda
   - PaymentMethods - Métodos de pagamento
   - Inventory - Controle de estoque

2. **Relacionamentos:**
   - Um produto pertence a uma categoria
   - Uma venda possui vários itens
   - Uma venda está associada a um cliente
   - Uma venda possui um ou mais métodos de pagamento

## Fluxo Básico de Operação

1. Operador faz login no sistema
2. Seleciona a opção de nova venda
3. Adiciona produtos ao carrinho (por código, leitura de código de barras ou busca)
4. Sistema calcula valores (subtotal, descontos, total)
5. Operador finaliza a venda selecionando método(s) de pagamento
6. Sistema registra a venda, atualiza estoque e emite comprovante
7. Dados ficam disponíveis para consultas e relatórios

## Considerações Técnicas

1. **Segurança:**
   - Autenticação JWT
   - HTTPS
   - Validação de entrada de dados
   - Controle de acesso baseado em perfis

2. **Performance:**
   - Paginação de resultados
   - Caching de dados frequentes
   - Índices adequados no banco de dados

3. **Escalabilidade:**
   - Arquitetura em camadas
   - Separação clara de responsabilidades
   - Possibilidade de containerização

4. **Offline First:**
   - Capacidade de operar com conexão intermitente
   - Sincronização quando online

## Próximos Passos para Implementação

1. Configurar ambiente de desenvolvimento
2. Criar projeto Angular com Angular CLI
3. Criar solução .NET 8 com os projetos necessários
4. Configurar banco de dados SQL Server
5. Implementar autenticação
6. Desenvolver CRUD básico de produtos
7. Implementar fluxo de vendas
8. Adicionar relatórios essenciais
9. Testar e refinar a aplicação

## Requisitos Técnicos

- Node.js e npm para o frontend
- .NET 8 SDK
- Docker e Docker Compose
- SQL Server (em container Docker)
- Visual Studio, VS Code ou Rider para desenvolvimento
- Git para controle de versão

## Configuração Docker

A arquitetura utiliza Docker para containerizar todos os componentes da aplicação:

1. **Frontend Container**:
   - Imagem base: Node.js para build e Nginx para servir a aplicação
   - Porta exposta: 80 (mapeada para 4200 no host)
   - Volume para desenvolvimento: código fonte montado para hot-reload

2. **Backend Container**:
   - Imagem base: .NET 8 SDK para desenvolvimento, .NET 8 Runtime para produção
   - Porta exposta: 5000 (API)
   - Configuração para debugging remoto

3. **SQL Server Container**:
   - Imagem oficial do SQL Server para Linux
   - Porta exposta: 1433
   - Volume persistente para dados
   - Variáveis de ambiente para configuração inicial

4. **Docker Compose**:
   - Orquestração de todos os containers
   - Configuração de rede interna
   - Definição de dependências entre serviços
   - Variáveis de ambiente centralizadas
