class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :add_trade, :cancel_bid, :delete_image_attachment]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  #before_action :establish, only:  [:add_trade]
  before_action :has_not_been_traded_assertion, only: [:edit, :update, :add_trade, :cancel_bid, :destroy]
  before_action :bid_has_not_been_traded_assertion, only: [:add_trade, :cancel_bid]

  # GET /items
  # GET /items.json
  def index
    item_per_page = 10
    page_num = params['page_num'].present? ? params['page_num'].to_i : 1
    
    #queried_items = sorted_items(
     # Item.where(trade_established: false)
     # )
     # .offset((page_num - 1) * item_per_page)
     # .limit(item_per_page + 1)
    queried_itemsRails.cache.fetch("querieditems", expires_in: 10.minutes) do
      sorted_items(
         Item.where(trade_established: false)
        )
        .offset((page_num - 1) * item_per_page)
        .limit(item_per_page + 1)
    end
    @prev_page = page_num == 1 ? nil : page_num - 1
    @next_page = queried_items.length <= item_per_page ? nil : page_num + 1
    @items = queried_items.limit(item_per_page)
  end

  # GET /items/1
  # GET /items/1.json
  def show
    session[:return_to] = request.referer
    if @item.trade_established 
      @traded_item = @item.traded_item
    end
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
    @item.user = current_user

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render new_item_path, notice: 'Cannot create item' }
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
      unless @item.save && bidding_with.save
        bidding_with.trade_established = false
        respond_to do |format|
          # refresh page with error
          format.html { redirect_to @item, alert: "Cannot establish trade" }
          format.json { render json: @item.errors, status: :unprocessable_entity}
        end
        return
      end
    end
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Sucessfully bid #{bidding_with.name} for #{@item.name}" }
        format.json { render :show, status: :ok, location: @item }
        
      else 
        format.html { redirect_to @item, alert: 'Some unknown error' }
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
        format.json { render json: @item.errors, status: :unprocessable_entity}
      end
    end
   
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find(params[:image_id])
    @image.purge_later
    redirect_to Item.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:category, :name, :description, images: [])
    end

    def has_not_been_traded_assertion
      if @item.trade_established 
        respond_to do |format|
          format.html { redirect_to @item, alert: 'The item has been traded. You cannot modify it'}
          format.html { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end

    def bid_has_not_been_traded_assertion
      if params[:bid_id].present?
        item = Item.find(params[:bid_id])
        if item.trade_established 
          respond_to do |format|
            format.html { redirect_to item, alert: 'The item has been traded. You cannot modify it'}
            format.html { render json: item.errors, status: :unprocessable_entity }
          end
        end
      end
    end

end
