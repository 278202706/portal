class Servicelist < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :isdelete,:userguid,:username,:name,:type,:plan,:apply_at,:approve_at,:reject_at,:active
end
