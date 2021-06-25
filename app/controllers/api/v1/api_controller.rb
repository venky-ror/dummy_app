class Api::V1::ApiController < ::ApplicationController
  # rescue_from ActiveRecord::RecorddNotFound, with: :not_found
  skip_before_action :verify_authenticity_token


  # def not_found
  #   render json: {error: "record not found"}, status: 404
  # end

end
