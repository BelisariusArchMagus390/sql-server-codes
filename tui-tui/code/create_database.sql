IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'database_tuitui')
	BEGIN
		CREATE DATABASE database_tuitui
	END
GO
	USE database_tuitui
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'User_tb' AND xtype='U')
BEGIN
	CREATE TABLE User_tb(
	  	idUser int PRIMARY KEY IDENTITY NOT NULL,
		username varchar(250) NOT NULL,
		passwordUser varchar(250) NOT NULL,
		descriptionUser varchar(250),
		userEmail varchar(250) NOT NULL,
		createdAt date NOT NULL,
		lastModifiedAt date NOT NULL,
		isDeleted bit NOT NULL,
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Tag_tb' AND xtype='U')
BEGIN
	CREATE TABLE Tag_tb(
	  	idTag int PRIMARY KEY IDENTITY NOT NULL,
		tagName varchar(250) NOT NULL,
		createdAt date NOT NULL
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Article_tb' AND xtype='U')
BEGIN
	CREATE TABLE Article_tb(
	  	idArticle int PRIMARY KEY IDENTITY NOT NULL,
		author int NOT NULL,
		title varchar(250) NOT NULL,
		content varchar(250) NOT NULL,
		isDeleted bit NOT NULL,
		createdAt date NOT NULL,
		lastModifiedAt date NOT NULL,
		FOREIGN KEY (author) REFERENCES User_tb(idUser),
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'TagArticle_tb' AND xtype='U')
BEGIN
	CREATE TABLE TagArticle_tb(
	  	idArticle int NOT NULL,
		idTag int NOT NULL,
		FOREIGN KEY (idArticle) REFERENCES Article_tb(idArticle),
		FOREIGN KEY (idTag) REFERENCES Tag_tb(idTag),
		PRIMARY KEY (idArticle, idTag)
	)
END


IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Favorite_tb' AND xtype='U')
BEGIN
	CREATE TABLE Favorite_tb(
		idUser int NOT NULL,
		idUserArticle int NOT NULL,
		idArticle int NOT NULL,
		messageFavorite varchar(250),
		FOREIGN KEY (idUser) REFERENCES User_tb(idUser),
		FOREIGN KEY (idUserArticle) REFERENCES User_tb(idUser),
		FOREIGN KEY (idArticle) REFERENCES Article_tb(idArticle),
		PRIMARY KEY (idUser, idUserArticle, idArticle)
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Follow_tb' AND xtype='U')
BEGIN
	CREATE TABLE Follow_tb(
		follower int NOT NULL,
		follow int NOT NULL,
		messageFollow varchar(250),
		FOREIGN KEY (follower) REFERENCES User_tb(idUser),
		FOREIGN KEY (follow) REFERENCES User_tb(idUser),
		PRIMARY KEY (follower, follow)
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Like_tb' AND xtype='U')
BEGIN
	CREATE TABLE Like_tb(
		likeUser int NOT NULL,
		likeArticle int NOT NULL,
		messageLike varchar(250),
		FOREIGN KEY (likeUser) REFERENCES User_tb(idUser),
		FOREIGN KEY (likeArticle) REFERENCES Article_tb(idArticle),
		PRIMARY KEY (likeUser, likeArticle)
	)
END