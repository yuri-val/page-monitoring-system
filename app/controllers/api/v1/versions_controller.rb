module Api::V1
  class VersionsController < ApiController
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
end
