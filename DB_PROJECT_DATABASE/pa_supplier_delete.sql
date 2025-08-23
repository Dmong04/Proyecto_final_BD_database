CREATE PROCEDURE pa_supplier_delete (
    @supplier_id INT
) AS
BEGIN
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM supplier WHERE id = @supplier_id)
    BEGIN
        RAISERROR('El proveedor no existe', 16, 1)
        RETURN
    END

    DELETE FROM supplier_phones WHERE supplier_id = @supplier_id;
    DELETE FROM tour_detail WHERE supplier_id = @supplier_id;
    DELETE FROM supplier WHERE id = @supplier_id;
END TRY
BEGIN CATCH
    RAISERROR('Error al eliminar proveedor', 16, 1)
END CATCH
END
GO