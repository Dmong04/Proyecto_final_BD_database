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

select name, compatibility_level
from sys.databases
where name = 'coco_tours_db'

use coco_tours_db
go
execute pa_reservation_insert '2025-09-11', '10:30:00', 'playita', 1

select * from tour where id = 1

select * from reservations

execute pa_passenger_insert 'Ramiro Sanches', 55, 5
execute pa_passenger_insert 'Dereck Monge', 21, 5
execute pa_passenger_insert 'Rachell Dávila', 21, 5
execute pa_passenger_insert 'Josué Arrieta', 7, 5
execute pa_passenger_insert 'Pedro Pascal', 45, 5

insert into supplier ([name], [description], email)
values ('Eliecer Dávila', 'Capitán del Sinaloa Sneeze', 'capitanmacho@gmail.com')

select * from supplier

execute pa_tour_details_reservation_insert 'Playas del coco', 'Playa huevo', 1, 1

select * from tour_detail

insert into extra ([name], [description], unit_price)
values ('Jetsky', 'Paseo en jetski por la costa', 25)

select * from extra

execute pa_extra_details_reservation_insert 6, 1, 1

select * from extra_detail

select * from reservations

select * from tour_detail