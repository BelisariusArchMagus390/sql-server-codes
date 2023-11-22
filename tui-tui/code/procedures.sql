/*INSERTS*/
/*--------------------------------------------------------------------------*/

/*insert User*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='insertUser')
	DROP PROCEDURE insertUser
	GO
	CREATE PROCEDURE insertUser(
	@username varchar(250),
	@passwordUser varchar(250),
	@descriptionUser varchar(250),
	@userEmail varchar(250),
	@createdAt date,
	@lastModifiedAt date,
	@isDeleted bit
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT username FROM User_tb WHERE username = @username)
					PRINT ('Erro, já existe esse nome de usuário.')
				ELSE IF EXISTS (SELECT passwordUser FROM User_tb WHERE passwordUser = @passwordUser)
					PRINT ('Erro, já existe uma senha como essa.')
				ELSE IF EXISTS (SELECT userEmail FROM User_tb WHERE userEmail = @userEmail)
					PRINT ('Erro, já existe um e-mail cadastrado como esse.')
				ELSE
					INSERT INTO User_tb (username, passwordUser, descriptionUser, userEmail, createdAt, lastModifiedAt, isDeleted) values (@username, @passwordUser, @descriptionUser, @userEmail, @createdAt, @lastModifiedAt, @isDeleted)
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*insert Tag*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='insertTag')
	DROP PROCEDURE insertTag
	GO
	CREATE PROCEDURE insertTag(
	@tagName varchar(250),
	@createdAt date
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				INSERT INTO Tag_tb (tagName, createdAt) values (@tagName, @createdAt)
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*insert Article*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='insertArticle')
	DROP PROCEDURE insertArticle
	GO
	CREATE PROCEDURE insertArticle(
	@author int,
	@title varchar(250),
	@content varchar(250),
	@isDeleted bit,
	@createdAt date,
	@lastModifiedAt date
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				INSERT INTO Article_tb (author, title, content, isDeleted, createdAt, lastModifiedAt) values (@author, @title, @content, @isDeleted, @createdAt, @lastModifiedAt)
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*insert tags ot article*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='insertTagArticle')
	DROP PROCEDURE insertTagArticle
	GO
	CREATE PROCEDURE insertTagArticle(
	@idArticle int,
	@idTag int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF NOT EXISTS (SELECT idArticle, idTag FROM TagArticle_tb WHERE idArticle = @idArticle AND idTag = @idTag)
					IF EXISTS (SELECT idArticle FROM Article_tb WHERE idArticle = @idArticle)
						IF EXISTS (SELECT idTag FROM Tag_tb WHERE idTag = @idTag)
							INSERT INTO TagArticle_tb (idArticle, idTag) values (@idArticle, @idTag)
						ELSE PRINT 'Essa tag não existe'
					ELSE PRINT 'Esse artigo não existe'
				ELSE PRINT 'Já foi atribuido essa tag'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*insert Follow*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='follow')
	DROP PROCEDURE follow
	GO
	CREATE PROCEDURE follow(
	@follower int,
	@follow int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT idUser FROM User_tb WHERE idUser = @follower)
					IF EXISTS (SELECT idUser FROM User_tb WHERE idUser = @follow)
						IF (@follower <> @follow)
							IF NOT EXISTS (SELECT follower, follow FROM Follow_tb WHERE follower = @follower AND follow = @follow)
								INSERT INTO Follow_tb (follower, follow, messageFollow) values (@follower, @follow, '')
							ELSE
								PRINT 'Erro, já foi seguido.'
						ELSE
							PRINT 'Erro, não pode seguir a si mesmo.'
					ELSE
						PRINT 'Esse usuário não existe'
				ELSE
					PRINT 'Esse usuário não existe'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='favorite')
	DROP PROCEDURE favorite
	GO
	CREATE PROCEDURE favorite(
	@idUser int,
	@idUserArticle int,
	@idArticle int
	)	
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT idUser FROM User_tb WHERE idUser = @idUser)
					IF EXISTS (SELECT idArticle FROM Article_tb WHERE idArticle = @idArticle)
						IF EXISTS (SELECT idUser FROM User_tb WHERE idUser = @idUserArticle)
							IF NOT EXISTS(SELECT idArticle FROM Article_tb WHERE author = @idUser AND idArticle = @idArticle)		
								IF NOT EXISTS (SELECT idUser, idArticle FROM Favorite_tb WHERE idUser = @idUser AND idArticle = @idArticle)
									INSERT INTO Favorite_tb (idUser, idUserArticle, idArticle, messageFavorite) values (@idUser, @idUserArticle, @idArticle, '')
								ELSE
									PRINT 'Erro, já foi favoritado.'
							ELSE
								PRINT 'Erro, não pode favoritar um artigo próprio.'
						ELSE
							PRINT 'Erro, esse usuário não existe'
					ELSE
						PRINT 'Esse artigo não existe'
				ELSE
					PRINT 'Esse usuário não existe'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*insert Like*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='likeUser')
	DROP PROCEDURE likeUser
	GO
	CREATE PROCEDURE likeUser(
	@likeUser int,
	@likeArticle int
	)	
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF EXISTS (SELECT idUser FROM User_tb WHERE idUser = @likeUser)
					IF EXISTS (SELECT idArticle FROM Article_tb WHERE idArticle = @likeArticle)
						IF NOT EXISTS(SELECT idArticle FROM Article_tb WHERE author = @likeUser AND idArticle = @likeArticle)		
							IF NOT EXISTS (SELECT likeUser, likeArticle FROM Like_tb WHERE likeUser = @likeUser AND likeArticle = @likeArticle)
								INSERT INTO Like_tb (likeUser, likeArticle, messageLike) values (@likeUser, @likeArticle, '')
							ELSE
								PRINT 'Erro, já foi curtido.'
						ELSE
							PRINT 'Erro, não pode curtir um artigo próprio.'
					ELSE
						PRINT 'Esse artigo não existe'
				ELSE
					PRINT 'Esse usuário não existe'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/


/*UPDATES*/
/*--------------------------------------------------------------------------*/

/*Modife username*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='modifeUsername')
	DROP PROCEDURE modifeUsername
	GO
	CREATE PROCEDURE modifeUsername(
	@idUser int,
	@username varchar(250)
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF NOT EXISTS (SELECT username FROM User_tb WHERE username = @username)
					UPDATE User_tb SET username = @username WHERE idUser = @idUser
				ELSE
					PRINT 'Erro, esse username já existe.'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Modife password*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='modifePassword')
	DROP PROCEDURE modifePassword
	GO
	CREATE PROCEDURE modifePassword(
	@idUser int,
	@passwordUser varchar(250)
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF NOT EXISTS (SELECT passwordUser FROM User_tb WHERE passwordUser = @passwordUser)
					UPDATE User_tb SET passwordUser = @passwordUser WHERE idUser = @idUser
				ELSE
					PRINT 'Erro, essa senha já existe.'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Modife description*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='modifeDescription')
	DROP PROCEDURE modifeDescription
	GO
	CREATE PROCEDURE modifeDescription(
	@idUser int,
	@descriptionUser varchar(250)
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				UPDATE User_tb SET descriptionUser = @descriptionUser WHERE idUser = @idUser
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Modife email*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='modifeEmail')
	DROP PROCEDURE modifeEmail
	GO
	CREATE PROCEDURE modifeEmail(
	@idUser int,
	@userEmail varchar(250)
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				IF NOT EXISTS (SELECT userEmail FROM User_tb WHERE userEmail = @userEmail)
					UPDATE User_tb SET userEmail = @userEmail WHERE idUser = @idUser
				ELSE
					PRINT 'Erro, esse e-mail já existe.'
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Modife title*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='modifeTitle')
	DROP PROCEDURE modifeTitle
	GO
	CREATE PROCEDURE modifeTitle(
	@idArticle int,
	@title varchar(250)
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				UPDATE Article_tb SET title = @title WHERE idArticle = @idArticle
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Modife content*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='modifeContent')
	DROP PROCEDURE modifeContent
	GO
	CREATE PROCEDURE modifeContent(
	@idArticle int,
	@content varchar(250)
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				UPDATE Article_tb SET content = @content WHERE idArticle = @idArticle
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/


/*DELETES*/

/*Delete User*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='deleteUser')
	DROP PROCEDURE deleteUser
	GO
	CREATE PROCEDURE deleteUser(
	@idUser int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				DELETE FROM Follow_tb WHERE follow = @idUser or follower = @idUser				
				DELETE FROM Like_tb WHERE likeUser = @idUser or likeArticle = @idUser
				DELETE FROM TagArticle_tb WHERE idArticle = (SELECT idArticle FROM Article_tb WHERE author = @idUser)
				DELETE FROM Article_tb WHERE author = @idUser
				DBCC CHECKIDENT (Article_tb, RESEED, 0)
				DELETE FROM User_tb WHERE idUser = @idUser
				DBCC CHECKIDENT (User_tb, RESEED, 0)
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Delete tag*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='deleteTag')
	DROP PROCEDURE deleteTag
	GO
	CREATE PROCEDURE deleteTag(
	@idTag int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				DELETE FROM TagArticle_tb WHERE idTag = @idTag
				DELETE FROM Tag_tb WHERE idTag = @idTag
				DBCC CHECKIDENT (Tag_tb, RESEED, 0)
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/


/*Delete Article*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='deleteArticle')
	DROP PROCEDURE deleteArticle
	GO
	CREATE PROCEDURE deleteArticle(
	@idArticle int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				DELETE FROM Like_tb WHERE likeArticle = @idArticle
				DELETE FROM TagArticle_tb WHERE idArticle = @idArticle
				DELETE FROM Article_tb WHERE idArticle = @idArticle
				DBCC CHECKIDENT (Article_tb, RESEED, 0)				
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/


/*Unfollow*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='unfollow')
	DROP PROCEDURE unfollow
	GO
	CREATE PROCEDURE unfollow(
	@follower int,
	@follow int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				DELETE FROM Follow_tb WHERE follower = @follower AND follow = @follow
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Cancel like*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='cancelLike')
	DROP PROCEDURE cancelLike
	GO
	CREATE PROCEDURE cancelLike(
	@likeUser int,
	@likeArticle int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				DELETE FROM Like_tb WHERE likeUser = @likeUser AND likeArticle = @likeArticle
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/

/*Remove tag in article*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='removeTag')
	DROP PROCEDURE removeTag
	GO
	CREATE PROCEDURE removeTag(
	@idArticle int,
	@idTag int
	)
		AS
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
			BEGIN TRANSACTION
				DELETE FROM TagArticle_tb WHERE idArticle = @idArticle AND idTag = @idTag
			COMMIT TRANSACTION
		END
	GO

/*--------------------------------------------------------------------------*/


/*SELECTS*/

/*Select article from author*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='selectArticleAuthor')
	DROP PROCEDURE selectArticleAuthor
	GO
	CREATE PROCEDURE selectArticleAuthor(
	@author varchar(250)
	)
		AS
		BEGIN
			SELECT * FROM Article_tb WHERE author = (SELECT idUser FROM User_tb WHERE username = @author)
		END
	GO

/*--------------------------------------------------------------------------*/

/*Select article from title*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='selectArticleTitle')
	DROP PROCEDURE selectArticleTitle
	GO
	CREATE PROCEDURE selectArticleTitle(
	@title varchar(250)
	)
		AS
		BEGIN
			SELECT * FROM Article_tb WHERE title = @title
		END
	GO

/*--------------------------------------------------------------------------*/

/*Select article from tag*/

IF EXISTS (SELECT * FROM sysobjects WHERE type='p' AND name='selectArticleTag')
	DROP PROCEDURE selectArticleTag
	GO
	CREATE PROCEDURE selectArticleTag(
	@tagName varchar(250)
	)
		AS
		BEGIN
			SELECT * FROM Article_tb AS A INNER JOIN TagArticle_tb AS TA ON A.idArticle = TA.idArticle INNER JOIN Tag_tb AS T ON TA.idTag = T.idTag WHERE T.tagName = @tagName
		END
	GO

/*--------------------------------------------------------------------------*/