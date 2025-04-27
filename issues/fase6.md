Fase 6: Clientes

## Descrição
Implementar o módulo completo de gerenciamento de clientes, incluindo backend (API) e frontend (interface de usuário), permitindo o cadastro, consulta, atualização e exclusão de clientes no sistema PDV.

## Tarefas Backend
- [ ] Criar entidade Customer com propriedades completas
- [ ] Implementar interface ICustomerRepository com métodos CRUD
- [ ] Criar CustomerRepository usando Entity Framework Core
- [ ] Implementar interface ICustomerService para lógica de negócio
- [ ] Criar CustomerService com validações e regras de negócio
- [ ] Desenvolver DTOs para transferência de dados de clientes
- [ ] Configurar AutoMapper para mapeamento de clientes
- [ ] Implementar CustomersController com endpoints RESTful
- [ ] Adicionar validação de entrada com FluentValidation
- [ ] Atualizar documentação Swagger

## Tarefas Frontend
- [ ] Criar CustomerService para comunicação com a API
- [ ] Implementar componente de listagem de clientes com paginação
- [ ] Criar formulário para cadastro/edição de clientes
- [ ] Implementar componente de detalhes do cliente
- [ ] Adicionar funcionalidade de busca de clientes por nome, CPF, etc.
- [ ] Implementar validação de formulários
- [ ] Criar componente de confirmação para exclusão
- [ ] Integrar com o módulo de vendas (para seleção de cliente)

## Detalhes Técnicos

### Backend

#### Customer Entity
```csharp
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Document { get; set; } // CPF/CNPJ
    public string Email { get; set; }
    public string Phone { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    
    // Relacionamentos
    public ICollection<Sale> Sales { get; set; }
}
```

#### ICustomerRepository
```csharp
public interface ICustomerRepository
{
    Task<PagedResult<Customer>> GetAllAsync(int page = 1, int pageSize = 10);
    Task<Customer> GetByIdAsync(int id);
    Task<Customer> GetByDocumentAsync(string document);
    Task<IEnumerable<Customer>> SearchAsync(string term);
    Task<Customer> AddAsync(Customer customer);
    Task<Customer> UpdateAsync(Customer customer);
    Task<bool> DeleteAsync(int id);
    Task<bool> ExistsAsync(int id);
    Task<bool> DocumentExistsAsync(string document, int? excludeId = null);
    Task<int> CountAsync();
}
```

#### ICustomerService
```csharp
public interface ICustomerService
{
    Task<PagedResult<CustomerDto>> GetAllAsync(int page = 1, int pageSize = 10);
    Task<CustomerDto> GetByIdAsync(int id);
    Task<CustomerDto> GetByDocumentAsync(string document);
    Task<IEnumerable<CustomerDto>> SearchAsync(string term);
    Task<CustomerDto> AddAsync(CreateCustomerDto customerDto);
    Task<CustomerDto> UpdateAsync(int id, UpdateCustomerDto customerDto);
    Task<bool> DeleteAsync(int id);
}
```

#### DTOs
```csharp
public class CustomerDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Document { get; set; }
    public string Email { get; set; }
    public string Phone { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public int SalesCount { get; set; }
}

public class CreateCustomerDto
{
    public string Name { get; set; }
    public string Document { get; set; }
    public string Email { get; set; }
    public string Phone { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
}

public class UpdateCustomerDto
{
    public string Name { get; set; }
    public string Email { get; set; }
    public string Phone { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
    public bool IsActive { get; set; }
}
```

#### CustomersController
```csharp
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CustomersController : ControllerBase
{
    private readonly ICustomerService _customerService;
    
    public CustomersController(ICustomerService customerService)
    {
        _customerService = customerService;
    }
    
    [HttpGet]
    public async Task<ActionResult<PagedResult<CustomerDto>>> GetAll([FromQuery] int page = 1, [FromQuery] int pageSize = 10)
    {
        return await _customerService.GetAllAsync(page, pageSize);
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<CustomerDto>> GetById(int id)
    {
        var customer = await _customerService.GetByIdAsync(id);
        if (customer == null)
            return NotFound();
            
        return customer;
    }
    
    [HttpGet("document/{document}")]
    public async Task<ActionResult<CustomerDto>> GetByDocument(string document)
    {
        var customer = await _customerService.GetByDocumentAsync(document);
        if (customer == null)
            return NotFound();
            
        return customer;
    }
    
    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<CustomerDto>>> Search([FromQuery] string term)
    {
        return Ok(await _customerService.SearchAsync(term));
    }
    
    [HttpPost]
    public async Task<ActionResult<CustomerDto>> Create(CreateCustomerDto customerDto)
    {
        var customer = await _customerService.AddAsync(customerDto);
        return CreatedAtAction(nameof(GetById), new { id = customer.Id }, customer);
    }
    
    [HttpPut("{id}")]
    public async Task<ActionResult<CustomerDto>> Update(int id, UpdateCustomerDto customerDto)
    {
        try
        {
            var customer = await _customerService.UpdateAsync(id, customerDto);
            return Ok(customer);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var result = await _customerService.DeleteAsync(id);
        if (!result)
            return NotFound();
            
        return NoContent();
    }
}
```

### Frontend

#### Interfaces TypeScript
```typescript
export interface Customer {
  id: number;
  name: string;
  document: string;
  email: string;
  phone: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
  isActive: boolean;
  createdAt: Date;
  salesCount: number;
}

export interface CreateCustomer {
  name: string;
  document: string;
  email: string;
  phone: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
}

export interface UpdateCustomer {
  name: string;
  email: string;
  phone: string;
  address: string;
  city: string;
  state: string;
  zipCode: string;
  isActive: boolean;
}
```

#### CustomerService
```typescript
@Injectable({
  providedIn: 'root'
})
export class CustomerService {
  private apiUrl = 'http://localhost:5000/api/customers';

  constructor(private http: HttpClient) { }

  getCustomers(page: number = 1, pageSize: number = 10): Observable<PagedResult<Customer>> {
    return this.http.get<PagedResult<Customer>>(`${this.apiUrl}?page=${page}&pageSize=${pageSize}`);
  }

  getCustomer(id: number): Observable<Customer> {
    return this.http.get<Customer>(`${this.apiUrl}/${id}`);
  }

  getCustomerByDocument(document: string): Observable<Customer> {
    return this.http.get<Customer>(`${this.apiUrl}/document/${document}`);
  }

  searchCustomers(term: string): Observable<Customer[]> {
    return this.http.get<Customer[]>(`${this.apiUrl}/search?term=${term}`);
  }

  createCustomer(customer: CreateCustomer): Observable<Customer> {
    return this.http.post<Customer>(this.apiUrl, customer);
  }

  updateCustomer(id: number, customer: UpdateCustomer): Observable<Customer> {
    return this.http.put<Customer>(`${this.apiUrl}/${id}`, customer);
  }

  deleteCustomer(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
```

#### Componentes Principais
1. **CustomerListComponent**: Listagem paginada de clientes com filtros
2. **CustomerFormComponent**: Formulário para criação/edição de clientes
3. **CustomerDetailComponent**: Visualização detalhada de um cliente
4. **CustomerSearchComponent**: Componente de busca de clientes
5. **CustomerSelectorComponent**: Componente para seleção de cliente em vendas

## Critérios de Aceitação
- API de clientes deve funcionar corretamente com validações
- Interface de usuário deve permitir gerenciamento completo de clientes
- Validação de CPF/CNPJ deve ser implementada
- Busca de clientes deve funcionar por nome, documento e outros campos
- Não deve ser possível cadastrar dois clientes com o mesmo documento
- Clientes com vendas associadas não devem ser excluídos (apenas inativados)
- Documentação Swagger deve estar atualizada
- Integração com o módulo de vendas deve funcionar corretamente
