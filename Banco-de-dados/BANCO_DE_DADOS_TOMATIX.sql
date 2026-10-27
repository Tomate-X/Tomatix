USE SPRINT2;

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
bairro VARCHAR(45) NOT NULL,
cep CHAR(8) NOT NULL,
cidade VARCHAR(45) NOT NULL,
uf CHAR(2) NOT NULL,
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
tipo_fase VARCHAR(45) NOT NULL,
CONSTRAINT ch_fase CHECK (tipo_fase IN('mudas','vegetativa','reprodutiva')),
identificador CHAR(5) NOT NULL,
fk_empresa INT NOT NULL,
FOREIGN KEY (fk_empresa) REFERENCES EMPRESA (id)
);

CREATE TABLE SENSOR(
id INT PRIMARY KEY AUTO_INCREMENT,
dtInstalacao DATETIME DEFAULT current_timestamp NOT NULL,
numeroSerie CHAR(6) NOT NULL,
status VARCHAR(45) NOT NULL,
CONSTRAINT ch_status CHECK (status IN('ativo','inativo','manutencao')),
fk_estufa INT NOT NULL,
FOREIGN KEY (fk_estufa) REFERENCES ESTUFA (id)
);

CREATE TABLE LEITURA_LUMINOSIDADE(
id INT PRIMARY KEY auto_increment,
dtHora  DATETIME DEFAULT current_timestamp NOT NULL,
ppfd DECIMAL(10,2) NOT NULL,
fk_sensor INT NOT NULL,
FOREIGN KEY (fk_sensor) REFERENCES SENSOR (id)
);

CREATE TABLE RESGISTRO(
id INT PRIMARY KEY AUTO_INCREMENT,
registro VARCHAR(45) NOT NULL,
CONSTRAINT ch_registro CHECK (registro IN ('critico','cuidado')),
fk_leitura INT NOT NULL,
FOREIGN KEY (fk_leitura) REFERENCES LEITURA_LUMINOSIDADE (id)
);

INSERT INTO EMPRESA (razaoSocial, cnpj,token,tipo,cidade,estado) VALUES
('AgroIndustria produção agricola e hortifruti LTDA',00123456000199,'FGT4J','MATRIZ','ITU','SÃO PAULO');

INSERT INTO USUARIO (nome,email,senha,fk_empresa) VALUES
('FERNANDO BRANDÃO','brandao.fernando@gmail.com','12345678',1);

INSERT INTO USUARIO (nome,email,senha,fk_empresa) VALUES
('JULIA ARARIPE','julia.araripe@gmail.com','12345678',1);

INSERT INTO USUARIO (nome,email,senha,fk_empresa) VALUES
('MARCOS ANTONIO','marcos.antonio@gmail.com','12345678',1);

INSERT INTO ESTUFA (tipo_fase,identificador,fk_empresa) VALUES
('mudas','m01es',1),
('vegetativa','v01es',1),
('reprodutiva','r01es',1);

INSERT INTO SENSOR (nSerie,status_sensor,fk_estufa) VALUES
('021526','ativo',1),
('158620','ativo',2),
('547100','ativo',3);




-- Relação de empresa com usuário
SELECT 
    E.razaoSocial AS empresa_razao_social,
    E.cnpj AS empresa_cnpj,
    U.nome AS usuario_nome,
    U.email AS usuario_email
FROM EMPRESA AS E
INNER JOIN USUARIO AS U 
    ON U.fk_empresa = E.id;
    
-- Relação de usuário com estufa
SELECT 
    U.nome AS usuario_nome,
    U.email AS usuario_email,
    ES.identificador AS estufa_identificador,
    ES.tipo_fase AS estufa_fase
FROM USUARIO AS U
INNER JOIN ESTUFA AS ES 
    ON ES.fk_empresa = U.fk_empresa;
    
-- Relação de empresa, estufa e sensor
SELECT 
    E.razaoSocial AS empresa_razao_social,
    ES.identificador AS estufa_identificador,
    ES.tipo_fase AS estufa_fase,
    S.nSerie AS sensor_n_serie,
    S.status_sensor AS sensor_status
FROM EMPRESA AS E
INNER JOIN ESTUFA AS ES 
    ON ES.fk_empresa = E.id
INNER JOIN SENSOR AS S 
    ON S.fk_estufa = ES.id;
    
    
-- Relação de estufa com sensor
SELECT 
    ES.identificador AS estufa_identificador,
    ES.tipo_fase AS estufa_fase,
    S.nSerie AS sensor_n_serie,
    S.status_sensor AS sensor_status,
    S.dtInstalacao AS sensor_dt_instalacao
FROM ESTUFA AS ES
INNER JOIN SENSOR AS S 
    ON S.fk_estufa = ES.id;