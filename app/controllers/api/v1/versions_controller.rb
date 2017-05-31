module Api::V1
  class VersionsController < ApiController
    before_action :set_version, only: [:show, :text]

    # GET /versions
    def index
      @versions = Version.by_params(params)
      render json: @versions
    end

    # GET /versions/1
    def show
      render json: @version
    end

    def text
      type = params[:type]
      if type == 'plain_text' or type == 'html_text'
        render json: {text: @version[type.to_sym]}
      else
        render json: @version
      end
    end

    def diff
      id   = params[:id]
      o_id = params[:another_id]
      if id && o_id
        render html: DifferTool.new(id, o_id, params).diff
      end
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
