Fase 3: Interface de Produtos (Frontend)

## Descrição
Implementar a interface de usuário para gerenciamento de produtos no frontend Angular, incluindo listagem, cadastro, edição e exclusão de produtos.

## Tarefas
- [ ] Configurar projeto Angular com Angular CLI
- [ ] Configurar módulos principais e roteamento
- [ ] Criar interfaces TypeScript para produtos e categorias
- [ ] Implementar ProductService para comunicação com a API
- [ ] Criar componente de listagem de produtos com paginação
- [ ] Implementar componente de formulário para cadastro/edição
- [ ] Criar componente de detalhes do produto
- [ ] Implementar funcionalidade de upload de imagens
- [ ] Adicionar validação de formulários
- [ ] Implementar notificações de sucesso/erro
- [ ] Criar componente de confirmação para exclusão
- [ ] Implementar filtros e ordenação na listagem

## Detalhes Técnicos

### Interfaces TypeScript
```typescript
export interface Product {
  id: number;
  name: string;
  description: string;
  barcode: string;
  price: number;
  stockQuantity: number;
  imageUrl: string;
  isActive: boolean;
  categoryName: string;
  categoryId: number;
}

export interface CreateProduct {
  name: string;
  description: string;
  barcode: string;
  price: number;
  cost: number;
  stockQuantity: number;
  imageUrl: string;
  categoryId: number;
}

export interface UpdateProduct {
  name: string;
  description: string;
  price: number;
  cost: number;
  stockQuantity: number;
  imageUrl: string;
  isActive: boolean;
  categoryId: number;
}

export interface Category {
  id: number;
  name: string;
  description: string;
}

export interface PagedResult<T> {
  items: T[];
  totalItems: number;
  pageNumber: number;
  pageSize: number;
  totalPages: number;
}
```

### ProductService
```typescript
@Injectable({
  providedIn: 'root'
})
export class ProductService {
  private apiUrl = 'http://localhost:5000/api/products';

  constructor(private http: HttpClient) { }

  getProducts(page: number = 1, pageSize: number = 10): Observable<PagedResult<Product>> {
    return this.http.get<PagedResult<Product>>(`${this.apiUrl}?page=${page}&pageSize=${pageSize}`);
  }

  getProduct(id: number): Observable<Product> {
    return this.http.get<Product>(`${this.apiUrl}/${id}`);
  }

  getProductByBarcode(barcode: string): Observable<Product> {
    return this.http.get<Product>(`${this.apiUrl}/barcode/${barcode}`);
  }

  getProductsByCategory(categoryId: number): Observable<Product[]> {
    return this.http.get<Product[]>(`${this.apiUrl}/category/${categoryId}`);
  }

  searchProducts(term: string): Observable<Product[]> {
    return this.http.get<Product[]>(`${this.apiUrl}/search?term=${term}`);
  }

  createProduct(product: CreateProduct): Observable<Product> {
    return this.http.post<Product>(this.apiUrl, product);
  }

  updateProduct(id: number, product: UpdateProduct): Observable<Product> {
    return this.http.put<Product>(`${this.apiUrl}/${id}`, product);
  }

  deleteProduct(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  uploadImage(file: File): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post<{imageUrl: string}>(`${this.apiUrl}/upload`, formData)
      .pipe(map(response => response.imageUrl));
  }
}
```

### Componentes Principais
1. **ProductListComponent**: Listagem paginada de produtos com filtros
2. **ProductFormComponent**: Formulário para criação/edição de produtos
3. **ProductDetailComponent**: Visualização detalhada de um produto
4. **ProductImageUploadComponent**: Upload de imagens de produtos
5. **DeleteConfirmationComponent**: Modal de confirmação para exclusão

### Rotas
```typescript
const routes: Routes = [
  { path: 'products', component: ProductListComponent },
  { path: 'products/new', component: ProductFormComponent },
  { path: 'products/edit/:id', component: ProductFormComponent },
  { path: 'products/:id', component: ProductDetailComponent }
];
```

## Critérios de Aceitação
- Interface deve ser responsiva e funcionar em dispositivos móveis e desktop
- Formulários devem validar entradas do usuário
- Listagem deve incluir paginação, filtros e ordenação
- Upload de imagens deve funcionar corretamente
- Notificações devem informar o usuário sobre sucesso/erro das operações
- Navegação entre telas deve ser intuitiva
- Todas as operações CRUD devem funcionar corretamente com a API
