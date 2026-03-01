module Api
  class BaseController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :api_request_format
    rescue_from StandardError, with: :handle_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

    protected

    def api_request_format
      request.format = :json
    end

    def json_response(data, status = :ok)
      render json: data, status: status
    end

    def handle_error(exception)
      Rails.logger.error("API Error: #{exception.class} - #{exception.message}")
      json_response({ error: exception.message }, :internal_server_error)
    end

    def handle_not_found
      json_response({ error: "Resource not found" }, :not_found)
    end

    def paginate(collection, per_page = 20)
      page = params[:page].to_i.positive? ? params[:page].to_i : 1
      offset = (page - 1) * per_page

      {
        data: collection.offset(offset).limit(per_page),
        meta: {
          page: page,
          per_page: per_page,
          total: collection.count
        }
      }
    end
  end
end
