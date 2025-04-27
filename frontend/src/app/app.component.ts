import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'PDV Mercado';
  apiStatus = 'Verificando...';
  apiEnvironment = '';
  apiTimestamp = '';

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.checkApiStatus();
  }

  checkApiStatus() {
    this.http.get<any>('http://localhost:5000/api/test').subscribe({
      next: (data) => {
        this.apiStatus = data.message;
        this.apiTimestamp = new Date(data.timestamp).toLocaleString();
      },
      error: (error) => {
        this.apiStatus = 'Erro ao conectar com a API';
        console.error('Erro ao verificar status da API:', error);
      }
    });

    this.http.get<any>('http://localhost:5000/api/test/environment').subscribe({
      next: (data) => {
        this.apiEnvironment = data.environment;
      },
      error: (error) => {
        this.apiEnvironment = 'Desconhecido';
        console.error('Erro ao verificar ambiente da API:', error);
      }
    });
  }
}
