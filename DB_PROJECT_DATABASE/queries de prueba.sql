use coco_tours_db;
go

insert into administrator(name) values(
	'Dereck Monge'
)

insert into [user](email, username, [password], client_id, admin_id) 
values ('dmong@gmail.com', 'dmong', '12345678', NULL, 1)

select * from [user]

select * from administrator

delete from [user] where id = 2

USE coco_tours_db;
SELECT name, type_desc 
FROM sys.database_principals
WHERE name = 'root_user';

