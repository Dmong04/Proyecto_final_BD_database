USE coco_tours_db
GO

CREATE PROCEDURE pa_tour_delete(
 @tour_id INT
)AS
BEGIN
BEGIN TRY

IF NOT EXISTS (SELECT 1 FROM tour WHERE id = @tour_id)
BEGIN
 RAISERROR ('El tour no existe', 16, 1)
 RETURN
END

 DELETE FROM tour_detail WHERE @tour_id = @tour_id;

 DELETE FROM tour WHERE id = @tour_id;

END TRY
BEGIN CATCH
 RAISERROR ('El tour no ha podido eliminarse...', 16, 1)
END CATCH
END