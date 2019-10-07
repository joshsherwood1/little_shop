class ItemsController<ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      redirect_to "/merchants/#{merchant.id}/items/new"
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      redirect_to "/items/#{item.id}"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      redirect_to "/items/#{item.id}/edit"
    end
  end

  def destroy
    item = Item.find(params[:id])
    if item.orders.empty?
      item.destroy
      redirect_to "/items"
    else
      flash[:delete_item_warning] = "This item has been ordered and cannot be deleted at this time."
      redirect_to "/items/#{item.id}"
    end
  end

  private

  def record_not_found
    redirect_to controller: 'items', action: 'index'
    flash[:error] = "The page you have selected does not exist"
  end

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

end
