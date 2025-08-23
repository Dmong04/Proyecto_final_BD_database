CREATE PROCEDURE pa_extra_update(
 @extra_id INT,
 @new_name VARCHAR(50) = NULL,
 @new_description VARCHAR(150) = NULL,
 @new_price DECIMAL(10,2) = NULL
) AS
BEGIN
BEGIN TRY
 
 IF NOT EXISTS (SELECT 1 FROM extra WHERE id =@extra_id)
 BEGIN
  RAISERROR('El extra no existe...', 16, 1)
  RETURN
 END

 IF @new_name IS NOT NULL AND @new_name = ''
 BEGIN
  RAISERROR('El  nombre del extra no es valido...', 16, 1)
  RETURN
 END

 IF @new_description IS NOT NULL AND @new_description = ''
 BEGIN
   RAISERROR('La descripcion del extra no es valido...', 16, 1)
   RETURN
 END

 IF @new_price IS NOT NULL AND @new_description <= 0
 BEGIN
   RAISERROR('El precio debe ser mayor a 0', 16, 1)
   RETURN
 END

 UPDATE extra SET
 name = ISNULL(@new_name, name),
 description = ISNULL(@new_description, description),
 unit_price = ISNULL(@new_price, unit_price)
WHERE id = @extra_id

END TRY
BEGIN CATCH
    RAISERROR('No se ha logrado actualizar el extra...', 16, 1)
    RETURN
END CATCH
END
GO