IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'faculdade')
	BEGIN
		CREATE DATABASE faculdade
	END
GO
	USE faculdade
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'CURSO' AND xtype = 'U')
	BEGIN
		CREATE TABLE CURSO(
			codigo int PRIMARY KEY IDENTITY NOT NULL,
			nome varchar(250) NOT NULL,
			numMatr int NOT NULL
		)
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'TURMA' AND xtype = 'U')
	BEGIN
		CREATE TABLE TURMA(
			 codigo int NOT NULL,
			 matricula int NOT NULL
			 PRIMARY KEY(codigo, matricula)
		)
	END
