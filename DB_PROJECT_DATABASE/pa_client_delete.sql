USE coco_tours_db
GO

CREATE PROCEDURE pa_client_delete(
 @client_id INT
)AS
BEGIN
BEGIN TRY
 
 --validation
 IF NOT EXISTS(SELECT 1 FROM client WHERE id = @client_id)
 BEGIN
  RAISERROR('El cliente no existe', 16, 1)
  RETURN
 END
 --
 BEGIN TRANSACTION
  DELETE FROM client_phones WHERE client_id = @client_id;

  DELETE FROM [user] WHERE client_id = @client_id;

  DELETE FROM client WHERE id = @client_id;

 COMMIT TRANSACTION

END TRY
BEGIN CATCH
 RAISERROR('Ha ocurrido un error al eliminar al cliente', 16, 1)
 RETURN
END CATCH
END
GO