class Entry < ApplicationRecord
  belongs_to :transaction, primary_key: 'transaction_id'
  belongs_to :user, foreign_key: 'account_number', primary_key: 'id'

  validates :account_number, :sign, :amount, presence: true
end
