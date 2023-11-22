/*Inserir curso*/
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='inserir_curso')
	DROP PROCEDURE inserir_curso	
	GO
	CREATE PROCEDURE inserir_curso(@nome varchar(250))
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				INSERT INTO CURSO(nome, numMatr) VALUES (@nome, 0)
			COMMIT TRANSACTION
		END
GO

/*--------------------------------------------------------------------------*/
/*Fazer matricula*/
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='matricule')
	DROP PROCEDURE matricule
	GO
	CREATE PROCEDURE matricule(@matricula int, @codigo int)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
			BEGIN TRANSACTION
				IF EXISTS (SELECT codigo FROM CURSO WHERE codigo = @codigo)
					BEGIN
						INSERT INTO TURMA (codigo, matricula) VALUES (@codigo, @matricula)
						UPDATE CURSO SET NumMatr += 1 WHERE codigo = @codigo
					END
			COMMIT TRANSACTION
		END
GO

/*--------------------------------------------------------------------------*/
/*Apagar curso*/
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='cancele')
	DROP PROCEDURE cancele
	GO
		CREATE PROCEDURE cancele(@codigo int)
			AS
			BEGIN
				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
				BEGIN TRANSACTION
					IF EXISTS (SELECT codigo FROM CURSO WHERE codigo = @codigo)
						BEGIN
							DELETE FROM TURMA WHERE codigo = @codigo
							DELETE FROM CURSO WHERE codigo = @codigo
						END
					ELSE
						BEGIN
							PRINT 'Esse registro não existe'
						END
				COMMIT TRANSACTION
			END
GO

/*--------------------------------------------------------------------------*/
/*listar de cursos de aluno*/
IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='listar_cursos_estudante')
	DROP PROCEDURE listar_cursos_estudante
	GO
		CREATE procedure listar_cursos_estudante @matricula INT
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			BEGIN TRANSACTION
				SELECT C.nome FROM CURSO AS C INNER JOIN TURMA AS T ON T.matricula = @matricula AND C.codigo = T.codigo
			COMMIT TRANSACTION
		END
GO