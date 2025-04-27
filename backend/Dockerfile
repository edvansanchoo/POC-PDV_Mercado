# Estágio de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copiar arquivos de projeto e restaurar dependências
COPY ["PDV.API/PDV.API.csproj", "PDV.API/"]
COPY ["PDV.Domain/PDV.Domain.csproj", "PDV.Domain/"]
COPY ["PDV.Infrastructure/PDV.Infrastructure.csproj", "PDV.Infrastructure/"]
COPY ["PDV.Tests/PDV.Tests.csproj", "PDV.Tests/"]

RUN dotnet restore "PDV.API/PDV.API.csproj"

# Copiar todo o código fonte
COPY . .

# Build do projeto
WORKDIR "/src/PDV.API"
RUN dotnet build "PDV.API.csproj" -c Release -o /app/build

# Estágio de publicação
FROM build AS publish
RUN dotnet publish "PDV.API.csproj" -c Release -o /app/publish

# Estágio final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app
COPY --from=publish /app/publish .

# Ambiente (desenvolvimento ou produção)
ARG ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_ENVIRONMENT=${ASPNETCORE_ENVIRONMENT}

# Expor porta
EXPOSE 80

# Iniciar aplicação
ENTRYPOINT ["dotnet", "PDV.API.dll"]
