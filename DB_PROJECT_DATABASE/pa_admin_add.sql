USE coco_tours_db
GO

CREATE PROCEDURE pa_admin_insert (
	@name VARCHAR(50),
	@email VARCHAR(70),
	@username VARCHAR(30),
	@password VARCHAR(150)
) AS
BEGIN
BEGIN TRY


 IF @name IS NULL OR LTRIM(RTRIM(@name)) = ''
 BEGIN
  RAISERROR('El nombre no puede ser un valor vacio', 16, 1)
  RETURN
 END

IF @email NOT LIKE '%_@_%._%'
BEGIN
 RAISERROR('El formato email no es válido', 16, 1)
 RETURN
END
ELSE IF exists (SELECT 1 FROM [user] WHERE email = @email)
BEGIN
 RAISERROR('El correo ya esta asosiado a un usuario', 16, 1)
 RETURN
END

IF @username IS NULL OR LTRIM(RTRIM(@username)) = ''
BEGIN
 RAISERROR('El nombre de usuario  no puede ser un valor vacio', 16, 1)
 RETURN;
END
ELSE IF exists (SELECT 1 FROM [user] WHERE username = @username)
BEGIN
 RAISERROR('El nombre de usuario ya se encuentra en uso', 16, 1)
 RETURN
END

IF @password IS NULL OR LTRIM(RTRIM(@password)) = ''
BEGIN
RAISERROR('la contraseña no es valida', 16, 1)
 RETURN
END
ELSE IF (@password NOT LIKE '%[0-9]%' AND @password NOT LIKE '%[!@#$^&*()]%')
BEGIN
 RAISERROR('La contraseña debe incluir un numero y un caracters especial', 16, 1)
 RETURN
END

--
INSERT INTO administrator ([name]) VALUES (@name)

DECLARE @admin_id INT = SCOPE_IDENTITY()

INSERT INTO [user](email, username, [password], admin_id, client_id)
VALUES(@email,@username,@password,@admin_id,NULL)

END  TRY
BEGIN CATCH
	RAISERROR('Hubo un error en el proceso, por favor, revise los datos ingresados', 16, 1)
	RETURN
END CATCH
END
GO