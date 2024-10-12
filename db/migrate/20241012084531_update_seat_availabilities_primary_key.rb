class UpdateSeatAvailabilitiesPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    # 1. Xóa khóa chính hiện tại
    remove_column :seat_availabilities, :id, :primary_key
    
    # 2. Tạo khóa chính mới trên ba cột: flight_id, seat_code, status
    execute "ALTER TABLE seat_availabilities ADD PRIMARY KEY (flight_id, seat_code, status);"
  end
end
