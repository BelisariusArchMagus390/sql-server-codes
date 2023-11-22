/*Inserts*/

execute insertUser 'Gustavo', '123', 'Gosto de Artigos', 'gustavo@gmail.com', '2022-09-20', '2022-09-20', 0
execute insertUser 'Ciro', '1234', 'Gosto de matemática', 'ciro@gmail.com', '2022-09-20', '2022-09-20', 0
execute insertUser 'Lucas', '12345', 'Gosto de história', 'lucas@gmail.com', '2022-09-20', '2022-09-20', 0
execute insertUser 'Artur', '12346', 'Gosto de geografia', 'artur@gmail.com', '2022-09-20', '2022-09-20', 0

execute insertTag 'Matemática', '2022-09-10'
execute insertTag 'Programação', '2022-09-12'
execute insertTag 'Cálculo', '2022-09-12'
execute insertTag 'Computadores', '2022-09-12'

execute insertArticle 1, 'Programação é legal', 'Gosto muito de programação, por isso ela é legal.', 0, '2022-09-18', '2022-09-18'
execute insertArticle 2, 'Matemática é legal', 'Gosto muito de matemática, por isso ela é legal.', 0, '2022-09-20', '2022-09-20'
execute insertArticle 3, 'Geomeria é legal', 'Gosto muito de geometria, por isso ela é legal.', 0, '2022-09-20', '2022-09-20'
execute insertArticle 1, 'Programação é o futuro', 'Acredito que a programação é o futuro por ter muitas implementações.', 0, '2022-09-18', '2022-09-18'


execute insertTagArticle 1, 2
execute insertTagArticle 1, 4
execute insertTagArticle 2, 1
execute insertTagArticle 2, 3
execute insertTagArticle 3, 1
execute insertTagArticle 4, 2


execute follow 1, 2
execute follow 2, 1
execute follow 3, 2
execute follow 4, 3
execute follow 1, 4

execute likeUser 1, 2
execute likeUser 2, 1
execute likeUser 3, 2
execute likeUser 4, 3

/*Modifes*/

execute modifeUsername 1, 'Felipe'

execute modifePassword 2, '9090'

execute modifeDescription 1, 'Gosto de história.'

execute modifeEmail 2, 'trindade@gmail.com'

execute modifeTitle 1, 'Programação é demais!'

execute modifeContent 2, 'Matemática tem muitas contas legais.'


/*Deletes*/

execute deleteUser 1
execute deleteUser 2
execute deleteUser 3
execute deleteUser 4

execute deleteTag 1
execute deleteTag 2
execute deleteTag 3
execute deleteTag 4

execute deleteArticle 1
execute deleteArticle 2
execute deleteArticle 3
execute deleteArticle 4

execute unfollow 1, 2
execute unfollow 2, 1
execute unfollow 3, 2
execute unfollow 4, 3
execute unfollow 1, 4

execute cancelLike 1, 2
execute cancelLike 2, 1
execute cancelLike 3, 2
execute cancelLike 4, 3

execute removeTag 2, 1


/*Selects*/

select * from User_tb

select * from Tag_tb

select * from Article_tb

select * from Follow_tb

select * from Like_tb

select * from TagArticle_tb

execute selectArticleAuthor 'Gustavo'

execute selectArticleTitle 'Geomeria é legal'

execute selectArticleTag 'Matemática'

/*Errors*/

execute insertUser 'Gustavo', '1', 'Gosto de Artigos', 'gu@gmail.com', '2022-09-18', '2022-09-18', 0 /*error same username*/
execute insertUser 'Gus', '12', 'Gosto de Artigos', 'gustavo@gmail.com', '2022-09-18', '2022-09-18', 0 /*error same email*/
execute insertUser 'Gol', '123', 'Gosto de Artigos', 'gust@gmail.com', '2022-09-18', '2022-09-18', 0 /*error same password*/

execute Follow 1, 1
execute Follow 5, 1

execute LikeUser 1, 5
execute LikeUser 1, 1


execute modifeUsername 1, 'Ciro'

execute modifePassword 2, '123'

execute modifeEmail 2, 'gustavo@gmail.com'

execute insertTagArticle 1, 4 /*tag not exist*/
execute insertTagArticle 5, 1 /*article not exist*/



/*Drops*/
DROP INDEX idx_author
DROP INDEX idx_title
DROP INDEX idx_tag

drop table Like_tb