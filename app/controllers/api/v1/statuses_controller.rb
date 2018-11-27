module Api::V1
  class StatusesController < ApiController
    before_action :set_status, only: %i[show update destroy]

    # GET /statuses
    def index
      @statuses = Status.all

      render json: @statuses
    end

    # GET /statuses/1
    def show
      render json: @status
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def status_params
      params.require(:status).permit(:name)
    end
  end
end
