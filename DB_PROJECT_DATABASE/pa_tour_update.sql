CREATE PROCEDURE pa_tour_update (
    @tour_id INT,
    @new_type VARCHAR(50) = NULL,
    @new_description VARCHAR(150) = NULL,
    @new_price DECIMAL(10,2) = NULL
) AS
BEGIN
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM tour WHERE id = @tour_id)
    BEGIN
        RAISERROR('El tour no existe', 16, 1)
        RETURN
    END

    -- Validaciones
    IF @new_type IS NOT NULL AND @new_type = ' '
    BEGIN
        RAISERROR('El tipo de tour no es válido', 16, 1)
        RETURN
    END
    IF @new_price IS NOT NULL AND @new_price <= 0
    BEGIN
        RAISERROR('El precio debe ser mayor a 0', 16, 1)
        RETURN
    END

    -- Actualización
    UPDATE tour
    SET
        type = ISNULL(@new_type, type),
        description = ISNULL(@new_description, description),
        price = ISNULL(@new_price, price)
    WHERE id = @tour_id;
END TRY
BEGIN CATCH
    RAISERROR('Error al actualizar tour', 16, 1)
END CATCH
END
GO
