CREATE DATABASE restaurante_marinke;

USE restaurante_marinke;

CREATE TABLE Mesa (
    idMesa INT PRIMARY KEY AUTO_INCREMENT,
    numeroMesa INT,
    statusMesa ENUM('Disponível', 'Reservada', 'Servindo Sobremesa', 'Aguardando Limpeza')
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nomeCliente VARCHAR(100)
);

CREATE TABLE Produto (
    idProduto INT PRIMARY KEY AUTO_INCREMENT,
    codigoProduto VARCHAR(50),
    precoUnitario DECIMAL(10,2),
    estoqueAtual INT,
    estoqueMinimo INT,
    marcaProduto VARCHAR(100)
);

CREATE TABLE FormaPagamento (
    idPagamento INT PRIMARY KEY AUTO_INCREMENT,
    tipoPagamento VARCHAR(100)
);

CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    idMesa INT,
    horario DATETIME,
    idPagamento INT,
    valorTotalPedido DECIMAL(10,2),
    FOREIGN KEY (idMesa) REFERENCES Mesa(idMesa),
    FOREIGN KEY (idPagamento) REFERENCES FormaPagamento(idPagamento)
);

CREATE TABLE ItemPedido (
    idItemPedido INT PRIMARY KEY AUTO_INCREMENT,
    idPedido INT,
    idProduto INT,
    quantidadeProduto INT,
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
);

CREATE TABLE MesaCliente (
    idMesaCliente INT PRIMARY KEY AUTO_INCREMENT,
    idMesa INT,
    idCliente INT,
    FOREIGN KEY (idMesa) REFERENCES Mesa(idMesa),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

INSERT INTO Mesa (numeroMesa, statusMesa) VALUES
(101, 'Disponível'),
(102, 'Reservada'),
(103, 'Servindo Sobremesa'),
(104, 'Disponível'),
(105, 'Aguardando Limpeza'),
(106, 'Reservada'),
(107, 'Disponível'),
(108, 'Servindo Sobremesa'),
(109, 'Reservada'),
(110, 'Disponível');

INSERT INTO Cliente (nomeCliente) VALUES
('Ana Pereira'),
('Carlos Silva'),
('Mariana Costa'),
('Lucas Ferreira'),
('Paulo Ramos'),
('Isabela Melo'),
('Sofia Andrade'),
('Tiago Mendes'),
('Camila Nunes'),
('Renato Almeida');

INSERT INTO Produto (codigoProduto, precoUnitario, estoqueAtual, estoqueMinimo, marcaProduto) VALUES
('P101', 18.75, 120, 15, 'Marca X'),
('P102', 32.00, 60, 10, 'Marca Y'),
('P103', 12.50, 250, 25, 'Marca Z'),
('P104', 8.90, 180, 20, 'Marca W'),
('P105', 14.20, 100, 12, 'Marca V'),
('P106', 40.00, 40, 5, 'Marca U'),
('P107', 25.00, 150, 20, 'Marca T'),
('P108', 22.50, 70, 8, 'Marca S'),
('P109', 9.30, 110, 15, 'Marca R'),
('P110', 28.00, 50, 6, 'Marca Q');

INSERT INTO FormaPagamento (tipoPagamento) VALUES
('Espécie'),
('Crédito'),
('Débito'),
('Pix'),
('Transferência'),
('Cheque'),
('Ticket Restaurante'),
('Ticket Alimentação'),
('Mercado Pago'),
('Crédito Interno');

INSERT INTO Pedido (idMesa, horario, idPagamento, valorTotalPedido) VALUES
(1, '2024-11-24 12:00:00', 1, 180.50),
(2, '2024-11-24 12:30:00', 2, 250.00),
(3, '2024-11-24 13:00:00', 3, 75.00),
(4, '2024-11-24 13:30:00', 4, 320.00),
(5, '2024-11-24 14:00:00', 5, 95.00),
(6, '2024-11-24 14:30:00', 6, 130.00),
(7, '2024-11-24 15:00:00', 7, 110.00),
(8, '2024-11-24 15:30:00', 8, 70.00),
(9, '2024-11-24 16:00:00', 9, 195.00),
(10, '2024-11-24 16:30:00', 10, 230.00);

INSERT INTO ItemPedido (idPedido, idProduto, quantidadeProduto) VALUES
(1, 1, 4),
(1, 2, 2),
(2, 3, 3),
(2, 4, 5),
(3, 5, 2),
(4, 6, 3),
(5, 7, 4),
(6, 8, 2),
(7, 9, 3),
(8, 10, 2);

INSERT INTO MesaCliente (idMesa, idCliente) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

/* A) --> */
SELECT 
    Cliente.nomeCliente AS NomeCliente,
    Mesa.numeroMesa AS NumeroMesa,
    SUM(Pedido.valorTotalPedido) AS ValorTotalGasto
FROM Pedido
JOIN Mesa ON Pedido.idMesa = Mesa.idMesa
JOIN MesaCliente ON Mesa.idMesa = MesaCliente.idMesa
JOIN Cliente ON MesaCliente.idCliente = Cliente.idCliente
GROUP BY Cliente.nomeCliente, Mesa.numeroMesa;

/* B) --> */
SELECT 
    Mesa.numeroMesa AS NumeroMesa,
    Produto.codigoProduto AS CodigoProduto,
    Produto.marcaProduto AS MarcaProduto,
    Produto.precoUnitario AS PrecoUnitario,
    ItemPedido.quantidadeProduto AS QuantidadeConsumida
FROM ItemPedido
JOIN Pedido ON ItemPedido.idPedido = Pedido.idPedido
JOIN Mesa ON Pedido.idMesa = Mesa.idMesa
JOIN Produto ON ItemPedido.idProduto = Produto.idProduto
WHERE Mesa.numeroMesa = 104;

DELIMITER $$

CREATE PROCEDURE RedefinirMesaDisponivel(IN numeroMesa INT)
BEGIN
    UPDATE Mesa
    SET statusMesa = 'Disponível'
    WHERE idMesa = (SELECT idMesa FROM Mesa WHERE numeroMesa = numeroMesa LIMIT 1);
END $$

DELIMITER ;

