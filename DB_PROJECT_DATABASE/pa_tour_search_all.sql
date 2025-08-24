USE coco_tours_db
GO

CREATE PROCEDURE pa_tour_search_all
AS
BEGIN
BEGIN TRY
SELECT 
id,
[type],
[description],
price
FROM tour
END TRY
BEGIN CATCH
 RAISERROR('Error al obtener los tours', 16, 1);
END CATCH
END
GO

