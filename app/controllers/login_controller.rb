# encoding: utf-8
class LoginController < ApplicationController
	include LoginHelper
  include HomeHelper
  skip_before_action :require_login
  def log
    @error=params[:error]
  end
  def index
    email=params[:email]
	  password=params[:password]

    flag=1
    if email=="admin"
      flag=0 if password!="admin"
    else
      flag=0 if (email==""||email==nil)
      acc=Account.where({:email=>email,:password=>password}).all
      flag=0 if (email!="admin"&&acc==[])
    end
    if flag==0
      redirect_to :controller => "login", :action => "log",:error=>"wrong"
      log= "登陆失败，用户名或密码有误"
      user="无效的用户"
      createlog user,log
    else
      credentials = {
          :username => email,
          :password => password
      }
    require 'timeout'
    begin
        client=target
        puts client
        client.login(credentials)
        session[:userclient]=client
        puts "----------------"
        puts session[:userclient]
        session[:currentuser]=email
        session[:useremail]=email
        if email=="admin"
          log= "管理员登陆成功"
          user=session[:useremail]
          createlog user,log
          redirect_to :controller => "adaccount", :action => "dashboard"
        else
          log= "用户登陆成功"
          user=session[:useremail]
          createlog user,log
          redirect_to :controller => "applications", :action => "dashboard"
        end

    rescue CFoundry::NotFound,CFoundry::TargetRefused
      log= "系统异常"
      user="无效的用户"
      createlog user,log
      redirect_to :controller => "login", :action => "log",:error=>"notfound"
    rescue Timeout::Error
      log= "登陆超时"
      user="无效的用户"
      createlog user,log
      redirect_to :controller => "login", :action => "log",:error=>"timeout"
    end
		#@client=login client,email,password
    end
  end
  def logout
    user=session[:useremail]
    session[:useremail]=nil
    session[:currentuser]=nil
    session[:userclient]=nil
    log= "退出登陆"
    createlog user,log
    redirect_to :controller => "home", :action => "index"
  end
  def profile
    respond_to do |format|
      format.js
      format.html #{render :json=> @traces}
    end
  end
  def setpwd

  end
  def loglist
    user=session[:useremail]
    @logs=get_user_logs user
  end


  def pwdchange
    @userclient=session[:userclient]
    @oldpw=params[:oldpassword]
    @newpw=params[:password]
    puts "4444444444444444444444"
    begin
        @userclient.current_user.change_password!(@newpw, @oldpw)
        log= "修改密码成功"
        user=session[:useremail]
        createlog user,log
        redirect_to :controller => "login", :action => "setpwd", :info => "success"
    rescue
      log= "修改密码失败"
      user=session[:useremail]
      createlog user,log
        redirect_to :controller => "login", :action => "setpwd", :info => "failure"
    end
  end

  def authented
    type = params[:type]
    value = params[:value]
    ret = nil
    if type == "name"
      if value=="admin"
        ret = "{:user=>admin}"
      else
        ret = Account.find_by_email(value)
      end

      session[:name]=value
    else
      #checksum = ApplicationHelper::md5 value
      ret = Account.where(:email=>session[:name],:password=>value)
      if ret.empty?
        ret = nil
      end
    end
    respond_to do|format|
      format.json {render :json=>ret}
    end
  end

end
