class CmpTaggroup < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_taggroup"
  self.inheritance_column = nil
end
