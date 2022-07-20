class Api::V1::SessionsController < Devise::SessionsController
skip_before_action :verify_authenticity_token

 def create
    user = User.find_by_email(params[:user][:email])
    if !user.blank?
      if user.valid_password?(params[:user][:password])
        sign_in user
        respond_with user
      else
      	error = "Invalid password"
        invalid_login_attempt(error)
      end
    elsif user.blank?
      if params[:user][:email] == ""
        error = "Please enter valid email address"
        invalid_login_attempt(error)
      else
      	error = "Invalid Email Address"
        invalid_login_attempt(error)
      end
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      h = request.headers['Authorization']
      render json: { token: h, message: 'You are logged in.', user: current_user }, status: :ok
    else
      login_failed
    end
  end

  def respond_to_on_destroy
    head :no_content
  end

  def login_failed
    render json: { message: 'Something went wrong.' }, status: :unauthorized
  end

  def invalid_login_attempt(error_message)
    warden.custom_failure!
    render json: {success: false, message: error_message}, status: 401
  end
end