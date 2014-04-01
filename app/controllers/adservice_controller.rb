<<<<<<< HEAD
# encoding: utf-8
class AdserviceController < ApplicationController
  include HomeHelper
=======
class AdserviceController < ApplicationController
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
  def dashboard
    @userclient=session[:userclient]
    @oklists=Servicelist.where({:active=>true}).all
    @waitlists=Servicelist.where({:active=>false,:isrej=>"no"}).all
    @rejlists=Servicelist.where({:active=>false,:isrej=>"yes"}).all
  end
  def manage
    @userclient=session[:userclient]
    @allsers=Serviceinst.all
  end

  def viewmysql
    @userclient=session[:userclient]
    serid=params[:id]
    @serinst=Serviceinst.where({:id=>serid}).first
    @ses=@userclient.service_instances_by_name @serinst.name
    @ses.each do |se|
      if se.guid==@serinst.serviceguid
        @thisser=se
      end
    end
    @serlist=Servicelist.where({:name=>@serinst.name,:username=>@serinst.username,:type=>@serinst.sertype}).first
  end

  def msgform
    if params[:msgtype]=="day"
    @getaccyear=params[:yearseld]
    @getaccmonth=params[:monthseld]
    @getaccday=params[:dayseld]
    else
      if  params[:msgtype]=="month"
        @getaccyear=params[:yearselm]
        @getaccmonth=params[:monthselm]
      else
        @getaccyear=params[:yearsely]
      end
    end
    @getnowyear=Time.now.year
    if @getaccyear==nil
      @showyear=@getnowyear
    else
      @showyear=@getaccyear
    end
    @getnowmonth=Time.now.strftime("%Y%m")
    if @getaccmonth==nil
      @showmonth=@getnowmonth
    else
      @showmonth=@getaccyear.to_s+@getaccmonth.to_s
    end
    @getnowday=Time.now.strftime("%Y%m%d")
    if @getaccday==nil
      @showday=@getnowday
    else
      @showday=@getaccyear.to_s+@getaccmonth.to_s+@getaccday.to_s
    end
  end
  def accform
    if params[:msgtype]=="day"
      @getaccyear=params[:yearseld]
      @getaccmonth=params[:monthseld]
      @getaccday=params[:dayseld]
    else
      if  params[:msgtype]=="month"
        @getaccyear=params[:yearselm]
        @getaccmonth=params[:monthselm]
      else
        @getaccyear=params[:yearsely]
      end
    end
    @getnowyear=Time.now.year
    if @getaccyear==nil
      @showyear=@getnowyear
    else
      @showyear=@getaccyear
    end
    @getnowmonth=Time.now.strftime("%Y%m")
    if @getaccmonth==nil
      @showmonth=@getnowmonth
    else
      @showmonth=@getaccyear.to_s+@getaccmonth.to_s
    end
    @getnowday=Time.now.strftime("%Y%m%d")
    if @getaccday==nil
      @showday=@getnowday
    else
      @showday=@getaccyear.to_s+@getaccmonth.to_s+@getaccday.to_s
    end
  end

  def rejser
    serlistid=params[:id]
    @serlist=Servicelist.find_by_id serlistid
    @serlist.reject_at= Time.now
    @serlist.isrej="yes"
    @serlist.save
<<<<<<< HEAD
    log="管理员拒绝账号"+@serlist.username+"的服务申请，编号为"+@serlist.id.to_s
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller=>"adservice",:action=>"dashboard"
  end

end
