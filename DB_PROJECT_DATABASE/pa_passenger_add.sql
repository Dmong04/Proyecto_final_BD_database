--version demo
USE coco_tours_db
GO

CREATE PROCEDURE pa_passenger_insert(
 @name VARCHAR(50),
 @age INT,
 @tour_detail_id INT
)AS
BEGIN
BEGIN TRY

 IF @name IS NULL OR @name = ''
 BEGIN
  RAISERROR ('El nombre no puede ser un valor vacio',16, 1)
  RETURN
 END

 IF @age <= 0
 BEGIN
   RAISERROR ('La edad debe ser un numero valido',16, 1)
   RETURN
 END

 IF NOT EXISTS (SELECT 1 FROM tour_detail WHERE id = @tour_detail_id)
 BEGIN
    RAISERROR ('El detalle de tour no existe',16, 1)
   RETURN
 END

 INSERT INTO passengers ([name], age, tour_detail_id) VALUES (@name, @age, @tour_detail_id);
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage,16,1);
END CATCH
END
GO