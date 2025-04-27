Fase 1: Banco de Dados e Entidades Básicas

## Descrição
Implementar o esquema de banco de dados SQL Server e as entidades de domínio básicas para o sistema PDV Mercado.

## Tarefas
- [ ] Criar scripts de inicialização do SQL Server
- [ ] Definir esquema básico do banco de dados
- [ ] Implementar entidade Product com propriedades completas
- [ ] Implementar entidade Category com propriedades completas
- [ ] Definir relacionamentos entre entidades
- [ ] Configurar Entity Framework Core
- [ ] Criar DbContext com configurações apropriadas
- [ ] Configurar mapeamentos de entidades
- [ ] Implementar migrações iniciais do EF Core
- [ ] Criar script de seed para dados iniciais

## Detalhes Técnicos

### Entidade Product
```csharp
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string Barcode { get; set; }
    public decimal Price { get; set; }
    public decimal Cost { get; set; }
    public int StockQuantity { get; set; }
    public string ImageUrl { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    
    // Relacionamentos
    public int CategoryId { get; set; }
    public Category Category { get; set; }
}
```

### Entidade Category
```csharp
public class Category
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    
    // Relacionamentos
    public ICollection<Product> Products { get; set; }
}
```

### DbContext
```csharp
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }
    
    public DbSet<Product> Products { get; set; }
    public DbSet<Category> Categories { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configurações de mapeamento
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
    }
}
```

### Scripts SQL
Criar scripts para:
- Criação de tabelas
- Índices
- Constraints
- Dados iniciais (categorias padrão, produtos de exemplo)

## Critérios de Aceitação
- Banco de dados deve ser criado automaticamente ao iniciar o container
- Migrações devem ser aplicadas automaticamente na inicialização da API
- Entidades devem ser mapeadas corretamente para tabelas no banco
- Relacionamentos devem ser configurados com chaves estrangeiras apropriadas
- Dados de seed devem ser inseridos corretamente
