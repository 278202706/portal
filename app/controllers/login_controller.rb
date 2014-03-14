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

end
