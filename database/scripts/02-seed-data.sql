USE PDVMercado;
GO

-- Inserir categorias iniciais se não existirem
IF NOT EXISTS (SELECT TOP 1 * FROM Categories)
BEGIN
    PRINT 'Inserindo categorias iniciais...';
    
    INSERT INTO Categories (Name, Description, IsActive, CreatedAt)
    VALUES 
        ('Bebidas', 'Refrigerantes, sucos, águas e outras bebidas', 1, GETDATE()),
        ('Mercearia', 'Produtos alimentícios em geral', 1, GETDATE()),
        ('Hortifruti', 'Frutas, legumes e verduras', 1, GETDATE()),
        ('Açougue', 'Carnes e derivados', 1, GETDATE()),
        ('Padaria', 'Pães, bolos e outros produtos de panificação', 1, GETDATE()),
        ('Limpeza', 'Produtos de limpeza doméstica', 1, GETDATE()),
        ('Higiene', 'Produtos de higiene pessoal', 1, GETDATE()),
        ('Laticínios', 'Leite, queijos e derivados', 1, GETDATE());
END

-- Inserir produtos de exemplo se não existirem
IF NOT EXISTS (SELECT TOP 1 * FROM Products)
BEGIN
    PRINT 'Inserindo produtos de exemplo...';
    
    -- Bebidas
    INSERT INTO Products (Name, Description, Barcode, Price, Cost, StockQuantity, IsActive, CategoryId, CreatedAt)
    VALUES 
        ('Refrigerante Cola 2L', 'Refrigerante sabor cola garrafa 2 litros', '7891000315507', 9.99, 5.50, 50, 1, 1, GETDATE()),
        ('Água Mineral 500ml', 'Água mineral sem gás garrafa 500ml', '7891000215500', 2.50, 1.00, 100, 1, 1, GETDATE()),
        ('Suco de Laranja 1L', 'Suco de laranja natural garrafa 1 litro', '7891000415504', 7.99, 4.00, 30, 1, 1, GETDATE());
    
    -- Mercearia
    INSERT INTO Products (Name, Description, Barcode, Price, Cost, StockQuantity, IsActive, CategoryId, CreatedAt)
    VALUES 
        ('Arroz Branco 5kg', 'Arroz branco tipo 1 pacote 5kg', '7891000515501', 24.90, 18.00, 40, 1, 2, GETDATE()),
        ('Feijão Carioca 1kg', 'Feijão carioca tipo 1 pacote 1kg', '7891000615508', 8.99, 6.00, 60, 1, 2, GETDATE()),
        ('Macarrão Espaguete 500g', 'Macarrão espaguete pacote 500g', '7891000715505', 4.50, 2.50, 80, 1, 2, GETDATE());
    
    -- Hortifruti
    INSERT INTO Products (Name, Description, Barcode, Price, Cost, StockQuantity, IsActive, CategoryId, CreatedAt)
    VALUES 
        ('Maçã Vermelha kg', 'Maçã vermelha fresca por kg', '7891000815502', 9.99, 6.00, 30, 1, 3, GETDATE()),
        ('Banana Prata kg', 'Banana prata fresca por kg', '7891000915509', 5.99, 3.50, 25, 1, 3, GETDATE()),
        ('Alface Crespa un', 'Alface crespa fresca unidade', '7891001015505', 3.50, 1.80, 20, 1, 3, GETDATE());
    
    -- Limpeza
    INSERT INTO Products (Name, Description, Barcode, Price, Cost, StockQuantity, IsActive, CategoryId, CreatedAt)
    VALUES 
        ('Detergente Líquido 500ml', 'Detergente líquido neutro 500ml', '7891001115502', 2.99, 1.50, 70, 1, 6, GETDATE()),
        ('Sabão em Pó 1kg', 'Sabão em pó para roupas 1kg', '7891001215509', 12.90, 8.00, 45, 1, 6, GETDATE()),
        ('Desinfetante 2L', 'Desinfetante perfumado 2 litros', '7891001315506', 8.50, 5.00, 35, 1, 6, GETDATE());
END

PRINT 'Dados iniciais inseridos com sucesso.';
GO
