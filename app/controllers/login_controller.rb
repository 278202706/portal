class LoginController < ApplicationController
	include LoginHelper
  def log
    @error=params[:error]
  end
  def index
    email=params[:email]
	  password=params[:password]
    session[:useremail]=email
    flag=1
    flag=0 if (email==""||email==nil)
    acc=Account.where({:email=>email,:password=>password}).first
    flag=0 if acc==[]
    if flag==0
      redirect_to :controller => "login", :action => "log",:error=>"wrong"  
    else
		client=target
		credentials = {
        :username => email,
        :password => password
		}
		client.login(credentials)
		#@client=login client,email,password
		session[:userclient]=client
		puts "----------------"
		puts session[:userclient]
    if email=="admin"
		session[:currentuser]="admin"
        redirect_to :controller => "adaccount", :action => "dashboard"  
    else
      session[:currentuser]=email
        redirect_to :controller => "applications", :action => "dashboard"
      end
    end
  end
  def logout
    session[:useremail]=nil
    session[:userclient]=nil
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
