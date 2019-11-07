class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :add_trade, :cancel_bid]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  #before_action :establish, only:  [:add_trade]

  # GET /items
  # GET /items.json
  def index
    @items = sorted_items(Item.all)
  end

  # GET /items/1
  # GET /items/1.json
  def show
    session[:return_to] = request.referer
  end

  # GET /items/new
  def new
    @item = Item.new(user_id: current_user.id)
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_trade 

    bidding_with = Item.find(params[:bid_id])
    
      if @item.trade_established && bidding_with.trade_established
        respond_to do |format|
          #format.html { render @item }
          format.html { redirect_to @item, alert: "failed to bid #{@item.name} because items has been traded" }
          format.json { render json: @item.errors, status: :unprocessable_entity}
        end
        return
      end
   
    
    
    
    @item.bid_by << bidding_with
    if bidding_with.bid_by.include?(@item)
      @item.trade_established = true
      bidding_with.trade_established = true
    end
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Sucessfully bid #{bidding_with.name} for #{@item.name}" }
        format.json { render :show, status: :ok, location: @item }
        
      else 
        format.html { render @item }
        format.json { render json: @item.errors, status: :unprocessable_entity}
      end
    end
   
  end

  def cancel_bid
    
    bidding_with = Item.find(params[:bid_id])
    @item.bid_by.delete(bidding_with)
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Sucessfully cancelled #{bidding_with.name} for #{@item.name}" }
        format.json { render :show, status: :ok, location: @item }
      else 
        format.html { render @item }
        format.json { render json: @item.erros, status: :unprocessable_entity}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:category, :name, :user_id, :description)
    end

   # def establish
    #  @item = Item.find(params[:id])
     # respond_to do |format|
      #  if @item.trade_established
       #   format.html { render @item }
        #  format.html { redirect_to @item, alert: "failed to bid #{@item.name} because  #{@item.name} has been traded" }
         # format.json { render json: @item.erros, status: :unprocessable_entity}
        #end
     # end
    #end
end
