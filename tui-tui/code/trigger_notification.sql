/*trigger of follow*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'tr' AND name = 'tr_follow')
	DROP TRIGGER tr_follow
	GO
	CREATE TRIGGER tr_follow
		ON Follow_tb
		AFTER INSERT
			AS
			BEGIN
				DECLARE
				@follower int,
				@follow int,
				@user varchar(250),
				@userTarget varchar(250),
				@message varchar(250)

				SELECT @follower = follower FROM inserted
				SELECT @follow = follow FROM inserted

				SET @user = (SELECT username FROM User_tb WHERE idUser = @follower)
				SET @userTarget = (SELECT username FROM User_tb WHERE idUser = @follow)

				SET @message = ('O '+@user+' está seguindo agora '+@userTarget)

				UPDATE Follow_tb SET messageFollow = @message WHERE follower = @follower AND follow = @follow

			END
	GO

/*trigger of like*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'tr' AND name = 'tr_like')
	DROP TRIGGER tr_like
	GO
	CREATE TRIGGER tr_like
		ON Like_tb
		AFTER INSERT
			AS
			BEGIN
				DECLARE
				@likeUser int,
				@likeArticle int,
				@user varchar(250),
				@userTarget varchar(250),
				@message varchar(250)

				SELECT @likeUser = likeUser FROM inserted
				SELECT @likeArticle = likeArticle FROM inserted

				SET @user = (SELECT username FROM User_tb WHERE idUser = @likeUser)
				SET @userTarget = (SELECT username FROM User_tb WHERE idUser = (SELECT author FROM Article_tb WHERE idArticle = @likeArticle))

				SET @message = ('O '+@user+' curtiu um artigo de '+@userTarget)

				UPDATE Like_tb SET messageLike = @message WHERE likeUser = @likeUser AND likeArticle = @likeArticle

			END
	GO

/*trigger of favorite*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'tr' AND name = 'tr_favorite')
	DROP TRIGGER tr_favorite
	GO
	CREATE TRIGGER tr_favorite
		ON Favorite_tb
		AFTER INSERT
			AS
			BEGIN
				DECLARE
				@idUser int,
				@idUserArticle int,
				@idArticle int,
				@user varchar(250),
				@userArticle varchar(250),
				@message varchar(250)

				SELECT @idUser = idUser FROM inserted
				SELECT @idUserArticle = idUserArticle FROM inserted
				SELECT @idArticle = idArticle FROM inserted

				SET @user = (SELECT username FROM User_tb WHERE idUser = @idUser)
				SET @userArticle = (SELECT username FROM User_tb WHERE idUser = @idUserArticle)

				SET @message = ('O '+@user+' favoritou um artigo de '+@userArticle)

				UPDATE Favorite_tb SET messageFavorite = @message WHERE idUser = @idUser AND idUserArticle = @idUserArticle AND idArticle = @idArticle

			END
	GO

/*trigger of modified date of user*/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'tr' AND name = 'tr_lastModifiedAt_user')
	DROP TRIGGER tr_lastModifiedAt_user
	GO
	CREATE TRIGGER tr_lastModifiedAt_user
		ON User_tb
		AFTER UPDATE
			AS
			BEGIN
				DECLARE
				@idUser int,
				@lastModifiedAt date

				SELECT @idUser = idUser FROM inserted

				SET @lastModifiedAt = GETDATE()

				UPDATE User_tb SET lastModifiedAt = @lastModifiedAt WHERE idUser = @idUser

			END
	GO

/*trigger of modified date of article*/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'tr' AND name = 'tr_lastModifiedAt_article')
	DROP TRIGGER tr_lastModifiedAt_article
	GO
	CREATE TRIGGER tr_lastModifiedAt_article
		ON Article_tb
		AFTER UPDATE
			AS
			BEGIN
				DECLARE
				@idArticle int,
				@lastModifiedAt date

				SELECT @idArticle = idArticle FROM inserted

				SET @lastModifiedAt = GETDATE()

				UPDATE Article_tb SET lastModifiedAt = @lastModifiedAt WHERE idArticle = @idArticle

			END
	GO

CREATE NONCLUSTERED INDEX idx_author ON Article_tb (author ASC)
GO

CREATE NONCLUSTERED INDEX idx_title ON Article_tb (title ASC)
GO