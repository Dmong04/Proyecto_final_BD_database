CREATE PROCEDURE pa_tour_insert (
    @type VARCHAR(50),
    @description VARCHAR(150),
    @price DECIMAL(10,2)
) AS
BEGIN
BEGIN TRY
    IF @type IS NULL OR @type = ' '
    BEGIN
        RAISERROR('El tipo de tour no es válido', 16, 1)
        RETURN
    END
    IF @price <= 0
    BEGIN
        RAISERROR('El precio debe ser mayor a 0', 16, 1)
        RETURN
    END

    INSERT INTO tour ([type], [description], price)
    VALUES (@type, @description, @price);
END TRY
BEGIN CATCH
    RAISERROR('Error al insertar tour', 16, 1)
END CATCH
END
GO