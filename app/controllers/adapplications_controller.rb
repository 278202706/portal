<<<<<<< HEAD
# encoding: utf-8
class AdapplicationsController < ApplicationController
  include HomeHelper
=======
class AdapplicationsController < ApplicationController
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
  def dashboard
    @userclient=session[:userclient]
    @allapps=App.all
    @allsers=Serviceinst.all
    @preapps = App.order(updated_at: :desc) \
         .limit(4) \
         .all
    @presers = Serviceinst.order(updated_at: :desc) \
         .limit(4) \
         .all
  end
  def manage
    @userclient=session[:userclient]
    @allapps=App.all
  end
  def service
    @userclient=session[:userclient]
    @locapps=App.all
  end
  def unitapp
    @userclient=session[:userclient]
    appid=params[:id]
    @locapp=App.find_by_id appid
    @cfapps=@userclient.apps_by_name @locapp.appname
    @cfapps.each do |cfapp|
      @cfapp=cfapp if (cfapp.guid==@locapp.appguid)
    end
  end
end
