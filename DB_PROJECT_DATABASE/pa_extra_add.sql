USE coco_tours_db
GO

CREATE PROCEDURE pa_extra_insert(
 @name VARCHAR(50),
 @description VARCHAR(150),
 @unit_price DECIMAL(10,2)
)AS
BEGIN
BEGIN TRY

 IF @name IS NULL OR LTRIM(RTRIM(@name)) = ''
 BEGIN
  RAISERROR ('El nombre no puede ser un valor vacio',16, 1)
  RETURN
 END

IF @description IS NULL OR LTRIM(RTRIM(@description)) = ''
 BEGIN
  RAISERROR ('La descripcion no puede ser un valor vacio',16, 1)
  RETURN
 END

IF @unit_price <= 0
BEGIN
 RAISERROR ('El precion unitario debe ser mayor a 0',16, 1)
END

INSERT INTO extra ([name], [description], unit_price) VALUES (@name, @description, @unit_price);

END TRY
BEGIN CATCH
 RAISERROR ('Error al agregar el extra',16, 1)
END CATCH
END
GO