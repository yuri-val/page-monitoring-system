module Api::V1
  class SitesController < ApiController
    before_action :set_site, only: %i[show update destroy]

    # GET /sites
    def index
      @sites = Site.all

      render json: @sites
    end

    # GET /sites/1
    def show
      render json: @site
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def site_params
      params.require(:site).permit(:site_url, :article_url_tmpl, :article_content_tag, :paginator_url_tmpl, :pages_to_scan)
    end
  end
end
