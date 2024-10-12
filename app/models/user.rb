# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: Devise.email_regexp }, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum:50 }

  before_save :set_uid
  # after_save :handle_registration

  private

  def set_uid
    self.uid = self.email
  end

  # def handle_registration
    # self.confirm
  # end
end
