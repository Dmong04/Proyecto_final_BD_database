USE coco_tours_db
GO

CREATE PROCEDURE pa_admin_update (
    @admin_id INT,
    @new_name VARCHAR(50),
    @new_email VARCHAR(70),
    @new_username VARCHAR(30),
    @new_password VARCHAR(150)
) AS
BEGIN
BEGIN TRY

 IF NOT EXISTS (SELECT 1 FROM administrator WHERE id = @admin_id)
 BEGIN
  RAISERROR('El administrador no existe', 16, 1)
  RETURN
 END

 IF LTRIM(RTRIM(@new_name)) = ''
 BEGIN
  RAISERROR('El nombre no puede ser un valor vacio', 16, 1)
  RETURN
 END

 IF @new_email IS NOT NULL
 BEGIN
 IF @new_email NOT LIKE '%_@_%._%'
 BEGIN
  RAISERROR('El formato email no es válido', 16, 1)
  RETURN
 END
 ELSE IF EXISTS (SELECT 1 FROM [user] WHERE email = @new_email AND admin_id <> @admin_id)
 BEGIN
  RAISERROR('El correo ya está asociado a otro usuario', 16, 1)
  RETURN
 END
 END

 IF @new_username IS NOT NULL
 BEGIN
 IF LTRIM(RTRIM(@new_username)) = ''
 BEGIN
  RAISERROR('El nombre de usuario no puede ser un valor vacio', 16, 1)
  RETURN
 END
 ELSE IF EXISTS (SELECT 1 FROM [user] WHERE username = @new_username AND admin_id <> @admin_id)
 BEGIN
  RAISERROR('El nombre de usuario ya se encuentra en uso', 16, 1)
  RETURN
 END
 END

 IF @new_password IS NOT NULL
 BEGIN
 IF LTRIM(RTRIM(@new_password)) = ''
 BEGIN
  RAISERROR('La contraseña  no puede ser un valor vacio', 16, 1)
  RETURN
 END
 ELSE IF (@new_password NOT LIKE '%[0-9]%' AND @new_password NOT LIKE '%[!@#$^&*()]%')
 BEGIN
  RAISERROR('La contraseña debe incluir un número y un carácter especial', 16, 1)
  RETURN
 END
 END

   UPDATE administrator SET name = ISNULL(@new_name, name) WHERE id = @admin_id;

    UPDATE [user]
    SET email = ISNULL(@new_email, email),
        username = ISNULL(@new_username, username),
        [password] = ISNULL(@new_password, [password])
    WHERE admin_id = @admin_id;

END TRY
BEGIN CATCH
    RAISERROR('Hubo un error al actualizar administrador', 16, 1)
    RETURN
END CATCH
END
GO