USE coco_tours_db
GO

CREATE PROCEDURE pa_extra_search_by_id
    @extra_id INT
AS
BEGIN
BEGIN TRY

IF @extra_id IS NULL OR @extra_id <= 0
BEGIN
 RAISERROR('El id proporcionado no es válido', 16, 1);
 RETURN;
END

IF NOT EXISTS (SELECT 1 FROM extra WHERE id = @extra_id)
BEGIN
 RAISERROR ('El extra no existe', 16, 1)
 RETURN
END

SELECT 
id,
[name],
[description],
unit_price
FROM extra
WHERE @extra_id = @extra_id;

END TRY
BEGIN CATCH
 RAISERROR ('Error al buscar el extra',16, 1)
END CATCH
END
GO

