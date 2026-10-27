create database tomatix;

use tomatix;


GRANT INSERT ON tomatix.LEITURA_LUMINOSIDADE TO 'tomatix_insert'@'localhost';


CREATE DATABASE IF NOT EXISTS tomatix;
USE tomatix;

CREATE TABLE EMPRESA(
id INT PRIMARY KEY AUTO_INCREMENT,
razaoSocial VARCHAR(100) NOT NULL,
cnpj CHAR(14) NOT NULL,
dtCadastro DATETIME DEFAULT current_timestamp NOT NULL,
token CHAR(5) NOT NULL,
tipo VARCHAR(45) NOT NULL,
CONSTRAINT ch_tipo_empresa CHECK (tipo IN ('filial','matriz'))
);

CREATE TABLE ENDERECO(
id INT PRIMARY KEY AUTO_INCREMENT,
logradouro VARCHAR(45) NOT NULL,
numero INT NOT NULL,
cep CHAR(8) NOT NULL,
uf CHAR(2) NOT NULL,
cidade VARCHAR(45),
bairro VARCHAR(45),
fk_empresa INT NOT NULL,
FOREIGN KEY (fk_empresa) REFERENCES EMPRESA (id)
);

CREATE TABLE USUARIO(
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
senha VARCHAR(45) NOT NULL,
dtCadastro DATETIME DEFAULT current_timestamp NOT NULL,
fk_empresa INT NOT NULL,
FOREIGN KEY (fk_empresa) REFERENCES EMPRESA (id)
);

CREATE TABLE ESTUFA(
id INT PRIMARY KEY AUTO_INCREMENT,
tipoFase VARCHAR(45) NOT NULL,
CONSTRAINT ch_fase_estufa CHECK (tipoFase IN ('mudas','vegetativa','reprodutiva')),
identificador CHAR(5) NOT NULL,
fk_empresa INT NOT NULL,
FOREIGN KEY (fk_empresa) REFERENCES EMPRESA (id)
);

CREATE TABLE SENSOR(
id INT PRIMARY KEY AUTO_INCREMENT,
dtInstalacao DATETIME DEFAULT current_timestamp NOT NULL,
numeroSerie CHAR(6) NOT NULL,
statusSensor VARCHAR(45) NOT NULL,
CONSTRAINT ch_status_sensor CHECK (statusSensor IN ('ativo','inativo','manutencao')),
fk_estufa INT NOT NULL,
FOREIGN KEY (fk_estufa) REFERENCES ESTUFA (id)
);

CREATE TABLE LEITURA_LUMINOSIDADE(
id INT PRIMARY KEY AUTO_INCREMENT,
dtHora DATETIME DEFAULT current_timestamp NOT NULL,
ppfd DECIMAL(10,2) NOT NULL,
fk_sensor INT NOT NULL,
FOREIGN KEY (fk_sensor) REFERENCES SENSOR (id)
);

CREATE TABLE REGISTRO(
id INT PRIMARY KEY AUTO_INCREMENT,
registro VARCHAR(45) NOT NULL,
CONSTRAINT ch_registro_tipo CHECK (registro IN ('cuidado','critico')),
fk_leitura INT NOT NULL,
FOREIGN KEY (fk_leitura) REFERENCES LEITURA_LUMINOSIDADE (id),
fk_estufa INT NOT NULL,
FOREIGN KEY (fk_estufa) REFERENCES ESTUFA (id)
);

-- 1. Inserir Empresa
INSERT INTO EMPRESA (razaoSocial, cnpj, token, tipo) VALUES
('AgroIndustria produção agricola e hortifruti LTDA', '00123456000199', 'PJX59', 'matriz');

-- 2. Inserir Endereço
INSERT INTO ENDERECO (logradouro, numero, cep, uf, cidade, bairro, fk_empresa) VALUES
('Av. Paulista', 1000, '01310100', 'SP', 'São Paulo', 'Bela Vista', 1);

-- 3. Inserir Usuários
INSERT INTO USUARIO (nome, email, senha, fk_empresa) VALUES
('FERNANDO BRANDÃO', 'brandao.fernando@gmail.com', '12345678', 1),
('JULIA ARARIPE', 'julia.araripe@gmail.com', '12345678', 1),
('MARCOS ANTONIO', 'marcos.antonio@gmail.com', '12345678', 1);

-- 4. Inserir Estufas
INSERT INTO ESTUFA (tipoFase, identificador, fk_empresa) VALUES
('mudas', 'm01es', 1),
('vegetativa', 'v01es', 1),
('reprodutiva', 'r01es', 1);

-- 5. Inserir Sensores
INSERT INTO SENSOR (numeroSerie, statusSensor, fk_estufa) VALUES
('021526', 'ativo', 1),
('158620', 'ativo', 2),
('547100', 'ativo', 3);

-- Inserindo dados na tabela registro
INSERT INTO REGISTRO (registro, fk_leitura, fk_estufa) VALUES 
-- SEGUNDA-FEIRA
('cuidado', 1, 1), 
('cuidado', 2, 1), 
('critico', 3, 1), 
('critico', 4, 1),

-- TERÇA-FEIRA
('cuidado', 5, 1), 
('cuidado', 6, 1), 
('cuidado', 7, 1), 
('cuidado', 8, 1), 
('critico', 9, 1),

-- QUARTA-FEIRA 
('cuidado', 10, 1), 
('critico', 11, 1),

-- QUINTA-FEIRA 
('cuidado', 12, 1), 
('cuidado', 13, 1), 
('critico', 14, 1),

-- SEXTA-FEIRA 
('cuidado', 15, 1), 
('critico', 16, 1), 
('critico', 17, 1),

-- SÁBADO 
('cuidado', 18, 1), 
('cuidado', 19, 1), 
('critico', 20, 1),

-- DOMINGO 
('cuidado', 21, 1), 
('critico', 22, 1); 