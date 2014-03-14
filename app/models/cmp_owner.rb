class CmpOwner < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_owner"
  self.inheritance_column = nil
end
