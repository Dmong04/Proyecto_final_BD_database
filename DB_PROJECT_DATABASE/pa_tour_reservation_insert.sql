use coco_tours_db
go

create procedure pa_tour_details_reservation_insert (
	@origin varchar(40),
	@destination varchar(40),
	@tour_id int,
	@reservation_id int
) as
begin
	set nocount on
	begin try
		if @origin is null or LTRIM(RTRIM(@origin)) = ''
		begin
			raiserror('El lugar de origen no puede estar vacío', 16, 1)
			return
		end
		if @destination is null or LTRIM(RTRIM(@destination)) = ''
		begin
			raiserror('El lugar de destino no puede estar vacío', 16, 1)
			return
		end
		declare @selected_tour int
		select @selected_tour = id from tour where id = @tour_id
		if @selected_tour is null
		begin
			raiserror('El tour no existe', 16, 1)
			return
		end
		declare @selected_reservation int
		select @selected_reservation = id from reservations where id = @reservation_id
		if @selected_reservation is null
		begin
			raiserror('La reservación no existe', 16, 1)
			return
		end
		declare @default_supplier int = 1
		insert into tour_detail (origin, destination, tour_id, reservation_id, supplier_id)
		values (@origin, @destination, @selected_tour, @selected_reservation, @default_supplier)
	end try
	begin catch
		declare @ErrorMessage nvarchar(4000) = error_message();
		raiserror(@ErrorMessage,16,1);
	end catch
end
go