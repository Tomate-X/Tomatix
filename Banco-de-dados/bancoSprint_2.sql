CREATE DATABASE tomatix02;

USE tomatix02;

CREATE TABLE empresa (
	id INT PRIMARY KEY AUTO_INCREMENT,
	razaoSocial VARCHAR(100) NOT NULL,
	CNPJ  CHAR(14) NOT NULL UNIQUE,
	dtCadastro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE estufa (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(100) NOT NULL,
	dtCadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	dtPlantio DATETIME NULL,
	statusEstufa VARCHAR(7) NOT NULL DEFAULT 'ativo',
    CONSTRAINT chkStatusEstufa CHECK (statusEstufa IN ('ativo', 'inativo')),
	fkEmpresa INT NOT NULL,
    CONSTRAINT fkEstufaEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa (id),
	UNIQUE KEY uqEstufa_Empresa (id, fkEmpresa)
);

CREATE TABLE usuario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha VARCHAR(50) NOT NULL,
  dtCadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  permissao VARCHAR(50) NOT NULL DEFAULT 'funcionario',
  CONSTRAINT chkPermissao CHECK (permissao IN ('admin', 'funcionario')),
  statusUsuario VARCHAR(7) NOT NULL DEFAULT 'ativo',
  CONSTRAINT chkStatusUsuario CHECK (statusUsuario IN ('ativo', 'inativo')),
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkUsuarioEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa (id),
  fkEstufa INT NULL,
  CONSTRAINT fkUsuarioEstufa FOREIGN KEY (fkEstufa, fkEmpresa)
    REFERENCES estufa (id, fkEmpresa),
  CONSTRAINT chkPermissaoEstufa CHECK (
    (permissao = 'admin' AND fkEstufa IS NULL) OR
    (permissao = 'funcionario' AND fkEstufa IS NOT NULL)
  )
);

CREATE TABLE sensor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  dtInstalacao DATETIME NOT NULL,
  nSerie VARCHAR(10) NOT NULL UNIQUE,
  status_sensor VARCHAR(7) NOT NULL DEFAULT 'ativo',
  fkEstufa INT NOT NULL,
  CONSTRAINT chkStatusSensor CHECK (status_sensor IN ('ativo', 'inativo')),
  CONSTRAINT fkSensorEstufa FOREIGN KEY (fkEstufa) REFERENCES estufa (id)
);

CREATE TABLE leituraLuminosidade (
  id INT PRIMARY KEY AUTO_INCREMENT,
  dtHora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  lux DECIMAL(10,2) NOT NULL,
  ppfd DECIMAL(10,2) NOT NULL,
  dli DECIMAL(5,2)  NOT NULL,
  fkSensor INT NOT NULL,
  CONSTRAINT fkLeituraSensor FOREIGN KEY (fkSensor) REFERENCES sensor (id),
  CONSTRAINT chkLeituraValores CHECK (lux >= 0 AND ppfd >= 0 AND dli >= 0)
);