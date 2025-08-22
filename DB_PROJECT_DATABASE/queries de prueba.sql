use coco_tours_db;
go

insert into administrator(name) values(
	'Dereck Monge'
)

insert into [user](email, username, [password], client_id, admin_id, role) 
values ('alex@gmail.com', 'alex', '87654321', 1, NULL, 'CLIENT')

select * from [user]

select * from client

delete from [user] where id = 2