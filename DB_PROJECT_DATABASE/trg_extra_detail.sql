CREATE OR ALTER TRIGGER trg_extra_detail_update
ON extra_detail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ed
    SET ed.total_price = ed.person_count * e.unit_price
    FROM extra_detail ed
    JOIN extra e ON ed.extra_id = e.id
    JOIN inserted i ON ed.id = i.id

    DECLARE @reservation_id INT;


    DECLARE res_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT DISTINCT reservation_id FROM inserted
        UNION
        SELECT DISTINCT reservation_id FROM deleted;

    OPEN res_cursor;
    FETCH NEXT FROM res_cursor INTO @reservation_id;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @extra_subtotal DECIMAL(10,2);
        SELECT @extra_subtotal = ISNULL(SUM(total_price),0)
        FROM extra_detail
        WHERE reservation_id = @reservation_id;
        UPDATE reservations
        SET extra_subtotal = @extra_subtotal,
            total = @extra_subtotal + ISNULL(tour_subtotal,0)
        WHERE id = @reservation_id;

        FETCH NEXT FROM res_cursor INTO @reservation_id;
    END

    CLOSE res_cursor;
    DEALLOCATE res_cursor;
END;
GO
