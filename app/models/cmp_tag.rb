class CmpTag < ActiveRecord::Base
	establish_connection :oracle_development
	self.table_name= "cmp_tag"
  self.inheritance_column = nil
end
