-- Criar banco de dados se não existir
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'PDVMercado')
BEGIN
    CREATE DATABASE PDVMercado;
END
GO

USE PDVMercado;
GO

-- Verificar se as tabelas já existem antes de criar
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categories]') AND type in (N'U'))
BEGIN
    PRINT 'Criando tabela Categories...';
    CREATE TABLE [dbo].[Categories] (
        [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Name] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(500) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
BEGIN
    PRINT 'Criando tabela Products...';
    CREATE TABLE [dbo].[Products] (
        [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Name] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(500) NULL,
        [Barcode] NVARCHAR(50) NULL,
        [Price] DECIMAL(18,2) NOT NULL,
        [Cost] DECIMAL(18,2) NOT NULL,
        [StockQuantity] INT NOT NULL DEFAULT 0,
        [ImageUrl] NVARCHAR(500) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [UpdatedAt] DATETIME2 NULL,
        [CategoryId] INT NOT NULL,
        CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id])
    );
END

-- Criar índices
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_Products_Barcode' AND object_id = OBJECT_ID('Products'))
BEGIN
    PRINT 'Criando índice IX_Products_Barcode...';
    CREATE INDEX [IX_Products_Barcode] ON [dbo].[Products]([Barcode]);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_Products_CategoryId' AND object_id = OBJECT_ID('Products'))
BEGIN
    PRINT 'Criando índice IX_Products_CategoryId...';
    CREATE INDEX [IX_Products_CategoryId] ON [dbo].[Products]([CategoryId]);
END

PRINT 'Configuração inicial do banco de dados concluída.';
GO
