CREATE DATABASE UserPosts
use UserPosts




CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY,Name NVARCHAR(40),Surname NVARCHAR(50),Age INT,UserId INT FOREIGN KEY REFERENCES Users(Id)
)
CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY,Login NVARCHAR(80),Password NVARCHAR(60),Email VARCHAR(120)
)

CREATE TABLE Posts
(
	Id INT PRIMARY KEY IDENTITY,Content NVARCHAR(max),PostDate datetime default GETDATE(),LikeCount INT,UserId INT FOREIGN KEY REFERENCES Users(Id),IsDeleted bit default 0
)

CREATE TABLE Comment
(
	Id INT PRIMARY KEY IDENTITY,UserId INT FOREIGN KEY REFERENCES Users(Id),PostId INT FOREIGN KEY REFERENCES Posts(Id),LikeCount INT,IsDeleted bit default 0
)


INSERT INTO Users
VALUES ('Zaman Safarov','zaman1234','zamanjs@code.edu.az'),
('Seyfi Necefli','seyfi1234','seyfi@code.edu.az'),
('Abbas Mammadli','abbas1234','abbas@code.edu.az'),
('Ramin Seferli','ramin1234','ramin@code.edu.az'),
('Agil Atakishiyev','agil1234','agil@code.edu.az'),
('Orxan Pasayev','orxan1234','orxan@code.edu.az'),
('Ibrahim Verdiev','ibrahim1234','ibrahim@code.edu.az')

INSERT INTO People
VALUES ('Zaman','Safarov',18,1),
('Seyfi','Necefli',20,2),
('Abbas','Mammadli',21,3),
('Ramin','Seferli',20,4),
('Agil','Atakishiyev',25,5),
('Orxan','Pasayev',17,6),
('Ibrahim','Verdiev',19,7)

INSERT INTO Posts
VALUES ('Entertaiment','',340,3,0),
('Fountain','',700,1,0),
('The Waterfall','',30,5,1),
('At Work','',1200,2,0),
('Having Fun','',12000,7,1),
('Birthdday Party','',200,4,1),
('Happy Halloween','',14,6,0)

INSERT INTO Comment
VALUES	(2,5,350,0),
(4,2,80,0),
(2,7,750,0),
(5,5,1250,1),
(1,3,30,0),
(3,1,10,0),
(7,4,7,1),
(3,6,120,1),
(6,7,99,0),
(1,6,34,0)


INSERT INTO Comment
VALUES (1,7,200,0)

SELECT p.Content as PostContent,COUNT(c.Id) as CommentCount From Comment as c
JOIN Posts as p
ON c.PostId = p.Id
GROUP BY p.Content


CREATE VIEW AllDataView
as
SELECT pe.Id as 'Id of People',pe.Name,pe.Surname,pe.Age,pe.UserId as 'UserId for People',u.Id as 'Id of User',U.Login,u.Password,u.Email,p.Id as 'Id of Post',p.Content,p.LikeCount as 'LikeCount for Post',p.PostDate,p.UserId as 'UserId for Post',p.IsDeleted as 'IsDeleted for Post',c.Id as 'Id of Comment',c.LikeCount as 'LikeCount for Comment',c.PostId,c.UserId as 'UserId for Comment',c.IsDeleted as 'IsDeleted for Comment' From Comment as c
JOIN Posts as p
ON c.PostId = p.Id
JOIN Users as u
ON c.UserId = u.Id
JOIN People AS pe
ON pe.UserId=u.Id


SELECT * FROM AllDataView



CREATE TRIGGER DeletedItemsForPost
ON Posts
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Id int
	SELECT top 1  @Id=Id from deleted
	UPDATE Posts SET IsDeleted =1 WHERE Id = @Id
END


CREATE TRIGGER DeletedItemsForComment
ON Comment
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Id int
	SELECT top 1  @Id=Id from deleted
	UPDATE Comment SET IsDeleted =1 WHERE Id = @Id
END


DELETE Posts
WHERE Id=2



CREATE PROCEDURE usp_LikePost(@Id INT) 
AS
BEGIN
    update Posts set LikeCount= LikeCount+1 where @Id = Id;    
END;

EXEC usp_LikePost @Id =4



CREATE PROCEDURE usp_ResetPassword(@Login VARCHAR(120),@New_Password NVARCHAR(60)) 
AS
BEGIN
	 UPDATE Users SET @New_Password	= Password WHERE @Login = Login;
END;

EXEC usp_ResetPassword @Login = 'Orxan Pasayev', @New_Password='orxanpashayev123'