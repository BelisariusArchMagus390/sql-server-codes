--INSERÇÕES

--inserção de CEP

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_cep')
	DROP PROCEDURE inserir_cep
	GO
	CREATE PROCEDURE inserir_cep (
			@id_cep int, 
			@rua varchar(250),
			@bairro varchar(250),
			@cidade varchar(50),
			@estado varchar(80)
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='CEP' AND xtype='U')
						BEGIN
							IF NOT EXISTS (SELECT id_cep FROM CEP WHERE id_cep = @id_cep)
								BEGIN 
									INSERT INTO CEP(id_cep, rua, bairro, cidade, estado) 
									VALUES (@id_cep, @rua, @bairro, @cidade, @estado)
								END
							ELSE
								BEGIN 
									PRINT 'Esse registro já existe.'
								END
						END
					ELSE
						BEGIN
							PRINT 'A tabela CEP não existe.'
						END
				COMMIT TRANSACTION
			END
	GO
 
------------------------------------------------------------------------------------------------

--inserção de CLIENTE

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_cliente')
	DROP PROCEDURE inserir_cliente
	GO
	CREATE PROCEDURE inserir_cliente (
			@nome varchar(200),
			@n_cep int,
			@cpf_cnpj varchar(14),
			@insc_municipal char(12),
			@numero_end varchar(7),
			@compl_end varchar(7)
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='CLIENTE' AND xtype='U')
						BEGIN
							IF EXISTS (SELECT id_cep FROM CEP WHERE id_cep = @n_cep)
								BEGIN
									INSERT INTO CLIENTE(nome, n_cep, cpf_cnpj, insc_municipal, numero_end, compl_end) 
									VALUES (@nome, @n_cep, @cpf_cnpj, @insc_municipal, @numero_end, @compl_end)
								END
							ELSE
								BEGIN
									PRINT 'Esse CEP não existe no banco de dados.'
								END
						END
					ELSE
						BEGIN
							PRINT 'A tabela CLIENTE não existe.'
						END
				COMMIT TRANSACTION
			END
	GO

------------------------------------------------------------------------------------------------

--inserção de NOTA_FISCAL

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_nota_fiscal')
	DROP PROCEDURE inserir_nota_fiscal
	GO
	CREATE PROCEDURE inserir_nota_fiscal (
			@id_cliente int,
			@dt_emissao date
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='NOTA_FISCAL' AND xtype='U')
						BEGIN
							INSERT INTO NOTA_FISCAL(id_cliente, dt_emissao) 
							VALUES (@id_cliente, @dt_emissao)
						END
					ELSE
						BEGIN
							PRINT 'A tabela NOTA_FISCAL não existe.'
						END
				COMMIT TRANSACTION
			END
	GO

------------------------------------------------------------------------------------------------

--inserção de IMPOSTO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_imposto')
	DROP PROCEDURE inserir_imposto
	GO
	CREATE PROCEDURE inserir_imposto (
			@sigla varchar(50),
			@descricao varchar(250),
			@aliquota float
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='IMPOSTO' AND xtype='U')
						BEGIN
							IF NOT EXISTS (SELECT sigla FROM IMPOSTO WHERE sigla = @sigla)
								BEGIN
									INSERT INTO IMPOSTO(sigla, descrico, aliquota)
									VALUES (@sigla, @descricao, @aliquota)
								END
							ELSE
								BEGIN
									PRINT 'Essa sigla de imposto já existe no banco de dados.'
								END
						END
					ELSE
						BEGIN
							PRINT 'A tabela IMPOSTO não existe.'
						END
				COMMIT TRANSACTION
			END
	GO

------------------------------------------------------------------------------------------------

--inserção de SERVICO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_servico')
	DROP PROCEDURE inserir_servico
	GO
	CREATE PROCEDURE inserir_servico (
			@descricao varchar(250),
			@preco_unit float,
			@unidade int
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='SERVICO' AND xtype='U')
						BEGIN
							IF NOT EXISTS (SELECT descricao FROM SERVICO WHERE descricao = @descricao)
								BEGIN
									INSERT INTO SERVICO(descricao, preco_unit, unidade)
									VALUES (@descricao, @preco_unit, @unidade)
								END
							ELSE
								BEGIN
									PRINT 'Essa descrição de serviço/produto já existe' 
								END
						END
					ELSE
						BEGIN
							PRINT 'A tabela SERVICO não existe.'
						END
				COMMIT TRANSACTION
			END
	GO

------------------------------------------------------------------------------------------------

--inserção de SERVICO_NF

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_servico_nf')
	DROP PROCEDURE inserir_servico_nf
	GO
	CREATE PROCEDURE inserir_servico_nf (
			@id_nf int, 
			@id_servico int,
			@qtde int
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='SERVICO_NF' AND xtype='U')
						BEGIN
							IF EXISTS (SELECT NF.id_nf, S.id_servico FROM NOTA_FISCAL AS NF, SERVICO AS S WHERE NF.id_nf = @id_nf AND S.id_servico = @id_servico)
								BEGIN
									IF NOT EXISTS (SELECT id_nf FROM SERVICO_NF WHERE id_nf = @id_nf)
										BEGIN 
											INSERT INTO SERVICO_NF(id_nf, id_servico, qtde)
											VALUES (@id_nf, @id_servico, @qtde)
										END
									ELSE
										BEGIN 
											PRINT 'Esse registro já existe.'
										END
								END
							ELSE
								BEGIN
									PRINT 'Esse(s) registro(s) não existe(m).'
								END
						END
					ELSE
						BEGIN
							PRINT 'A tabela SERVICO_NF não existe.'
						END

						declare @preco_unit float
						declare @tt_servico float

						SET @preco_unit = (SELECT preco_unit FROM SERVICO WHERE id_servico = @id_servico)
							
						SET @tt_servico = @qtde*@preco_unit

						UPDATE SERVICO_NF SET tt_servico = @tt_servico WHERE id_nf = @id_nf AND id_servico = @id_servico

				COMMIT TRANSACTION
			END
	GO

------------------------------------------------------------------------------------------------

--inserção de IMP_SERVICO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'inserir_imp_servico')
	DROP PROCEDURE inserir_imp_servico
	GO
	CREATE PROCEDURE inserir_imp_servico (
			@id_imposto int, 
			@id_servico int,
			@id_nf int
			)
			AS	
			BEGIN 
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT * FROM sysobjects WHERE name='IMP_SERVICO' AND xtype='U')
						BEGIN
							IF EXISTS (SELECT S.id_servico, I.id_imposto, NF.id_nf FROM SERVICO AS S, IMPOSTO AS I, NOTA_FISCAL AS NF WHERE S.id_servico = @id_servico AND I.id_imposto = @id_imposto AND NF.id_nf = @id_nf)
								BEGIN
									IF NOT EXISTS (SELECT id_nf  FROM IMP_SERVICO WHERE id_nf = @id_nf)
										BEGIN 
											INSERT INTO IMP_SERVICO(id_imposto, id_servico, id_nf) 
											VALUES (@id_imposto, @id_servico, @id_nf)
										END
									ELSE	
										BEGIN 
											PRINT 'Esse registro já existe.'
										END
								END
							ELSE
								BEGIN
									PRINT 'Esse(s) registro(s) não existe(m).'
								END
						END
					ELSE
						BEGIN
							PRINT 'A tabela IMP_SERVICO não existe.'
						END

					declare @tt_imp_nf float
					declare @tt_nota float
					declare @tt_servico float
					declare @aliquota float

					SET @aliquota = (SELECT aliquota FROM IMPOSTO WHERE id_imposto = @id_imposto)
					SET @tt_servico = (SELECT tt_servico FROM SERVICO_NF WHERE id_nf = @id_nf)

					SET @tt_imp_nf = @tt_servico*@aliquota
					SET @tt_nota = @tt_servico+@tt_imp_nf

					UPDATE NOTA_FISCAL SET tt_imp_nf = @tt_imp_nf WHERE id_nf = @id_nf
					UPDATE SERVICO_NF SET tt_imposto = @tt_imp_nf WHERE id_nf = @id_nf
					UPDATE IMP_SERVICO SET vl_imposto = @tt_imp_nf WHERE id_nf = @id_nf
					UPDATE NOTA_FISCAL SET tt_nota = @tt_nota WHERE id_nf = @id_nf

				COMMIT TRANSACTION
			END
	GO

------------------------------------------------------------------------------------------------

--CONSULTAS

--1. Listar todos os clientes cadastrados em ordem crescente, mostrando todos os seus dados relacionados.

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'select_1')
	DROP PROCEDURE select_1
	GO
	CREATE PROCEDURE select_1
		AS	
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				SELECT * FROM CLIENTE ORDER BY id_cliente ASC
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--2. Listar todos os clientes que possuem alguma compra; mostre o nome do cliente, e a quantidade de compras feitas nos últimos 30 dias.

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'select_2')
	DROP PROCEDURE select_2
	GO
	CREATE PROCEDURE select_2
		AS	
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				SELECT C.id_cliente, C.nome, count(NF.id_nf) as n_compras FROM CLIENTE AS C INNER JOIN NOTA_FISCAL AS NF ON C.id_cliente = NF.id_cliente GROUP BY C.id_cliente, C.nome
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--3. Listar todas as vendas mostrando os serviços, quantidades e valores.

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'select_3')
	DROP PROCEDURE select_3
	GO
	CREATE PROCEDURE select_3
		AS	
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				SELECT SNF.id_nf, SNF.qtde, NF.tt_nota AS valor, S.descricao AS servico_produto FROM SERVICO_NF AS SNF, NOTA_FISCAL AS NF, SERVICO AS S WHERE SNF.id_servico = S.id_servico AND SNF.id_nf = NF.id_nf
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--4. Faça mais duas consultas a seu critério, que permita a utilização de comandos avançados de JOIN.
--4.1. Mostrar todos os clientes que fizeram ou não uma compra, e o total gasto por aqueles que compraram.

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'select_4_1')
	DROP PROCEDURE select_4_1
	GO
	CREATE PROCEDURE select_4_1
		AS	
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				SELECT C.id_cliente, C.nome, SUM(NF.tt_nota) as total_compras FROM CLIENTE AS C LEFT OUTER JOIN NOTA_FISCAL AS NF ON C.id_cliente = NF.id_cliente GROUP BY C.id_cliente, C.nome
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--4.2. Mostrar todos os servicos/produtos que foram e não foram vendidos, e o total de cada um que foram.

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'p' AND name = 'select_4_2')
	DROP PROCEDURE select_4_2
	GO
	CREATE PROCEDURE select_4_2
		AS	
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				SELECT S.id_servico, S.descricao AS servico_produto, SUM(SF.tt_servico) as total FROM SERVICO AS S LEFT OUTER JOIN SERVICO_NF AS SF ON S.id_servico = SF.id_servico GROUP BY S.id_servico, S.descricao
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--APAGAR DADOS
--Apaga dados da tabela CEP
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_cep')
	DROP PROCEDURE delete_cep
	GO
	CREATE PROCEDURE delete_cep
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'CEP' AND xtype='U')
					BEGIN
						DELETE FROM CEP
						DBCC CHECKIDENT (CEP, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela CEP não existe no banco de dados.'
					END
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--Apaga dados da tabela CLIENTE
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_cliente')
	DROP PROCEDURE delete_cliente
	GO
	CREATE PROCEDURE delete_cliente
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'CLIENTE' AND xtype='U')
					BEGIN
						DELETE FROM CLIENTE
						DBCC CHECKIDENT (CLIENTE, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela CLIENTE não existe no banco de dados.'
					END
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--Apaga dados da tabela NOTA_FISCAL
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_nota_fiscal')
	DROP PROCEDURE delete_nota_fiscal
	GO
	CREATE PROCEDURE delete_nota_fiscal
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE	
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'NOTA_FISCAL' AND xtype='U')
					BEGIN
						DELETE FROM NOTA_FISCAL
						DBCC CHECKIDENT (NOTA_FISCAL, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela NOTA_FISCAL não existe no banco de dados.'
					END
		END
	GO

------------------------------------------------------------------------------------------------

--Apaga dados da tabela IMPOSTO
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_imposto')
	DROP PROCEDURE delete_imposto
	GO
	CREATE PROCEDURE delete_imposto
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'IMPOSTO' AND xtype='U')
					BEGIN
						DELETE FROM IMPOSTO
						DBCC CHECKIDENT (IMPOSTO, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela IMPOSTO não existe no banco de dados.'
					END
			COMMIT TRANSACTION
		END
	GO
------------------------------------------------------------------------------------------------

--Apaga dados da tabela SERVICO
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_servico')
	DROP PROCEDURE delete_servico
	GO
	CREATE PROCEDURE delete_servico
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'SERVICO' AND xtype='U')
					BEGIN
						DELETE FROM SERVICO
						DBCC CHECKIDENT (SERVICO, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela SERVICO não existe no banco de dados.'
					END
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--Apaga dados da tabela SERVICO_NF
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_servico_nf')
	DROP PROCEDURE delete_servico_nf
	GO
	CREATE PROCEDURE delete_servico_nf
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'SERVICO_NF' AND xtype='U')
					BEGIN
						DELETE FROM SERVICO_NF
						DBCC CHECKIDENT (SERVICO_NF, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela SERVICO_NF não existe no banco de dados.'
					END
			COMMIT TRANSACTION
		END
	GO

------------------------------------------------------------------------------------------------

--Apaga dados da tabela IMP_SERVICO
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name = 'delete_imp_servico')
	DROP PROCEDURE delete_imp_servico
	GO
	CREATE PROCEDURE delete_imp_servico
		AS
		BEGIN 
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT * FROM sysobjects WHERE name = 'IMP_SERVICO' AND xtype='U')
					BEGIN
						DELETE FROM IMP_SERVICO
						DBCC CHECKIDENT (IMP_SERVICO, RESEED, 0)
					END
				ELSE
					BEGIN
						PRINT 'A tabela IMP_SERVICO não existe no banco de dados.'
					END
			COMMIT TRANSACTION
		END
	GO
------------------------------------------------------------------------------------------------
