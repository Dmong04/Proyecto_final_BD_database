use coco_tours_db
go

CREATE PROCEDURE USP_insert_admin_users (
    @name      VARCHAR(50),
    @email     VARCHAR(70),
    @username  VARCHAR(30),
    @password  VARCHAR(150)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validaciones antes de insertar nada
        IF @name IS NULL OR LTRIM(RTRIM(@name)) = ''
        BEGIN
            THROW 50001, 'El nombre no corresponde a un valor válido', 1;
        END

        IF @password IS NULL OR LTRIM(RTRIM(@password)) = ''
        BEGIN
            THROW 50002, 'La contraseña no es válida', 1;
        END

        IF @email NOT LIKE '%_@_%._%'
        BEGIN
            THROW 50003, 'El formato de email no es válido', 1;
        END

        IF EXISTS (SELECT 1 FROM [user] WHERE email = @email)
        BEGIN
            THROW 50004, 'El correo ya está registrado', 1;
        END

        IF EXISTS (SELECT 1 FROM [user] WHERE username = @username)
        BEGIN
            THROW 50005, 'El nombre de usuario ya está en uso', 1;
        END

        -- Inserción
        DECLARE @newAdminId INT;

        INSERT INTO administrator ([name])
        VALUES (@name);

        SET @newAdminId = SCOPE_IDENTITY();

        INSERT INTO [user] (email, username, [password], client_id, admin_id)
        VALUES (@email, @username, @password, NULL, @newAdminId);

    END TRY
    BEGIN CATCH
        THROW 50010, 'Hubo un error en el proceso, por favor revise los datos ingresados', 1;
    END CATCH
END

execute USP_insert_admin_users 'Nahomy', 'naho@gmail.com', 'naho', '12345678'

select * from [user]

select * from [administrator]