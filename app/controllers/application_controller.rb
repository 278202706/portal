# encoding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login
  protected
  def require_login
    if session[:useremail]==nil
      session[:userclient]= nil
      session[:currentuser]= nil
      redirect_to :controller => "login", :action => "log"
    else
      account=Account.find_by_email session[:useremail]
      account="admin" if session[:useremail]=="admin"
      if account==nil
        redirect_to :controller => "login", :action => "log"
      end
    end
  end
  #before_action :require_login
  #
  #
  #protected
  #
  #def current_user
  #  @current_user ||= User.find_by_email(session[:useremail])
  #end
  #
  #def require_login
  #  if current_user.nil?
  #    user = User.find_by_remember_token(cookies[:auth_token]) unless cookies[:auth_token].blank?
  #
  #    if user.nil?
  #      reset_session
  #      session[:user_id] = nil
  #      redirect_to new_session_url
  #    else
  #      user.refresh_remember_token
  #      session[:user_id] = user.id
  #    end
  #  end
  #end


end
