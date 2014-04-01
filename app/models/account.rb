class Account < ActiveRecord::Base
  attr_accessible :email,:password,:username,:guid,:organization,:space, :codenum
  #validates :email,:password,presence: true
  #validates :password, presence: true
  ##validates_presence_of :email, :password
  #validates_confirmation_of :password
  ##validates :password_confirmation,presence: true
  #validates_uniqueness_of :email
  ##validates :email,uniqueness: true
  #validates_format_of(:email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => 'address is wrong!')
end
