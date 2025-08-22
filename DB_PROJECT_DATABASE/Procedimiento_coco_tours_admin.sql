use coco_tours_db
go

create procedure pa_admin_users (
	@name VARCHAR(50),
	@email VARCHAR(70),
	@username VARCHAR(30),
	@password VARCHAR(150)
) as
begin
begin try
	if @name = null or @name = ' '
	begin
		raiserror('El nombre no corresponde a un valor válido', 16, 1)
		return
	end
	insert into administrator ([name]) values (@name)

	if @email not like '%_@_%._%'
		begin
			raiserror('El formato email no es válido', 16, 1)
			return
		end
	else if exists (select 1 from [user] where email = @email)
		begin
			raiserror('El correo no corresponde a un valor válido', 16, 1)
			return
		end
	if exists (select 1 from [user] where username = @username)
		begin
			raiserror('El nombre de usuario no es válido', 16, 1)
			return
		end
	if @password = null or @password = ' '
		begin
			raiserror('La contraseña no es válida', 16, 1)
			return
		end
	insert into [user] (email, username, [password], client_id, admin_id)
	values (@email, @username, @password, null, @@IDENTITY)
end try
begin catch
	raiserror('Hubo un error en el proceso, por favor, revise los datos ingresados', 16, 1)
	return
end catch
end
go

execute pa_admin_users 'Christopher', 'chrisLam@gmail.com', 'ChrisLam2', '12345678'

select * from [user]

select * from [administrator]