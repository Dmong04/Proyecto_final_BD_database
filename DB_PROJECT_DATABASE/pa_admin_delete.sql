USE coco_tours_db
GO

CREATE PROCEDURE pa_admin_delete(
 @admin_id INT
)AS
BEGIN
BEGIN TRY
 

 IF NOT EXISTS(SELECT 1 FROM administrator WHERE id = @admin_id)
 BEGIN
  RAISERROR('El administrador no existe', 16, 1)
  RETURN
 END
 --
 BEGIN TRANSACTION
  DELETE FROM [user] WHERE admin_id = @admin_id;
  DELETE FROM administrator WHERE id = @admin_id;
 COMMIT TRANSACTION
 --

END TRY
BEGIN CATCH
 RAISERROR('Ha ocurrido un error al eliminar al administrador', 16, 1)
 RETURN
END CATCH
END
GO