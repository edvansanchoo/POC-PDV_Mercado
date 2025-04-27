# Plano de Desenvolvimento Incremental - PDV Mercado

Este documento apresenta um plano de desenvolvimento incremental para a POC do PDV de Mercado, permitindo testar cada componente à medida que é desenvolvido.

## Fase 0: Configuração do Ambiente

### Tarefas:
1. **Configurar repositório Git**
   - Inicializar repositório
   - Configurar .gitignore para .NET, Angular e Docker

2. **Configurar Docker**
   - Criar Dockerfile para frontend
   - Criar Dockerfile para backend
   - Criar Dockerfile para SQL Server
   - Criar docker-compose.yml

3. **Preparar estrutura de diretórios**
   - Criar estrutura base conforme arquitetura definida

### Entregável:
- Ambiente de desenvolvimento completo com Docker
- Repositório Git inicializado
- Estrutura de diretórios criada

### Como testar:
- Executar `docker-compose up` e verificar se todos os containers iniciam corretamente
- Acessar cada serviço nas portas configuradas

## Fase 1: Banco de Dados e Entidades Básicas

### Tarefas:
1. **Configurar SQL Server**
   - Criar scripts de inicialização
   - Definir esquema básico do banco

2. **Implementar entidades de domínio**
   - Criar entidade Product
   - Criar entidade Category
   - Definir relacionamentos

3. **Configurar Entity Framework Core**
   - Criar DbContext
   - Configurar mapeamentos
   - Implementar migrações iniciais

### Entregável:
- Banco de dados SQL Server configurado
- Entidades básicas implementadas
- Migrações do EF Core funcionando

### Como testar:
- Conectar ao SQL Server via SQL Management Studio ou Azure Data Studio
- Verificar se as tabelas foram criadas corretamente
- Executar migrações e confirmar estrutura do banco

## Fase 2: API de Produtos (Backend)

### Tarefas:
1. **Implementar repositório de produtos**
   - Criar interface IProductRepository
   - Implementar ProductRepository

2. **Implementar serviço de produtos**
   - Criar interface IProductService
   - Implementar ProductService com lógica de negócio

3. **Implementar controller de produtos**
   - Criar ProductController com endpoints CRUD
   - Implementar DTOs para produtos
   - Configurar AutoMapper

4. **Configurar Swagger**
   - Documentar API
   - Configurar UI do Swagger

### Entregável:
- API REST para produtos funcionando
- Documentação Swagger disponível

### Como testar:
- Acessar Swagger UI (http://localhost:5000/swagger)
- Testar endpoints de produtos (GET, POST, PUT, DELETE)
- Verificar persistência no banco de dados

## Fase 3: Interface de Produtos (Frontend)

### Tarefas:
1. **Configurar projeto Angular**
   - Criar projeto com Angular CLI
   - Configurar módulos principais
   - Configurar roteamento

2. **Implementar serviço de produtos**
   - Criar ProductService para comunicação com API
   - Implementar métodos CRUD

3. **Implementar componentes de produtos**
   - Criar componente de listagem
   - Criar componente de formulário
   - Criar componente de detalhes

4. **Implementar páginas de produtos**
   - Página de listagem de produtos
   - Página de cadastro/edição
   - Página de detalhes

### Entregável:
- Interface de usuário para gerenciamento de produtos

### Como testar:
- Acessar interface (http://localhost:4200)
- Cadastrar, editar e excluir produtos
- Verificar se as alterações são refletidas no banco de dados

## Fase 4: Categorias de Produtos (Full Stack)

### Tarefas:
1. **Backend para categorias**
   - Implementar repositório, serviço e controller
   - Configurar endpoints CRUD

2. **Frontend para categorias**
   - Implementar serviço e componentes
   - Integrar com produtos

### Entregável:
- Funcionalidade completa de categorias
- Integração entre produtos e categorias

### Como testar:
- Criar categorias via interface
- Associar produtos a categorias
- Filtrar produtos por categoria

## Fase 5: Autenticação e Autorização

### Tarefas:
1. **Backend de autenticação**
   - Implementar entidade User
   - Configurar Identity ou sistema de autenticação próprio
   - Implementar JWT

2. **Frontend de autenticação**
   - Criar componentes de login/registro
   - Implementar guards de rota
   - Configurar interceptors para tokens

### Entregável:
- Sistema de autenticação funcional
- Proteção de rotas e recursos

### Como testar:
- Registrar usuário
- Fazer login/logout
- Verificar acesso a recursos protegidos

## Fase 6: Clientes

### Tarefas:
1. **Backend para clientes**
   - Implementar entidade Customer
   - Criar repositório, serviço e controller

2. **Frontend para clientes**
   - Implementar serviço e componentes
   - Criar páginas de gerenciamento

### Entregável:
- Funcionalidade completa de clientes

### Como testar:
- Cadastrar, editar e excluir clientes
- Buscar clientes por nome, CPF, etc.

## Fase 7: PDV - Carrinho de Compras

### Tarefas:
1. **Backend para carrinho**
   - Implementar modelo de carrinho
   - Criar endpoints para gerenciamento

2. **Frontend para carrinho**
   - Implementar serviço de carrinho
   - Criar componente de carrinho
   - Implementar adição/remoção de produtos

### Entregável:
- Funcionalidade de carrinho de compras

### Como testar:
- Adicionar produtos ao carrinho
- Alterar quantidades
- Remover produtos
- Verificar cálculos de valores

## Fase 8: PDV - Finalização de Venda

### Tarefas:
1. **Backend para vendas**
   - Implementar entidades Sale e SaleItem
   - Criar endpoints para registro de vendas
   - Implementar lógica de atualização de estoque

2. **Frontend para finalização**
   - Implementar componente de checkout
   - Criar fluxo de finalização
   - Implementar seleção de métodos de pagamento

### Entregável:
- Funcionalidade completa de vendas

### Como testar:
- Finalizar venda com diferentes métodos de pagamento
- Verificar registro no banco de dados
- Confirmar atualização de estoque

## Fase 9: Relatórios Básicos

### Tarefas:
1. **Backend para relatórios**
   - Implementar queries para relatórios
   - Criar endpoints para dados agregados

2. **Frontend para relatórios**
   - Implementar componentes de visualização
   - Criar dashboards simples

### Entregável:
- Relatórios básicos de vendas e estoque

### Como testar:
- Gerar relatórios por período
- Verificar totalizadores
- Exportar dados

## Fase 10: Refinamento e Polimento

### Tarefas:
1. **Melhorias de UX/UI**
   - Aplicar design consistente
   - Melhorar responsividade
   - Otimizar fluxos de usuário

2. **Otimizações de performance**
   - Refinar consultas ao banco
   - Implementar caching
   - Otimizar carregamento de assets

3. **Testes automatizados**
   - Implementar testes unitários
   - Implementar testes de integração
   - Configurar CI/CD básico

### Entregável:
- Versão refinada da POC
- Documentação completa

### Como testar:
- Executar testes automatizados
- Realizar testes de usabilidade
- Verificar performance em diferentes cenários

## Arquivos Docker de Exemplo

### docker-compose.yml
```yaml
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "4200:80"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    depends_on:
      - backend
    networks:
      - pdv-network

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "5000:80"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__DefaultConnection=Server=db;Database=PDVMercado;User=sa;Password=${SQL_PASSWORD};TrustServerCertificate=True
    depends_on:
      - db
    networks:
      - pdv-network

  db:
    build:
      context: ./database
      dockerfile: Dockerfile
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=${SQL_PASSWORD}
    ports:
      - "1433:1433"
    volumes:
      - sqlserver-data:/var/opt/mssql
    networks:
      - pdv-network

networks:
  pdv-network:
    driver: bridge

volumes:
  sqlserver-data:
```

### Frontend Dockerfile
```dockerfile
# Build stage
FROM node:18 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist/frontend /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

### Backend Dockerfile
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["PDV.API/PDV.API.csproj", "PDV.API/"]
COPY ["PDV.Domain/PDV.Domain.csproj", "PDV.Domain/"]
COPY ["PDV.Infrastructure/PDV.Infrastructure.csproj", "PDV.Infrastructure/"]
RUN dotnet restore "PDV.API/PDV.API.csproj"
COPY . .
WORKDIR "/src/PDV.API"
RUN dotnet build "PDV.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PDV.API.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PDV.API.dll"]
```

### Database Dockerfile
```dockerfile
FROM mcr.microsoft.com/mssql/server:2022-latest

# Copiar scripts de inicialização
COPY ./scripts/ /docker-entrypoint-initdb.d/

# Definir variáveis de ambiente
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express

# Expor porta
EXPOSE 1433
```
