class App < ActiveRecord::Base
  attr_accessible :org,:space,:userguid,:username,:appguid,:zipfilename,:version,:appname,:appframework,:active,:uploaddate
end
