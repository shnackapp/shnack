class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])
    if @order.vendor.nil?
      @owner = @order.restaurant
    else
      @owner = @order.vendor 
    end
    @menu = @owner.menu


    @items = Hash[@menu.items.map{|it| [it.id, it]}]
    @order_details = parse_order_details @order.details
    # @charge = Stripe::Charge.retrieve(params[:charge])


    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @order }
    # end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new

    if params[:vendor_id].nil?
      @owner = Restaurant.find(params[:restaurant_id])
    else
      @owner = Vendor.find(params[:vendor_id])
    end
    @menu = @owner.menu

    # @vendor = Vendor.find(params[:vendor_id])
    @order = Order.new
    # @stadium = @vendor.stadium

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    details = ""
    amount = 0

    if params[:order][:vendor_id].nil?
      owner = Restaurant.find(params[:order].delete(:restaurant_id), :include => {:menu => :items})
    else
      owner = Vendor.find(params[:order].delete(:vendor_id), :include => {:menu => :items})
    end

    user_id = params[:order].delete(:user_id)
    items = owner.menu.items
    items_price = Hash[items.map { |it| [it.id, (it.price*100).to_int]}]

    params[:order].delete(:item).each { |id, qty|
      unless qty == 0
        details += "#{id} #{qty} "

        cost = qty.to_i * items_price[id.to_i]
        amount += cost
      end
    }

    params[:order][:amount] = amount
    params[:order][:details] = details


    @order = Order.new(params[:order])
    owner.instance_of?(Vendor) ? @order.vendor = owner : @order.restaurant = owner
    @order.user = current_user

    redirect_to new_order_charge_path(@order) if @order.save

    # respond_to do |format|
    #   if @order.save
    #     format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #     format.json { render json: @order, status: :created, location: @order }
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def add_number_to_order
    @order = Order.find(params[:order_id])
    @user = User.where(:number => params[:number]).first_or_create(:email => "guest@shnackapp.com", :password => "welcome_to_shnack")
    @order.user = @user
    @order.save
    render :json => @order
  end

end
