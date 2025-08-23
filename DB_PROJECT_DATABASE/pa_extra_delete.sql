USE coco_tours_db
GO

CREATE PROCEDURE pa_extra_delete(
 @extra_id INT
)AS
BEGIN
BEGIN TRY

IF NOT EXISTS (SELECT 1 FROM extra WHERE id = @extra_id)
BEGIN
 RAISERROR ('El extra no existe', 16, 1)
 RETURN
END

 DELETE FROM extra_detail WHERE extra_id = @extra_id;

 DELETE FROM extra WHERE id = @extra_id;

END TRY
BEGIN CATCH
 RAISERROR ('El extra no ha podido eliminarse...', 16, 1)
END CATCH
END