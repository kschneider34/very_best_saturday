class BookmarksController < ApplicationController
  before_action :current_user_must_be_bookmark_user, :only => [:edit_form, :update_row, :destroy_row]

  def current_user_must_be_bookmark_user
    bookmark = Bookmark.find(params["id_to_display"] || params["prefill_with_id"] || params["id_to_modify"] || params["id_to_remove"])

    unless current_user == bookmark.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @q = Bookmark.ransack(params[:q])
    @bookmarks = @q.result(:distinct => true).includes(:dish, :user, :venue).page(params[:page]).per(10)

    render("bookmark_templates/index.html.erb")
  end

  def show
    @bookmark = Bookmark.find(params.fetch("id_to_display"))

    render("bookmark_templates/show.html.erb")
  end

  def new_form
    @bookmark = Bookmark.new

    render("bookmark_templates/new_form.html.erb")
  end

  def create_row
    @bookmark = Bookmark.new

    @bookmark.dish_id = params.fetch("dish_id")
    @bookmark.user_id = params.fetch("user_id")
    @bookmark.venue_id = params.fetch("venue_id")

    if @bookmark.valid?
      @bookmark.save

      redirect_back(:fallback_location => "/bookmarks", :notice => "Bookmark created successfully.")
    else
      render("bookmark_templates/new_form_with_errors.html.erb")
    end
  end

  def create_row_from_dish
    @bookmark = Bookmark.new

    @bookmark.dish_id = params.fetch("dish_id")
    @bookmark.user_id = params.fetch("user_id")
    @bookmark.venue_id = params.fetch("venue_id")

    if @bookmark.valid?
      @bookmark.save

      redirect_to("/dishes/#{@bookmark.dish_id}", notice: "Bookmark created successfully.")
    else
      render("bookmark_templates/new_form_with_errors.html.erb")
    end
  end

  def create_row_from_venue
    @bookmark = Bookmark.new

    @bookmark.dish_id = params.fetch("dish_id")
    @bookmark.user_id = params.fetch("user_id")
    @bookmark.venue_id = params.fetch("venue_id")

    if @bookmark.valid?
      @bookmark.save

      redirect_to("/venues/#{@bookmark.venue_id}", notice: "Bookmark created successfully.")
    else
      render("bookmark_templates/new_form_with_errors.html.erb")
    end
  end

  def edit_form
    @bookmark = Bookmark.find(params.fetch("prefill_with_id"))

    render("bookmark_templates/edit_form.html.erb")
  end

  def update_row
    @bookmark = Bookmark.find(params.fetch("id_to_modify"))

    @bookmark.dish_id = params.fetch("dish_id")
    
    @bookmark.venue_id = params.fetch("venue_id")

    if @bookmark.valid?
      @bookmark.save

      redirect_to("/bookmarks/#{@bookmark.id}", :notice => "Bookmark updated successfully.")
    else
      render("bookmark_templates/edit_form_with_errors.html.erb")
    end
  end

  def destroy_row_from_dish
    @bookmark = Bookmark.find(params.fetch("id_to_remove"))

    @bookmark.destroy

    redirect_to("/dishes/#{@bookmark.dish_id}", notice: "Bookmark deleted successfully.")
  end

  def destroy_row_from_user
    @bookmark = Bookmark.find(params.fetch("id_to_remove"))

    @bookmark.destroy

    redirect_to("/users/#{@bookmark.user_id}", notice: "Bookmark deleted successfully.")
  end

  def destroy_row_from_venue
    @bookmark = Bookmark.find(params.fetch("id_to_remove"))

    @bookmark.destroy

    redirect_to("/venues/#{@bookmark.venue_id}", notice: "Bookmark deleted successfully.")
  end

  def destroy_row
    @bookmark = Bookmark.find(params.fetch("id_to_remove"))

    @bookmark.destroy

    redirect_to("/bookmarks", :notice => "Bookmark deleted successfully.")
  end
end
