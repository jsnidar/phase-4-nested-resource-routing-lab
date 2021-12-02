class ItemsController < ApplicationController

  def index
    if params[:user_id]
      if User.find_by(id: params[:user_id])
        user = User.find_by(id: params[:user_id])
        items = user.items
      else
        return render json: { error: "User not found" }, status: :not_found
      end
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if Item.find_by(id: params[:id])
      item = Item.find_by(id: params[:id])
      render json: item
    else
      render json: { error: "Item not found" }, status: :not_found
    end
  end

  def create
    user = User.find_by(id: params[:user_id])
    item = user.items.create!(user_params)
    render json: item, status: :created
  rescue ActiveRecord::RecordInvalid => invalid 
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

  private 

  def user_params
    params.permit(:name, :price, :description)
  end

end
