IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'loja')
	BEGIN
		CREATE DATABASE loja
	END
GO
	USE loja
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'CEP' AND xtype='U')
BEGIN
	CREATE TABLE CEP(
	  	id_cep int NOT NULL,
  		rua varchar(250) NOT NULL,
	  	bairro varchar(250) NOT NULL,
  		cidade varchar(50) NOT NULL,
	  	estado varchar(80) NOT NULL,
  		PRIMARY KEY (id_cep)
	)
END


IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CLIENTE' AND xtype='U')
	BEGIN
		CREATE TABLE CLIENTE(
			id_cliente int PRIMARY KEY IDENTITY NOT NULL,
			nome varchar(200) NOT NULL,
			n_cep INT NOT NULL,
  			cpf_cnpj varchar(14) NOT NULL,
  			insc_municipal char(12) NOT NULL,
  			numero_end varchar(7) NOT NULL,
  			compl_end varchar(7) NOT NULL,
			FOREIGN KEY (n_cep) REFERENCES CEP(id_cep) ON DELETE CASCADE ON UPDATE CASCADE
		)
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'NOTA_FISCAL' AND xtype = 'U')
	BEGIN
		CREATE table NOTA_FISCAL(
			id_nf int PRIMARY KEY IDENTITY NOT NULL,
  			id_cliente int NOT NULL,
  			dt_emissao date NOT NULL,
  			tt_nota float,
  			tt_imp_nf float,
			FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
		)
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'IMPOSTO' AND xtype = 'U')
	BEGIN
		create table IMPOSTO(
			id_imposto int PRIMARY KEY IDENTITY NOT NULL,
  			sigla varchar(50) NOT NULL,
  			descrico varchar(250) NOT NULL,
  			aliquota float NOT NULL
		)
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'SERVICO' AND xtype = 'U')
	BEGIN
		CREATE TABLE SERVICO(
			id_servico int PRIMARY KEY IDENTITY NOT NULL,
  			descricao varchar(250) NOT NULL,
  			preco_unit float NOT NULL,
  			unidade int NOT NULL
		)
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SERVICO_NF' AND xtype='U')
	BEGIN
		CREATE table SERVICO_NF(
			id_nf int NOT NULL,
  			id_servico int NOT NULL,
  			qtde int NOT NULL,
  			tt_servico float,
  			tt_imposto float,
  			PRIMARY KEY (id_nf, id_servico),
  			FOREIGN KEY (id_nf) REFERENCES NOTA_FISCAL(id_nf) ON DELETE CASCADE ON UPDATE CASCADE,
  			FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico) ON DELETE CASCADE ON UPDATE CASCADE
		)
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'IMP_SERVICO' AND xtype = 'U')
	BEGIN
		CREATE table IMP_SERVICO(
			id_imposto int NOT NULL,
			id_servico int NOT NULL,
  			id_nf int NOT NULL,
  			vl_imposto float,
  			PRIMARY KEY (id_nf, id_servico, id_imposto),
  			FOREIGN KEY (id_imposto) REFERENCES IMPOSTO(id_imposto) ON DELETE CASCADE ON UPDATE CASCADE,
  			FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico) ON DELETE CASCADE ON UPDATE CASCADE,
  			FOREIGN KEY (id_nf) REFERENCES NOTA_FISCAL(id_nf) ON DELETE CASCADE ON UPDATE CASCADE
		)
	END
