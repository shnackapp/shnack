class UsersController < ApplicationController
  before_filter :find_user

  def find_user
    @user = params[:id].nil? ? current_user : User.find(params[:id])
  end

  def show
    @users = User.all
  end

  def new
  	super
  end

  def edit
  end

  def update
    #Update things from Role 
    r = @user.role
    r.is_super = params[:user].delete(:is_super) unless params[:user][:is_super].nil?
    r.role_type = params[:user].delete(:role_type) unless params[:user][:role_type].nil?
    r.stadium = Stadium.find(params[:user].delete(:stadium_id)) unless params[:user][:stadium_id].nil?
    r.save

    if params[:user][:current_password].empty? 
      params[:user].delete(:current_password)

      #if they tried to update the password, flash an error saying current password needs to be filled
      flash[:error] = "We need your current password to change your password" if !params[:user][:password].empty?

      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)

      @user.update_attributes(params[:user])
    end
    
    render "edit"

    # if !params[:user][:password].empty? || @user.update_with_password(params[:user])
    #   # Sign in the user by passing validation in case his password changed
    #   sign_in @user, :bypass => true unless params[:user][:password].empty? && current_user.id != @user.id
  	 #  redirect_to user_root_path

    # else
    #  
    # end


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
