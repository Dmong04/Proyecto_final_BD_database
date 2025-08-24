CREATE OR ALTER TRIGGER trg_tour_detail_update
ON tour_detail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @reservation_id INT;

    DECLARE res_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT DISTINCT reservation_id FROM inserted
        UNION
        SELECT DISTINCT reservation_id FROM deleted;

    OPEN res_cursor;
    FETCH NEXT FROM res_cursor INTO @reservation_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @tour_subtotal DECIMAL(10,2);

        SELECT @tour_subtotal = ISNULL(SUM(t.price),0)
        FROM tour_detail td
        JOIN tour t ON td.tour_id = t.id
        WHERE td.reservation_id = @reservation_id;

        UPDATE reservations
        SET tour_subtotal = @tour_subtotal,
            total = @tour_subtotal + ISNULL(extra_subtotal,0)
        WHERE id = @reservation_id;

        FETCH NEXT FROM res_cursor INTO @reservation_id;
    END

    CLOSE res_cursor;
    DEALLOCATE res_cursor;
END;
GO
