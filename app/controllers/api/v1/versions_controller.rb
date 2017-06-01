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
      render content_by_type
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

      def content_by_type
        id   = params[:id]
        o_id = params[:another_id]
        type = (params[:type] || :json).to_sym
        diff = DifferTool.new(id, o_id, params)
        data = if type == :html
                {type => diff.diff}
              elsif type == :json
                {type => {'diff_text': diff.diff, 'error': diff.error}}
              else
                {json: {'diff_text': "unknown type #{type}", 'error': true}}
              end
      end
  end
end
