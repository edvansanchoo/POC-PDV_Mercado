Fase 4: Categorias de Produtos (Full Stack)

## Descrição
Implementar o gerenciamento completo de categorias de produtos, incluindo backend (API) e frontend (interface de usuário), com integração total com o módulo de produtos.

## Tarefas Backend
- [ ] Criar interface ICategoryRepository com métodos CRUD
- [ ] Implementar CategoryRepository usando Entity Framework Core
- [ ] Criar interface ICategoryService para lógica de negócio
- [ ] Implementar CategoryService com validações
- [ ] Criar DTOs para transferência de dados de categorias
- [ ] Configurar AutoMapper para mapeamento de categorias
- [ ] Implementar CategoriesController com endpoints RESTful
- [ ] Adicionar validação de entrada com FluentValidation
- [ ] Atualizar documentação Swagger

## Tarefas Frontend
- [ ] Criar CategoryService para comunicação com a API
- [ ] Implementar componente de listagem de categorias
- [ ] Criar formulário para cadastro/edição de categorias
- [ ] Implementar componente de seleção de categoria para produtos
- [ ] Adicionar filtro por categoria na listagem de produtos
- [ ] Implementar validação de formulários
- [ ] Criar componente de confirmação para exclusão

## Detalhes Técnicos

### Backend

#### ICategoryRepository
```csharp
public interface ICategoryRepository
{
    Task<IEnumerable<Category>> GetAllAsync();
    Task<Category> GetByIdAsync(int id);
    Task<Category> AddAsync(Category category);
    Task<Category> UpdateAsync(Category category);
    Task<bool> DeleteAsync(int id);
    Task<bool> ExistsAsync(int id);
    Task<int> CountProductsAsync(int categoryId);
}
```

#### ICategoryService
```csharp
public interface ICategoryService
{
    Task<IEnumerable<CategoryDto>> GetAllAsync();
    Task<CategoryDto> GetByIdAsync(int id);
    Task<CategoryDto> AddAsync(CreateCategoryDto categoryDto);
    Task<CategoryDto> UpdateAsync(int id, UpdateCategoryDto categoryDto);
    Task<bool> DeleteAsync(int id);
}
```

#### DTOs
```csharp
public class CategoryDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public bool IsActive { get; set; }
    public int ProductCount { get; set; }
}

public class CreateCategoryDto
{
    public string Name { get; set; }
    public string Description { get; set; }
}

public class UpdateCategoryDto
{
    public string Name { get; set; }
    public string Description { get; set; }
    public bool IsActive { get; set; }
}
```

#### CategoriesController
```csharp
[ApiController]
[Route("api/[controller]")]
public class CategoriesController : ControllerBase
{
    private readonly ICategoryService _categoryService;
    
    public CategoriesController(ICategoryService categoryService)
    {
        _categoryService = categoryService;
    }
    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<CategoryDto>>> GetAll()
    {
        return Ok(await _categoryService.GetAllAsync());
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<CategoryDto>> GetById(int id)
    {
        var category = await _categoryService.GetByIdAsync(id);
        if (category == null)
            return NotFound();
            
        return category;
    }
    
    [HttpPost]
    public async Task<ActionResult<CategoryDto>> Create(CreateCategoryDto categoryDto)
    {
        var category = await _categoryService.AddAsync(categoryDto);
        return CreatedAtAction(nameof(GetById), new { id = category.Id }, category);
    }
    
    [HttpPut("{id}")]
    public async Task<ActionResult<CategoryDto>> Update(int id, UpdateCategoryDto categoryDto)
    {
        try
        {
            var category = await _categoryService.UpdateAsync(id, categoryDto);
            return Ok(category);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var result = await _categoryService.DeleteAsync(id);
        if (!result)
            return NotFound();
            
        return NoContent();
    }
}
```

### Frontend

#### Interfaces TypeScript
```typescript
export interface Category {
  id: number;
  name: string;
  description: string;
  isActive: boolean;
  productCount: number;
}

export interface CreateCategory {
  name: string;
  description: string;
}

export interface UpdateCategory {
  name: string;
  description: string;
  isActive: boolean;
}
```

#### CategoryService
```typescript
@Injectable({
  providedIn: 'root'
})
export class CategoryService {
  private apiUrl = 'http://localhost:5000/api/categories';

  constructor(private http: HttpClient) { }

  getCategories(): Observable<Category[]> {
    return this.http.get<Category[]>(this.apiUrl);
  }

  getCategory(id: number): Observable<Category> {
    return this.http.get<Category>(`${this.apiUrl}/${id}`);
  }

  createCategory(category: CreateCategory): Observable<Category> {
    return this.http.post<Category>(this.apiUrl, category);
  }

  updateCategory(id: number, category: UpdateCategory): Observable<Category> {
    return this.http.put<Category>(`${this.apiUrl}/${id}`, category);
  }

  deleteCategory(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
```

#### Componentes Principais
1. **CategoryListComponent**: Listagem de categorias
2. **CategoryFormComponent**: Formulário para criação/edição
3. **CategorySelectorComponent**: Dropdown para seleção de categoria
4. **DeleteConfirmationComponent**: Modal de confirmação para exclusão

## Critérios de Aceitação
- API de categorias deve funcionar corretamente com validações
- Interface de usuário deve permitir gerenciamento completo de categorias
- Produtos devem ser associados a categorias
- Deve ser possível filtrar produtos por categoria
- Não deve ser possível excluir categorias com produtos associados
- Validações devem ser aplicadas em formulários
- Documentação Swagger deve estar atualizada
