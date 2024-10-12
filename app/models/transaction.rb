class Transaction < ApplicationRecord
  belongs_to :booking, primary_key: 'booking_id'
  has_many :entries #, primary_key: 'entry_id'

  # Enum cho trường status
  enum status: {
    pending: 0,     # Chờ xử lý
    completed: 1,   # Đã hoàn thành
    failed: 2,      # Thất bại
    refunded: 3     # Đã hoàn tiền
  }

  self.inheritance_column = :_type_disabled
  # Enum cho trường type
  enum type: {
    payment: 0,     # Thanh toán
    refund: 1,      # Hoàn tiền
    adjustment: 2   # Điều chỉnh
  }

  # Enum cho trường method
  enum method: {
    credit_card: 0, # Thẻ tín dụng
    debit_card: 1,  # Thẻ ghi nợ
    paypal: 2,      # PayPal
    bank_transfer: 3 # Chuyển khoản ngân hàng
  }

  validates :status, :type, :amount, :method, presence: true
end
