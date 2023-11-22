SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRANSACTION
	execute inserir_curso 'curso 1'
	execute matricule 1,1
	execute matricule 2,1
	execute listar_cursos_estudante 1
COMMIT TRANSACTION

select * from CURSO

select * from TURMA