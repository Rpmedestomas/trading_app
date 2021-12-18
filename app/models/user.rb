class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  
  has_many :stocks

  # after_create :registration_notification

  # def after_confirmation
  #   UserMailer.success_notification(self).deliver
  # end
    
  # def registration_notification
  #   UserMailer.success_notification(self).deliver if approved
  # end
end
