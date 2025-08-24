USE coco_tours_db
GO

CREATE PROCEDURE pa_tour_search_by_id
    @tour_id INT
AS
BEGIN
BEGIN TRY

IF @tour_id IS NULL OR @tour_id <= 0
BEGIN
 RAISERROR('El id proporcionado no es válido', 16, 1);
 RETURN;
END

IF NOT EXISTS (SELECT 1 FROM tour WHERE id = @tour_id)
BEGIN
 RAISERROR ('El tour no existe', 16, 1)
 RETURN
END

SELECT 
id,
[type],
[description],
price
FROM tour
WHERE @tour_id = @tour_id;

END TRY
BEGIN CATCH
 RAISERROR ('Error al buscar el tour',16, 1)
END CATCH
END
GO
