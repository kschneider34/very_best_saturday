class FavoritesController < ApplicationController
  before_action :current_user_must_be_favorite_user, :only => [:edit_form, :update_row, :destroy_row]

  def current_user_must_be_favorite_user
    favorite = Favorite.find(params["id_to_display"] || params["prefill_with_id"] || params["id_to_modify"] || params["id_to_remove"])

    unless current_user == favorite.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @q = Favorite.ransack(params[:q])
    @favorites = @q.result(:distinct => true).includes(:dish, :user, :venue).page(params[:page]).per(10)

    render("favorite_templates/index.html.erb")
  end

  def show
    @favorite = Favorite.find(params.fetch("id_to_display"))

    render("favorite_templates/show.html.erb")
  end

  def new_form
    @favorite = Favorite.new

    render("favorite_templates/new_form.html.erb")
  end

  def create_row
    @favorite = Favorite.new

    @favorite.dish_id = params.fetch("dish_id")
    @favorite.user_id = params.fetch("user_id")
    @favorite.venue_id = params.fetch("venue_id")

    if @favorite.valid?
      @favorite.save

      redirect_back(:fallback_location => "/favorites", :notice => "Favorite created successfully.")
    else
      render("favorite_templates/new_form_with_errors.html.erb")
    end
  end

  def create_row_from_dish
    @favorite = Favorite.new

    @favorite.dish_id = params.fetch("dish_id")
    @favorite.user_id = params.fetch("user_id")
    @favorite.venue_id = params.fetch("venue_id")

    if @favorite.valid?
      @favorite.save

      redirect_to("/dishes/#{@favorite.dish_id}", notice: "Favorite created successfully.")
    else
      render("favorite_templates/new_form_with_errors.html.erb")
    end
  end

  def create_row_from_venue
    @favorite = Favorite.new

    @favorite.dish_id = params.fetch("dish_id")
    @favorite.user_id = params.fetch("user_id")
    @favorite.venue_id = params.fetch("venue_id")

    if @favorite.valid?
      @favorite.save

      redirect_to("/venues/#{@favorite.venue_id}", notice: "Favorite created successfully.")
    else
      render("favorite_templates/new_form_with_errors.html.erb")
    end
  end

  def edit_form
    @favorite = Favorite.find(params.fetch("prefill_with_id"))

    render("favorite_templates/edit_form.html.erb")
  end

  def update_row
    @favorite = Favorite.find(params.fetch("id_to_modify"))

    @favorite.dish_id = params.fetch("dish_id")
    
    @favorite.venue_id = params.fetch("venue_id")

    if @favorite.valid?
      @favorite.save

      redirect_to("/favorites/#{@favorite.id}", :notice => "Favorite updated successfully.")
    else
      render("favorite_templates/edit_form_with_errors.html.erb")
    end
  end

  def destroy_row_from_dish
    @favorite = Favorite.find(params.fetch("id_to_remove"))

    @favorite.destroy

    redirect_to("/dishes/#{@favorite.dish_id}", notice: "Favorite deleted successfully.")
  end

  def destroy_row_from_user
    @favorite = Favorite.find(params.fetch("id_to_remove"))

    @favorite.destroy

    redirect_to("/users/#{@favorite.user_id}", notice: "Favorite deleted successfully.")
  end

  def destroy_row_from_venue
    @favorite = Favorite.find(params.fetch("id_to_remove"))

    @favorite.destroy

    redirect_to("/venues/#{@favorite.venue_id}", notice: "Favorite deleted successfully.")
  end

  def destroy_row
    @favorite = Favorite.find(params.fetch("id_to_remove"))

    @favorite.destroy

    redirect_to("/favorites", :notice => "Favorite deleted successfully.")
  end
end
