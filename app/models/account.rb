class Account < ActiveRecord::Base
  attr_accessible :email,:password,:username,:guid,:organization,:space, :codenum
end
