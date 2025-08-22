use coco_tours_db
go

CREATE PROCEDURE USP_insert_client_users (
    @name      VARCHAR(50) = NULL,
    @phone     VARCHAR(20) = NULL,
    @email     VARCHAR(70) = NULL,
    @username  VARCHAR(30) = NULL,
    @password  VARCHAR(150) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validaciones
        IF @name IS NULL OR LTRIM(RTRIM(@name)) = ''
        BEGIN
            THROW 51001, 'El nombre no corresponde a un valor válido', 1;
        END

        IF @phone IS NULL OR @phone NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        BEGIN
            THROW 51002, 'El formato del teléfono no es válido', 1;
        END

        IF EXISTS (SELECT 1 FROM client_phones WHERE phone = @phone)
        BEGIN
            THROW 51003, 'El teléfono ya está registrado', 1;
        END

        IF @email NOT LIKE '%_@_%._%'
        BEGIN
            THROW 51004, 'El formato de email no es válido', 1;
        END

        IF EXISTS (SELECT 1 FROM [user] WHERE email = @email)
        BEGIN
            THROW 51005, 'El correo ya está registrado', 1;
        END

        IF EXISTS (SELECT 1 FROM [user] WHERE username = @username)
        BEGIN
            THROW 51006, 'El nombre de usuario ya está en uso', 1;
        END

        IF @password IS NULL OR LTRIM(RTRIM(@password)) = ''
        BEGIN
            THROW 51007, 'La contraseña no es válida', 1;
        END

        -- Inserciones
        DECLARE @client_id INT;

        INSERT INTO client ([name])
        VALUES (@name);

        SET @client_id = SCOPE_IDENTITY();

        INSERT INTO client_phones (client_id, [phone])
        VALUES (@client_id, @phone);

        INSERT INTO [user] (email, username, [password], client_id, admin_id)
        VALUES (@email, @username, @password, @client_id, NULL);

    END TRY
    BEGIN CATCH
        THROW 51010, 'Hubo un error en el proceso, por favor revise los datos ingresados', 1;
    END CATCH
END
GO


execute USP_insert_client_users 'Melissa Chaves','60974927', 'meli@gmail.com', 'meli', '12345678'

select * from [user]

select * from [client]

select * from [client_phones]