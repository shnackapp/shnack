class UsersController < ApplicationController
  before_filter :find_user

  def find_user
    @user = params[:id].nil? ? current_user : User.find(params[:id])
  end

  def new
  	super
  end

  def edit
  end

  def update

    #Update things from Role 
    r = @user.role
    r.is_super = params[:user].delete(:is_super)
    r.role_type = params[:user].delete(:role_type)
    r.stadium = Stadium.find(params[:user].delete(:stadium_id))
    r.save
    

    if params[:user][:password].empty? || @user.update_with_password(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true unless params[:user][:password].nil?
  	  redirect_to user_root_path

    else
      render "edit"
    end


  end

  def create_vendor
    v = Vendor.create(params[:vendor])
    v.build_menu
    v.save

    r = @user.role
    r.vendors << v
    r.save
    
    redirect_to user_root_path
  end

end
