CREATE PROCEDURE pa_supplier_update (
    @supplier_id INT,
    @new_name VARCHAR(50) = NULL,
    @new_description VARCHAR(150) = NULL,
    @new_email VARCHAR(70) = NULL,
    @new_phone VARCHAR(20) = NULL
) AS
BEGIN
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM supplier WHERE id = @supplier_id)
    BEGIN
        RAISERROR('El proveedor no existe', 16, 1)
        RETURN
    END

    -- Validaciones
    IF @new_name IS NOT NULL AND @new_name = ' '
    BEGIN
        RAISERROR('El nombre no corresponde a un valor válido', 16, 1)
        RETURN
    END
    IF @new_email IS NOT NULL AND @new_email NOT LIKE '%_@_%._%'
    BEGIN
        RAISERROR('El formato del email no es válido', 16, 1)
        RETURN
    END
    IF @new_phone IS NOT NULL
    BEGIN
        IF @new_phone LIKE '%[^0-9]%' OR LEN(@new_phone) <> 8
        BEGIN
            RAISERROR('El teléfono no es válido (solo 8 dígitos)', 16, 1)
            RETURN
        END
        IF EXISTS (SELECT 1 FROM supplier_phones WHERE supplier_id = @supplier_id)
            UPDATE supplier_phones SET phone = @new_phone WHERE supplier_id = @supplier_id;
        ELSE
            INSERT INTO supplier_phones (supplier_id, phone) VALUES (@supplier_id, @new_phone);
    END

    -- Actualización de supplier
    UPDATE supplier
    SET
        name = ISNULL(@new_name, name),
        description = ISNULL(@new_description, description),
        email = ISNULL(@new_email, email)
    WHERE id = @supplier_id;
END TRY
BEGIN CATCH
    RAISERROR('Error al actualizar proveedor', 16, 1)
END CATCH
END
GO