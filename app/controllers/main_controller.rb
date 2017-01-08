class MainController < ApplicationController

  def index
  end

  def search
    if params[:commit].blank?
      @images = Image.page(params[:page]).per(5)
    else
      # @images = Image.joins(:camera).where cameras: { model: params[:camera] }
      filters = {}
      if params[:camera].present?
        filters[:camera] = Camera.find_by(model: params[:camera])
      end
      if params[:lens].present?
        filters[:lens] = Lens.find_by(model: params[:lens])
      end
      filters[:focal_length] = params[:focal_length] if params[:focal_length].present?
      filters[:aperture] = params[:aperture] if params[:aperture].present?
      filters[:iso] = params[:iso] if params[:iso].present?
      if filters.blank?
        @images = {}
      else
        @images = Image.where(filters).page(params[:page]).per(5)
      end
    end
  end

end
