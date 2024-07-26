class Application < ApplicationRecord
  has_many :chats
  has_many :messages

  # before_create :generate_app_token
  
  private

  # def generate_app_token
  #   self.app_token = SecureRandom.uuid
  # end
end
