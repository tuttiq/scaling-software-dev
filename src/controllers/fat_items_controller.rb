class ItemsController < ApplicationController
  def index
    current_user = User.find(params[:user_id])
    if current_user.logged_in?
      @items  = Item.sort(:position, :name).all
    else
      flash[:error] = I18n.t('errors.not_logged_in')
      redirect_to login_path
    end
  end

  def new
    current_user = User.find(params[:user_id])
    if current_user.logged_in?
      @item = Item.new
      render 'items/new'
    else
      flash[:error] = I18n.t('errors.not_logged_in')
      redirect_to login_path
    end
  end

  def edit
    current_user = User.find(params[:user_id])
    if current_user.logged_in?
      @item = Item.new
      render 'items/new'
    else
      flash[:error] = I18n.t('errors.not_logged_in')
      redirect_to login_path
    end
  end

  def create
    parse_color_params
    @item = Item.new item_params
    @item.published = false
    @item.sold = false

    if @item.save
      render 'items/details', item: @item, notice: t('items.create.success')
    else
      flash[:error] = parse_error_messages(@item)
      render :new
    end
  end

  # ... many other necessary actions here

  private

  def parse_color_params
    if params[:item][:color] == '#000000'
      params[:item][:color] = :black
    elsif params[:item][:color] == '#FFFFFF'
      params[:item][:color] = :white
    else
      params[:item][:color] = :other
    end
  end

  def parse_error_messages(item)
    error_messages = []
    if item.errors[:name].any?
      error_messages << I18n.t('items.errors.name')
    end
    if item.errors[:color].any?
      error_messages << I18n.t('items.errors.color')
    end
  end

  def item_params
    params
      .require(:item)
      .permit(:name, :color, :price)
  end
end
