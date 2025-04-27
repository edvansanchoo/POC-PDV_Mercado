Fase 7: PDV - Carrinho de Compras

## Descrição
Implementar o módulo de carrinho de compras para o PDV, permitindo adicionar produtos, alterar quantidades, aplicar descontos e calcular valores totais, como parte fundamental do processo de venda.

## Tarefas Backend
- [ ] Criar modelo de carrinho de compras (Cart e CartItem)
- [ ] Implementar serviço de gerenciamento de carrinho
- [ ] Criar endpoints para manipulação do carrinho
- [ ] Implementar cálculos de valores (subtotal, descontos, total)
- [ ] Desenvolver validações para itens do carrinho
- [ ] Integrar com serviço de produtos para verificação de estoque
- [ ] Implementar persistência temporária de carrinhos

## Tarefas Frontend
- [ ] Criar serviço de carrinho para gerenciamento de estado
- [ ] Implementar componente principal do carrinho de compras
- [ ] Desenvolver componente de busca e adição rápida de produtos
- [ ] Criar componente para exibição de itens do carrinho
- [ ] Implementar controles para alterar quantidade de itens
- [ ] Desenvolver componente para aplicação de descontos
- [ ] Criar componente de resumo de valores
- [ ] Implementar funcionalidade de leitura de código de barras

## Detalhes Técnicos

### Backend

#### Modelos
```csharp
public class Cart
{
    public string Id { get; set; } // GUID como string
    public string SessionId { get; set; }
    public int? CustomerId { get; set; }
    public decimal Subtotal { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal TotalAmount { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    
    // Relacionamentos
    public Customer Customer { get; set; }
    public ICollection<CartItem> Items { get; set; } = new List<CartItem>();
}

public class CartItem
{
    public int Id { get; set; }
    public string CartId { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; }
    public decimal UnitPrice { get; set; }
    public int Quantity { get; set; }
    public decimal DiscountPercentage { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal TotalPrice { get; set; }
    
    // Relacionamentos
    public Cart Cart { get; set; }
    public Product Product { get; set; }
}
```

#### DTOs
```csharp
public class CartDto
{
    public string Id { get; set; }
    public int? CustomerId { get; set; }
    public string CustomerName { get; set; }
    public decimal Subtotal { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal TotalAmount { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public ICollection<CartItemDto> Items { get; set; }
}

public class CartItemDto
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; }
    public decimal UnitPrice { get; set; }
    public int Quantity { get; set; }
    public decimal DiscountPercentage { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal TotalPrice { get; set; }
}

public class AddCartItemDto
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public decimal? DiscountPercentage { get; set; }
}

public class UpdateCartItemDto
{
    public int Quantity { get; set; }
    public decimal? DiscountPercentage { get; set; }
}

public class ApplyDiscountDto
{
    public decimal DiscountPercentage { get; set; }
}

public class SetCustomerDto
{
    public int CustomerId { get; set; }
}
```

#### ICartService
```csharp
public interface ICartService
{
    Task<CartDto> GetCartAsync(string cartId);
    Task<CartDto> CreateCartAsync();
    Task<CartDto> AddItemAsync(string cartId, AddCartItemDto itemDto);
    Task<CartDto> UpdateItemAsync(string cartId, int itemId, UpdateCartItemDto itemDto);
    Task<CartDto> RemoveItemAsync(string cartId, int itemId);
    Task<CartDto> ClearCartAsync(string cartId);
    Task<CartDto> SetCustomerAsync(string cartId, SetCustomerDto customerDto);
    Task<CartDto> ApplyDiscountAsync(string cartId, int? itemId, ApplyDiscountDto discountDto);
    Task<bool> DeleteCartAsync(string cartId);
}
```

#### CartController
```csharp
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CartController : ControllerBase
{
    private readonly ICartService _cartService;
    
    public CartController(ICartService cartService)
    {
        _cartService = cartService;
    }
    
    [HttpGet("{cartId}")]
    public async Task<ActionResult<CartDto>> GetCart(string cartId)
    {
        try
        {
            var cart = await _cartService.GetCartAsync(cartId);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpPost]
    public async Task<ActionResult<CartDto>> CreateCart()
    {
        var cart = await _cartService.CreateCartAsync();
        return CreatedAtAction(nameof(GetCart), new { cartId = cart.Id }, cart);
    }
    
    [HttpPost("{cartId}/items")]
    public async Task<ActionResult<CartDto>> AddItem(string cartId, AddCartItemDto itemDto)
    {
        try
        {
            var cart = await _cartService.AddItemAsync(cartId, itemDto);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }
    
    [HttpPut("{cartId}/items/{itemId}")]
    public async Task<ActionResult<CartDto>> UpdateItem(string cartId, int itemId, UpdateCartItemDto itemDto)
    {
        try
        {
            var cart = await _cartService.UpdateItemAsync(cartId, itemId, itemDto);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }
    
    [HttpDelete("{cartId}/items/{itemId}")]
    public async Task<ActionResult<CartDto>> RemoveItem(string cartId, int itemId)
    {
        try
        {
            var cart = await _cartService.RemoveItemAsync(cartId, itemId);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpDelete("{cartId}/items")]
    public async Task<ActionResult<CartDto>> ClearCart(string cartId)
    {
        try
        {
            var cart = await _cartService.ClearCartAsync(cartId);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpPost("{cartId}/customer")]
    public async Task<ActionResult<CartDto>> SetCustomer(string cartId, SetCustomerDto customerDto)
    {
        try
        {
            var cart = await _cartService.SetCustomerAsync(cartId, customerDto);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpPost("{cartId}/discount")]
    public async Task<ActionResult<CartDto>> ApplyDiscount(string cartId, ApplyDiscountDto discountDto)
    {
        try
        {
            var cart = await _cartService.ApplyDiscountAsync(cartId, null, discountDto);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpPost("{cartId}/items/{itemId}/discount")]
    public async Task<ActionResult<CartDto>> ApplyItemDiscount(string cartId, int itemId, ApplyDiscountDto discountDto)
    {
        try
        {
            var cart = await _cartService.ApplyDiscountAsync(cartId, itemId, discountDto);
            return Ok(cart);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
    
    [HttpDelete("{cartId}")]
    public async Task<ActionResult> DeleteCart(string cartId)
    {
        var result = await _cartService.DeleteCartAsync(cartId);
        if (!result)
            return NotFound();
            
        return NoContent();
    }
}
```

### Frontend

#### Interfaces TypeScript
```typescript
export interface Cart {
  id: string;
  customerId?: number;
  customerName?: string;
  subtotal: number;
  discountAmount: number;
  totalAmount: number;
  createdAt: Date;
  updatedAt: Date;
  items: CartItem[];
}

export interface CartItem {
  id: number;
  productId: number;
  productName: string;
  unitPrice: number;
  quantity: number;
  discountPercentage: number;
  discountAmount: number;
  totalPrice: number;
}

export interface AddCartItem {
  productId: number;
  quantity: number;
  discountPercentage?: number;
}

export interface UpdateCartItem {
  quantity: number;
  discountPercentage?: number;
}

export interface ApplyDiscount {
  discountPercentage: number;
}

export interface SetCustomer {
  customerId: number;
}
```

#### CartService
```typescript
@Injectable({
  providedIn: 'root'
})
export class CartService {
  private apiUrl = 'http://localhost:5000/api/cart';
  private cartSubject = new BehaviorSubject<Cart | null>(null);
  public cart$ = this.cartSubject.asObservable();

  constructor(private http: HttpClient) { }

  getCart(cartId: string): Observable<Cart> {
    return this.http.get<Cart>(`${this.apiUrl}/${cartId}`).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  createCart(): Observable<Cart> {
    return this.http.post<Cart>(this.apiUrl, {}).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  addItem(cartId: string, item: AddCartItem): Observable<Cart> {
    return this.http.post<Cart>(`${this.apiUrl}/${cartId}/items`, item).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  updateItem(cartId: string, itemId: number, item: UpdateCartItem): Observable<Cart> {
    return this.http.put<Cart>(`${this.apiUrl}/${cartId}/items/${itemId}`, item).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  removeItem(cartId: string, itemId: number): Observable<Cart> {
    return this.http.delete<Cart>(`${this.apiUrl}/${cartId}/items/${itemId}`).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  clearCart(cartId: string): Observable<Cart> {
    return this.http.delete<Cart>(`${this.apiUrl}/${cartId}/items`).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  setCustomer(cartId: string, customer: SetCustomer): Observable<Cart> {
    return this.http.post<Cart>(`${this.apiUrl}/${cartId}/customer`, customer).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  applyDiscount(cartId: string, discount: ApplyDiscount): Observable<Cart> {
    return this.http.post<Cart>(`${this.apiUrl}/${cartId}/discount`, discount).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  applyItemDiscount(cartId: string, itemId: number, discount: ApplyDiscount): Observable<Cart> {
    return this.http.post<Cart>(`${this.apiUrl}/${cartId}/items/${itemId}/discount`, discount).pipe(
      tap(cart => this.cartSubject.next(cart))
    );
  }

  deleteCart(cartId: string): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${cartId}`).pipe(
      tap(() => this.cartSubject.next(null))
    );
  }

  getCurrentCart(): Cart | null {
    return this.cartSubject.value;
  }
}
```

#### Componentes Principais
1. **CartComponent**: Componente principal do carrinho
2. **CartItemsComponent**: Lista de itens no carrinho
3. **ProductSearchComponent**: Busca e adição rápida de produtos
4. **CartSummaryComponent**: Resumo de valores e totais
5. **DiscountComponent**: Aplicação de descontos
6. **BarcodeReaderComponent**: Leitura de código de barras

## Critérios de Aceitação
- Deve ser possível adicionar produtos ao carrinho por código, busca ou código de barras
- Alteração de quantidades deve atualizar valores automaticamente
- Aplicação de descontos deve funcionar por item e para o carrinho todo
- Validações devem impedir adição de produtos sem estoque
- Cálculos de valores devem estar corretos (subtotal, descontos, total)
- Interface deve ser intuitiva e responsiva
- Carrinho deve persistir durante a sessão do usuário
- Deve ser possível associar um cliente ao carrinho
