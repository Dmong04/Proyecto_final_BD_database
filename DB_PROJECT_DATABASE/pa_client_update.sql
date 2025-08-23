USE coco_tours_db
GO

CREATE PROCEDURE pa_client_update (
    @client_id INT,
    @new_name VARCHAR(50) = NULL,
    @new_phone VARCHAR(20) = NULL,
    @new_email VARCHAR(70) = NULL,
    @new_username VARCHAR(30) = NULL,
    @new_password VARCHAR(150) = NULL
) AS
BEGIN
BEGIN TRY
    -- Verification

    IF NOT EXISTS (SELECT 1 FROM client WHERE id = @client_id)
    BEGIN
        RAISERROR('El cliente no existe', 16, 1)
        RETURN
    END

    --

    IF LTRIM(RTRIM(@new_name)) = ''
    BEGIN
        RAISERROR('El nombre no puede ser un valor vacio', 16, 1)
        RETURN
    END

    IF @new_phone IS NOT NULL
    BEGIN
        IF @new_phone LIKE '%[^0-9]%' OR LEN(@new_phone) <> 8
        BEGIN
            RAISERROR('El formato del teléfono no es válido', 16, 1)
            RETURN
        END
        ELSE IF EXISTS (SELECT 1 FROM client_phones WHERE phone = @new_phone AND client_id <> @client_id)
        BEGIN
            RAISERROR('El teléfono ya está asociado a otro cliente', 16, 1)
            RETURN
        END
    END


    IF @new_email IS NOT NULL
    BEGIN
        IF @new_email NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('El formato email no es válido', 16, 1)
            RETURN
        END
        ELSE IF EXISTS (SELECT 1 FROM [user] WHERE email = @new_email AND client_id <> @client_id)
        BEGIN
            RAISERROR('El correo ya está asociado a otro usuario', 16, 1)
            RETURN
        END
    END


    IF @new_username IS NOT NULL
    BEGIN
        IF LTRIM(RTRIM(@new_username)) = ''
        BEGIN
            RAISERROR('El nombre de usuario  no puede ser un valor vacio', 16, 1)
            RETURN
        END
        ELSE IF EXISTS (SELECT 1 FROM [user] WHERE username = @new_username AND client_id <> @client_id)
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
        ELSE IF (@new_password NOT LIKE '%[0-9]%' OR @new_password NOT LIKE '%[!@#$^&*()]%')
        BEGIN
            RAISERROR('La contraseña debe incluir un número y un carácter especial', 16, 1)
            RETURN
        END
    END

    --

    UPDATE client SET name = ISNULL(@new_name, name) WHERE id = @client_id;

    --

    IF @new_phone IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM client_phones WHERE client_id = @client_id)
            UPDATE client_phones SET phone = @new_phone WHERE client_id = @client_id;
        ELSE
            INSERT INTO client_phones (client_id, phone) VALUES (@client_id, @new_phone);
    END

    UPDATE [user]SET 
    email = ISNULL(@new_email, email),
    username = ISNULL(@new_username, username),
    [password] = ISNULL(@new_password, [password])
    WHERE client_id = @client_id;

END TRY
BEGIN CATCH
    RAISERROR('Hubo un error al actualizar cliente', 16, 1)
    RETURN
END CATCH
END
GO