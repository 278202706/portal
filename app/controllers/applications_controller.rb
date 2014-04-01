# encoding: utf-8
class ApplicationsController < ApplicationController
  include ApplicationsHelper
<<<<<<< HEAD
  include HomeHelper
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
  def dashboard
    curemail=session[:useremail]
    @userclient=session[:userclient]
    @account=Account.find_by_email curemail
    @org=@userclient.organization_by_user_guid @account.guid
    #@apps=App.find_by_userguid @account.guid
    @apps=App.where({userguid:@account.guid}).all
    #@serinsts=Serviceinst.find_by_userguid @account.guid
    @serinsts=Serviceinst.where({userguid:@account.guid}).all

  end

  def manage
    curemail=session[:useremail]
    @userclient=session[:userclient]
    @account=Account.find_by_email curemail
    @org=@userclient.organization_by_user_guid @account.guid
   # selector={userguid=>@account.guid}
    @apps=App.where({:userguid=>@account.guid}).all
    @appcodes=Appcode.where({:username=>curemail}).all
    @size=0
    @appcodes.each do |code|
      @size=@size+code.size.to_i
    end
    @size=@size/1024.0/1024.0
  end

  def service
    curemail=session[:useremail]
    @userclient=session[:userclient]
    @account=Account.find_by_email curemail
    @binds=@userclient.service_bindings
    @allser=Serviceinst.where({:username=>curemail}).all
    @allapp=App.where({:userguid=>@account.guid}).all
  end

  def unitapp
    curemail=session[:useremail]
    @userclient=session[:userclient]
    appid=params[:id]
    puts "*********************"+appid
    @app=App.find_by_id appid
    puts "*********************"+@app.appname
    @cfapp=@userclient.app_by_name @app.appname
    @avidomains=@cfapp.summary[:available_domains]
    @account=Account.find_by_email curemail
    @org=@userclient.organization_by_user_guid @account.guid
    @appcodes=Appcode.where({appguid:@app.appguid}).all
    @services=@userclient.service_instances
  end

  def uploadcode
    @userclient=session[:userclient]
    appid=params[:appid]
    curemail=session[:useremail]
    @app=App.find_by_id appid
    @cfapp=@userclient.app_by_name @app.appname
    @appname=params[:appname].to_s
    @codeversion=params[:codeversion]
    @tmpfile = params[:fileInput]
    @useremail=curemail
    result=upcode @appname,@useremail,@tmpfile,@userclient,@app.appguid,@codeversion
    if result=="success"
<<<<<<< HEAD
      log="用户上传版本号为"+@codeversion+"的代码成功，应用名称为"+@appname
      user=session[:useremail]
      createlog user,log
      redirect_to :controller=>"applications",:action=>"unitapp",:id=>appid ,:tab=>"tab2"
    else
      log="用户上传版本号为"+@codeversion+"的代码失败，应用名称为"+@appname
      user=session[:useremail]
      createlog user,log
=======
      redirect_to :controller=>"applications",:action=>"unitapp",:id=>appid ,:tab=>"tab2"
    else
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      #redirect_to :controller=>"applications",:action=>"unitapp",:id=>"123",:error=>"wrong"
      redirect_to :controller=>"applications",:action=>"unitapp",:id=>appid,:tab=>"tab2",:error=>"wrong"
    end
  end

  def creapplication
    curemail=session[:useremail]
    @account=Account.find_by_email curemail
    @apname=params[:appname]
    @apinnum=params[:appinsnum]
    @apsize=params[:appsize]
    #@apname="testapp2"
    #@apinnum="2"
    #@apspname="0"
    #@apsize="64"
    @userclient=session[:userclient]
    @space=@userclient.organizations[0].spaces[0]
    begin
      @app=initapp @userclient, @apname, @apinnum, @space, @apsize
      @newapp = App.new
      @newapp.username=session[:email]
      @newapp.userguid=@account.guid
      @newapp.appguid=@app.guid
      @newapp.active=false
      @newapp.appname=@apname
      @newapp.org=@userclient.organizations[0].name
      @newapp.space= @space.name
      @newapp.hascode="0"
      @newapp.save
<<<<<<< HEAD
      log="用户成功创建应用"+@appname.to_s
      user=session[:useremail]
      createlog user,log
=======
      act="成功创建应用"+@appname.to_s
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      redirect_to :controller => "applications", :action => "manage",:response=>"success"
        #createlog act
      #redirect_to :controller => "app", :action => "index"
    rescue Exception => e
      puts e
      puts '---------------------------------'
<<<<<<< HEAD
      log="用户创建应用"+@appname.to_s+"失败"
      user=session[:useremail]
      createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      redirect_to :controller => "applications", :action => "manage",:response=>"failure"

      #act="创建应用"+@appname.to_s+"失败"
      #createlog act
      #if e.to_s.include? "100002: The app name is taken:"
      #  redirect_to :controller => "app", :action => "sorrycreapp", :name => @apname, :type => "1"
      #else
      #  if e.to_s=="100005: You have exceeded your organization's memory limit. Please login to your account and upgrade. If you are trying to scale down and you are receiving this error, you can either delete an app or contact support."
      #    redirect_to :controller => "app", :action => "sorrycreapp", :name => e, :type => "2"
      #  else
      #    redirect_to :controller => "app", :action => "sorrycreapp", :name => e, :type => "3"
      #  end
      #end
    end


  end

  def deleteapp
    curemail=session[:useremail]
    @userclient=session[:userclient]
    @account=Account.find_by_email curemail
    @locapp=App.find_by_id params[:appid]
    @cfapp=@userclient.app_by_name @locapp.appname
<<<<<<< HEAD
    @appname=@locapp.appname
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    puts "-----------------"
    puts @cfapp.guid
    begin
    to_deleted_routes = @cfapp.routes
    to_deleted_routes.each { |r|
      r.delete!
    }
    #unbind service
    service_instances = @cfapp.services
    service_instances.each { |si|
      @cfapp.unbind si
    }
    @appcodes=Appcode.where({:appguid=>@locapp.appguid}).all
    @appcodes.each do |code|
      @path="#{Rails.root}/public/userdata/"+session[:useremail].to_s+"/"+code.zipname
      File.delete(@path.to_s)
      code.destroy
    end
    @locapp.destroy
    @cfapp.delete!
<<<<<<< HEAD
    log="用户删除应用"+@appname.to_s+"成功"
    user=session[:useremail]
    createlog user,log
    rescue
      log="用户删除应用"+@appname.to_s+"失败"
      user=session[:useremail]
      createlog user,log
=======
    rescue
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    end
    redirect_to :controller=>"applications",:action=>"manage"
  end


  def appbindser
    curemail=session[:useremail]
    @userclient=session[:userclient]
    @account=Account.find_by_email curemail
    serid=params[:serid]
    appid=params[:appid]
    @locser=Serviceinst.find_by_id serid
    @locapp=App.find_by_id appid
    @cfapp=@userclient.app_by_name @locapp.appname
    @ses=@userclient.service_instances_by_name @locser.name
    @ses.each do |se|
      if se.guid==@locser.serviceguid
        @cfser=se
      end
    end
    begin
      @cfapp.bind @cfser
      flag=1
    rescue
      flag=0
    end
    if flag=1
      if params[:type]=="1"
<<<<<<< HEAD
        log="用户绑定应用"+@locapp.appname.to_s+"与服务"+@locser.name+"成功"
        user=session[:useremail]
        createlog user,log
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"addsuccess"
      else
        log="用户绑定应用"+@locapp.appname.to_s+"与服务"+@locser.name+"成功"
        user=session[:useremail]
        createlog user,log
=======
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"addsuccess"
      else
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
        redirect_to :controller => "applications", :action => "service",:response=>"addsuccess"
      end
    else
      if params[:type]=="1"
<<<<<<< HEAD
        log="用户绑定应用"+@locapp.appname.to_s+"与服务"+@locser.name+"失败"
        user=session[:useremail]
        createlog user,log
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"addfailure"
      else
        log="用户绑定应用"+@locapp.appname.to_s+"与服务"+@locser.name+"失败"
        user=session[:useremail]
        createlog user,log
=======
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"addfailure"
      else
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
        redirect_to :controller => "applications", :action => "service",:response=>"addfailure"
      end
    end
  end

  def unbind
    appid=params[:appid]
    curemail=session[:useremail]
    @userclient=session[:userclient]
    @account=Account.find_by_email curemail
    @cfapp=@userclient.app_by_name params[:appname]
    @ses=@userclient.service_instances_by_name params[:sername]
    @ses.each do |se|
      if se.guid==params[:id]
        @cfser=se
      end
    end
    begin
      @cfapp.unbind @cfser
      flag=1
    rescue
      flag=0
    end
    if flag=1
      if params[:type]=="1"
<<<<<<< HEAD
        log="用户解绑应用"+@locapp.appname.to_s+"与服务"+@locser.name+"成功"
        user=session[:useremail]
        createlog user,log
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"unbindsuccess"
      else
        log="用户解绑应用"+@locapp.appname.to_s+"与服务"+@locser.name+"成功"
        user=session[:useremail]
        createlog user,log
=======
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"unbindsuccess"
      else
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
        redirect_to :controller => "applications", :action => "service",:response=>"unbindsuccess"
      end
    else
      if params[:type]=="1"
<<<<<<< HEAD
        log="用户解绑应用"+@locapp.appname.to_s+"与服务"+@locser.name+"失败"
        user=session[:useremail]
        createlog user,log
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"unbindfailure"
      else
        log="用户解绑应用"+@locapp.appname.to_s+"与服务"+@locser.name+"失败"
        user=session[:useremail]
        createlog user,log
=======
        redirect_to :controller => "applications", :action => "unitapp",:id=>appid,:tab=>"tab4",:response=>"unbindfailure"
      else
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
        redirect_to :controller => "applications", :action => "service",:response=>"unbindfailure"
      end
    end
  end


  def addroute
    @hostname=params[:hostname]
    @domainname=params[:domainname]
    @userclient=session[:userclient]
    appid=params[:appid]
    @app=App.find_by_id appid
    @cfapp=@userclient.app_by_name @app.appname
    @space=@userclient.organizations[0].spaces[0]
    @domain=@space.domain_by_name @domainname.to_s
    puts "&&&&&&&&&&&&&&&&&&&&&&&&77"
    puts @domain
    @host=@hostname.to_s
    @route=find_or_create_route @domain, @host, @space
    if @route=="sorry"
<<<<<<< HEAD
      log="用户给应用"+@appname.to_s+"添加路由"+@route.name.to_s+"失败,"+"路由名称已被使用"
      user=session[:useremail]
      createlog user,log
=======
      act="给应用"+@appname.to_s+"添加路由"+@route.to_s+"失败,"+"路由名称已被使用"
      #createlog act
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      redirect_to :controller => "applications",:action => "unitapp", :id => @app.id, :type => "erradroure"
    else
      begin
        @cfapp.add_route @route
<<<<<<< HEAD
        log="用户给应用"+@appname.to_s+"添加路由"+@route.name.to_s+"成功"
        user=session[:useremail]
        createlog user,log
        redirect_to :controller => "applications", :action => "unitapp", :id => @app.id
      rescue Exception => e
        log="用户给应用"+@appname.to_s+"添加路由"+@route.name.to_s+"失败"
        user=session[:useremail]
        createlog user,log
=======
        act="成功给应用"+@appname.to_s+"添加路由"+@route.to_s
       # createlog act
        redirect_to :controller => "applications", :action => "unitapp", :id => @app.id
      rescue Exception => e
        act="给应用"+@appname.to_s+"添加路由"+@route.to_s+"失败"
       # createlog act
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
        redirect_to :controller => "applications", :action => "unitapp", :id => @app.id,  :type => "erradrou"
      end
    end
  end


  def deleteroute
    id=params[:id]
    app=App.find_by_id id
    @appname=app.appname
    @hostname=params[:type]
    @userclient=session[:userclient]
    @appnow=@userclient.organizations[0].spaces[0].app_by_name @appname.to_s
    @route=@appnow.routes_by_host @hostname
    @routename=@route[0].name
    begin
      @route[0].delete!
<<<<<<< HEAD
      log="用户成功删除应用*"+@appname.to_s+"的路由"+@routename
      user=session[:useremail]
      createlog user,log
      redirect_to :controller => "applications", :action => "unitapp", :id => app.id
    rescue Exception => e
      log="用户删除应用"+@appname.to_s+"的路由"+@routename+"失败"
      user=session[:useremail]
      createlog user,log
=======
      act="成功删除应用*"+@appname.to_s+"的路由"+@routename
      #createlog act
      redirect_to :controller => "applications", :action => "unitapp", :id => app.id
    rescue Exception => e
      act="删除应用"+@appname.to_s+"的路由"+@routename+"失败"
      #createlog act
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      redirect_to :controller => "applications", :action => "unitapp", :id => app.id, :type => "errderou"
    end

  end

  def deletecode
    @codeid=params[:id]
    @appid=params[:appid]
    @nowappinf=Appcode.find_by_id @codeid
    @path="#{Rails.root}/public/userdata/"+session[:useremail].to_s+"/"+@nowappinf.zipname
    begin
      File.delete(@path.to_s)
<<<<<<< HEAD
      log="用户成功删除应用"+@nowappinf.appname.to_s+"的代码包，版本号为："+@nowappinf.version
      user=session[:useremail]
      createlog user,log
=======
      act="成功删除应用"+@appname.to_s+"的代码包，版本号为："
      #createlog act
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      @nowappinf.destroy
      redirect_to :controller => "applications", :action => "unitapp", :id => @appid, :tab=>"tab2"
    rescue Exception => e
      puts   session[:useremail].to_s +@codeid.to_s
      puts "/////////////////////"+e.to_s
<<<<<<< HEAD
      log="用户删除应用"+@nowappinf.appname.to_s+"的代码包失败，版本号为："+@nowappinf.version
      user=session[:useremail]
      createlog user,log
=======
      act="删除应用"+@appname.to_s+"的代码包失败，版本号为："
      #createlog act
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      redirect_to :controller => "applications", :action => "unitapp", :id => @appid, :tab=>"tab2", :type => "errdecode"
    end
  end

  def downcode
    @codeid=params[:id]
    @nowappinf=Appcode.find_by_id @codeid
    @path="#{Rails.root}/public/userdata/"+session[:useremail].to_s+"/"+@nowappinf.zipname
    send_file @path
<<<<<<< HEAD
    log="用户下载应用"+@nowappinf.appname.to_s+"的代码包成功，版本号为："+@nowappinf.version
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
  end

  def stopcode
    @codeid=params[:id]
    @appid=params[:appid]
    @nowappinf=Appcode.find_by_id @codeid
    @path="#{Rails.root}/public/userdata/"+session[:useremail].to_s+"/"+@nowappinf.zipname
    @nowappinf.active=false
    @nowappinf.save
<<<<<<< HEAD
    log="用户停用应用"+@nowappinf.appname.to_s+"的代码包，版本号为："+@nowappinf.version
    user=session[:useremail]
    createlog user,log
=======
   # act="停用应用"+@appname.to_s+"的代码包，版本号为："+@codeversion
   # createlog act
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    @nowapp=App.find_by_id @appid
    if @nowapp.active == true
      @appnow.stop!
      @nowapp.active = false
    else
    end
    @nowapp.version=nil
    @nowapp.zipfilename=nil
    @nowapp.appframework=nil
    @nowapp.save
    redirect_to :controller => "applications", :action => "unitapp", :id => @appid, :tab=>"tab2"
  end

  def usecode
    @codeid=params[:id]
    @appid=params[:appid]
    @nowappinf=Appcode.find_by_id @codeid
    @username=session[:useremail]
    require 'pathname'
    zipfilename=@nowappinf.zipname
    directory = Pathname.new("#{Rails.root}/public/userdata/"+@username)
    path = File.join(directory.to_s, zipfilename)
    dirpath = File.join("#{Rails.root}/public/userdata/"+@username.to_s, @nowappinf.appname.to_s)
    require "fileutils"
    puts "------------"+dirpath
    FileUtils.remove_dir(dirpath)
    Dir.mkdir(dirpath)
    @path=dirpath
    require "rubygems"
    require "zip/zip"
    Zip::ZipFile.open(path) do |zipfile|
      zipfile.each do |zf|
        path=File.join(@path.to_s, zf.name)
        zipfile.extract(zf, path) { true }
      end
    end
      @nowappinf.active=true
      @nowappinf.save
      @allappinfs=Appcode.where({appguid:@nowappinf.appguid}).all
      @allappinfs.each do |allappinf|
        if allappinf.zipname!=@nowappinf.zipname
          allappinf.active=false
          allappinf.save
        end
      end
      @nowapp=App.find_by_id @appid
      @nowapp.version=@nowappinf.version
      @nowapp.zipfilename=@nowappinf.zipname
      @nowapp.appframework=@nowappinf.appdetect
      @nowapp.save
<<<<<<< HEAD
    log="用户启用应用"+@nowappinf.appname.to_s+"的代码包，版本号为："+@nowappinf.version
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller => "applications", :action => "unitapp", :id => @appid, :tab=>"tab2"
  end

  def changeappname
    newname=params[:appname]
    @userclient=session[:userclient]
    appid=params[:appid]
    @app=App.find_by_id appid
    @cfapp=@userclient.app_by_name @app.appname
<<<<<<< HEAD
    oldname=@cfapp.name
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    @cfapp.name=newname
    @cfapp.update!
    @app.appname=newname
    @app.save
    @allappinfs=Appcode.where({appguid:@app.appguid}).all
    @allappinfs.each do |allappinf|
        allappinf.appname=newname
        allappinf.save
    end
<<<<<<< HEAD
    log="用户修改应用"+oldname+"的名称为："+newname
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller => "applications", :action => "unitapp", :id => appid
  end

  def changeappinstnum
    @newnum=params[:instnum]
    @userclient=session[:userclient]
    appid=params[:appid]
    @app=App.find_by_id appid
    @cfapp=@userclient.app_by_name @app.appname
    @cfapp.total_instances= @newnum.to_i
    @cfapp.update!
<<<<<<< HEAD
    log="用户修改应用"+@app.appname+"的实例个数为："+@newnum
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller => "applications", :action => "unitapp", :id => appid
  end

  def startapp
    @userclient=session[:userclient]
    @username=session[:useremail]
    appid=params[:id]
    @app=App.find_by_id appid
    @cfapp=@userclient.app_by_name @app.appname
    @path = File.join("#{Rails.root}/public/userdata/"+session[:useremail].to_s, @app.appname.to_s)
    @cfapp.upload @path.to_s
    @app.startime=Time.now
    @app.save
    t2=Thread.new do
      puts "app"+@app.appname.to_s
<<<<<<< HEAD
      @app.delay.startheapp(@cfapp,@username,@userclient)
=======
      @app.delay.startheapp(@cfapp,@username)
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
      @app.active=true
      @app.save
    end
    #t2=Thread.new do
    #    #@cfapp.start!
    #    startheapp @cfapp
    #    @app.active=true
    #    @app.save
    #end
<<<<<<< HEAD
    log="用户启动应用"+@app.appname
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller => "applications", :action => "unitapp", :id => appid
  end

  def restartapp
    @userclient=session[:userclient]
    appid=params[:id]
    @app=App.find_by_id appid
<<<<<<< HEAD
    @username=session[:useremail]
    @cfapp=@userclient.app_by_name @app.appname
    #@cfapp.restart!
    @cfapp.stop!
    t5=Thread.new do
      puts "app"+@app.appname.to_s
      @app.delay.startheapp(@cfapp,@username,@userclient)
      @app.active=true
      @app.save
    end
    log="用户重启应用"+@app.appname
    user=session[:useremail]
    createlog user,log
=======
    @cfapp=@userclient.app_by_name @app.appname
    @cfapp.restart!
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller => "applications", :action => "unitapp", :id => appid
  end

  def stopapp
    @userclient=session[:userclient]
    appid=params[:id]
    @app=App.find_by_id appid
    @cfapp=@userclient.app_by_name @app.appname
      @cfapp.stop!
    @app.active=false
    @app.save
<<<<<<< HEAD
    log="用户停止应用"+@app.appname
    user=session[:useremail]
    createlog user,log
=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    redirect_to :controller => "applications", :action => "unitapp", :id => appid
  end


  def authented
    type = params[:type]
    value = params[:value]
    curemail=session[:useremail]
    @account=Account.find_by_email curemail
    ret = nil
    ret = App.where({:userguid=>@account.guid,:appname=>value}).all  if type == "appname"
    if type=="hostname"
      @hostname=value
      @domainname=params[:domainname]
      @userclient=session[:userclient]
      @space=@userclient.organizations[0].spaces[0]
      @domain=@space.domain_by_name @domainname.to_s
      host=@hostname.to_s
      route=find_route(@domain, host)
      if route==nil
        ret=[]
      else
        ret={:res=>"invalid"}
      end
    end

    ret={:res=>"valid"} if ret==[]

    #jsonpcallback = params['jsonpcallback']
    @res="#{ret.to_json}"
    respond_to do|format|
      format.json {render :json=>@res}
    end
  end


  def getinfo
   # t3=Thread.new do
    appid = params[:appid]
<<<<<<< HEAD
    timetype=params[:timetype].to_s
    curemail=session[:useremail]
    app=App.find_by_id appid
    if timetype=="1"
      appinfos=Appstartpro.where({:username=>curemail,:appid=>app.appguid,:token=>"no"}).all
    else
      startime=app.startime
      appinfos=Appstartpro.where("created_at >= :start_date",{:start_date=>startime,:username=>curemail,:appid=>app.appguid}).all
    end
=======
    curemail=session[:useremail]
    app=App.find_by_id appid
    appinfos=Appstartpro.where({:username=>curemail,:appid=>app.appguid,:token=>"no"}).all
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    appinfos.each do |info|
      info.token="yes"
      info.save
    end
<<<<<<< HEAD
=======

>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
    ret=appinfos

    #jsonpcallback = params['jsonpcallback']
    @res="#{ret.to_json}"
    respond_to do|format|
      format.json {render :json=>@res}
    end
    #end
    #t3.join
  end


end
