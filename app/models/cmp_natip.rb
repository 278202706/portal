class CmpNatip < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_natip"
  self.inheritance_column = nil
end
