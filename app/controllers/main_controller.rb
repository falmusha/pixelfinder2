class MainController < ApplicationController

  PER_PAGE = 5

  def index
  end

  def search
    if params[:commit].blank?
      @images = Image.page(params[:page]).per(PER_PAGE)
    else
      filters = {}
      if params[:camera].present?
        filters[:camera] = Camera.find_by(model: params[:camera].strip.downcase)
      end
      if params[:lens].present?
        filters[:lens] = Lens.find_by(model: params[:lens].strip.downcase)
      end
      if params[:focal_length].present?
        filters[:focal_length] = params[:focal_length].strip.downcase
      end
      filters[:aperture] = params[:aperture].to_i if params[:aperture].present?
      filters[:iso] = params[:iso].to_i if params[:iso].present?
      if filters.blank?
        @images = {}
      else
        @images = Image.where(filters).page(params[:page]).per(PER_PAGE)
      end
    end
  end

end