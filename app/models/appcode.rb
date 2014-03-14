class Appcode < ActiveRecord::Base
  attr_accessible  :id,:appguid,:zipname,:size,:userguid,:username,:appname,:version,:active,:uploaddate,:appdetect
end
