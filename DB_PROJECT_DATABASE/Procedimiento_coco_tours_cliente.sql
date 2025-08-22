use coco_tours_db
go

create procedure pa_client_users (
	@name VARCHAR(50) = null,
	@phone VARCHAR(20) = null,
	@email VARCHAR(70) = null,
	@username VARCHAR(30) = null,
	@password VARCHAR(150) = null
) as
begin
begin try
	if @name = null or @name = ' '
	begin
		raiserror('El nombre no corresponde a un valor válido', 16, 1)
		return
	end
	insert into client([name]) values (@name)

	if @phone like '%[^0-9]%' or len(@phone) <> 8
		begin
			raiserror('El formato del teléfono no es válido', 16, 1)
			return
		end
	else if exists (select 1 from [client_phones] where phone = @phone)
		begin
			raiserror('El teléfono no corresponde a un valor válido', 16, 1)
			return
		end

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
	DECLARE @client_phone_id INT;
	DECLARE @client_id INT;
	SELECT @client_id = @@IDENTITY;
	SELECT @client_phone_id = @client_id;
	insert into client_phones(client_id, [phone]) values (@client_phone_id, @phone)
	insert into [user] (email, username, [password], client_id, admin_id)
	values (@email, @username, @password, @client_id, null)
end try
begin catch
	raiserror('Hubo un error en el proceso, por favor, revise los datos ingresados', 16, 1)
	return
end catch
end
go

execute pa_client_users 'clientillouo','80808088', 'client2656@gmail.com', 'client2656', '12345678'

select * from [user]

select * from [client]

select * from [client_phones]