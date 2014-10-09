class UsersController < ApplicationController
  before_filter :find_user

  def create
    @user = User.create(params[:user])
    @user.create_role
    if is_referral?
      #give_shnack_credit( session[:referral], 555)
    end

    respond_to do |format|
      if @user.save
        # Tell the UserMailer to send a welcome Email after save
        UserMailer.welcome_email(@user).deliver
 
        format.html { redirect_to(@user, notice: 'User was successfully created.') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # tried it in the model
  def give_shnack_credit(creditor_id, amount)
    @creditor = User.find(creditor_id)
    creditor.account_credit = creditor.account_credit + amount
  end

  def find_user
    @user = params[:id].nil? ? current_user : User.find(params[:id])
  end


  def show
    @users = User.all
  end

  def new!
    UserMailer.welcome_email(@user).deliver
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

  private
    def is_referral?
      session[:referral].blank?
    end

end
