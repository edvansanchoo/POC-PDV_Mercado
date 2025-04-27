Fase 2: API de Produtos (Backend)

## Descrição
Implementar a API RESTful para gerenciamento de produtos no backend .NET 8, incluindo repositórios, serviços, controllers e documentação Swagger.

## Tarefas
- [ ] Criar interface IProductRepository com métodos CRUD
- [ ] Implementar ProductRepository usando Entity Framework Core
- [ ] Criar interface IProductService para lógica de negócio
- [ ] Implementar ProductService com validações e regras de negócio
- [ ] Criar DTOs para transferência de dados de produtos
- [ ] Configurar AutoMapper para mapeamento entre entidades e DTOs
- [ ] Implementar ProductController com endpoints RESTful
- [ ] Adicionar validação de entrada com FluentValidation
- [ ] Configurar tratamento global de exceções
- [ ] Implementar paginação para listagem de produtos
- [ ] Configurar e documentar API com Swagger

## Detalhes Técnicos

### IProductRepository
```csharp
public interface IProductRepository
{
    Task<IEnumerable<Product>> GetAllAsync(int page = 1, int pageSize = 10);
    Task<Product> GetByIdAsync(int id);
    Task<Product> GetByBarcodeAsync(string barcode);
    Task<IEnumerable<Product>> GetByCategoryIdAsync(int categoryId);
    Task<IEnumerable<Product>> SearchAsync(string term);
    Task<Product> AddAsync(Product product);
    Task<Product> UpdateAsync(Product product);
    Task<bool> DeleteAsync(int id);
    Task<int> CountAsync();
}
```

### IProductService
```csharp
public interface IProductService
{
    Task<PagedResult<ProductDto>> GetAllAsync(int page = 1, int pageSize = 10);
    Task<ProductDto> GetByIdAsync(int id);
    Task<ProductDto> GetByBarcodeAsync(string barcode);
    Task<IEnumerable<ProductDto>> GetByCategoryIdAsync(int categoryId);
    Task<IEnumerable<ProductDto>> SearchAsync(string term);
    Task<ProductDto> AddAsync(CreateProductDto productDto);
    Task<ProductDto> UpdateAsync(int id, UpdateProductDto productDto);
    Task<bool> DeleteAsync(int id);
}
```

### DTOs
```csharp
public class ProductDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string Barcode { get; set; }
    public decimal Price { get; set; }
    public int StockQuantity { get; set; }
    public string ImageUrl { get; set; }
    public bool IsActive { get; set; }
    public string CategoryName { get; set; }
    public int CategoryId { get; set; }
}

public class CreateProductDto
{
    public string Name { get; set; }
    public string Description { get; set; }
    public string Barcode { get; set; }
    public decimal Price { get; set; }
    public decimal Cost { get; set; }
    public int StockQuantity { get; set; }
    public string ImageUrl { get; set; }
    public int CategoryId { get; set; }
}

public class UpdateProductDto
{
    public string Name { get; set; }
    public string Description { get; set; }
    public decimal Price { get; set; }
    public decimal Cost { get; set; }
    public int StockQuantity { get; set; }
    public string ImageUrl { get; set; }
    public bool IsActive { get; set; }
    public int CategoryId { get; set; }
}
```

### ProductController
```csharp
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly IProductService _productService;
    
    public ProductsController(IProductService productService)
    {
        _productService = productService;
    }
    
    [HttpGet]
    public async Task<ActionResult<PagedResult<ProductDto>>> GetAll([FromQuery] int page = 1, [FromQuery] int pageSize = 10)
    {
        return await _productService.GetAllAsync(page, pageSize);
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<ProductDto>> GetById(int id)
    {
        var product = await _productService.GetByIdAsync(id);
        if (product == null)
            return NotFound();
            
        return product;
    }
    
    [HttpGet("barcode/{barcode}")]
    public async Task<ActionResult<ProductDto>> GetByBarcode(string barcode)
    {
        var product = await _productService.GetByBarcodeAsync(barcode);
        if (product == null)
            return NotFound();
            
        return product;
    }
    
    [HttpGet("category/{categoryId}")]
    public async Task<ActionResult<IEnumerable<ProductDto>>> GetByCategory(int categoryId)
    {
        return Ok(await _productService.GetByCategoryIdAsync(categoryId));
    }
    
    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<ProductDto>>> Search([FromQuery] string term)
    {
        return Ok(await _productService.SearchAsync(term));
    }
    
    [HttpPost]
    public async Task<ActionResult<ProductDto>> Create(CreateProductDto productDto)
    {
        var product = await _productService.AddAsync(productDto);
        return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
    }
    
    [HttpPut("{id}")]
    public async Task<ActionResult<ProductDto>> Update(int id, UpdateProductDto productDto)
    {
        try
        {
            var product = await _productService.UpdateAsync(id, productDto);
            return Ok(product);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var result = await _productService.DeleteAsync(id);
        if (!result)
            return NotFound();
            
        return NoContent();
    }
}
```

## Critérios de Aceitação
- Todos os endpoints da API devem funcionar conforme especificado
- Validações devem ser aplicadas corretamente nos DTOs
- Erros devem ser tratados e retornar respostas HTTP apropriadas
- Documentação Swagger deve estar completa e acessível
- Paginação deve funcionar corretamente para grandes conjuntos de dados
- Testes manuais via Swagger UI devem ser bem-sucedidos
