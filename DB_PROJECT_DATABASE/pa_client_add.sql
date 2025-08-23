USE coco_tours_db
GO

CREATE PROCEDURE pa_client_insert (
	@name VARCHAR(50),
	@phone VARCHAR(20),
	@email VARCHAR(70),
	@username VARCHAR(30),
	@password VARCHAR(150)
) AS
BEGIN
BEGIN TRY

 --Name validation

IF @name IS NULL OR LTRIM(RTRIM(@name)) = ''
BEGIN
 RAISERROR('El nombre no corresponde a un valor válido', 16, 1)
 RETURN
END

--Phone validation
IF @phone IS NULL OR LTRIM(RTRIM(@phone)) = ''
BEGIN
 RAISERROR('El telefono no puede estar vacio', 16, 1)
 RETURN
END
ELSE IF @phone LIKE '%[^0-9]%' OR LEN(@phone) <> 8
BEGIN
 RAISERROR('El formato del teléfono no es válido', 16, 1)
 RETURN
END
ELSE IF EXISTS (SELECT 1 FROM [client_phones] WHERE phone = @phone)
BEGIN
 RAISERROR('El teléfono ya esta asociado a un cliente', 16, 1)
 RETURN
END

--Email validation

IF @email NOT LIKE '%_@_%._%'
BEGIN
 RAISERROR('El formato email no es válido', 16, 1)
 RETURN
END
ELSE IF EXISTS (SELECT 1 FROM [user] WHERE email = @email)
BEGIN
 RAISERROR('El correo ya esta asosiado a un usuario', 16, 1)
 RETURN
END

--Username validation

IF @username IS NULL OR LTRIM(RTRIM(@username)) = ''
BEGIN
 RAISERROR('El nombre de usuario no corresponde a un valor válido', 16, 1)
 RETURN;
END
ELSE IF exists (SELECT 1 FROM [user] WHERE username = @username)
BEGIN
 RAISERROR('El nombre de usuario ya se encuentra en uso', 16, 1)
 RETURN
END

--Password Validation
	
IF @password IS NULL OR LTRIM(RTRIM(@password)) = ''
BEGIN
RAISERROR('la contraseña no es valida', 16, 1)
 RETURN
END
ELSE IF (@password NOT LIKE '%[0-9]%' AND @password NOT LIKE '%[!@#$^&*()]%')
BEGIN
 RAISERROR('La contraseña debe incluir un numero y un caracter especial', 16, 1)
 RETURN
END

--

INSERT INTO client([name]) VALUES (@name)
DECLARE @client_id INT = SCOPE_IDENTITY()
	
INSERT INTO client_phones(client_id, [phone])
values (@client_id, @phone)

INSERT INTO [user] (email, username, [password], client_id, admin_id)
values (@email, @username, @password, @client_id, null)

END TRY
BEGIN CATCH
	RAISERROR('Hubo un error en el proceso, por favor, revise los datos ingresados', 16, 1)
	RETURN
END CATCH
END
GO