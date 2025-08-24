USE coco_tours_db
GO

CREATE PROCEDURE pa_extra_search_all
AS
BEGIN
BEGIN TRY
SELECT 
id,
[name],
[description],
unit_price
FROM extra;
END TRY
BEGIN CATCH
 RAISERROR('Error al obtener los extras', 16, 1);
END CATCH
END
GO
