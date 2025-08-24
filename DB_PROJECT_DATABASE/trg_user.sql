CREATE TRIGGER trg_set_user_role
ON [user]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE u
    SET role = 
        CASE 
            WHEN i.client_id IS NOT NULL THEN 'CLIENT'
            WHEN i.admin_id IS NOT NULL THEN 'ADMIN'
            ELSE NULL
        END
    FROM [user] u
    INNER JOIN inserted i ON u.id = i.id;
END;