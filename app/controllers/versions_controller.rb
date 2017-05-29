class VersionsController < ApplicationController
  before_action :set_version, only: [:show, :update, :destroy]

  # GET /versions
  def index
    @versions = Version.all

    render json: @versions
  end

  # GET /versions/1
  def show
    render json: @version
  end

  # POST /versions
  def create
    @version = Version.new(version_params)

    if @version.save
      render json: @version, status: :created, location: @version
    else
      render json: @version.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /versions/1
  def update
    if @version.update(version_params)
      render json: @version
    else
      render json: @version.errors, status: :unprocessable_entity
    end
  end

  # DELETE /versions/1
  def destroy
    @version.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_version
      @version = Version.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def version_params
      params.require(:version).permit(:article_id, :html_text, :plain_text)
    end
end
