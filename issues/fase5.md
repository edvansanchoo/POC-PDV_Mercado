Fase 5: Autenticação e Autorização

## Descrição
Implementar um sistema completo de autenticação e autorização para o PDV Mercado, incluindo registro de usuários, login, controle de acesso baseado em perfis e proteção de rotas tanto no backend quanto no frontend.

## Tarefas Backend
- [ ] Criar entidade User com propriedades necessárias
- [ ] Configurar Identity para gerenciamento de usuários
- [ ] Implementar serviço de autenticação com JWT
- [ ] Criar endpoints para registro, login e refresh token
- [ ] Implementar controle de acesso baseado em perfis (Admin, Operador, Gerente)
- [ ] Configurar políticas de autorização
- [ ] Proteger endpoints da API com atributos de autorização
- [ ] Implementar validação de tokens
- [ ] Configurar CORS para segurança

## Tarefas Frontend
- [ ] Criar serviço de autenticação
- [ ] Implementar componentes de login e registro
- [ ] Criar interceptor HTTP para tokens JWT
- [ ] Implementar guards para proteção de rotas
- [ ] Criar componente de perfil de usuário
- [ ] Implementar gerenciamento de sessão
- [ ] Adicionar controle de exibição baseado em perfil
- [ ] Implementar logout e expiração de sessão

## Detalhes Técnicos

### Backend

#### User Entity
```csharp
public class ApplicationUser : IdentityUser
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? LastLogin { get; set; }
}
```

#### DTOs
```csharp
public class RegisterDto
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public string ConfirmPassword { get; set; }
}

public class LoginDto
{
    public string UserName { get; set; }
    public string Password { get; set; }
}

public class AuthResponseDto
{
    public string Token { get; set; }
    public string RefreshToken { get; set; }
    public DateTime Expiration { get; set; }
    public string UserName { get; set; }
    public string Email { get; set; }
    public IList<string> Roles { get; set; }
}

public class RefreshTokenDto
{
    public string Token { get; set; }
    public string RefreshToken { get; set; }
}

public class UserDto
{
    public string Id { get; set; }
    public string UserName { get; set; }
    public string Email { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public bool IsActive { get; set; }
    public IList<string> Roles { get; set; }
}
```

#### AuthController
```csharp
[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    
    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }
    
    [HttpPost("register")]
    public async Task<ActionResult<AuthResponseDto>> Register(RegisterDto registerDto)
    {
        var result = await _authService.RegisterAsync(registerDto);
        
        if (!result.Succeeded)
            return BadRequest(result.Errors);
            
        return Ok(result.Data);
    }
    
    [HttpPost("login")]
    public async Task<ActionResult<AuthResponseDto>> Login(LoginDto loginDto)
    {
        var result = await _authService.LoginAsync(loginDto);
        
        if (!result.Succeeded)
            return Unauthorized(result.Errors);
            
        return Ok(result.Data);
    }
    
    [HttpPost("refresh-token")]
    public async Task<ActionResult<AuthResponseDto>> RefreshToken(RefreshTokenDto refreshTokenDto)
    {
        var result = await _authService.RefreshTokenAsync(refreshTokenDto);
        
        if (!result.Succeeded)
            return Unauthorized(result.Errors);
            
        return Ok(result.Data);
    }
    
    [Authorize]
    [HttpGet("profile")]
    public async Task<ActionResult<UserDto>> GetProfile()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await _authService.GetUserProfileAsync(userId);
        
        if (!result.Succeeded)
            return NotFound(result.Errors);
            
        return Ok(result.Data);
    }
    
    [Authorize]
    [HttpPost("logout")]
    public async Task<ActionResult> Logout()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        await _authService.LogoutAsync(userId);
        return NoContent();
    }
}
```

#### JWT Configuration
```csharp
public class JwtSettings
{
    public string Key { get; set; }
    public string Issuer { get; set; }
    public string Audience { get; set; }
    public int DurationInMinutes { get; set; }
}
```

### Frontend

#### Auth Models
```typescript
export interface LoginRequest {
  userName: string;
  password: string;
}

export interface RegisterRequest {
  firstName: string;
  lastName: string;
  email: string;
  userName: string;
  password: string;
  confirmPassword: string;
}

export interface AuthResponse {
  token: string;
  refreshToken: string;
  expiration: Date;
  userName: string;
  email: string;
  roles: string[];
}

export interface User {
  id: string;
  userName: string;
  email: string;
  firstName: string;
  lastName: string;
  isActive: boolean;
  roles: string[];
}
```

#### AuthService
```typescript
@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://localhost:5000/api/auth';
  private currentUserSubject = new BehaviorSubject<User | null>(null);
  public currentUser$ = this.currentUserSubject.asObservable();
  private tokenExpirationTimer: any;

  constructor(private http: HttpClient) {
    this.loadStoredUser();
  }

  login(loginRequest: LoginRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.apiUrl}/login`, loginRequest)
      .pipe(
        tap(response => this.handleAuthentication(response))
      );
  }

  register(registerRequest: RegisterRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.apiUrl}/register`, registerRequest)
      .pipe(
        tap(response => this.handleAuthentication(response))
      );
  }

  refreshToken(): Observable<AuthResponse> {
    const storedData = localStorage.getItem('authData');
    if (!storedData) {
      return throwError(() => new Error('No stored authentication data'));
    }

    const authData = JSON.parse(storedData);
    return this.http.post<AuthResponse>(`${this.apiUrl}/refresh-token`, {
      token: authData.token,
      refreshToken: authData.refreshToken
    }).pipe(
      tap(response => this.handleAuthentication(response))
    );
  }

  logout(): void {
    if (this.currentUserSubject.value) {
      this.http.post(`${this.apiUrl}/logout`, {}).subscribe();
    }
    
    localStorage.removeItem('authData');
    this.currentUserSubject.next(null);
    
    if (this.tokenExpirationTimer) {
      clearTimeout(this.tokenExpirationTimer);
    }
    this.tokenExpirationTimer = null;
  }

  getProfile(): Observable<User> {
    return this.http.get<User>(`${this.apiUrl}/profile`);
  }

  isAuthenticated(): boolean {
    return !!this.currentUserSubject.value;
  }

  hasRole(role: string): boolean {
    const user = this.currentUserSubject.value;
    return user ? user.roles.includes(role) : false;
  }

  private handleAuthentication(response: AuthResponse): void {
    const expirationDate = new Date(response.expiration);
    
    localStorage.setItem('authData', JSON.stringify({
      token: response.token,
      refreshToken: response.refreshToken,
      expiration: expirationDate.toISOString()
    }));
    
    this.getProfile().subscribe(user => {
      this.currentUserSubject.next(user);
      this.autoLogout(expirationDate);
    });
  }

  private loadStoredUser(): void {
    const storedData = localStorage.getItem('authData');
    if (!storedData) {
      return;
    }

    const authData = JSON.parse(storedData);
    const expirationDate = new Date(authData.expiration);
    
    if (expirationDate <= new Date()) {
      this.logout();
      return;
    }

    this.getProfile().subscribe({
      next: user => {
        this.currentUserSubject.next(user);
        this.autoLogout(expirationDate);
      },
      error: () => this.logout()
    });
  }

  private autoLogout(expirationDate: Date): void {
    if (this.tokenExpirationTimer) {
      clearTimeout(this.tokenExpirationTimer);
    }
    
    const expiresIn = expirationDate.getTime() - new Date().getTime();
    this.tokenExpirationTimer = setTimeout(() => {
      this.logout();
    }, expiresIn);
  }
}
```

#### AuthGuard
```typescript
@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean | UrlTree | Observable<boolean | UrlTree> | Promise<boolean | UrlTree> {
    if (!this.authService.isAuthenticated()) {
      return this.router.createUrlTree(['/login'], { queryParams: { returnUrl: state.url } });
    }

    const requiredRoles = route.data['roles'] as Array<string>;
    if (requiredRoles && requiredRoles.length > 0) {
      const hasRequiredRole = requiredRoles.some(role => this.authService.hasRole(role));
      if (!hasRequiredRole) {
        return this.router.createUrlTree(['/unauthorized']);
      }
    }

    return true;
  }
}
```

## Critérios de Aceitação
- Usuários devem poder se registrar e fazer login
- Tokens JWT devem ser gerados e validados corretamente
- Refresh tokens devem funcionar para renovar sessões
- Rotas protegidas devem ser acessíveis apenas para usuários autenticados
- Controle de acesso baseado em perfis deve funcionar corretamente
- Sessões devem expirar após o tempo configurado
- Logout deve invalidar tokens
- Frontend deve mostrar/esconder elementos com base nos perfis do usuário
