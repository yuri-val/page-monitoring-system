module Api::V1
  class ArticlesController < ApiController
    before_action :set_article, only: [:show, :update, :destroy]

    # GET /articles
    def index
      @articles = Article.by_params(params)

      render json: @articles
    end

    # GET /articles/1
    def show
      render json: @article
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_article
        @article = Article.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def article_params
        params.require(:article).permit(:site_id, :article_url, :status_id, :current_version_id)
      end
  end
end
