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

    @vendor = @order.vendor
    @items = Hash[@order.vendor.menu.items.map{|it| [it.id, it]}]
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
    @vendor = Vendor.find(params[:vendor_id])
    @order = Order.new
    

    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @order }
    # end
  end

  # GET /orders/1/edit
  def edit
    @vendor = Vendor.find(params[:vendor_id])
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    details = ""
    amount = 0

    v = Vendor.find(params[:order].delete(:vendor_id), :include => {:menu => :items})
    user_id = params[:order].delete(:user_id)
    items = v.menu.items
    items_price = Hash[items.map { |it| [it.id, (it.price*100).to_int]}]

    params[:order].delete(:item).each { |id, qty|
      unless qty.to_i == 0
        details += "#{id} #{qty} "

        cost = qty.to_i * items_price[id.to_i]
        amount += cost
      end
    }

    #if total order price = 0, redirect to new order
    if amount == 0 
      flash[:error] = "Order cannot be empty"
      redirect_to new_order_path(:vendor_id => v.id)
    else


      params[:order][:amount] = amount
      params[:order][:details] = details

      guest_params = params[:order].delete(:guest)


      @order = Order.new(params[:order])

      @order.vendor = v
      if user_signed_in?
        @order.user = current_user
      else
        guest = Guest.create(guest_params)
        @order.guest = guest
      end

      redirect_to new_order_charge_path(@order) if @order.save
    end

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
end
